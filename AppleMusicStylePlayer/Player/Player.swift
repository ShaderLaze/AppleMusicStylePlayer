//
//  Player.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 30.11.2024.
//

import Foundation
import AVFoundation

final class Player {
    private var player: AVAudioPlayer?

    /// Starts playing provided media. If the same media was already loaded, it
    /// simply resumes the playback. Otherwise the previous playback is stopped
    /// and new audio file is loaded.
    func play(_ media: Media) {
        guard let url = media.fileURL else { return }

        if player?.url != url {
            stop()
            player = try? AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
        }

        player?.play()
    }

    /// Pauses the playback keeping the current player instance.
    func pause() {
        player?.pause()
    }

    /// Completely stops playback and releases player instance.
    func stop() {
        player?.stop()
        player = nil
    }
}
