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
        list = []
    }

    var isEmpty: Bool {
        !list.contains { !$0.items.isEmpty }
    }

    func addMedia(from urls: [URL]) {
        guard !urls.isEmpty else { return }
        let items = urls.map { url in
            Media(
                artwork: nil,
                title: url.deletingPathExtension().lastPathComponent,
                subtitle: nil,
                url: url,
                online: false
            )
        }

        if let first = list.first {
            let updated = MediaList(
                artwork: first.artwork,
                title: first.title,
                subtitle: first.subtitle,
                items: first.items + items
            )
            list[0] = updated
        } else {
            list = [
                MediaList(
                    artwork: nil,
                    title: "Imported",
                    subtitle: nil,
                    items: items
                )
            ]
        }
    }
}
