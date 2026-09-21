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

// MARK: - Фон локации (изометрия, реалистичный интерьер)

struct LocationBackground: View {

    let location: LocationID

    static let floorZone = FloorZone.standard

    // Границы комнаты
    private let backWallTop: CGFloat    = 0.05
    private let backWallBottom: CGFloat = 0.55
    private let backWallLeft: CGFloat   = 0.15
    private let backWallRight: CGFloat  = 0.85

    private var isOutdoor: Bool {
        location == .park || location == .beach
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // 0. Жёсткий непрозрачный фон — закрашивает ВСЁ, включая небо родителя
                Color(hex: "#0F1419")
                    .ignoresSafeArea()

                if isOutdoor {
                    outdoorScene(w: w, h: h)
                } else {
                    indoorScene(w: w, h: h)
                }
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - УЛИЧНАЯ СЦЕНА (парк / пляж)

    private func outdoorScene(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            // Небо (только для улицы — здесь оно уместно)
            LinearGradient(
                colors: [Color(hex: "#AEE2FF"), Color(hex: "#DCF3FF")],
                startPoint: .top, endPoint: .bottom
            )
            .frame(width: w, height: h * 0.55)
            .position(x: w / 2, y: h * 0.275)

            // Горизонт / линия земли
            Rectangle()
                .fill(location == .beach ? Color(hex: "#4FC3F7") : Color(hex: "#7BC05A"))
                .frame(width: w, height: h * 0.45)
                .position(x: w / 2, y: h * 0.775)

            // Песок для пляжа / трава для парка
            if location == .beach {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#FFE9A8"), Color(hex: "#F5D78E")],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .frame(width: w, height: h * 0.30)
                    .position(x: w / 2, y: h * 0.85)
            } else {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#8FD16B"), Color(hex: "#6BB84C")],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .frame(width: w, height: h * 0.30)
                    .position(x: w / 2, y: h * 0.85)
            }

            // Декор уличный
            if location == .beach {
                beachDecor(w: w, h: h)
            } else {
                parkDecor(w: w, h: h)
            }
        }
    }

    // MARK: - ВНУТРЕННЯЯ СЦЕНА (дом / кафе / магазин / больница / школа)

    private func indoorScene(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            // 1. Потолок — большая трапеция, полностью закрывает верх
            ceilingShape(w: w, h: h)
                .fill(
                    LinearGradient(
                        colors: [ceilingColor, ceilingColor.opacity(0.92)],
                        startPoint: .top, endPoint: .bottom
                    )
                )

            // 2. Потолочный карниз (полоска между потолком и стенами)
            crownMolding(w: w, h: h)

            // 3. Боковые стены
            leftWallShape(w: w, h: h)
                .fill(sideWallColor)
            rightWallShape(w: w, h: h)
                .fill(sideWallColor)

            // 4. Задняя стена
            backWallShape(w: w, h: h)
                .fill(backWallColor)

            // 5. Обои / текстура задней стены
            backWallTexture(w: w, h: h)

            // 6. Пол
            floorShape(w: w, h: h)
                .fill(
                    LinearGradient(
                        colors: [floorColor.opacity(0.82), floorColor],
                        startPoint: .top, endPoint: .bottom
                    )
                )

            // 7. Плинтус
            baseboardShape(w: w, h: h)
                .fill(baseboardColor)

            // 8. Доски на полу (имитация)
            floorPlanks(w: w, h: h)

            // 9. Окно со светом
            windowView(w: w, h: h)

            // 10. Свет из окна на пол
            lightBeam(w: w, h: h)

            // 11. Мебель / декор локации
            locationDecor(w: w, h: h)
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

    // MARK: - Карниз

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

    // MARK: - Текстура задней стены (вертикальные обои)

    private func backWallTexture(w: CGFloat, h: CGFloat) -> some View {
        let cols = 12
        return ZStack {
            ForEach(0..<cols, id: \.self) { i in
                let t = CGFloat(i) / CGFloat(cols)
                Rectangle()
                    .fill(Color.black.opacity(0.028))
                    .frame(width: 1, height: h * (backWallBottom - backWallTop))
                    .position(
                        x: w * (backWallLeft + (backWallRight - backWallLeft) * t),
                        y: h * (backWallTop + (backWallBottom - backWallTop) / 2)
                    )
            }
        }
    }

    // MARK: - Доски на полу

    private func floorPlanks(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            // Продольные линии, сходящиеся к точке схода
            ForEach(0..<8, id: \.self) { i in
                let t = CGFloat(i) / 7.0
                let xTop = w * (backWallLeft + (backWallRight - backWallLeft) * t)
                let xBottom = w * (0.0 + 1.0 * t)
                Path { p in
                    p.move(to: CGPoint(x: xTop, y: h * backWallBottom))
                    p.addLine(to: CGPoint(x: xBottom, y: h))
                }
                .stroke(Color.black.opacity(0.10), lineWidth: 1)
            }
            // Поперечные линии
            ForEach(0..<4, id: \.self) { i in
                let t = CGFloat(i + 1) / 5.0
                let y = h * (backWallBottom + (1.0 - backWallBottom) * t)
                Rectangle()
                    .fill(Color.black.opacity(0.06))
                    .frame(width: w, height: 1)
                    .position(x: w / 2, y: y)
            }
        }
    }

