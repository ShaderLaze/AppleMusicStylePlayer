//
//  Media.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 27.11.2024.
//

import Foundation
import UIKit

struct Media {
    let artwork: URL?
    /// Embedded artwork image if available
    let artworkImage: UIImage?
    let title: String
    let subtitle: String?
    let online: Bool
    /// Local file location for user imported media
    let fileURL: URL?

    init(
        artwork: URL? = nil,
        artworkImage: UIImage? = nil,
        title: String,
        subtitle: String?,
        online: Bool,
        fileURL: URL? = nil
    ) {
        self.artwork = artwork
        self.artworkImage = artworkImage
        self.title = title
        self.subtitle = subtitle
        self.online = online
        self.fileURL = fileURL
    }
}
