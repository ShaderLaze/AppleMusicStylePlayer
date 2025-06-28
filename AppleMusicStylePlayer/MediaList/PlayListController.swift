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
        if let cur = current,
           let updated = library.list.first(where: { $0.title == cur.title }) {
            current = updated
        } else {
            current = library.list.first { !$0.items.isEmpty }
        }
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
