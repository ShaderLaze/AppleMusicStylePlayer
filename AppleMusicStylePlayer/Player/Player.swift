//
//  Player.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 30.11.2024.
//

import AVFoundation
import Foundation

class Player {
    private var player: AVAudioPlayer?

    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }

    func play(_ media: Media) {
        stop()
        guard let url = media.fileURL else {
            print("No file for \(media.title)")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Failed to play \(media.title): \(error)")
        }
    }

    func stop() {
        player?.stop()
        player = nil
    }
}
