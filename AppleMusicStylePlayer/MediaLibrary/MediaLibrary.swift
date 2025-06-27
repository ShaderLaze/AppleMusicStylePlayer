//
//  MediaLibrary.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 27.11.2024.
//

import AVFoundation
import Foundation
import UniformTypeIdentifiers

final class MediaLibrary {
    private let storageKey = "MediaLibrary.urls"
    var list: [MediaList] = []

    init() {
        loadSaved()
    }

    var isEmpty: Bool {
        !list.contains { !$0.items.isEmpty }
    }

    func importFiles(_ urls: [URL]) {
        var items = list.first?.items ?? []
        urls.forEach { url in
            if let media = metadata(for: url) {
                items.append(media)
            }
        }
        let newList = MediaList(artwork: nil, title: "Library", subtitle: nil, items: items)
        list = [newList]
        persist()
    }

    private func loadSaved() {
        guard let stored = UserDefaults.standard.array(forKey: storageKey) as? [String] else { return }
        let urls = stored.compactMap { URL(string: $0) }
        importFiles(urls)
    }

    private func persist() {
        guard let items = list.first?.items else { return }
        let strings = items.map { $0.url.absoluteString }
        UserDefaults.standard.set(strings, forKey: storageKey)
    }

    private func metadata(for url: URL) -> Media? {
        let asset = AVURLAsset(url: url)
        let meta = asset.commonMetadata
        let title = meta.first(where: { $0.commonKey == .commonKeyTitle })?.stringValue ?? url.lastPathComponent
        let artist = meta.first(where: { $0.commonKey == .commonKeyArtist })?.stringValue
        var artworkURL: URL?
        if let data = meta.first(where: { $0.commonKey == .commonKeyArtwork })?.dataValue {
            let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let imageURL = caches.appendingPathComponent(UUID().uuidString + ".png")
            try? data.write(to: imageURL)
            artworkURL = imageURL
        }
        return Media(artwork: artworkURL, title: title, subtitle: artist, url: url, online: false)
    }
}
