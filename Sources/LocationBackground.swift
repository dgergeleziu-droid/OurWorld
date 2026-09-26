import SwiftUI

// MARK: - Зона пола

struct FloorZone {
    let xMin: Double
    let xMax: Double
    let yMin: Double
    let yMax: Double

    static let standard = FloorZone(
        xMin: 0.08, xMax: 0.92,
        yMin: 0.60, yMax: 0.94
    )

    func clamp(x: Double, y: Double) -> (x: Double, y: Double) {
        (
            min(max(x, xMin), xMax),
            min(max(y, yMin), yMax)
        )
    }

    var center: (x: Double, y: Double) {
        ((xMin + xMax) / 2, (yMin + yMax) / 2)
    }
}

// MARK: - Глобальное состояние времени суток

final class DayNightState: ObservableObject {
    static let shared = DayNightState()
    @Published var isNight: Bool = false
    private init() {}
}

// MARK: - Фон локации

struct LocationBackground: View {

    let location: LocationID

    @ObservedObject private var dayNight = DayNightState.shared

    static let floorZone = FloorZone.standard

    private let backWallTop: CGFloat    = 0.05
    private let backWallBottom: CGFloat = 0.55
    private let backWallLeft: CGFloat   = 0.15
    private let backWallRight: CGFloat  = 0.85

    private var isOutdoor: Bool {
        location == .park || location == .beach
    }

    private var isNight: Bool { dayNight.isNight }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                Color(hex: "#0F1419")
                    .ignoresSafeArea()

                if isOutdoor {
                    outdoorScene(w: w, h: h)
                } else {
                    indoorScene(w: w, h: h)
                }

                // Ночной оверлей — синеватое затемнение поверх всей локации
                if isNight {
                    Color(hex: "#0B1E3A")
                        .opacity(0.45)
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                }
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - УЛИЦА (парк / пляж)

