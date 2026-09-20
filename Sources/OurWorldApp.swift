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
                }
            }
            .onAppear {
                // Показываем заставку 2 секунды, потом плавно убираем
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        showSplash = false
                    }
                }
            }
        }
    }
}