    // MARK: - Окно

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

            // Небо внутри окна
            RoundedRectangle(cornerRadius: 6)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#87CEEB"), Color(hex: "#DCF3FF")],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(width: winW, height: winH)

            // Облако в окне
            Ellipse()
                .fill(Color.white)
                .frame(width: winW * 0.55, height: winH * 0.22)
                .offset(x: -winW * 0.1, y: -winH * 0.1)
                .opacity(0.9)

            // Солнце в окне
            Circle()
                .fill(Color(hex: "#FFE066"))
                .frame(width: winW * 0.20, height: winW * 0.20)
                .offset(x: winW * 0.28, y: -winH * 0.28)

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
    }

    // MARK: - Свет из окна на пол

    private func lightBeam(w: CGFloat, h: CGFloat) -> some View {
        Path { p in
            let topY = h * (backWallTop + (backWallBottom - backWallTop) * 0.6)
            p.move(to: CGPoint(x: w * 0.42, y: topY))
            p.addLine(to: CGPoint(x: w * 0.58, y: topY))
            p.addLine(to: CGPoint(x: w * 0.75, y: h))
            p.addLine(to: CGPoint(x: w * 0.25, y: h))
            p.closeSubpath()
        }
        .fill(Color.white.opacity(0.13))
        .blendMode(.screen)
    }

    // MARK: - Декор локации

    @ViewBuilder
    private func locationDecor(w: CGFloat, h: CGFloat) -> some View {
        switch location {
        case .home:
            homeDecor(w: w, h: h)
        case .cafe:
            cafeDecor(w: w, h: h)
        case .shop:
            shopDecor(w: w, h: h)
        case .hospital:
            hospitalDecor(w: w, h: h)
        case .school:
            schoolDecor(w: w, h: h)
        case .park, .beach:
            EmptyView()
        }
    }

    // MARK: - ДОМ

    @ViewBuilder
    private func homeDecor(w: CGFloat, h: CGFloat) -> some View {
        // Ковёр по центру пола
        Ellipse()
            .fill(Color(hex: "#D9A6A0"))
            .overlay(Ellipse().stroke(Color.black.opacity(0.15), lineWidth: 2))
            .frame(width: w * 0.34, height: h * 0.11)
            .position(x: w * 0.5, y: h * 0.78)

        // Диван слева
        IsoSofa(width: w * 0.26, height: h * 0.16,
                bodyColor: Color(hex: "#C97B84"),
                pillowColor: Color(hex: "#F4B7BD"))
            .position(x: w * 0.28, y: h * 0.68)

        // Журнальный столик в центре
        IsoCoffeeTable(width: w * 0.16, height: h * 0.06)
            .position(x: w * 0.5, y: h * 0.80)

        // Торшер справа
        IsoLamp(width: w * 0.10, height: h * 0.30)
            .position(x: w * 0.82, y: h * 0.66)

        // Картина на задней стене
        IsoWallPicture(width: w * 0.10, height: h * 0.14)
            .position(x: w * 0.72, y: h * 0.26)

        // Полка с книгами
        IsoShelf(width: w * 0.16, height: h * 0.10)
            .position(x: w * 0.28, y: h * 0.30)
    }

    // MARK: - КАФЕ

    @ViewBuilder
    private func cafeDecor(w: CGFloat, h: CGFloat) -> some View {
        // Барная стойка справа
        IsoBarCounter(width: w * 0.30, height: h * 0.20)
            .position(x: w * 0.72, y: h * 0.70)

        // Два табурета перед стойкой
        IsoStool(width: w * 0.06, height: h * 0.10)
            .position(x: w * 0.62, y: h * 0.84)
        IsoStool(width: w * 0.06, height: h * 0.10)
            .position(x: w * 0.78, y: h * 0.86)

        // Столик слева
        IsoCafeTable(width: w * 0.18, height: h * 0.10)
            .position(x: w * 0.26, y: h * 0.78)

        // Чашка на столике
        Circle()
            .fill(Color.white)
            .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 1.2))
            .frame(width: 14, height: 14)
            .position(x: w * 0.26, y: h * 0.72)

        // Кофемашина на задней стене
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(hex: "#3E2723"))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.black.opacity(0.4), lineWidth: 1.5)
            )
            .frame(width: w * 0.06, height: h * 0.08)
            .position(x: w * 0.30, y: h * 0.28)

        // Вывеска "OPEN"
        RoundedRectangle(cornerRadius: 6)
            .fill(Color(hex: "#F5B300"))
            .overlay(
                Text("OPEN")
                    .font(.system(size: 12, weight: .heavy))
                    .foregroundColor(.white)
            )
            .frame(width: w * 0.10, height: h * 0.05)
            .position(x: w * 0.68, y: h * 0.24)
    }

    // MARK: - МАГАЗИН

    @ViewBuilder
    private func shopDecor(w: CGFloat, h: CGFloat) -> some View {
        // Стеллаж с товарами слева
        IsoShelfWithGoods(width: w * 0.22, height: h * 0.28)
            .position(x: w * 0.26, y: h * 0.42)

        // Второй стеллаж справа
        IsoShelfWithGoods(width: w * 0.20, height: h * 0.24)
            .position(x: w * 0.76, y: h * 0.44)

        // Прилавок
        IsoBarCounter(width: w * 0.26, height: h * 0.16)
            .position(x: w * 0.5, y: h * 0.76)

        // Касса на прилавке
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(hex: "#455A64"))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.black.opacity(0.4), lineWidth: 1.5)
            )
            .frame(width: w * 0.06, height: h * 0.06)
            .position(x: w * 0.5, y: h * 0.70)

        // Корзина на полу
        Ellipse()
            .fill(Color(hex: "#C68B59"))
            .overlay(Ellipse().stroke(Color.black.opacity(0.3), lineWidth: 1.5))
            .frame(width: w * 0.06, height: h * 0.05)
            .position(x: w * 0.20, y: h * 0.88)
    }

    // MARK: - БОЛЬНИЦА

    @ViewBuilder
    private func hospitalDecor(w: CGFloat, h: CGFloat) -> some View {
        // Койка слева
        IsoHospitalBed(width: w * 0.30, height: h * 0.18)
            .position(x: w * 0.30, y: h * 0.72)

        // Тумбочка
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.black.opacity(0.25), lineWidth: 1.5)
            )
            .frame(width: w * 0.07, height: h * 0.09)
            .position(x: w * 0.48, y: h * 0.76)

        // Шкафчик аптечки на стене
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(hex: "#F1F1F1"))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.black.opacity(0.3), lineWidth: 1.5)
            )
            .frame(width: w * 0.08, height: h * 0.10)
            .position(x: w * 0.72, y: h * 0.30)

        // Красный крест
        ZStack {
            RoundedRectangle(cornerRadius: 2).fill(Color(hex: "#E85C5C"))
                .frame(width: 22, height: 6)
            RoundedRectangle(cornerRadius: 2).fill(Color(hex: "#E85C5C"))
                .frame(width: 6, height: 22)
        }
        .position(x: w * 0.72, y: h * 0.30)

        // Стул справа
        IsoStool(width: w * 0.06, height: h * 0.10)
            .position(x: w * 0.62, y: h * 0.82)
    }

    // MARK: - ШКОЛА

    @ViewBuilder
    private func schoolDecor(w: CGFloat, h: CGFloat) -> some View {
        // Доска на задней стене
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(hex: "#2E6B4F"))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(hex: "#8B5A2B"), lineWidth: 6)
            )
            .overlay(
                VStack(alignment: .leading, spacing: 5) {
                    Rectangle().fill(Color.white.opacity(0.7)).frame(width: 60, height: 2)
                    Rectangle().fill(Color.white.opacity(0.7)).frame(width: 90, height: 2)
                    Rectangle().fill(Color.white.opacity(0.7)).frame(width: 70, height: 2)
                }
            )
            .frame(width: w * 0.30, height: h * 0.18)
            .position(x: w * 0.5, y: h * 0.24)

        // Две парты (стол + стул)
        IsoSchoolDesk(width: w * 0.18, height: h * 0.12)
            .position(x: w * 0.28, y: h * 0.78)
        IsoSchoolDesk(width: w * 0.18, height: h * 0.12)
            .position(x: w * 0.72, y: h * 0.82)

        // Глобус на столе
        ZStack {
            Circle()
                .fill(Color(hex: "#4FA3D1"))
                .overlay(Circle().stroke(Color.black.opacity(0.4), lineWidth: 1.3))
                .frame(width: 20, height: 20)
            Ellipse()
                .fill(Color(hex: "#8B5A2B"))
                .frame(width: 18, height: 4)
                .offset(y: 12)
        }
        .position(x: w * 0.28, y: h * 0.70)

        // Полка с книгами
        IsoShelf(width: w * 0.16, height: h * 0.10)
            .position(x: w * 0.82, y: h * 0.30)
    }

    // MARK: - ПАРК

    @ViewBuilder
    private func parkDecor(w: CGFloat, h: CGFloat) -> some View {
        // Дерево
        ZStack {
            Ellipse()
                .fill(Color.black.opacity(0.18))
                .frame(width: 60, height: 12)
                .offset(y: 40)
            Capsule()
                .fill(Color(hex: "#8B5A2B"))
                .overlay(Capsule().stroke(Color.black.opacity(0.4), lineWidth: 1.5))
                .frame(width: 14, height: 60)
                .offset(y: 10)
            Circle()
                .fill(Color(hex: "#4CAF50"))
                .overlay(Circle().stroke(Color.black.opacity(0.35), lineWidth: 2))
                .frame(width: 90, height: 90)
                .offset(y: -30)
            Circle()
                .fill(Color(hex: "#66BB6A"))
                .frame(width: 40, height: 40)
                .offset(x: -15, y: -40)
        }
        .position(x: w * 0.20, y: h * 0.70)

        // Второе дерево
        ZStack {
            Ellipse()
                .fill(Color.black.opacity(0.18))
                .frame(width: 50, height: 10)
                .offset(y: 35)
            Capsule()
                .fill(Color(hex: "#8B5A2B"))
                .overlay(Capsule().stroke(Color.black.opacity(0.4), lineWidth: 1.5))
                .frame(width: 12, height: 50)
                .offset(y: 8)
            Circle()
                .fill(Color(hex: "#4CAF50"))
                .overlay(Circle().stroke(Color.black.opacity(0.35), lineWidth: 2))
                .frame(width: 75, height: 75)
                .offset(y: -25)
        }
        .position(x: w * 0.80, y: h * 0.76)

        // Скамейка
        ZStack {
            HStack(spacing: 26) {
                Capsule().fill(Color(hex: "#5C3B1E")).frame(width: 4, height: 14)
                Capsule().fill(Color(hex: "#5C3B1E")).frame(width: 4, height: 14)
            }
            .offset(y: 6)
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(hex: "#A6714A"))
                .overlay(RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.black.opacity(0.4), lineWidth: 1.3))
                .frame(width: 50, height: 8)
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(hex: "#A6714A"))
                .overlay(RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.black.opacity(0.4), lineWidth: 1.2))
                .frame(width: 50, height: 4)
                .offset(y: -10)
        }
        .position(x: w * 0.5, y: h * 0.82)
    }

    // MARK: - ПЛЯЖ

    @ViewBuilder
    private func beachDecor(w: CGFloat, h: CGFloat) -> some View {
        // Зонт
        ZStack {
            // Ножка
            Capsule()
                .fill(Color(hex: "#8B5A2B"))
                .frame(width: 4, height: 70)
                .offset(y: 20)
            // Купол
            ZStack {
                Path { p in
                    let w: CGFloat = 90
                    let hh: CGFloat = 40
                    p.move(to: CGPoint(x: 0, y: hh))
                    p.addQuadCurve(
                        to: CGPoint(x: w, y: hh),
                        control: CGPoint(x: w / 2, y: -hh * 0.9)
                    )
                    p.closeSubpath()
                }
                .fill(Color(hex: "#E85C5C"))
                .frame(width: 90, height: 40)
                .overlay(
                    Path { p in
                        let w: CGFloat = 90
                        let hh: CGFloat = 40
                        p.move(to: CGPoint(x: 0, y: hh))
                        p.addQuadCurve(
                            to: CGPoint(x: w, y: hh),
                            control: CGPoint(x: w / 2, y: -hh * 0.9)
                        )
                    }
                    .stroke(Color.black.opacity(0.4), lineWidth: 1.8)
                    .frame(width: 90, height: 40)
                )
            }
            .offset(y: -20)
        }
        .position(x: w * 0.25, y: h * 0.68)

        // Мяч
        Circle()
            .fill(Color(hex: "#FBBF24"))
            .overlay(
                Circle().stroke(Color.black.opacity(0.35), lineWidth: 1.5)
            )
            .overlay(
                Circle().trim(from: 0, to: 0.5)
                    .stroke(Color.white, lineWidth: 2)
                    .rotationEffect(.degrees(45))
            )
            .frame(width: 26, height: 26)
            .position(x: w * 0.62, y: h * 0.86)

        // Полотенце
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(hex: "#64B5F6"))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.black.opacity(0.3), lineWidth: 1.3)
            )
            .frame(width: 60, height: 24)
            .position(x: w * 0.75, y: h * 0.84)
    }

    // MARK: - Цвета

    private var ceilingColor: Color {
        switch location {
        case .home:     return Color(hex: "#FFF8F0")
        case .cafe:     return Color(hex: "#FFF1E0")
        case .shop:     return Color(hex: "#F0F8E8")
        case .hospital: return Color(hex: "#F5FBFF")
        case .school:   return Color(hex: "#FFFCEB")
        case .park:     return Color(hex: "#BEE3FF")
        case .beach:    return Color(hex: "#BEE3FF")
        }
    }

    private var backWallColor: Color {
        switch location {
        case .home:     return Color(hex: "#F5D9B8")
        case .cafe:     return Color(hex: "#F0C9A0")
        case .shop:     return Color(hex: "#E2EFCF")
        case .hospital: return Color(hex: "#E8F4FC")
        case .school:   return Color(hex: "#F9E8C2")
        case .park:     return Color(hex: "#A6D98A")
        case .beach:    return Color(hex: "#4FC3F7")
        }
    }

    private var sideWallColor: Color {
        backWallColor.opacity(0.82)
    }

    private var floorColor: Color {
        switch location {
        case .home:     return Color(hex: "#C89B6E")
        case .cafe:     return Color(hex: "#B87850")
        case .shop:     return Color(hex: "#C4A886")
        case .hospital: return Color(hex: "#B9D4E5")
        case .school:   return Color(hex: "#B8875A")
        case .park:     return Color(hex: "#7BC05A")
        case .beach:    return Color(hex: "#FFE9A8")
        }
    }

    private var baseboardColor: Color {
        backWallColor.opacity(0.55)
    }
}