    private func outdoorScene(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            // Небо
            LinearGradient(
                colors: isNight
                    ? [Color(hex: "#0B1E3A"), Color(hex: "#1B2E5A")]
                    : [Color(hex: "#AEE2FF"), Color(hex: "#DCF3FF")],
                startPoint: .top, endPoint: .bottom
            )
            .frame(width: w, height: h * 0.55)
            .position(x: w / 2, y: h * 0.275)

            // Звёзды ночью
            if isNight {
                starsLayer(w: w, h: h)
            }

            // Луна ночью / солнце днём
            if isNight {
                Circle()
                    .fill(Color(hex: "#F4F1DE"))
                    .frame(width: 60, height: 60)
                    .shadow(color: Color.white.opacity(0.5), radius: 20)
                    .position(x: w * 0.82, y: h * 0.15)
            } else {
                Circle()
                    .fill(Color(hex: "#FFE066"))
                    .frame(width: 70, height: 70)
                    .shadow(color: Color(hex: "#FFD700").opacity(0.6), radius: 25)
                    .position(x: w * 0.82, y: h * 0.15)
            }

            // Линия земли
            Rectangle()
                .fill(
                    isNight
                        ? (location == .beach ? Color(hex: "#1E3A5F") : Color(hex: "#2A4A2A"))
                        : (location == .beach ? Color(hex: "#4FC3F7") : Color(hex: "#7BC05A"))
                )
                .frame(width: w, height: h * 0.45)
                .position(x: w / 2, y: h * 0.775)

            // Песок / трава
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: location == .beach
                            ? (isNight
                                ? [Color(hex: "#4A4438"), Color(hex: "#3A3428")]
                                : [Color(hex: "#FFE9A8"), Color(hex: "#F5D78E")])
                            : (isNight
                                ? [Color(hex: "#2A4A2A"), Color(hex: "#1E3A1E")]
                                : [Color(hex: "#8FD16B"), Color(hex: "#6BB84C")]),
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(width: w, height: h * 0.30)
                .position(x: w / 2, y: h * 0.85)
        }
    }

    private func starsLayer(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            ForEach(0..<30, id: \.self) { i in
                let seedX = Double((i * 73) % 100) / 100.0
                let seedY = Double((i * 41) % 100) / 100.0
                Circle()
                    .fill(Color.white)
                    .frame(width: 2, height: 2)
                    .opacity(0.7)
                    .position(
                        x: w * seedX,
                        y: h * (0.05 + seedY * 0.35)
                    )
            }
        }
    }

    // MARK: - ПОМЕЩЕНИЕ

    private func indoorScene(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            // Потолок
            ceilingShape(w: w, h: h)
                .fill(
                    LinearGradient(
                        colors: [ceilingColor, ceilingColor.opacity(0.92)],
                        startPoint: .top, endPoint: .bottom
                    )
                )

            // Карниз
            crownMolding(w: w, h: h)

            // Боковые стены
            leftWallShape(w: w, h: h)
                .fill(sideWallColor)
            rightWallShape(w: w, h: h)
                .fill(sideWallColor)

            // Задняя стена
            backWallShape(w: w, h: h)
                .fill(backWallColor)

            // Пол
            floorShape(w: w, h: h)
                .fill(
                    LinearGradient(
                        colors: [floorColor.opacity(0.82), floorColor],
                        startPoint: .top, endPoint: .bottom
                    )
                )

            // Плинтус
            baseboardShape(w: w, h: h)
                .fill(baseboardColor)

            // Окно — тап переключает день/ночь
            windowView(w: w, h: h)
        }
    }

    // MARK: - Формы комнаты

    private func ceilingShape(w: CGFloat, h: CGFloat) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: 0))
        p.addLine(to: CGPoint(x: w, y: 0))
        p.addLine(to: CGPoint(x: w * backWallRight, y: h * backWallTop))
        p.addLine(to: CGPoint(x: w * backWallLeft, y: h * backWallTop))
        p.closeSubpath()
        return p
    }

    private func leftWallShape(w: CGFloat, h: CGFloat) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: 0))
        p.addLine(to: CGPoint(x: w * backWallLeft, y: h * backWallTop))
        p.addLine(to: CGPoint(x: w * backWallLeft, y: h * backWallBottom))
        p.addLine(to: CGPoint(x: 0, y: h))
        p.closeSubpath()
        return p
    }

    private func rightWallShape(w: CGFloat, h: CGFloat) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: w, y: 0))
        p.addLine(to: CGPoint(x: w * backWallRight, y: h * backWallTop))
        p.addLine(to: CGPoint(x: w * backWallRight, y: h * backWallBottom))
        p.addLine(to: CGPoint(x: w, y: h))
        p.closeSubpath()
        return p
    }

    private func backWallShape(w: CGFloat, h: CGFloat) -> Path {
        var p = Path()
        p.addRect(CGRect(
            x: w * backWallLeft,
            y: h * backWallTop,
            width: w * (backWallRight - backWallLeft),
            height: h * (backWallBottom - backWallTop)
        ))
        return p
    }

    private func floorShape(w: CGFloat, h: CGFloat) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: w * backWallLeft, y: h * backWallBottom))
        p.addLine(to: CGPoint(x: w * backWallRight, y: h * backWallBottom))
        p.addLine(to: CGPoint(x: w, y: h))
        p.addLine(to: CGPoint(x: 0, y: h))
        p.closeSubpath()
        return p
    }

    private func baseboardShape(w: CGFloat, h: CGFloat) -> Path {
        var p = Path()
        let thickness: CGFloat = 0.014
        p.move(to: CGPoint(x: w * backWallLeft, y: h * backWallBottom))
        p.addLine(to: CGPoint(x: w * backWallRight, y: h * backWallBottom))
        p.addLine(to: CGPoint(x: w * backWallRight, y: h * (backWallBottom + thickness)))
        p.addLine(to: CGPoint(x: w * backWallLeft, y: h * (backWallBottom + thickness)))
        p.closeSubpath()
        return p
    }

    private func crownMolding(w: CGFloat, h: CGFloat) -> some View {
        Path { p in
            let t: CGFloat = 0.012
            p.move(to: CGPoint(x: 0, y: 0))
            p.addLine(to: CGPoint(x: w, y: 0))
            p.addLine(to: CGPoint(x: w, y: h * t))
            p.addLine(to: CGPoint(x: w * backWallRight, y: h * (backWallTop + t * 0.4)))
            p.addLine(to: CGPoint(x: w * backWallLeft, y: h * (backWallTop + t * 0.4)))
            p.addLine(to: CGPoint(x: 0, y: h * t))
            p.closeSubpath()
        }
        .fill(Color.black.opacity(0.10))
    }

    // MARK: - Окно (тап → смена дня/ночи)

    private func windowView(w: CGFloat, h: CGFloat) -> some View {
        let winW = w * 0.20
        let winH = h * 0.26
        let cx   = w * 0.5
        let cy   = h * (backWallTop + (backWallBottom - backWallTop) * 0.42)

        return ZStack {
            // Тень за окном
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.12))
                .frame(width: winW + 6, height: winH + 6)
                .blur(radius: 4)
                .offset(y: 3)

            // Небо внутри окна — меняется день/ночь
            RoundedRectangle(cornerRadius: 6)
                .fill(
                    LinearGradient(
                        colors: isNight
                            ? [Color(hex: "#0B1E3A"), Color(hex: "#2A3F6A")]
                            : [Color(hex: "#87CEEB"), Color(hex: "#DCF3FF")],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(width: winW, height: winH)

            // Ночью — луна и звёзды в окне
            if isNight {
                // Звёзды
                ForEach(0..<6, id: \.self) { i in
                    Circle()
                        .fill(Color.white)
                        .frame(width: 1.5, height: 1.5)
                        .offset(
                            x: -winW * 0.3 + CGFloat(i % 3) * winW * 0.3,
                            y: -winH * 0.25 + CGFloat(i / 3) * winH * 0.2
                        )
                }
                // Луна
                Circle()
                    .fill(Color(hex: "#F4F1DE"))
                    .frame(width: winW * 0.22, height: winW * 0.22)
                    .offset(x: winW * 0.25, y: -winH * 0.25)
                    .shadow(color: .white.opacity(0.4), radius: 6)
            } else {
                // Днём — облако и солнце
                Ellipse()
                    .fill(Color.white)
                    .frame(width: winW * 0.55, height: winH * 0.22)
                    .offset(x: -winW * 0.1, y: -winH * 0.1)
                    .opacity(0.9)

                Circle()
                    .fill(Color(hex: "#FFE066"))
                    .frame(width: winW * 0.20, height: winW * 0.20)
                    .offset(x: winW * 0.28, y: -winH * 0.28)
            }

            // Рама
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.white, lineWidth: 6)
                .frame(width: winW, height: winH)

            // Переплёт
            Rectangle()
                .fill(Color.white)
                .frame(width: 5, height: winH)
            Rectangle()
                .fill(Color.white)
                .frame(width: winW, height: 5)

            // Подоконник
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white)
                .frame(width: winW + 12, height: 8)
                .offset(y: winH / 2 + 4)
                .shadow(color: .black.opacity(0.15), radius: 2, y: 2)
        }
        .position(x: cx, y: cy)
        .contentShape(Rectangle().size(width: winW, height: winH).offset(x: cx - winW / 2, y: cy - winH / 2))
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.6)) {
                dayNight.isNight.toggle()
            }
        }
    }

    // MARK: - Цвета

    private var ceilingColor: Color {
        let base: Color
        switch location {
        case .home:     base = Color(hex: "#FFF8F0")
        case .cafe:     base = Color(hex: "#FFF1E0")
        case .shop:     base = Color(hex: "#F0F8E8")
        case .hospital: base = Color(hex: "#F5FBFF")
        case .school:   base = Color(hex: "#FFFCEB")
        case .park:     base = Color(hex: "#BEE3FF")
        case .beach:    base = Color(hex: "#BEE3FF")
        }
        return isNight ? base.opacity(0.5) : base
    }

    private var backWallColor: Color {
        let base: Color
        switch location {
        case .home:     base = Color(hex: "#F5D9B8")
        case .cafe:     base = Color(hex: "#F0C9A0")
        case .shop:     base = Color(hex: "#E2EFCF")
        case .hospital: base = Color(hex: "#E8F4FC")
        case .school:   base = Color(hex: "#F9E8C2")
        case .park:     base = Color(hex: "#A6D98A")
        case .beach:    base = Color(hex: "#4FC3F7")
        }
        return isNight ? base.opacity(0.55) : base
    }

    private var sideWallColor: Color {
        backWallColor.opacity(0.82)
    }

    private var floorColor: Color {
        let base: Color
        switch location {
        case .home:     base = Color(hex: "#C89B6E")
        case .cafe:     base = Color(hex: "#B87850")
        case .shop:     base = Color(hex: "#C4A886")
        case .hospital: base = Color(hex: "#B9D4E5")
        case .school:   base = Color(hex: "#B8875A")
        case .park:     base = Color(hex: "#7BC05A")
        case .beach:    base = Color(hex: "#FFE9A8")
        }
        return isNight ? base.opacity(0.6) : base
    }

    private var baseboardColor: Color {
        backWallColor.opacity(0.55)
    }
}
