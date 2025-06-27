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
    /// Source location of the audio file.
    let url: URL
    let online: Bool
}