// MARK: - Мебель (объёмные фигуры с тенями)

struct IsoSofa: View {
    let width: CGFloat
    let height: CGFloat
    let bodyColor: Color
    let pillowColor: Color

    var body: some View {
        ZStack {
            // Тень
            Ellipse()
                .fill(Color.black.opacity(0.20))
                .frame(width: width * 0.95, height: height * 0.14)
                .blur(radius: 3)
                .offset(y: height * 0.45)

            // Спинка
            RoundedRectangle(cornerRadius: 6)
                .fill(bodyColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black.opacity(0.4), lineWidth: 1.6)
                )
                .frame(width: width, height: height * 0.65)
                .offset(y: -height * 0.12)

            // Сиденье
            RoundedRectangle(cornerRadius: 6)
                .fill(bodyColor.opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black.opacity(0.4), lineWidth: 1.6)
                )
                .frame(width: width * 1.02, height: height * 0.32)
                .offset(y: height * 0.18)

            // Подушки
            HStack(spacing: width * 0.08) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(pillowColor)
                    .overlay(RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.black.opacity(0.3), lineWidth: 1.2))
                    .frame(width: width * 0.22, height: height * 0.28)
                RoundedRectangle(cornerRadius: 4)
                    .fill(pillowColor)
                    .overlay(RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.black.opacity(0.3), lineWidth: 1.2))
                    .frame(width: width * 0.22, height: height * 0.28)
            }
            .offset(y: -height * 0.12)

            // Подлокотники
            HStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(bodyColor.opacity(0.85))
                    .overlay(RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.black.opacity(0.4), lineWidth: 1.4))
                    .frame(width: width * 0.13, height: height * 0.45)
                Spacer()
                RoundedRectangle(cornerRadius: 4)
                    .fill(bodyColor.opacity(0.85))
                    .overlay(RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.black.opacity(0.4), lineWidth: 1.4))
                    .frame(width: width * 0.13, height: height * 0.45)
            }
            .frame(width: width * 1.02)
            .offset(y: height * 0.05)
        }
        .frame(width: width, height: height)
    }
}

