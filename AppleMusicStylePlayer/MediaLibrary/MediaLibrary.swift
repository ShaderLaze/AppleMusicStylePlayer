//
//  MediaLibrary.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 27.11.2024.
//

import Foundation

final class MediaLibrary {
    var list: [MediaList]

    init() {
        list = [MockGTA5Radio().mediaList]
    }

    var isEmpty: Bool {
        !list.contains { !$0.items.isEmpty }
    }

    func addMedia(from urls: [URL]) {
        let media = urls.map { url in
            Media(
                artwork: nil,
                title: url.deletingPathExtension().lastPathComponent,
                subtitle: nil,
                online: false
            )
        }

        guard !media.isEmpty else { return }
        let list = MediaList(
            artwork: nil,
            title: "Imported",
            subtitle: nil,
            items: media
        )
        self.list.append(list)
    }
}
