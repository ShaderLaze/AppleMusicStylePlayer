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
    private var avPlayer: AVPlayer?

    /// Starts playback of the given media item
    func play(_ media: Media) {
        stop()
        guard let url = media.url else { return }

        if media.online {
            avPlayer = AVPlayer(url: url)
            avPlayer?.play()
        } else {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Failed to play: \(error)")
            }
        }
    }

    /// Stops any currently playing audio
    func stop() {
        audioPlayer?.stop()
        avPlayer?.pause()
        audioPlayer = nil
        avPlayer = nil
    }
}
