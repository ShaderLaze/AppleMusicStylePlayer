//
//  TimingIndicator.swift
//  AppleMusicStylePlayer
//
//  Created by Alexey Vorobyov on 13.12.2024.
//

import SwiftUI

struct TimingIndicator: View {
    @Environment(NowPlayingController.self) private var model
    let spacing: CGFloat
    @State private var dragTime: Double?

    var body: some View {
        ElasticSlider(
            value: sliderBinding,
            in: sliderRange,
            onEditingChanged: editingChanged,
            leadingLabel: {
                label(leadingLabelText)
            },
            trailingLabel: {
                label(trailingLabelText)
            }
        )
        .sliderStyle(.playbackProgress)
        .frame(height: 60)
        .transformEffect(.identity)
    }
}

private extension TimingIndicator {
    func label(_ text: String) -> some View {
        Text(text)
            .font(.appFont.timingIndicator)
            .padding(.top, 11)
    }

    var leadingLabelText: String {
        displayedProgress.asTimeString(style: .positional)
    }

    var trailingLabelText: String {
        ((sliderRange.upperBound - displayedProgress) * -1.0).asTimeString(style: .positional)
    }

    var palette: Palette.PlayerCard.Type {
        UIColor.palette.playerCard.self
    }

    var sliderRange: ClosedRange<Double> {
        0 ... max(model.duration, 0)
    }

    var displayedProgress: Double {
        dragTime ?? model.currentTime
    }

    var sliderBinding: Binding<Double> {
        Binding(
            get: { displayedProgress },
            set: { dragTime = $0 }
        )
    }

    func editingChanged(_ active: Bool) {
        if !active {
            if let dragTime {
                model.seek(to: dragTime)
            }
            dragTime = nil
        } else {
            dragTime = model.currentTime
        }
    }
}

extension ElasticSliderConfig {
    static var playbackProgress: Self {
        Self(
            labelLocation: .bottom,
            maxStretch: 0,
            minimumTrackActiveColor: Color(Palette.PlayerCard.opaque),
            minimumTrackInactiveColor: Color(Palette.PlayerCard.translucent),
            maximumTrackColor: Color(Palette.PlayerCard.translucent),
            blendMode: .overlay,
            syncLabelsStyle: true
        )
    }
}

#Preview {
    ZStack {
        PreviewBackground()
        TimingIndicator(spacing: 10)
            .padding(.horizontal)
    }
}

extension BinaryFloatingPoint {
    func asTimeString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = style
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(self)) ?? ""
    }
}
