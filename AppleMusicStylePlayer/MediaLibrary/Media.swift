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
    /// Local or remote audio file location
    let url: URL?
    /// Indicates whether the audio should be streamed
    let online: Bool
}