struct IsoCoffeeTable: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color.black.opacity(0.20))
                .frame(width: width * 0.9, height: height * 0.28)
                .blur(radius: 2)
                .offset(y: height * 0.5)

            // Ножки
            HStack(spacing: width * 0.55) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(hex: "#7A5033"))
                    .frame(width: 6, height: height * 0.5)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(hex: "#7A5033"))
                    .frame(width: 6, height: height * 0.5)
            }
            .offset(y: height * 0.2)

            // Столешница
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(hex: "#A6714A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black.opacity(0.4), lineWidth: 1.6)
                )
                .frame(width: width, height: height * 0.45)
                .offset(y: -height * 0.15)
        }
        .frame(width: width, height: height)
    }
}

struct IsoLamp: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color.black.opacity(0.18))
                .frame(width: width * 1.2, height: 8)
                .blur(radius: 2)
                .offset(y: height * 0.5)

            // Штатив
            Capsule()
                .fill(Color(hex: "#37474F"))
                .frame(width: 4, height: height * 0.75)
                .offset(y: height * 0.10)

            // Абажур (трапеция)
            Path { p in
                let w = width
                let h = height * 0.3
                p.move(to: CGPoint(x: w * 0.15, y: 0))
                p.addLine(to: CGPoint(x: w * 0.85, y: 0))
                p.addLine(to: CGPoint(x: w, y: h))
                p.addLine(to: CGPoint(x: 0, y: h))
                p.closeSubpath()
            }
            .fill(Color(hex: "#F5B300"))
            .overlay(
                Path { p in
                    let w = width
                    let h = height * 0.3
                    p.move(to: CGPoint(x: w * 0.15, y: 0))
                    p.addLine(to: CGPoint(x: w * 0.85, y: 0))
                    p.addLine(to: CGPoint(x: w, y: h))
                    p.addLine(to: CGPoint(x: 0, y: h))
                }
                .stroke(Color.black.opacity(0.4), lineWidth: 1.6)
            )
            .frame(width: width, height: height * 0.3)
            .offset(y: -height * 0.30)
        }
        .frame(width: width, height: height)
    }
}

