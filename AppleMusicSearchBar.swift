//
//  AppleMusicSearchBar.swift
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
import MusicKit

TextField("Search Apple Music", text: $searchText)
    .onSubmit {
        var catalogSearch = MusicCatalogSearchRequest(term: searchText, types: [Song.self])
        catalogSearch.limit = 10
        Task {
            searchResults = []
            let catalogResults = try await catalogSearch.response().songs
            for amSong in catalogResults {
                searchResults.append(SongData(name: amSong.title, artists: [amSong.artistName], albumName: amSong.albumTitle ?? "", albumArtists: [amSong.artistName], isrc: amSong.isrc ?? "", amid: amSong.id.rawValue, spid: "", coverImage: amSong.artwork?.url(width: 300, height: 300)!.absoluteString))
            }
            isPresented = true
            searchText = ""
        }
    }