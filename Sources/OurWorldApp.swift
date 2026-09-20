import SwiftUI

@main
struct OurWorldApp: App {
    @StateObject private var characterStore = CharacterStore()
    @StateObject private var worldStore = WorldStore()
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView()
                        .transition(.opacity)
                } else {
                    MainMenuView()
                        .environmentObject(characterStore)
                        .environmentObject(worldStore)
                        .transition(.opacity)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showSplash = false
                    }
                }
            }
        }
    }
}
