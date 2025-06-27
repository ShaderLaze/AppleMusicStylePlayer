//
//  MediaLibrary.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 27.11.2024.
//

import Foundation

final class MediaLibrary {
    var list: [MediaList]
    private let storage = UserTracksStorage()

    init() {
        let tracks = storage.load()
        if tracks.isEmpty {
            list = [MockGTA5Radio().mediaList]
        } else {
            let items = tracks.map {
                Media(
                    artwork: $0.artworkURL,
                    title: $0.title,
                    subtitle: $0.artist,
                    fileURL: $0.fileURL,
                    online: false
                )
            }
            list = [
                MediaList(
                    artwork: nil,
                    title: "Your Tracks",
                    subtitle: nil,
                    items: items
                )
            ]
        }
    }

    var isEmpty: Bool {
        !list.contains { !$0.items.isEmpty }
    }

    func save(_ tracks: [UserTrack]) {
        storage.save(tracks)
    }
}
