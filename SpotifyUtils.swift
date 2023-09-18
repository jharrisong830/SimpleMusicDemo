//
//  SpotifyUtils.swift
//  Copyright (C) 2023  John Graham
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.


import Foundation
import KeychainAccess
import HTTPTypes
import HTTPTypesFoundation


let spClient = "clientKey"
let redirect = "simpleMusic://"
let keychain = Keychain(service: "SMKEYS")
let api_key = "clientSecretKey"


func initialAccessAuth(authCode: String) async throws {    
    var newRequest = HTTPRequest(method: .post, url: URL(string: "https://accounts.spotify.com/api/token")!)
    newRequest.headerFields[.contentType] = "application/x-www-form-urlencoded"
    let accessParams = "grant_type=authorization_code&code=\(authCode)&redirect_uri=\(redirect)"

    let apiKeys = "\(spClient):\(api_key!)"
    let encodedKeys = Data(apiKeys.data(using: .utf8)!).base64EncodedString()
    newRequest.headerFields[.authorization] = "Basic \(encodedKeys)"
    
    let (data, _) = try await URLSession.shared.upload(for: newRequest, from: accessParams.data(using: .utf8)!)
    let jsonData = try JSONSerialization.jsonObject(with: data) as! JSONObject
    
    try keychain.removeAll()
    keychain["access_token"] = jsonData["access_token"] as? String
    keychain["refresh_token"] = jsonData["refresh_token"] as? String
    keychain["access_expiration"] = ((jsonData["expires_in"] as! Double) + Date.now.timeIntervalSince1970).description
}


func checkRefresh() -> Bool {
    guard let expiryTime = Double(keychain["access_expiration"]!) else {
        return true
    }
    return Date.now.timeIntervalSince1970 > expiryTime
}
    

func getRefreshToken() async throws {
    let accessParams = "grant_type=refresh_token&refresh_token=\(keychain["refresh_token"]!)&redirect_uri=\(redirect)"
    var newRequest = HTTPRequest(method: .post, url: URL(string: "https://accounts.spotify.com/api/token")!)
    newRequest.headerFields[.contentType] = "application/x-www-form-urlencoded"
    
    let apiKeys = "\(spClient):\(api_key!)"
    let encodedKeys = Data(apiKeys.data(using: .utf8)!).base64EncodedString()
    newRequest.headerFields[.authorization] = "Basic \(encodedKeys)"
    
    let (data, _) = try await URLSession.shared.upload(for: newRequest, from: accessParams.data(using: .utf8)!)
    
    let jsonData = try JSONSerialization.jsonObject(with: data) as! JSONObject
    
    keychain["access_token"] = jsonData["access_token"] as? String
    keychain["access_expiration"] = ((jsonData["expires_in"] as! Double) + Date.now.timeIntervalSince1970).description
}


func getPlaylistSongs(playlistID: String) async throws -> [SongData] {
    var allSongs: [SongData] = []
    var songURL: String? = "https://api.spotify.com/v1/playlists/\(playlistID)/tracks?offset=0&limit=50"
    
    repeat {
        var songReq = URLRequest(url: URL(string: songURL!)!)
        songReq.httpMethod = "GET"
        songReq.setValue("Bearer \(keychain["access_token"]!)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: songReq)
        
        guard response is HTTPURLResponse else {
            print("URL response error")
            return []
        }
        let jsonData = try JSONSerialization.jsonObject(with: data) as! JSONObject
        
        allSongs.append(contentsOf: (jsonData["items"] as! [JSONObject]).map {
            SongData(name: ($0["track"] as! JSONObject)["name"] as! String,
                     artists: (($0["track"] as! JSONObject)["artists"] as! [JSONObject]).map({$0["name"] as! String}),
                     albumName: (($0["track"] as! JSONObject)["album"] as! JSONObject)["name"] as! String,
                     albumArtists: ((($0["track"] as! JSONObject)["album"] as! JSONObject)["artists"] as! [JSONObject]).map({$0["name"] as! String}),
                     isrc: (($0["track"] as! JSONObject)["external_ids"] as! JSONObject)["isrc"] as! String,
                     amid: "",
                     spid: ($0["track"] as! JSONObject)["id"] as! String,
                     coverImage: ((($0["track"] as! JSONObject)["album"] as! JSONObject)["images"] as! [JSONObject])[2]["url"] as? String)
        })
        songURL = jsonData["next"] as? String
    } while songURL != nil
    
    return allSongs
}