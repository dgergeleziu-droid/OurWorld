import SwiftUI

// MARK: - Пресеты анимаций (перевод из Android XML)

enum AppAnimation {

    // fade_in.xml / fade_out.xml — 150 ms
    static let fade = Animation.easeOut(duration: 0.15)

    // m3_motion_fade_enter.xml — fade + scale 0.8→1.0
    static let fadeEnter = Animation.spring(response: 0.45, dampingFraction: 0.85)

    // m3_motion_fade_exit.xml — просто fade out 150 ms
    static let fadeExit = Animation.easeIn(duration: 0.15)

    // design_bottom_sheet_slide_in.xml — снизу вверх, 250 ms
    static let bottomSheetIn = Animation.easeOut(duration: 0.30)

    // design_bottom_sheet_slide_out.xml — вниз, 200 ms
    static let bottomSheetOut = Animation.easeIn(duration: 0.22)

    // m3_side_sheet_enter_from_right.xml — сбоку, 275 ms
    static let sideSheet = Animation.easeInOut(duration: 0.28)

    // abc_slide_in_bottom.xml — 50% снизу + fade
    static let slideInBottom = Animation.easeOut(duration: 0.30)

    // abc_slide_in_top.xml — 50% сверху + fade
    static let slideInTop = Animation.easeOut(duration: 0.30)

    // design_snackbar_in.xml — снизу
    static let snackbar = Animation.spring(response: 0.4, dampingFraction: 0.8)

    // lunar_console_slide_in_top.xml — сверху
    static let console = Animation.easeOut(duration: 0.25)

    // abc_popup_enter.xml — быстрое появление
    static let popup = Animation.easeOut(duration: 0.15)

    // btn_radio_to_on — пружинка
    static let tap = Animation.spring(response: 0.25, dampingFraction: 0.6)
}

// MARK: - Модификатор появления снизу вверх (bottom sheet)
struct BottomSheetTransition: ViewModifier {
    let isPresented: Bool

    func body(content: Content) -> some View {
        content
            .offset(y: isPresented ? 0 : UIScreen.main.bounds.height)
            .opacity(isPresented ? 1 : 0)
            .animation(AppAnimation.bottomSheetIn, value: isPresented)
    }
}

// MARK: - Модификатор появления сбоку (side sheet)
struct SideSheetTransition: ViewModifier {
    let isPresented: Bool
    let fromRight: Bool

    func body(content: Content) -> some View {
        content
            .offset(x: isPresented ? 0 : (fromRight ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width))
            .opacity(isPresented ? 1 : 0)
            .animation(AppAnimation.sideSheet, value: isPresented)
    }
}

// MARK: - Модификатор всплытия с масштабом (fade enter)
struct FadeScaleEnter: ViewModifier {
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(appeared ? 1.0 : 0.85)
            .opacity(appeared ? 1.0 : 0.0)
            .onAppear {
                withAnimation(AppAnimation.fadeEnter) {
                    appeared = true
                }
            }
    }
}

// MARK: - Пульсация (для кнопок)
struct PulseEffect: ViewModifier {
    @State private var pulse = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(pulse ? 1.06 : 1.0)
            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: pulse)
            .onAppear { pulse = true }
    }
}

// MARK: - Покачивание (для привлечения внимания)
struct WiggleEffect: ViewModifier {
    @State private var wiggle = false

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(wiggle ? 3 : -3))
            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: wiggle)
            .onAppear { wiggle = true }
    }
}

// MARK: - Плавное появление списка (с задержкой для каждого элемента)
struct StaggeredAppear: ViewModifier {
    let index: Int
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1.0 : 0.0)
            .offset(y: appeared ? 0 : 20)
            .onAppear {
                withAnimation(AppAnimation.fadeEnter.delay(Double(index) * 0.06)) {
                    appeared = true
                }
            }
    }
}

// MARK: - Расширения для удобства
extension View {
    func bottomSheet(isPresented: Bool) -> some View {
        modifier(BottomSheetTransition(isPresented: isPresented))
    }
    func sideSheet(isPresented: Bool, fromRight: Bool = true) -> some View {
        modifier(SideSheetTransition(isPresented: isPresented, fromRight: fromRight))
    }
    func fadeScaleEnter() -> some View {
        modifier(FadeScaleEnter())
    }
    func pulse() -> some View {
        modifier(PulseEffect())
    }
    func wiggle() -> some View {
        modifier(WiggleEffect())
    }
    func staggered(index: Int) -> some View {
        modifier(StaggeredAppear(index: index))
    }
}
