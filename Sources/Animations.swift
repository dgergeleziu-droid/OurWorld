import SwiftUI

// MARK: - Константы анимаций (адаптировано из Android Material)
enum AppAnimation {

    // === Базовые (были раньше) ===
    /// 0.15s ease out — стандартный fade
    static let fade = Animation.timingCurve(0.4, 0.0, 0.2, 1.0, duration: 0.15)

    /// Spring при появлении
    static let fadeEnter = Animation.spring(response: 0.45, dampingFraction: 0.85)

    /// Bottom sheet
    static let bottomSheetIn = Animation.spring(response: 0.4, dampingFraction: 0.85)
    static let bottomSheetOut = Animation.timingCurve(0.4, 0.0, 1.0, 1.0, duration: 0.2)

    /// Боковая шторка — 0.28s
    static let sideSheet = Animation.timingCurve(0.4, 0.0, 0.2, 1.0, duration: 0.28)

    /// Snackbar
    static let snackbar = Animation.spring(response: 0.4, dampingFraction: 0.8)

    /// Нажатие — пружинка
    static let tap = Animation.spring(response: 0.25, dampingFraction: 0.6)

    // === Extended FAB (mtrl_extended_fab_show/hide_motion_spec.xml) ===
    /// Показ: opacity 0→1 за 150ms, scale 0.8→1.0 за 150ms
    static let extendedFabShow = Animation.timingCurve(0.4, 0.0, 0.2, 1.0, duration: 0.15)
    /// Скрытие: opacity 1→0 за 75ms linear
    static let extendedFabHide = Animation.linear(duration: 0.075)

    // === FAB (mtrl_fab_show/hide_motion_spec.xml) ===
    /// Показ: scale 330ms linear_out_slow_in, opacity 15ms с задержкой 30ms, iconScale 240ms с задержкой 90ms
    static let fabShow = Animation.timingCurve(0.0, 0.0, 0.2, 1.0, duration: 0.33)
    /// Скрытие: scale 135ms fast_out_linear_in, opacity 15ms с задержкой 150ms
    static let fabHide = Animation.timingCurve(0.4, 0.0, 1.0, 1.0, duration: 0.135)

    // === Fragment transitions ===
    /// Открытие enter: scale 0.85→1.0 за 300ms
    static let fragmentOpenEnter = Animation.timingCurve(0.4, 0.0, 0.2, 1.0, duration: 0.3)
    /// Закрытие exit: scale 1.0→0.9 за 300ms
    static let fragmentCloseExit = Animation.timingCurve(0.4, 0.0, 0.2, 1.0, duration: 0.3)
    /// Открытие exit: scale 1.0→1.15 за 300ms
    static let fragmentOpenExit = Animation.timingCurve(0.4, 0.0, 0.2, 1.0, duration: 0.3)
    /// Закрытие enter: scale 1.1→1.0 за 300ms
    static let fragmentCloseEnter = Animation.timingCurve(0.4, 0.0, 0.2, 1.0, duration: 0.3)

    // === M3 Extended FAB (m3_extended_fab_show/hide_motion_spec.xml) ===
    /// Показ: long2 (500ms) emphasized, scale 0.4→1.0
    static let m3ExtendedFabShow = Animation.timingCurve(0.2, 0.0, 0.0, 1.0, duration: 0.5)
    /// Скрытие: short3 (150ms) emphasizedAccelerate
    static let m3ExtendedFabHide = Animation.timingCurve(0.3, 0.0, 0.8, 0.15, duration: 0.15)
}

// MARK: - Модификаторы

extension View {

    /// Bottom sheet: выезд снизу + fade
    func bottomSheet() -> some View {
        modifier(BottomSheetModifier())
    }

    /// Side sheet: выезд справа + fade
    func sideSheet() -> some View {
        modifier(SideSheetModifier())
    }

    /// Fade + Scale enter (0.85 → 1.0)
    func fadeScaleEnter() -> some View {
        modifier(FadeScaleEnterModifier())
    }

    /// Пульсация: scale 1.0 ↔ 1.05
    func pulse() -> some View {
        modifier(PulseModifier())
    }

    /// Покачивание: rotation -3° ↔ 3°
    func wiggle() -> some View {
        modifier(WiggleModifier())
    }

    /// Staggered появление по индексу
    func staggered(index: Int) -> some View {
        modifier(StaggeredModifier(index: index))
    }
}

// MARK: - Реализации модификаторов

private struct BottomSheetModifier: ViewModifier {
    @State private var appeared = false
    func body(content: Content) -> some View {
        content
            .offset(y: appeared ? 0 : 40)
            .opacity(appeared ? 1 : 0)
            .onAppear {
                withAnimation(AppAnimation.bottomSheetIn) { appeared = true }
            }
    }
}

private struct SideSheetModifier: ViewModifier {
    @State private var appeared = false
    func body(content: Content) -> some View {
        content
            .offset(x: appeared ? 0 : 60)
            .opacity(appeared ? 1 : 0)
            .onAppear {
                withAnimation(AppAnimation.sideSheet) { appeared = true }
            }
    }
}

private struct FadeScaleEnterModifier: ViewModifier {
    @State private var appeared = false
    func body(content: Content) -> some View {
        content
            .scaleEffect(appeared ? 1.0 : 0.85)
            .opacity(appeared ? 1 : 0)
            .onAppear {
                withAnimation(AppAnimation.fragmentOpenEnter) { appeared = true }
            }
    }
}

private struct PulseModifier: ViewModifier {
    @State private var pulse = false
    func body(content: Content) -> some View {
        content
            .scaleEffect(pulse ? 1.05 : 1.0)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 1.0).repeatForever(autoreverses: true)
                ) {
                    pulse = true
                }
            }
    }
}

private struct WiggleModifier: ViewModifier {
    @State private var wiggle = false
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(wiggle ? 3 : -3))
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 0.4).repeatForever(autoreverses: true)
                ) {
                    wiggle = true
                }
            }
    }
}

private struct StaggeredModifier: ViewModifier {
    let index: Int
    @State private var appeared = false
    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 20)
            .onAppear {
                let delay = Double(index) * 0.05
                withAnimation(AppAnimation.fadeEnter.delay(delay)) {
                    appeared = true
                }
            }
    }
}

// MARK: - BounceButtonStyle

struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(AppAnimation.tap, value: configuration.isPressed)
    }
}
