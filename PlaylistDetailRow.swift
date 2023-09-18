//
//  PlaylistDetailRow.swift
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

struct PlaylistRow: View {
    @Bindable var playlist: PlaylistData
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: playlist.coverImage!)) { image in
                image.resizable()
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            } placeholder: {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 64, height: 64)
                    .foregroundStyle(.gray)
                    .overlay(content: {Image(systemName: "questionmark.app.dashed").foregroundStyle(playlist.sourcePlatform == .spotify ? .green : .pink)})
            }
            Text(playlist.name)
        }
    }
}