struct IsoWallPicture: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(hex: "#8B5A2B"))
                .frame(width: width + 6, height: height + 6)
                .shadow(color: .black.opacity(0.25), radius: 3, y: 2)

            RoundedRectangle(cornerRadius: 2)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#F5D9B8"), Color(hex: "#E8B88A")],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(width: width, height: height)
                .overlay(
                    // Абстрактный пейзаж
                    VStack(spacing: 2) {
                        Circle()
                            .fill(Color(hex: "#FFB84D"))
                            .frame(width: 10, height: 10)
                            .offset(x: 10, y: -4)
                        Rectangle()
                            .fill(Color(hex: "#7BC05A"))
                            .frame(width: width * 0.8, height: 3)
                    }
                )
        }
    }
}

struct IsoShelf: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            // Задняя стенка
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(hex: "#8B5A2B"))
                .frame(width: width, height: height)

            // Книги
            VStack(spacing: 2) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 2) {
                        ForEach(0..<5, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 1)
                                .fill(bookColor(row: row, col: i))
                                .frame(width: width * 0.14, height: height * 0.22)
                        }
                    }
                }
            }

            // Рамка
            RoundedRectangle(cornerRadius: 2)
                .stroke(Color.black.opacity(0.5), lineWidth: 1.8)
                .frame(width: width, height: height)
        }
    }

    private func bookColor(row: Int, col: Int) -> Color {
        let colors: [Color] = [
            Color(hex: "#E85C5C"), Color(hex: "#4FA3D1"),
            Color(hex: "#F5B300"), Color(hex: "#7BC05A"),
            Color(hex: "#C97B84")
        ]
        return colors[(row * 5 + col) % colors.count]
    }
}

