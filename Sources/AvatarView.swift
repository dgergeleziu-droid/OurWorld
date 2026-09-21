import SwiftUI

struct AvatarView: View {

    let player: Player
    var size: CGFloat = 200

    var body: some View {
        ZStack {
            if let imageName = player.imageName,
               let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                TocaAvatar(player: player, size: size)
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Toca Boca стиль

struct TocaAvatar: View {

    let player: Player
    let size: CGFloat

    // Цвета
    private var skin: Color {
        Palette.skinTones[safe: player.skinTone] ?? Palette.skinTones[1]
    }
    private var hair: Color {
        Palette.hairColors[safe: player.hairColor] ?? Palette.hairColors[0]
    }
    private var eye: Color {
        Palette.eyeColors[safe: player.eyeColor] ?? Palette.eyeColors[0]
    }
    private var outfit: Color {
        Palette.outfitColors[safe: player.outfitColor] ?? Palette.outfitColors[0]
    }

    private var W: CGFloat { size }
    private var H: CGFloat { size }

    // Пропорции Toca Boca
    private let headCenterYRatio: CGFloat = 0.30
    private let headHeightRatio: CGFloat = 0.55
    private let headWidthRatio: CGFloat = 0.55
    private let bodyCenterYRatio: CGFloat = 0.68
    private let bodyHeightRatio: CGFloat = 0.22
    private let bodyWidthRatio: CGFloat = 0.24
    private let legsTopRatio: CGFloat = 0.79
    private let legsBottomRatio: CGFloat = 0.98

    var body: some View {
        ZStack {
            // Тень под ногами
            Ellipse()
                .fill(Color.black.opacity(0.12))
                .frame(width: W * 0.35, height: H * 0.025)
                .position(x: W / 2, y: H * 0.99)

            // Задние длинные волосы (для стилей 1, 8, 10)
            backHairLayer

            // Ноги
            legsLayer

            // Тело
            bodyLayer

            // Руки
            armsLayer

            // Голова (с ушами, лицом)
            headLayer

            // Волосы спереди
            frontHairLayer

            // Аксессуар
            accessoryLayer
        }
        .frame(width: W, height: H)
    }

    // MARK: - Задние волосы

    @ViewBuilder
    private var backHairLayer: some View {
        let hs = player.hairStyle
        let headH = H * headHeightRatio
        let headW = W * headWidthRatio
        let headCY = H * headCenterYRatio

        if hs == 1 || hs == 8 || hs == 10 {
            // Длинные волосы — рисуем "полотно" за головой
            RoundedRectangle(cornerRadius: headW * 0.4)
                .fill(hair)
                .frame(width: headW * 1.05, height: headH * 1.45)
                .position(x: W / 2, y: headCY + headH * 0.35)
        } else if hs == 3 {
            // Два хвоста — круги за головой
            Circle()
                .fill(hair)
                .frame(width: headW * 0.36, height: headW * 0.36)
                .position(x: W / 2 - headW * 0.58, y: headCY + headH * 0.15)
            Circle()
                .fill(hair)
                .frame(width: headW * 0.36, height: headW * 0.36)
                .position(x: W / 2 + headW * 0.58, y: headCY + headH * 0.15)
        } else if hs == 2 {
            // Хвостик справа
            Circle()
                .fill(hair)
                .frame(width: headW * 0.42, height: headW * 0.42)
                .position(x: W / 2 + headW * 0.55, y: headCY + headH * 0.05)
        }
    }

    // MARK: - Ноги

    private var legsLayer: some View {
        let legW = H * 0.07
        let legH = H * (legsBottomRatio - legsTopRatio)
        let legTop = H * legsTopRatio
        let gap: CGFloat = H * 0.04
        let legColor: Color = {
            if player.outfitStyle == 2 || player.outfitStyle == 6 {
                return skin
            }
            return outfit
        }()

        return ZStack {
            // Левая нога
            RoundedRectangle(cornerRadius: legW * 0.45)
                .fill(legColor)
                .overlay(
                    RoundedRectangle(cornerRadius: legW * 0.45)
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.5)
                )
                .frame(width: legW, height: legH)
                .position(x: W / 2 - gap / 2 - legW / 2,
                          y: legTop + legH / 2)

            // Правая нога
            RoundedRectangle(cornerRadius: legW * 0.45)
                .fill(legColor)
                .overlay(
                    RoundedRectangle(cornerRadius: legW * 0.45)
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.5)
                )
                .frame(width: legW, height: legH)
                .position(x: W / 2 + gap / 2 + legW / 2,
                          y: legTop + legH / 2)

            // Ботинки
            shoe(side: -1, legTop: legTop, legH: legH, legW: legW, gap: gap)
            shoe(side: 1,  legTop: legTop, legH: legH, legW: legW, gap: gap)
        }
    }

    private func shoe(side: CGFloat, legTop: CGFloat, legH: CGFloat,
                      legW: CGFloat, gap: CGFloat) -> some View {
        let shoeW = H * 0.10
        let shoeH = H * 0.05
        let cx = W / 2 + side * (gap / 2 + legW / 2) + side * H * 0.005
        let cy = legTop + legH + shoeH * 0.15

        return RoundedRectangle(cornerRadius: shoeH * 0.5)
            .fill(Color(hex: "#2C2C36"))
            .overlay(
                RoundedRectangle(cornerRadius: shoeH * 0.5)
                    .stroke(Color.black, lineWidth: 1.5)
            )
            .overlay(
                // Носок ботинка (белая полоска)
                RoundedRectangle(cornerRadius: shoeH * 0.3)
                    .fill(Color.white.opacity(0.85))
                    .frame(width: shoeW * 0.85, height: shoeH * 0.25)
                    .offset(y: shoeH * 0.15)
            )
            .frame(width: shoeW, height: shoeH)
            .position(x: cx, y: cy)
    }

    // MARK: - Тело

    private var bodyLayer: some View {
        let bodyW = W * bodyWidthRatio
        let bodyH = H * bodyHeightRatio
        let bodyCY = H * bodyCenterYRatio

        return ZStack {
            // Основная фигура
            RoundedRectangle(cornerRadius: bodyW * 0.35)
                .fill(outfit)
                .overlay(
                    RoundedRectangle(cornerRadius: bodyW * 0.35)
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.8)
                )
                .frame(width: bodyW, height: bodyH)

            // Воротник (маленькая полоска сверху)
            RoundedRectangle(cornerRadius: bodyW * 0.1)
                .fill(outfit.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: bodyW * 0.1)
                        .stroke(Color.black.opacity(0.4), lineWidth: 1.2)
                )
                .frame(width: bodyW * 0.4, height: bodyW * 0.14)
                .offset(y: -bodyH * 0.42)

            // Декор для некоторых стилей
            if player.outfitStyle == 3 {
                // Худи — карман
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.black.opacity(0.12))
                    .frame(width: bodyW * 0.5, height: bodyH * 0.18)
                    .offset(y: bodyH * 0.18)
            }
        }
        .position(x: W / 2, y: bodyCY)
    }

    // MARK: - Руки

    private var armsLayer: some View {
        let armW = H * 0.055
        let armH = H * 0.20
        let shoulderY = H * 0.60
        let bodyW = W * bodyWidthRatio
        let armOffsetX = bodyW * 0.55

        return ZStack {
            arm(side: -1, armW: armW, armH: armH,
                shoulderX: W / 2 - armOffsetX, shoulderY: shoulderY)
            arm(side: 1,  armW: armW, armH: armH,
                shoulderX: W / 2 + armOffsetX, shoulderY: shoulderY)
        }
    }

    private func arm(side: CGFloat, armW: CGFloat, armH: CGFloat,
                     shoulderX: CGFloat, shoulderY: CGFloat) -> some View {
        let handSize = H * 0.085
        let handCY = shoulderY + armH + handSize * 0.1

        return ZStack {
            // Палочка-рука
            RoundedRectangle(cornerRadius: armW * 0.5)
                .fill(skin)
                .overlay(
                    RoundedRectangle(cornerRadius: armW * 0.5)
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.5)
                )
                .frame(width: armW, height: armH)
                .position(x: shoulderX, y: shoulderY + armH / 2)

            // Кисть-кружок
            Circle()
                .fill(skin)
                .overlay(
                    Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.5)
                )
                .frame(width: handSize, height: handSize)
                .position(x: shoulderX, y: handCY)

            // Пальчик — маленький кружок сбоку
            Circle()
                .fill(skin)
                .overlay(
                    Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.2)
                )
                .frame(width: handSize * 0.4, height: handSize * 0.4)
                .position(x: shoulderX - side * handSize * 0.55,
                          y: handCY - handSize * 0.15)
        }
    }

    // MARK: - Голова

    private var headLayer: some View {
        let headW = W * headWidthRatio
        let headH = H * headHeightRatio
        let headCY = H * headCenterYRatio

        return ZStack {
            // Уши
            ear(side: -1, headW: headW, headCY: headCY)
            ear(side: 1,  headW: headW, headCY: headCY)

            // Основа головы
            RoundedRectangle(cornerRadius: headW * 0.5)
                .fill(skin)
                .overlay(
                    RoundedRectangle(cornerRadius: headW * 0.5)
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.8)
                )
                .frame(width: headW, height: headH)
                .position(x: W / 2, y: headCY)

            // Брови
            eyebrow(side: -1, headW: headW, headCY: headCY)
            eyebrow(side: 1,  headW: headW, headCY: headCY)

            // Глаза
            eye(side: -1, headW: headW, headH: headH, headCY: headCY)
            eye(side: 1,  headW: headW, headH: headH, headCY: headCY)

            // Нос
            nose(headH: headH, headCY: headCY)

            // Рот
            mouth(headW: headW, headCY: headCY)

            // Румянец
            blush(side: -1, headW: headW, headCY: headCY)
            blush(side: 1,  headW: headW, headCY: headCY)
        }
    }

    private func ear(side: CGFloat, headW: CGFloat, headCY: CGFloat) -> some View {
        Circle()
            .fill(skin)
            .overlay(
                Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.5)
            )
            .frame(width: headW * 0.16, height: headW * 0.16)
            .position(x: W / 2 + side * headW * 0.48,
                      y: headCY + headW * 0.05)
    }

    private func eyebrow(side: CGFloat, headW: CGFloat, headCY: CGFloat) -> some View {
        Capsule()
            .fill(Color.black.opacity(0.85))
            .frame(width: headW * 0.14, height: headW * 0.025)
            .rotationEffect(.degrees(side < 0 ? 5 : -5))
            .position(x: W / 2 + side * headW * 0.19,
                      y: headCY - headW * 0.22)
    }

    private func eye(side: CGFloat, headW: CGFloat, headH: CGFloat,
                     headCY: CGFloat) -> some View {
        let eyeW = headW * 0.20
        let eyeH = headW * 0.22
        let cx = W / 2 + side * headW * 0.20
        let cy = headCY - headW * 0.06

        return ZStack {
            // Белок
            Ellipse()
                .fill(Color.white)
                .overlay(
                    Ellipse().stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                )
                .frame(width: eyeW, height: eyeH)
                .position(x: cx, y: cy)

            // Зрачок
            Ellipse()
                .fill(eye)
                .frame(width: eyeW * 0.68, height: eyeH * 0.68)
                .position(x: cx, y: cy)

            // Большой блик
            Circle()
                .fill(Color.white)
                .frame(width: eyeW * 0.28, height: eyeW * 0.28)
                .position(x: cx - eyeW * 0.14, y: cy - eyeH * 0.18)

            // Маленький блик
            Circle()
                .fill(Color.white.opacity(0.85))
                .frame(width: eyeW * 0.14, height: eyeW * 0.14)
                .position(x: cx + eyeW * 0.12, y: cy + eyeH * 0.15)
        }
    }

    private func nose(headH: CGFloat, headCY: CGFloat) -> some View {
        Ellipse()
            .fill(skin.opacity(0.85))
            .overlay(
                Ellipse().stroke(Color.black.opacity(0.4), lineWidth: 1.2)
            )
            .frame(width: headH * 0.05, height: headH * 0.035)
            .position(x: W / 2, y: headCY + headH * 0.08)
    }

    private func mouth(headW: CGFloat, headCY: CGFloat) -> some View {
        Group {
            switch player.mouthStyle {
            case 0: // Улыбка
                TocaSmile()
                    .stroke(Color.black.opacity(0.85),
                            style: StrokeStyle(lineWidth: 2.2, lineCap: .round))
                    .frame(width: headW * 0.16, height: headW * 0.08)
                    .position(x: W / 2, y: headCY + headW * 0.24)
            case 1: // Нейтральный
                Capsule()
                    .fill(Color.black.opacity(0.85))
                    .frame(width: headW * 0.10, height: 2.2)
                    .position(x: W / 2, y: headCY + headW * 0.25)
            case 2: // Грустный
                TocaSmile()
                    .stroke(Color.black.opacity(0.85),
                            style: StrokeStyle(lineWidth: 2.2, lineCap: .round))
                    .frame(width: headW * 0.16, height: headW * 0.08)
                    .rotationEffect(.degrees(180))
                    .position(x: W / 2, y: headCY + headW * 0.28)
            case 3: // Открытый (рот)
                Ellipse()
                    .fill(Color(hex: "#4A2C2A"))
                    .overlay(
                        Ellipse().stroke(Color.black.opacity(0.7), lineWidth: 1.4)
                    )
                    .frame(width: headW * 0.10, height: headW * 0.13)
                    .position(x: W / 2, y: headCY + headW * 0.26)
            case 4: // Смех
                Ellipse()
                    .fill(Color(hex: "#4A2C2A"))
                    .overlay(
                        Ellipse().stroke(Color.black.opacity(0.7), lineWidth: 1.4)
                    )
                    .overlay(
                        // Язычок
                        Ellipse()
                            .fill(Color(hex: "#E85C5C"))
                            .frame(width: headW * 0.06, height: headW * 0.04)
                            .offset(y: headW * 0.03)
                    )
                    .frame(width: headW * 0.16, height: headW * 0.16)
                    .position(x: W / 2, y: headCY + headW * 0.26)
            default: // Удивление
                Circle()
                    .fill(Color(hex: "#4A2C2A"))
                    .overlay(
                        Circle().stroke(Color.black.opacity(0.7), lineWidth: 1.4)
                    )
                    .frame(width: headW * 0.08, height: headW * 0.08)
                    .position(x: W / 2, y: headCY + headW * 0.26)
            }
        }
    }

    private func blush(side: CGFloat, headW: CGFloat, headCY: CGFloat) -> some View {
        Ellipse()
            .fill(Color(hex: "#F4A0A0").opacity(0.45))
            .frame(width: headW * 0.14, height: headW * 0.08)
            .position(x: W / 2 + side * headW * 0.32,
                      y: headCY + headW * 0.15)
    }

    // MARK: - Передние волосы

    private var frontHairLayer: some View {
        let headW = W * headWidthRatio
        let headH = H * headHeightRatio
        let headCY = H * headCenterYRatio
        let top = headCY - headH * 0.5

        return Group {
            switch player.hairStyle {
            case 0: // Короткие
                shortHair(headW: headW, headH: headH, top: top)
            case 1: // Длинные
                longHair(headW: headW, headH: headH, top: top)
            case 2: // Хвостик
                ponytailHair(headW: headW, headH: headH, top: top)
            case 3: // Два хвоста
                twinTailsHair(headW: headW, headH: headH, top: top)
            case 4: // Пучок
                bunHair(headW: headW, headH: headH, top: top)
            case 5: // Кудри
                curlyHair(headW: headW, headH: headH, top: top)
            case 6: // Косички
                braidsHair(headW: headW, headH: headH, top: top)
            case 7: // Ирокез
                mohawkHair(headW: headW, headH: headH, top: top)
            case 8: // Прямые
                straightHair(headW: headW, headH: headH, top: top)
            case 9: // Волны
                wavyHair(headW: headW, headH: headH, top: top)
            case 10: // Каре
                bobHair(headW: headW, headH: headH, top: top)
            default: // Лысый
                EmptyView()
            }
        }
    }

    private func hairCap(headW: CGFloat, headH: CGFloat, top: CGFloat,
                         scaleW: CGFloat = 1.04, scaleH: CGFloat = 0.5,
                         yOffset: CGFloat = 0.28) -> some View {
        RoundedRectangle(cornerRadius: headW * 0.5)
            .fill(hair)
            .overlay(
                RoundedRectangle(cornerRadius: headW * 0.5)
                    .stroke(Color.black.opacity(0.55), lineWidth: 1.6)
            )
            .frame(width: headW * scaleW, height: headH * scaleH)
            .position(x: W / 2, y: top + headH * yOffset)
    }

    private func shortHair(headW: CGFloat, headH: CGFloat, top: CGFloat) -> some View {
        hairCap(headW: headW, headH: headH, top: top,
                scaleW: 1.06, scaleH: 0.55, yOffset: 0.28)
    }

    private func longHair(headW: CGFloat, headH: CGFloat, top: CGFloat) -> some View {
        hairCap(headW: headW, headH: headH, top: top,
                scaleW: 1.06, scaleH: 0.52, yOffset: 0.26)
    }

    private func ponytailHair(headW: CGFloat, headH: CGFloat, top: CGFloat) -> some View {
        hairCap(headW: headW, headH: headH, top: top,
                scaleW: 1.06, scaleH: 0.55, yOffset: 0.28)
    }

    private func twinTailsHair(headW: CGFloat, headH: CGFloat, top: CGFloat) -> some View {
        hairCap(headW: headW, headH: headH, top: top,
                scaleW: 1.06, scaleH: 0.55, yOffset: 0.28)
    }

    private func bunHair(headW: CGFloat, headH: CGFloat, top: CGFloat) -> some View {
        ZStack {
            hairCap(headW: headW, headH: headH, top: top,
                    scaleW: 1.06, scaleH: 0.5, yOffset: 0.26)
            // Пучок
            Circle()
                .fill(hair)
                .overlay(
                    Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.6)
                )
                .frame(width: headW * 0.34, height: headW * 0.34)
                .position(x: W / 2, y: top - headH * 0.08)
        }
    }

    private func curlyHair(headW: CGFloat, headH: CGFloat, top: CGFloat) -> some View {
        ZStack {
            // Кружки по верху головы
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(hair)
                    .overlay(
                        Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                    )
                    .frame(width: headW * 0.28, height: headW * 0.28)
                    .position(
                        x: W / 2 + CGFloat(i - 2) * headW * 0.20,
                        y: top + headH * 0.15
                    )
            }
            // Спускающиеся кудри по бокам
            Circle()
                .fill(hair)
                .overlay(Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.4))
                .frame(width: headW * 0.30, height: headW * 0.30)
                .position(x: W / 2 - headW * 0.48, y: top + headH * 0.55)
            Circle()
                .fill(hair)
                .overlay(Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.4))
                .frame(width: headW * 0.30, height: headW * 0.30)
                .position(x: W / 2 + headW * 0.48, y: top + headH * 0.55)
        }
    }

    private func braidsHair(headW: CGFloat, headH: CGFloat, top: CGFloat) -> some View {
        ZStack {
            hairCap(headW: headW, headH: headH, top: top,
                    scaleW: 1.06, scaleH: 0.52, yOffset: 0.26)
            // Косички — 4 кружка с каждой стороны
            ForEach(0..<4, id: \.self) { i in
                Circle()
                    .fill(hair)
                    .overlay(Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.2))
                    .frame(width: headW * 0.13, height: headW * 0.13)
                    .position(
                        x: W / 2 - headW * 0.48,
                        y: top + headH * 0.55 + CGFloat(i) * headW * 0.14
                    )
                Circle()
                    .fill(hair)
                    .overlay(Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.2))
                    .frame(width: headW * 0.13, height: headW * 0.13)
                    .position(
                        x: W / 2 + headW * 0.48,
                        y: top + headH * 0.55 + CGFloat(i) * headW * 0.14
                    )
            }
        }
    }

    private func mohawkHair(headW: CGFloat, headH: CGFloat, top: CGFloat) -> some View {
        ZStack {
            // Короткие сзади и по бокам
            hairCap(headW: headW, headH: headH, top: top,
                    scaleW: 1.02, scaleH: 0.35, yOffset: 0.24)
            // Треугольники ирокеза
            ForEach(0..<5, id: \.self) { i in
                Triangle()
                    .fill(hair)
                    .overlay(
                        Triangle().stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                    )
                    .frame(width: headW * 0.13, height: headH * 0.28)
                    .position(
                        x: W / 2 + CGFloat(i - 2) * headW * 0.14,
                        y: top + headH * 0.10
                    )
            }
        }
    }

    private func straightHair(headW: CGFloat, headH: CGFloat, top: CGFloat) -> some View {
        ZStack {
            hairCap(headW: headW, headH: headH, top: top,
                    scaleW: 1.06, scaleH: 0.55, yOffset: 0.28)
            // Прямые пряди по бокам
            RoundedRectangle(cornerRadius: 6)
                .fill(hair)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                )
                .frame(width: headW * 0.16, height: headH * 0.75)
                .position(x: W / 2 - headW * 0.48, y: top + headH * 0.6)
            RoundedRectangle(cornerRadius: 6)
                .fill(hair)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                )
                .frame(width: headW * 0.16, height: headH * 0.75)
                .position(x: W / 2 + headW * 0.48, y: top + headH * 0.6)
        }
    }

    private func wavyHair(headW: CGFloat, headH: CGFloat, top: CGFloat) -> some View {
        ZStack {
            hairCap(headW: headW, headH: headH, top: top,
                    scaleW: 1.06, scaleH: 0.5, yOffset: 0.26)
            // Волны — эллипсы по бокам
            ForEach(0..<3, id: \.self) { i in
                Ellipse()
                    .fill(hair)
                    .overlay(
                        Ellipse().stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                    )
                    .frame(width: headW * 0.22, height: headW * 0.18)
                    .position(
                        x: W / 2 - headW * 0.46,
                        y: top + headH * 0.5 + CGFloat(i) * headW * 0.16
                    )
                Ellipse()
                    .fill(hair)
                    .overlay(
                        Ellipse().stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                    )
                    .frame(width: headW * 0.22, height: headW * 0.18)
                    .position(
                        x: W / 2 + headW * 0.46,
                        y: top + headH * 0.5 + CGFloat(i) * headW * 0.16
                    )
            }
        }
    }

    private func bobHair(headW: CGFloat, headH: CGFloat, top: CGFloat) -> some View {
        ZStack {
            hairCap(headW: headW, headH: headH, top: top,
                    scaleW: 1.08, scaleH: 0.6, yOffset: 0.30)
            // Боковые пряди (каре)
            RoundedRectangle(cornerRadius: 8)
                .fill(hair)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                )
                .frame(width: headW * 0.20, height: headH * 0.45)
                .position(x: W / 2 - headW * 0.48, y: top + headH * 0.75)
            RoundedRectangle(cornerRadius: 8)
                .fill(hair)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                )
                .frame(width: headW * 0.20, height: headH * 0.45)
                .position(x: W / 2 + headW * 0.48, y: top + headH * 0.75)
        }
    }

    // MARK: - Аксессуар

    @ViewBuilder
    private var accessoryLayer: some View {
        let headW = W * headWidthRatio
        let headH = H * headHeightRatio
        let headCY = H * headCenterYRatio
        let top = headCY - headH * 0.5

        switch player.accessory {
        case 1: // Очки
            glassesView(headW: headW, headCY: headCY)
        case 2: // Кепка
            capView(headW: headW, top: top, headH: headH)
        case 3: // Бант
            bowView(headW: headW, top: top, headH: headH)
        case 4: // Шляпа
            hatView(headW: headW, top: top, headH: headH)
        case 5: // Ободок
            headbandView(headW: headW, top: top, headH: headH)
        case 6: // Серёжки
            earringsView(headW: headW, headCY: headCY)
        case 7: // Маска
            maskView(headW: headW, headCY: headCY)
        default:
            EmptyView()
        }
    }

    private func glassesView(headW: CGFloat, headCY: CGFloat) -> some View {
        let eyeY = headCY - headW * 0.06
        let r = headW * 0.13
        let spacing = headW * 0.20

        return ZStack {
            Circle()
                .stroke(Color.black.opacity(0.85), lineWidth: 2.2)
                .frame(width: r * 1.7, height: r * 1.7)
                .position(x: W / 2 - spacing, y: eyeY)
            Circle()
                .stroke(Color.black.opacity(0.85), lineWidth: 2.2)
                .frame(width: r * 1.7, height: r * 1.7)
                .position(x: W / 2 + spacing, y: eyeY)
            Rectangle()
                .fill(Color.black.opacity(0.85))
                .frame(width: spacing * 0.6, height: 1.8)
                .position(x: W / 2, y: eyeY)
        }
    }

    private func capView(headW: CGFloat, top: CGFloat, headH: CGFloat) -> some View {
        ZStack {
            // Купол
            Ellipse()
                .fill(Color(hex: "#1F2937"))
                .overlay(
                    Ellipse().stroke(Color.black.opacity(0.7), lineWidth: 1.5)
                )
                .frame(width: headW * 1.05, height: headH * 0.45)
                .position(x: W / 2, y: top + headH * 0.28)
            // Козырёк
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "#0F172A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black.opacity(0.7), lineWidth: 1.4)
                )
                .frame(width: headW * 0.5, height: headH * 0.10)
                .position(x: W / 2 + headW * 0.30, y: top + headH * 0.42)
        }
    }

    private func bowView(headW: CGFloat, top: CGFloat, headH: CGFloat) -> some View {
        ZStack {
            Triangle()
                .fill(Color(hex: "#EC4899"))
                .overlay(Triangle().stroke(Color.black.opacity(0.6), lineWidth: 1.4))
                .frame(width: headW * 0.22, height: headH * 0.18)
                .rotationEffect(.degrees(90))
                .position(x: W / 2 - headW * 0.14,
                          y: top + headH * 0.35)
            Triangle()
                .fill(Color(hex: "#EC4899"))
                .overlay(Triangle().stroke(Color.black.opacity(0.6), lineWidth: 1.4))
                .frame(width: headW * 0.22, height: headH * 0.18)
                .rotationEffect(.degrees(-90))
                .position(x: W / 2 + headW * 0.14,
                          y: top + headH * 0.35)
            Circle()
                .fill(Color(hex: "#BE185D"))
                .overlay(Circle().stroke(Color.black.opacity(0.6), lineWidth: 1.2))
                .frame(width: headW * 0.09, height: headW * 0.09)
                .position(x: W / 2, y: top + headH * 0.35)
        }
    }

    private func hatView(headW: CGFloat, top: CGFloat, headH: CGFloat) -> some View {
        ZStack {
            Ellipse()
                .fill(Color(hex: "#8B5A2B"))
                .overlay(Ellipse().stroke(Color.black.opacity(0.6), lineWidth: 1.5))
                .frame(width: headW * 1.5, height: headH * 0.18)
                .position(x: W / 2, y: top + headH * 0.42)
            RoundedRectangle(cornerRadius: headW * 0.2)
                .fill(Color(hex: "#A0704A"))
                .overlay(
                    RoundedRectangle(cornerRadius: headW * 0.2)
                        .stroke(Color.black.opacity(0.6), lineWidth: 1.5)
                )
                .frame(width: headW * 0.7, height: headH * 0.45)
                .position(x: W / 2, y: top + headH * 0.22)
            Rectangle()
                .fill(Color(hex: "#1F2937"))
                .frame(width: headW * 0.7, height: headH * 0.06)
                .position(x: W / 2, y: top + headH * 0.35)
        }
    }

    private func headbandView(headW: CGFloat, top: CGFloat, headH: CGFloat) -> some View {
        Capsule()
            .fill(Color(hex: "#8B5CF6"))
            .overlay(
                Capsule().stroke(Color.black.opacity(0.6), lineWidth: 1.4)
            )
            .frame(width: headW * 1.05, height: headH * 0.08)
            .position(x: W / 2, y: top + headH * 0.35)
    }

    private func earringsView(headW: CGFloat, headCY: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(Color(hex: "#FBBF24"))
                .overlay(Circle().stroke(Color.black.opacity(0.5), lineWidth: 1))
                .frame(width: headW * 0.09, height: headW * 0.09)
                .position(x: W / 2 - headW * 0.55,
                          y: headCY + headW * 0.15)
            Circle()
                .fill(Color(hex: "#FBBF24"))
                .overlay(Circle().stroke(Color.black.opacity(0.5), lineWidth: 1))
                .frame(width: headW * 0.09, height: headW * 0.09)
                .position(x: W / 2 + headW * 0.55,
                          y: headCY + headW * 0.15)
        }
    }

    private func maskView(headW: CGFloat, headCY: CGFloat) -> some View {
        let eyeY = headCY - headW * 0.06

        return ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "#1F2937"))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1.4)
                )
                .frame(width: headW * 0.75, height: headW * 0.24)
                .position(x: W / 2, y: eyeY)

            // Прорези для глаз
            Ellipse()
                .fill(Color.white)
                .frame(width: headW * 0.15, height: headW * 0.08)
                .position(x: W / 2 - headW * 0.19, y: eyeY)
            Ellipse()
                .fill(Color.white)
                .frame(width: headW * 0.15, height: headW * 0.08)
                .position(x: W / 2 + headW * 0.19, y: eyeY)
        }
    }
}

// MARK: - Вспомогательные формы

struct TocaSmile: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.2))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.2),
            control: CGPoint(x: rect.midX, y: rect.maxY * 1.8)
        )
        return p
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
