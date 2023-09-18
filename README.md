# SimpleMusicDemo

### Transfer Playlists with Ease
SimpleMusic is an app that allows users to match and transfer playlists across platforms. Built using SwiftUI, SwiftData, MusicKit, and the Spotify Web API, SimpleMusic provides an easy-to-use interface that makes transferring playlists straightforward.

I often find myself switching between music services whenever there are new features or promotional offers. But with a large playlist library, staying in sync across platforms can be daunting. SimpleMusic makes the transferring and matching process as easy as just a couple of clicks!

This project was completed separately from my coursework and self-taught from Apple and Spotify's online documentation. This repository contains demo source code that I used to build SimpleMusic. An iOS release is currently being tested and will be released soon!

## How it Works
Users can log into their various music streaming accounts (currently only Spotify and Apple Music are supported), select playlists, and create an equivalent playlist on another platform. Songs are first matched by using their ISRCs (International Standard Recording Codes), which ensure that song matches are as accurate as possible across platforms. When a certain song can't be matched, the user can select another version by searching the Spotify and Apple Music catalogs.

## Requirements
- A device running iOS 17.0 or later
- An active Spotify account (free or premium)
- An active Apple Music **subscription**