struct IsoBarCounter: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color.black.opacity(0.20))
                .frame(width: width * 0.9, height: height * 0.15)
                .blur(radius: 3)
                .offset(y: height * 0.5)

            // Корпус
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(hex: "#5C3B1E"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.black.opacity(0.45), lineWidth: 1.8)
                )
                .frame(width: width * 0.92, height: height * 0.8)
                .offset(y: height * 0.06)

            // Верхняя полка — столешница
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(hex: "#A6714A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.black.opacity(0.45), lineWidth: 1.8)
                )
                .frame(width: width, height: height * 0.22)
                .offset(y: -height * 0.35)
        }
        .frame(width: width, height: height)
    }
}

struct IsoStool: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color.black.opacity(0.22))
                .frame(width: width * 1.1, height: 6)
                .blur(radius: 2)
                .offset(y: height * 0.5)

            // Ножки
            HStack(spacing: width * 0.5) {
                Capsule().fill(Color(hex: "#5C3B1E"))
                    .frame(width: 3, height: height * 0.55)
                Capsule().fill(Color(hex: "#5C3B1E"))
                    .frame(width: 3, height: height * 0.55)
            }
            .offset(y: height * 0.18)

            // Сиденье
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(hex: "#A6714A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.black.opacity(0.4), lineWidth: 1.5)
                )
                .frame(width: width, height: height * 0.3)
                .offset(y: -height * 0.15)
        }
        .frame(width: width, height: height)
    }
}

