import SwiftUI

struct AvatarBody: View {

    let player: Player
    let size: CGFloat

    private var skin: Color {
        Palette.skinTones[safe: player.skinTone] ?? Palette.skinTones[1]
    }
    private var outfit: Color {
        Palette.outfitColors[safe: player.outfitColor] ?? Palette.outfitColors[0]
    }

    var body: some View {
        ZStack {
            legsLayer
            bodyLayer
            armsLayer
        }
    }

    // MARK: - Ноги

    private var legsLayer: some View {
        let legW = size * 0.07
        let legH = size * 0.19
        let legTop = size * 0.79
        let gap: CGFloat = size * 0.04
        let legColor = legColorForStyle

        return ZStack {
            leg(side: -1, legW: legW, legH: legH, legTop: legTop, gap: gap, color: legColor)
            leg(side: 1,  legW: legW, legH: legH, legTop: legTop, gap: gap, color: legColor)
        }
    }

    private var legColorForStyle: Color {
        if player.outfitStyle == 2 || player.outfitStyle == 6 {
            return skin
        }
        return outfit
    }

    private func leg(side: CGFloat, legW: CGFloat, legH: CGFloat,
                     legTop: CGFloat, gap: CGFloat, color: Color) -> some View {
        let shoeW = size * 0.10
        let shoeH = size * 0.05
        let cx = size / 2 + side * (gap / 2 + legW / 2)
        let legCY = legTop + legH / 2
        let shoeCY = legTop + legH + shoeH * 0.15

        return ZStack {
            RoundedRectangle(cornerRadius: legW * 0.45)
                .fill(color)
                .overlay(
                    RoundedRectangle(cornerRadius: legW * 0.45)
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.5)
                )
                .frame(width: legW, height: legH)
                .position(x: cx, y: legCY)

            shoeShape(side: side, shoeW: shoeW, shoeH: shoeH)
                .position(x: cx + side * size * 0.005, y: shoeCY)
        }
    }

    private func shoeShape(side: CGFloat, shoeW: CGFloat, shoeH: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: shoeH * 0.5)
                .fill(Color(hex: "#2C2C36"))
                .overlay(
                    RoundedRectangle(cornerRadius: shoeH * 0.5)
                        .stroke(Color.black, lineWidth: 1.5)
                )

            RoundedRectangle(cornerRadius: shoeH * 0.3)
                .fill(Color.white.opacity(0.9))
                .frame(width: shoeW * 0.9, height: shoeH * 0.3)
                .offset(y: shoeH * 0.18)
        }
        .frame(width: shoeW, height: shoeH)
    }

    // MARK: - Тело

    private var bodyLayer: some View {
        let bodyW = size * 0.24
        let bodyH = size * 0.22
        let bodyCY = size * 0.68

        return ZStack {
            bodyShape(bodyW: bodyW, bodyH: bodyH)
                .position(x: size / 2, y: bodyCY)

            bodyDecor(bodyW: bodyW, bodyH: bodyH)
                .position(x: size / 2, y: bodyCY)
        }
    }

    @ViewBuilder
    private func bodyShape(bodyW: CGFloat, bodyH: CGFloat) -> some View {
        switch player.outfitStyle {
        case 2, 6: // Платье / Сарафан
            TocaDressShape()
                .fill(outfit)
                .overlay(
                    TocaDressShape()
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.8)
                )
                .frame(width: bodyW * 1.15, height: bodyH * 1.15)
        case 7: // Костюм
            RoundedRectangle(cornerRadius: bodyW * 0.3)
                .fill(outfit)
                .overlay(
                    RoundedRectangle(cornerRadius: bodyW * 0.3)
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.8)
                )
                .frame(width: bodyW, height: bodyH)
        default: // Обычная
            RoundedRectangle(cornerRadius: bodyW * 0.35)
                .fill(outfit)
                .overlay(
                    RoundedRectangle(cornerRadius: bodyW * 0.35)
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.8)
                )
                .frame(width: bodyW, height: bodyH)
        }
    }

    @ViewBuilder
    private func bodyDecor(bodyW: CGFloat, bodyH: CGFloat) -> some View {
        ZStack {
            // Воротник
            RoundedRectangle(cornerRadius: bodyW * 0.08)
                .fill(outfit.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: bodyW * 0.08)
                        .stroke(Color.black.opacity(0.3), lineWidth: 1)
                )
                .frame(width: bodyW * 0.4, height: bodyW * 0.14)
                .offset(y: -bodyH * 0.45)

            // Декор по стилю
            switch player.outfitStyle {
            case 0: // Футболка — маленький принт
                Circle()
                    .fill(Color.white.opacity(0.5))
                    .frame(width: bodyW * 0.15, height: bodyW * 0.15)
                    .offset(y: -bodyH * 0.05)
            case 1: // Рубашка — пуговицы
                VStack(spacing: bodyH * 0.08) {
                    ForEach(0..<3, id: \.self) { _ in
                        Circle()
                            .fill(Color.white.opacity(0.8))
                            .frame(width: 3, height: 3)
                    }
                }
            case 3: // Худи — карман
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.black.opacity(0.15))
                    .frame(width: bodyW * 0.5, height: bodyH * 0.2)
                    .offset(y: bodyH * 0.2)
            case 4: // Свитер — полоски
                VStack(spacing: bodyH * 0.12) {
                    ForEach(0..<3, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.white.opacity(0.25))
                            .frame(width: bodyW * 0.9, height: 1.5)
                    }
                }
            case 5: // Комбинезон — молния
                Rectangle()
                    .fill(Color.black.opacity(0.3))
                    .frame(width: 1.5, height: bodyH * 0.7)
            case 8: // Куртка — полы
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.black.opacity(0.2))
                        .frame(width: 1.5, height: bodyH * 0.8)
                }
            case 9: // Жилет
                Rectangle()
                    .fill(Color.black.opacity(0.2))
                    .frame(width: 1.5, height: bodyH * 0.8)
            case 10: // Фартук
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white.opacity(0.7))
                    .frame(width: bodyW * 0.5, height: bodyH * 0.5)
                    .offset(y: bodyH * 0.15)
            case 11: // Мантия
                VStack {
                    Spacer()
                    Triangle()
                        .fill(Color.black.opacity(0.15))
                        .frame(width: bodyW * 1.2, height: bodyH * 0.5)
                        .offset(y: bodyH * 0.4)
                }
            default:
                EmptyView()
            }
        }
    }

    // MARK: - Руки (разведены в стороны, как у Ани и Демьяна)

    private var armsLayer: some View {
        let armW = size * 0.055
        let armH = size * 0.20
        let shoulderY = size * 0.60
        let bodyW = size * 0.24
        let armOffsetX = bodyW * 0.42

        let leftShoulderX  = size / 2 - armOffsetX
        let rightShoulderX = size / 2 + armOffsetX

        return ZStack {
            arm(side: -1, armW: armW, armH: armH,
                shoulderX: leftShoulderX,  shoulderY: shoulderY)
            arm(side: 1,  armW: armW, armH: armH,
                shoulderX: rightShoulderX, shoulderY: shoulderY)
        }
    }

    private func arm(side: CGFloat, armW: CGFloat, armH: CGFloat,
                     shoulderX: CGFloat, shoulderY: CGFloat) -> some View {
        // Угол разведения: 32° в стороны
        let angleDeg: Double = Double(side) * 32.0
        let angleRad: CGFloat = CGFloat(angleDeg) * .pi / 180.0
        let handSize = size * 0.085
        let fingerSize = handSize * 0.4

        // Позиция кисти через тригонометрию (плечо → рука вниз под углом)
        let armLen = armH + handSize * 0.25
        let handX = shoulderX + sin(angleRad) * armLen
        let handY = shoulderY + cos(angleRad) * armLen

        // Середина палочки руки
        let midLen = armH * 0.5
        let midX = shoulderX + sin(angleRad) * midLen
        let midY = shoulderY + cos(angleRad) * midLen

        return ZStack {
            // Палочка руки — повёрнута под углом
            Capsule()
                .fill(skin)
                .overlay(
                    Capsule().stroke(Color.black.opacity(0.55), lineWidth: 1.5)
                )
                .frame(width: armW, height: armH)
                .rotationEffect(.degrees(angleDeg))
                .position(x: midX, y: midY)

            // Кисть
            Circle()
                .fill(skin)
                .overlay(
                    Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.5)
                )
                .frame(width: handSize, height: handSize)
                .position(x: handX, y: handY)

            // Пальчик — с внутренней стороны кисти
            Circle()
                .fill(skin)
                .overlay(
                    Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.2)
                )
                .frame(width: fingerSize, height: fingerSize)
                .position(
                    x: handX - side * handSize * 0.55,
                    y: handY - handSize * 0.15
                )
        }
    }
}

// MARK: - Форма платья

struct TocaDressShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        p.move(to: CGPoint(x: w * 0.15, y: 0))
        p.addLine(to: CGPoint(x: w * 0.85, y: 0))
        p.addLine(to: CGPoint(x: w, y: h * 0.4))
        p.addLine(to: CGPoint(x: w * 0.95, y: h))
        p.addLine(to: CGPoint(x: w * 0.05, y: h))
        p.addLine(to: CGPoint(x: 0, y: h * 0.4))
        p.closeSubpath()
        return p
    }
}
