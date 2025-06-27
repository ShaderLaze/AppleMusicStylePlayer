import SwiftUI

typealias ExpandNowPlayingAction = @MainActor () -> Void

private struct ExpandNowPlayingKey: EnvironmentKey {
    @MainActor static let defaultValue: ExpandNowPlayingAction = {}
}

extension EnvironmentValues {
    var expandNowPlaying: ExpandNowPlayingAction {
        get { self[ExpandNowPlayingKey.self] }
        set { self[ExpandNowPlayingKey.self] = newValue }
    }
}