struct IsoCafeTable: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color.black.opacity(0.20))
                .frame(width: width * 0.9, height: 8)
                .blur(radius: 2)
                .offset(y: height * 0.5)

            // Ножка
            Capsule()
                .fill(Color(hex: "#5C3B1E"))
                .frame(width: 5, height: height * 0.85)
                .offset(y: height * 0.1)

            // Столешница
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(hex: "#A6714A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.black.opacity(0.4), lineWidth: 1.6)
                )
                .frame(width: width, height: height * 0.35)
                .offset(y: -height * 0.2)
        }
        .frame(width: width, height: height)
    }
}

struct IsoShelfWithGoods: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            // Корпус
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(hex: "#8B5A2B"))
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color.black.opacity(0.5), lineWidth: 1.8)
                )
                .frame(width: width, height: height)

            // Полки с товарами
            VStack(spacing: 0) {
                ForEach(0..<4, id: \.self) { _ in
                    HStack(spacing: 2) {
                        ForEach(0..<4, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 1)
                                .fill(goodsColor(index: i))
                                .frame(width: width * 0.18, height: height * 0.14)
                        }
                    }
                    .frame(height: height * 0.25)
                }
            }
        }
    }

    private func goodsColor(index: Int) -> Color {
        let colors: [Color] = [
            Color(hex: "#E85C5C"), Color(hex: "#4FA3D1"),
            Color(hex: "#F5B300"), Color(hex: "#7BC05A")
        ]
        return colors[index % colors.count]
    }
}

