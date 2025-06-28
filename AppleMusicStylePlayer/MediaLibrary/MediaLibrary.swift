//
//  MediaLibrary.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 27.11.2024.
//

import Foundation

final class MediaLibrary {
    private let storageKey = "MediaLibrary.list"
    var list: [MediaList]

    init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([MediaList].self, from: data) {
            list = decoded
        } else {
            list = [MediaList(artwork: nil, title: "Library", subtitle: nil, items: [])]
        }
    }

    var isEmpty: Bool {
        !list.contains { !$0.items.isEmpty }
    }

    func append(from urls: [URL]) {
        guard !urls.isEmpty else { return }

        if list.isEmpty {
            list.append(MediaList(artwork: nil, title: "Library", subtitle: nil, items: []))
        }

        var first = list[0]
        first.items.append(contentsOf: urls.map { url in
            Media(
                artwork: nil,
                title: url.deletingPathExtension().lastPathComponent,
                subtitle: nil,
                online: false,
                fileURL: url
            )
        })
        list[0] = first
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
