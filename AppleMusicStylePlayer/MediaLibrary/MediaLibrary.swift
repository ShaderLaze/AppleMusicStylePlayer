//
//  MediaLibrary.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 27.11.2024.
//

import Foundation

private let userTracksTitle = "User Tracks"

final class MediaLibrary {
    private static let storageKey = "MediaLibrary.list"
    var list: [MediaList]

    init() {
        if let data = UserDefaults.standard.data(forKey: Self.storageKey),
           let decoded = try? JSONDecoder().decode([MediaList].self, from: data) {
            list = decoded
        } else {
            list = [MockGTA5Radio().mediaList]
        }
    }

    var isEmpty: Bool {
        !list.contains { !$0.items.isEmpty }
    }

    func appendMedia(from urls: [URL]) {
        let medias = urls.map { url in
            Media(
                artwork: nil,
                title: url.lastPathComponent,
                subtitle: nil,
                online: false
            )
        }

        if let index = list.firstIndex(where: { $0.title == userTracksTitle }) {
            var userList = list[index]
            userList = MediaList(
                artwork: userList.artwork,
                title: userList.title,
                subtitle: userList.subtitle,
                items: userList.items + medias
            )
            list[index] = userList
        } else {
            list.append(
                MediaList(
                    artwork: nil,
                    title: userTracksTitle,
                    subtitle: nil,
                    items: medias
                )
            )
        }
        persist()
    }

    func persist() {
        if let data = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(data, forKey: Self.storageKey)
        }
    }
}
