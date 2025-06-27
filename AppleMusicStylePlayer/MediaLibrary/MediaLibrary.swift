//
//  MediaLibrary.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 27.11.2024.
//

import Foundation

import AVFoundation

final class MediaLibrary {
    /// Collection of playlists available in the app
    var list: [MediaList]

    init() {
        // Start with an empty "My Tracks" playlist where imported tracks will be stored
        list = [MediaList(artwork: nil, title: "My Tracks", subtitle: nil, items: [])]
    }

    var isEmpty: Bool {
        !list.contains { !$0.items.isEmpty }
    }

    /// Adds an audio file from the given URL to the first playlist
    func addTrack(from url: URL) {
        let asset = AVURLAsset(url: url)

        let title = asset.metadataValue(for: .commonKeyTitle) ?? url.deletingPathExtension().lastPathComponent
        let artist = asset.metadataValue(for: .commonKeyArtist)
        let artworkURL = asset.saveArtwork()

        let media = Media(artwork: artworkURL, title: title, subtitle: artist, url: url, online: false)

        // Append to the first playlist
        if list.isEmpty {
            list.append(MediaList(artwork: nil, title: "My Tracks", subtitle: nil, items: [media]))
        } else {
            list[0].items.append(media)
        }
    }
}

private extension AVURLAsset {
    func metadataItem(with key: AVMetadataKey) -> AVMetadataItem? {
        AVMetadataItem.metadataItems(from: commonMetadata, withKey: key, keySpace: .common).first
    }

    func metadataValue(for key: AVMetadataKey) -> String? {
        metadataItem(with: key)?.stringValue
    }

    func saveArtwork() -> URL? {
        guard let data = metadataItem(with: .commonKeyArtwork)?.dataValue else { return nil }
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".png")
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            return nil
        }
    }
}
