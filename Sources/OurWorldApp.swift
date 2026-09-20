import SwiftUI

@main
struct OurWorldApp: App {
    @StateObject private var store = CharacterStore()

    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .environmentObject(store)
                .preferredColorScheme(.light)
        }
    }
}
