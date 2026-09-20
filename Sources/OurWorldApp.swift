import SwiftUI

@main
struct OurWorldApp: App {
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView()
                        .transition(.opacity)
                } else {
                    MainMenuView()
                        .environmentObject(CharacterStore())
                        .transition(.opacity)
                }
            }
            .onAppear {
                // Заставка держится 2.5 секунды, потом плавно исчезает
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showSplash = false
                    }
                }
            }
        }
    }
}
