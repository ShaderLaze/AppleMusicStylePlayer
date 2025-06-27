//
//  MediaLibrary.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 27.11.2024.
//

import Foundation
import UIKit

final class MediaLibrary {
    private let userTracksKey = "local-media-urls"
    private let loader = LocalMediaLoader()

    var list: [MediaList]

    init() {
        list = [MockGTA5Radio().mediaList]

        if let stored = UserDefaults.standard.array(forKey: userTracksKey) as? [String] {
            let urls = stored.compactMap { URL(string: $0) }
            let items = loader.loadMedia(from: urls)
            if !items.isEmpty {
                list.insert(MediaList(artwork: nil, title: "User Tracks", subtitle: nil, items: items), at: 0)
            }
        }
    }

    func pickUserTracks(from controller: UIViewController) async {
        let items = await loader.pick(from: controller)
        guard !items.isEmpty else { return }
        addUserTracks(items)
    }

    var isEmpty: Bool {
        !list.contains { !$0.items.isEmpty }
    }

    /// Inserts new items into "User Tracks" list and persists them
    func addUserTracks(_ items: [Media]) {
        if let index = list.firstIndex(where: { $0.title == "User Tracks" }) {
            var current = list[index]
            current = MediaList(artwork: current.artwork, title: current.title, subtitle: current.subtitle, items: current.items + items)
            list[index] = current
        } else {
            list.insert(MediaList(artwork: nil, title: "User Tracks", subtitle: nil, items: items), at: 0)
        }

        let urls = list.first(where: { $0.title == "User Tracks" })?.items.compactMap(\.fileURL)
        let strings = urls?.map(\.absoluteString) ?? []
        UserDefaults.standard.set(strings, forKey: userTracksKey)
    }
}
