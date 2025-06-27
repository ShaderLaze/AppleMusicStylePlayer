//
//  Player.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 30.11.2024.
//

import AVFoundation
import Foundation

class Player {
    private var audioPlayer: AVAudioPlayer?

    func play(_ media: Media) {
        stop()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: media.url)
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer?.play()
        } catch {
            print("Playback error: \(error)")
        }
    }

    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
