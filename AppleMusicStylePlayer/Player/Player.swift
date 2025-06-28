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
    private var currentURL: URL?
    private var storedTime: TimeInterval = 0

    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }

    func play(_ media: Media) {
        guard let url = media.fileURL else {
            print("No file for \(media.title)")
            return
        }

        if url != currentURL {
            // new track selected
            stop()
            currentURL = url
            storedTime = 0
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.prepareToPlay()
            } catch {
                print("Failed to load \(media.title): \(error)")
            }
        }

        player?.currentTime = storedTime
        player?.play()
    }

    func pause() {
        storedTime = player?.currentTime ?? 0
        player?.pause()
    }

    func stop() {
        storedTime = 0
        player?.stop()
        player = nil
        currentURL = nil
    }

    var currentTime: TimeInterval {
        get { player?.currentTime ?? storedTime }
        set {
            storedTime = newValue
            player?.currentTime = newValue
        }
    }

    var duration: TimeInterval {
        player?.duration ?? 0
    }
}
