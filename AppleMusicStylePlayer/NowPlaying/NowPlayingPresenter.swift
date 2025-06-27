import SwiftUI

private struct PresentNowPlayingEnvironmentKey: EnvironmentKey {
    static let defaultValue: (() -> Void)? = nil
}

extension EnvironmentValues {
    var presentNowPlaying: (() -> Void)? {
        get { self[PresentNowPlayingEnvironmentKey.self] }
        set { self[PresentNowPlayingEnvironmentKey.self] = newValue }
    }
}

