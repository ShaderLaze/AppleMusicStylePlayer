//
//  MediaList.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 27.11.2024.
//

import Foundation

struct MediaList: Codable {
    var artwork: URL?
    var title: String
    var subtitle: String?
    var items: [Media]
}
