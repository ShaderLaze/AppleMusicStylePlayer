//
//  Player.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 30.11.2024.
//

import Foundation
import AVFoundation

class Player {
    private var player: AVQueuePlayer?
    private var currentURL: URL?

    func play(_ media: Media) {
        guard let url = media.fileURL else { return }

        if currentURL != url {
            let item = AVPlayerItem(url: url)
            player = AVQueuePlayer(items: [item])
            currentURL = url
        }

        player?.play()
    }

    func pause() {
        player?.pause()
    }

    func stop() {
        player?.pause()
        player?.removeAllItems()
        player = nil
        currentURL = nil
    }
}
