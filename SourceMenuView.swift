//
//  SourceMenuView.swift
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
import SwiftData
import MusicKit

struct SourceMenuView: View {
    @Query private var userSettings: [UserSettings]
    
    @Binding var isPresentingSpotify: Bool
    @Binding var isPresentingAppleMusic: Bool
    @Binding var currentTab: SelectedTab
    
    var body: some View {
        Menu {
            if userSettings == [] || (userSettings[0].noServicesActive && (MusicAuthorization.currentStatus != .authorized)) {
                Button {
                    currentTab = .settings
                } label: {
                    Label("Add services in settings.", systemImage: "xmark.circle.fill")
                }
            }
            else {
                if userSettings[0].spotifyActive {
                    Button {
                        isPresentingSpotify = true
                    } label: {
                        Label("From Spotify", image: "Spotify Logo")
                    }
                }
                if MusicAuthorization.currentStatus == .authorized {
                    Button {
                        isPresentingAppleMusic = true
                    } label: {
                        Label("From Apple Music", image: "AM Logo")
                    }
                }
            }
        } label: {
            Label("Add Item", systemImage: "plus")
        }
    }
}