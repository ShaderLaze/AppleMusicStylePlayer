//
//  Player.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 30.11.2024.
//

import AVFoundation
import Foundation

@MainActor
@Observable
class Player {
    private var player: AVAudioPlayer?
    private var currentURL: URL?
    private var storedTime: TimeInterval = 0
    private var timer: Timer?

    var duration: TimeInterval = 0
    var currentTime: TimeInterval = 0

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
                duration = player?.duration ?? 0
            } catch {
                print("Failed to load \(media.title): \(error)")
            }
        }

        player?.currentTime = storedTime
        player?.play()
        startTimer()
    }

    func pause() {
        storedTime = player?.currentTime ?? 0
        player?.pause()
        stopTimer()
    }

    func stop() {
        storedTime = 0
        player?.stop()
        player = nil
        currentURL = nil
        stopTimer()
    }

    func seek(to time: TimeInterval) {
        player?.currentTime = time
        storedTime = time
        currentTime = player?.currentTime ?? time
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self else { return }
            currentTime = player?.currentTime ?? 0
        }
        if let timer { RunLoop.main.add(timer, forMode: .common) }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
