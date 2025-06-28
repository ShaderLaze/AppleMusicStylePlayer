//
//  NowPlayingController.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 27.11.2024.
//

import Kingfisher
import Observation
import Combine
import UIKit

@MainActor
@Observable
class NowPlayingController {
    enum State {
        case playing
        case paused
    }

    var state: State = .paused
    var currentIndex: Int? = 1
    private let playList: PlayListController
    private let player: Player
    var colors: [ColorFrequency] = []
    var progress: Double = 0
    var duration: Double = 0
    private var progressCancellable: AnyCancellable?

    var currentMedia: Media? {
        guard let currentIndex else { return nil }
        return playList.items[safe: currentIndex]
    }

    init(playList: PlayListController, player: Player) {
        self.playList = playList
        self.player = player
    }

    var display: Media {
        currentMedia ?? .placeholder
    }

    var title: String {
        display.title
    }

    var subtitle: String? {
        display.subtitle
    }

    var playPauseButton: ButtonType {
        switch state {
        case .playing: currentMedia.map(\.online) ?? false ? .stop : .pause
        case .paused: .play
        }
    }

    var backwardButton: ButtonType { .backward }
    var forwardButton: ButtonType { .forward }

    func onAppear() {
        updateColors()
    }

    func onPlayPause() {
        enshureMediaAvailable()
        guard let currentMedia else { return }
        state.toggle()
        if state == .playing {
            player.play(currentMedia)
            duration = player.duration
            startProgressUpdates()
        } else {
            player.pause()
            stopProgressUpdates()
        }
    }

    func onForward() {
        enshureMediaAvailable()
        guard !playList.items.isEmpty else { return }

        let next: Int
        if let currentIndex {
            next = (currentIndex + 1) % playList.items.count
        } else {
            next = 0
        }

        self.currentIndex = next
        if state == .playing, let media = currentMedia {
            player.play(media)
            duration = player.duration
            startProgressUpdates()
        }
        updateColors()
    }

    func onBackward() {
        enshureMediaAvailable()
        guard !playList.items.isEmpty else { return }

        let lastIndex = playList.items.count - 1
        let prev: Int
        if let currentIndex {
            let candidate = currentIndex - 1
            prev = candidate < 0 ? lastIndex : candidate
        } else {
            prev = lastIndex
        }

        self.currentIndex = prev
        if state == .playing, let media = currentMedia {
            player.play(media)
            duration = player.duration
            startProgressUpdates()
        }
        updateColors()
    }

    public func select(at index: Int) {
        guard playList.items.indices.contains(index) else { return }
        currentIndex = index
        updateColors()
    }

    public func play(at index: Int) {
        guard playList.items.indices.contains(index) else { return }
        currentIndex = index
        state = .playing
        if let media = currentMedia {
            player.play(media)
            duration = player.duration
            startProgressUpdates()
        }
        updateColors()
    }

    public func seek(to time: Double) {
        player.currentTime = time
        progress = time
    }
}

private extension NowPlayingController {
    func enshureMediaAvailable() {
        if playList.items.isEmpty {
            selectFirstAvailableMedia()
        }
    }

    func selectFirstAvailableMedia() {
        stopPlaying()
        playList.selectFirstAvailable()
        currentIndex = playList.items.isEmpty ? nil : 0
    }

    func stopPlaying() {
        state = .paused
        player.stop()
        stopProgressUpdates()
    }

    func updateColors() {
        guard let url = display.artwork else { return }
        Task { @MainActor in
            if let image = try? await KingfisherManager.shared.retrieveImage(with: url).image {
                self.colors = (image.dominantColorFrequencies(with: .high) ?? [])
            }
        }
    }

    func startProgressUpdates() {
        progress = player.currentTime
        duration = player.duration
        progressCancellable?.cancel()
        progressCancellable = Timer
            .publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                self.progress = self.player.currentTime
                self.duration = self.player.duration
            }
    }

    func stopProgressUpdates() {
        progressCancellable?.cancel()
        progressCancellable = nil
    }
}

private extension NowPlayingController.State {
    mutating func toggle() {
        switch self {
        case .playing: self = .paused
        case .paused: self = .playing
        }
    }
}

private extension Media {
    static var placeholder: Self {
        Media(
            artwork: nil,
            title: "---",
            subtitle: "---",
            online: false,
            fileURL: nil
        )
    }
}
