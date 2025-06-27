import SwiftUI

private struct ExpandNowPlayingKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

extension EnvironmentValues {
    var expandNowPlaying: () -> Void {
        get { self[ExpandNowPlayingKey.self] }
        set { self[ExpandNowPlayingKey.self] = newValue }
    }
}
