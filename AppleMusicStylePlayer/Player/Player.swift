//
//  Player.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 30.11.2024.
//

import AVFoundation
import Foundation

final class Player {
    private var player: AVPlayer?

    func play(_ media: Media) {
        stop()
        guard let url = media.url else { return }
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        player?.play()
    }

    func stop() {
        player?.pause()
        player = nil
    }
}
