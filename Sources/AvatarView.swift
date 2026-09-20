import SwiftUI

struct AvatarView: View {
    let player: Player
    var size: CGFloat = 200

    private var skin: Color { Color(hex: Palette.skinColors[player.skinColorIndex % Palette.skinColors.count]) }
    private var hair: Color { Color(hex: Palette.hairColors[player.hairColorIndex % Palette.hairColors.count]) }
    private var clothes: Color { Color(hex: Palette.clothesColors[player.clothesColorIndex % Palette.clothesColors.count]) }
    private var eyes: Color { Color(hex: Palette.eyeColors[player.eyeColorIndex % Palette.eyeColors.count]) }

    var body: some View {
        ZStack {
            // Ноги
            HStack(spacing: size * 0.09) {
                Capsule().fill(skin)
                    .frame(width: size * 0.1, height: size * 0.2)
                Capsule().fill(skin)
                    .frame(width: size * 0.1, height: size * 0.2)
            }
            .offset(y: size * 0.32)

            // Руки
            HStack(spacing: size * 0.46) {
                Capsule().fill(skin)
                    .frame(width: size * 0.09, height: size * 0.32)
                Capsule().fill(skin)
                    .frame(width: size * 0.09, height: size * 0.32)
            }
            .offset(y: size * 0.13)

            // Тело (одежда)
            clothesShape
                .offset(y: size * 0.16)

            // Волосы сзади
            hairBack
                .offset(y: -size * 0.14)

            // Голова
            Circle()
                .fill(skin)
                .frame(width: size * 0.6, height: size * 0.6)
                .offset(y: -size * 0.14)

            // Уши
            HStack(spacing: size * 0.56) {
                Circle().fill(skin).frame(width: size * 0.08, height: size * 0.1)
                Circle().fill(skin).frame(width: size * 0.08, height: size * 0.1)
            }
            .offset(y: -size * 0.1)

            // Лицо
            faceFeatures
                .offset(y: -size * 0.12)

            // Волосы спереди
            hairFront
                .offset(y: -size * 0.14)
        }
        .frame(width: size, height: size)
    }

    // MARK: - Одежда
    @ViewBuilder
    var clothesShape: some View {
        switch player.clothesStyleIndex % 3 {
        case 0:
            // Футболка
            RoundedRectangle(cornerRadius: size * 0.08)
                .fill(clothes)
                .frame(width: size * 0.38, height: size * 0.34)
        case 1:
            // Платье (трапеция)
            DressShape()
                .fill(clothes)
                .frame(width: size * 0.5, height: size * 0.42)
        default:
            // Худи с капюшоном
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.08)
                    .fill(clothes)
                    .frame(width: size * 0.38, height: size * 0.34)
                Circle()
                    .fill(clothes.opacity(0.85))
                    .frame(width: size * 0.22, height: size * 0.22)
                    .offset(y: -size * 0.16)
            }
        }
    }

    // MARK: - Лицо
    var faceFeatures: some View {
        VStack(spacing: size * 0.03) {
            // Брови
            HStack(spacing: size * 0.18) {
                Capsule().fill(hair.opacity(0.9))
                    .frame(width: size * 0.1, height: size * 0.02)
                Capsule().fill(hair.opacity(0.9))
                    .frame(width: size * 0.1, height: size * 0.02)
            }
            .padding(.top, size * 0.08)

            // Глаза
            HStack(spacing: size * 0.15) {
                eye
                eye
            }

            // Рот
            SmileShape()
                .stroke(Color.black.opacity(0.7), lineWidth: size * 0.015)
                .frame(width: size * 0.1, height: size * 0.05)
                .padding(.top, size * 0.01)
        }
    }

    var eye: some View {
        ZStack {
            // Белок
            Ellipse()
                .fill(Color.white)
                .frame(width: size * 0.1, height: size * 0.12)
            // Зрачок
            Circle()
                .fill(eyes)
                .frame(width: size * 0.06, height: size * 0.06)
                .offset(y: size * 0.005)
            // Блик
            Circle()
                .fill(Color.white)
                .frame(width: size * 0.02, height: size * 0.02)
                .offset(x: -size * 0.015, y: -size * 0.015)
        }
    }

    // MARK: - Волосы
    @ViewBuilder
    var hairBack: some View {
        switch player.hairStyleIndex % 5 {
        case 0: // Короткая стрижка
            EmptyView()
        case 1: // Длинные
            RoundedRectangle(cornerRadius: size * 0.15)
                .fill(hair)
                .frame(width: size * 0.72, height: size * 0.5)
        case 2: // Пучок
            Circle()
                .fill(hair)
                .frame(width: size * 0.2, height: size * 0.2)
                .offset(y: -size * 0.28)
        case 3: // Хвост
            Capsule()
                .fill(hair)
                .frame(width: size * 0.12, height: size * 0.35)
                .offset(x: size * 0.3, y: size * 0.08)
        default: // Кудри
            Circle()
                .fill(hair)
                .frame(width: size * 0.85, height: size * 0.85)
        }
    }

    @ViewBuilder
    var hairFront: some View {
        switch player.hairStyleIndex % 5 {
        case 0: // Короткая стрижка — шапочка сверху
            Capsule()
                .fill(hair)
                .frame(width: size * 0.62, height: size * 0.22)
                .offset(y: -size * 0.2)
        case 1: // Длинные — чёлка
            Capsule()
                .fill(hair)
                .frame(width: size * 0.62, height: size * 0.28)
                .offset(y: -size * 0.17)
        case 2: // Пучок — чёлка + пучок
            ZStack {
                Capsule()
                    .fill(hair)
                    .frame(width: size * 0.62, height: size * 0.24)
                    .offset(y: -size * 0.18)
                Circle()
                    .fill(hair)
                    .frame(width: size * 0.22, height: size * 0.22)
                    .offset(y: -size * 0.36)
            }
        case 3: // Хвост — боковой пробор
            Capsule()
                .fill(hair)
                .frame(width: size * 0.62, height: size * 0.26)
                .offset(y: -size * 0.18)
        default: // Кудри — пышная шапка
            Ellipse()
                .fill(hair)
                .frame(width: size * 0.7, height: size * 0.4)
                .offset(y: -size * 0.22)
        }
    }
}

// Трапеция для платья
struct DressShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.width * 0.25, y: 0))
        p.addLine(to: CGPoint(x: rect.width * 0.75, y: 0))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: 0, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

// Улыбка
struct SmileShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY),
                       control: CGPoint(x: rect.midX, y: rect.maxY * 2))
        return p
    }
}
