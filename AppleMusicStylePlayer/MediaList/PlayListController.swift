//
//  PlayListController.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 30.11.2024.
//

import Observation
import SwiftUI

@Observable
class PlayListController {
    var library = MediaLibrary()
    var current: MediaList?
    private(set) var userTracks: [URL] = []

    init() {
        selectFirstAvailable()
    }

    var display: MediaList {
        current ?? .placeholder
    }

    var items: [Media] {
        current?.items ?? []
    }

    var footer: LocalizedStringKey? {
        current.map { "^[\($0.items.count) station](inflect: true)" }
    }

    func selectFirstAvailable() {
        current = library.list.first { !$0.items.isEmpty }
    }

    func importMedia(from urls: [URL]) {
        guard !urls.isEmpty else { return }
        userTracks.append(contentsOf: urls)
        library.addMedia(from: urls)
        selectFirstAvailable()
    }
}

private extension MediaList {
    static var placeholder: Self {
        MediaList(
            artwork: nil,
            title: "---",
            subtitle: nil,
            items: []
        )
    }
}
