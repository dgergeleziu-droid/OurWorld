import SwiftUI

@main
struct OurWorldApp: App {
    @StateObject private var characterStore = CharacterStore()
    @StateObject private var worldStore = WorldStore()

    var body: some Scene {
        WindowGroup {
            MapView()
                .environmentObject(characterStore)
                .environmentObject(worldStore)
                .preferredColorScheme(.light)
        }
    }
}
