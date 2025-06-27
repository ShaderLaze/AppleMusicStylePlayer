//
//  Media.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 27.11.2024.
//

import Foundation

struct Media {
    let artwork: URL?
    let title: String
    let subtitle: String?
    /// Local file URL for offline items
    let fileURL: URL?
    let online: Bool
}
