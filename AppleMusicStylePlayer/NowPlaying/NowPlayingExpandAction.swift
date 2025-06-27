import SwiftUI

private struct NowPlayingExpandActionKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

extension EnvironmentValues {
    var nowPlayingExpandAction: () -> Void {
        get { self[NowPlayingExpandActionKey.self] }
        set { self[NowPlayingExpandActionKey.self] = newValue }
    }
}
