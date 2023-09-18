//
//  PlaylistDetailView.swift
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


import SwiftUI

struct PlaylistDetailView: View {    
    @Bindable var playlist: PlaylistData
    
    @State private var songs: [SongData] = []
    
    var body: some View {
        List {
            if songs.isEmpty {
                ProgressView()
            }
            else {
                ForEach(songs) { song in
                    SongRow(song: song)
                }
            }
        }
        .navigationTitle(playlist.name)
        .task {
            switch playlist.sourcePlatform {
            case .spotify:
                do {
                    if SpotifyClient().checkRefresh() {
                        try await SpotifyClient().getRefreshToken()
                    }
                    songs = try await SpotifyClient().getPlaylistSongs(playlistID: playlist.spid)
                } catch {
                    print("error loading songs")
                }
            case .appleMusic:
                do {
                    songs = try await AppleMusicClient().getPlaylistSongs(playlistID: playlist.amid)
                } catch {
                    print("error loading songs")
                }
            }
        }
    }
}