struct IsoHospitalBed: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color.black.opacity(0.20))
                .frame(width: width * 1.02, height: height * 0.14)
                .blur(radius: 3)
                .offset(y: height * 0.48)

            // Ножки
            HStack(spacing: width * 0.7) {
                Capsule().fill(Color(hex: "#90A4AE"))
                    .frame(width: 4, height: height * 0.35)
                Capsule().fill(Color(hex: "#90A4AE"))
                    .frame(width: 4, height: height * 0.35)
            }
            .offset(y: height * 0.28)

            // Матрас
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black.opacity(0.35), lineWidth: 1.6)
                )
                .frame(width: width, height: height * 0.45)
                .offset(y: height * 0.02)

            // Одеяло
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(hex: "#7FC7E8"))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black.opacity(0.3), lineWidth: 1.3)
                )
                .frame(width: width * 0.85, height: height * 0.32)
                .offset(x: width * 0.06, y: height * 0.10)

            // Подушка
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black.opacity(0.3), lineWidth: 1.3)
                )
                .frame(width: width * 0.22, height: height * 0.25)
                .offset(x: -width * 0.35, y: -height * 0.12)
        }
        .frame(width: width, height: height)
    }
}

struct IsoSchoolDesk: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color.black.opacity(0.20))
                .frame(width: width * 0.95, height: height * 0.14)
                .blur(radius: 2)
                .offset(y: height * 0.5)

            // Ножки стола
            HStack(spacing: width * 0.55) {
                Capsule().fill(Color(hex: "#5C3B1E"))
                    .frame(width: 3, height: height * 0.5)
                Capsule().fill(Color(hex: "#5C3B1E"))
                    .frame(width: 3, height: height * 0.5)
            }
            .offset(y: height * 0.2)

            // Столешница
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(hex: "#C68B59"))
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color.black.opacity(0.4), lineWidth: 1.5)
                )
                .frame(width: width, height: height * 0.3)
                .offset(y: -height * 0.1)

            // Стул (сбоку/сзади)
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(hex: "#7BC05A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.black.opacity(0.4), lineWidth: 1.4)
                )
                .frame(width: width * 0.35, height: height * 0.15)
                .offset(y: height * 0.28)
        }
        .frame(width: width, height: height)
    }
}
