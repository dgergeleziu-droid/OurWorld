import SwiftUI

// MARK: - Zoom-in переход (как "вход в здание")
struct ZoomNavigationTransition: ViewModifier {
    let trigger: Bool

    func body(content: Content) -> some View {
        content
            .scaleEffect(trigger ? 1.0 : 0.92)
            .opacity(trigger ? 1.0 : 0.0)
            .animation(AppAnimation.fadeEnter, value: trigger)
    }
}

// MARK: - Появление экрана снизу (для sheet внутри локаций)
struct SlideUpScreen: ViewModifier {
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .offset(y: appeared ? 0 : 80)
            .opacity(appeared ? 1.0 : 0.0)
            .onAppear {
                withAnimation(AppAnimation.slideInBottom) {
                    appeared = true
                }
            }
    }
}

extension View {
    func zoomTransition(trigger: Bool = true) -> some View {
        modifier(ZoomNavigationTransition(trigger: trigger))
    }
    func slideUp() -> some View {
        modifier(SlideUpScreen())
    }
}
