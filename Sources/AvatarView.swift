import SwiftUI

struct AvatarView: View {
    let player: Player
    var size: CGFloat = 200
    var isDragging: Bool = false

    private var skin: Color { Palette.skinTones[safe: player.skinTone] ?? Palette.skinTones[1] }
    private var hair: Color { Palette.hairColors[safe: player.hairColor] ?? Palette.hairColors[1] }
    private var eyeColor: Color { Palette.eyeColors[safe: player.eyeColor] ?? Palette.eyeColors[0] }
    private var outfit: Color { Palette.outfitColors[safe: player.outfitColor] ?? Palette.outfitColors[0] }

    var body: some View {
        if let imageName = player.imageName, let uiImage = UIImage(named: imageName) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .scaleEffect(isDragging ? 1.15 : 1.0)
                .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isDragging)
        } else {
            drawnAvatar
        }
    }

    // MARK: - Нарисованный персонаж
    @ViewBuilder
    var drawnAvatar: some View {
        ZStack {
            Ellipse()
                .fill(Color.black.opacity(0.10))
                .frame(width: size * 0.55, height: size * 0.06)
                .offset(y: size * 0.44)

            HStack(spacing: size * 0.05) {
                Capsule().fill(skin)
                    .frame(width: size * 0.10, height: size * 0.20)
                Capsule().fill(skin)
                    .frame(width: size * 0.10, height: size * 0.20)
            }
            .offset(y: size * 0.33)

            HStack(spacing: size * 0.05) {
                RoundedRectangle(cornerRadius: size * 0.02)
                    .fill(Color(hex: "#2C2C2C"))
                    .frame(width: size * 0.13, height: size * 0.055)
                RoundedRectangle(cornerRadius: size * 0.02)
                    .fill(Color(hex: "#2C2C2C"))
                    .frame(width: size * 0.13, height: size * 0.055)
            }
            .offset(y: size * 0.44)

            bodyView
            armView

            Circle()
                .fill(skin)
                .frame(width: size * 0.62, height: size * 0.62)
                .offset(y: -size * 0.14)

            Circle().fill(skin)
                .frame(width: size * 0.07, height: size * 0.07)
                .offset(x: -size * 0.31, y: -size * 0.14)
            Circle().fill(skin)
                .frame(width: size * 0.07, height: size * 0.07)
                .offset(x: size * 0.31, y: -size * 0.14)

            hairView
            faceView
            accessoryView
        }
        .frame(width: size, height: size)
        .scaleEffect(isDragging ? 1.15 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isDragging)
    }

    @ViewBuilder
    var bodyView: some View {
        switch player.outfitStyle {
        case 1, 6:
            Path { p in
                let w = size * 0.44
                let h = size * 0.22
                p.move(to: CGPoint(x: -w / 2, y: -h / 2))
                p.addLine(to: CGPoint(x: w / 2, y: -h / 2))
                p.addLine(to: CGPoint(x: w / 1.6, y: h / 2))
                p.addLine(to: CGPoint(x: -w / 1.6, y: h / 2))
                p.closeSubpath()
            }
            .fill(outfit)
            .frame(width: size * 0.5, height: size * 0.3)
            .offset(y: size * 0.18)
        default:
            RoundedRectangle(cornerRadius: size * 0.10)
                .fill(outfit)
                .frame(width: size * 0.42, height: size * 0.32)
                .offset(y: size * 0.16)
        }
    }

    var armView: some View {
        HStack(spacing: size * 0.30) {
            Capsule().fill(skin)
                .frame(width: size * 0.08, height: size * 0.24)
            Capsule().fill(skin)
                .frame(width: size * 0.08, height: size * 0.24)
        }
        .offset(y: size * 0.18)
    }

    @ViewBuilder
    var hairView: some View {
        let headR = size * 0.31
        switch player.hairStyle {
        case 0:
            Circle()
                .fill(hair)
                .frame(width: headR * 2.1, height: headR * 1.9)
                .offset(y: -size * 0.20)
                .mask(Rectangle().frame(height: size * 0.25).offset(y: -size * 0.22))
        case 1:
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.20)
                    .fill(hair)
                    .frame(width: headR * 2.2, height: headR * 2.6)
                    .offset(y: size * 0.02)
                Circle()
                    .fill(hair)
                    .frame(width: headR * 2.05, height: headR * 1.7)
                    .offset(y: -size * 0.20)
            }
            .mask(VStack(spacing: 0) { Rectangle().frame(height: size * 0.32); Spacer() })
        case 2:
            ZStack {
                Circle()
                    .fill(hair)
                    .frame(width: headR * 2.1, height: headR * 1.8)
                    .offset(y: -size * 0.20)
                    .mask(Rectangle().frame(height: size * 0.25).offset(y: -size * 0.22))
                Circle().fill(hair).frame(width: size * 0.22, height: size * 0.22).offset(x: -size * 0.36, y: -size * 0.02)
                Circle().fill(hair).frame(width: size * 0.22, height: size * 0.22).offset(x: size * 0.36, y: -size * 0.02)
            }
        case 3:
            ZStack {
                Circle()
                    .fill(hair)
                    .frame(width: headR * 2.1, height: headR * 1.8)
                    .offset(y: -size * 0.20)
                    .mask(Rectangle().frame(height: size * 0.25).offset(y: -size * 0.22))
                Circle().fill(hair).frame(width: size * 0.26, height: size * 0.26).offset(y: -size * 0.50)
            }
        case 4:
            ZStack {
                ForEach(0..<8) { i in
                    let angle = Double(i) / 7 * .pi - .pi / 2
                    Circle().fill(hair).frame(width: size * 0.20, height: size * 0.20)
                        .offset(x: CGFloat(cos(angle)) * size * 0.26,
                                y: -size * 0.24 + CGFloat(sin(angle)) * size * 0.18)
                }
            }
        case 5:
            ZStack {
                Circle()
                    .fill(hair)
                    .frame(width: headR * 2.1, height: headR * 1.8)
                    .offset(y: -size * 0.20)
                    .mask(Rectangle().frame(height: size * 0.25).offset(y: -size * 0.22))
                Capsule().fill(hair).frame(width: size * 0.11, height: size * 0.36).offset(x: -size * 0.33, y: size * 0.06)
                Capsule().fill(hair).frame(width: size * 0.11, height: size * 0.36).offset(x: size * 0.33, y: size * 0.06)
            }
        case 6:
            Capsule().fill(hair).frame(width: size * 0.16, height: size * 0.42).offset(y: -size * 0.40)
        case 7:
            RoundedRectangle(cornerRadius: size * 0.08)
                .fill(hair)
                .frame(width: headR * 2.2, height: headR * 2.8)
                .offset(y: size * 0.02)
                .mask(VStack(spacing: 0) { Rectangle().frame(height: size * 0.36); Spacer() })
        case 8:
            Circle()
                .fill(hair)
                .frame(width: headR * 2.3, height: headR * 2.1)
                .offset(y: -size * 0.16)
                .mask(Rectangle().frame(height: size * 0.30).offset(y: -size * 0.20))
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    var faceView: some View {
        ZStack {
            eyeView.offset(x: -size * 0.12, y: -size * 0.15)
            eyeView.offset(x: size * 0.12, y: -size * 0.15)
            Circle()
                .fill(skin.opacity(0.75))
                .frame(width: size * 0.03, height: size * 0.03)
                .offset(y: -size * 0.07)
            mouthView.offset(y: -size * 0.01)
        }
    }

    var eyeView: some View {
        let d: CGFloat = {
            switch player.eyeStyle {
            case 0: return size * 0.10
            case 1: return size * 0.13
            case 2: return size * 0.075
            case 3: return size * 0.115
            case 4: return size * 0.085
            default: return size * 0.105
            }
        }()
        return ZStack {
            Circle().fill(Color.white).frame(width: d, height: d)
            Circle().fill(eyeColor).frame(width: d * 0.68, height: d * 0.68)
            Circle().fill(Color.black).frame(width: d * 0.38, height: d * 0.38)
            Circle().fill(Color.white).frame(width: d * 0.16, height: d * 0.16)
                .offset(x: -d * 0.16, y: -d * 0.16)
        }
    }

    @ViewBuilder
    var mouthView: some View {
        let w = size * 0.14
        let h = size * 0.07
        switch player.mouthStyle {
        case 0:
            SmileShape().stroke(Color(hex: "#8B2C1A"),
                                style: StrokeStyle(lineWidth: size * 0.018, lineCap: .round))
                .frame(width: w, height: h)
        case 1:
            ZStack {
                FilledSmileShape().fill(Color(hex: "#C0392B")).frame(width: w, height: h * 1.3)
                FilledSmileShape().fill(Color.white).frame(width: w * 0.85, height: h * 0.5).offset(y: -h * 0.3)
            }
        case 2:
            ZStack {
                Capsule().fill(Color(hex: "#C0392B")).frame(width: w, height: size * 0.025)
                Circle().fill(Color(hex: "#C0392B")).frame(width: size * 0.02, height: size * 0.02).offset(y: size * 0.018)
            }
        case 3:
            Capsule().fill(Color(hex: "#8B2C1A")).frame(width: w * 0.8, height: size * 0.02)
        case 4:
            Circle().fill(Color(hex: "#8B2C1A")).frame(width: size * 0.06, height: size * 0.06)
        default:
            HStack(spacing: w * 0.4) {
                SmileShape().stroke(Color(hex: "#8B2C1A"), lineWidth: size * 0.014)
                    .frame(width: w * 0.3, height: h * 0.5)
                SmileShape().stroke(Color(hex: "#8B2C1A"), lineWidth: size * 0.014)
                    .frame(width: w * 0.3, height: h * 0.5)
            }
        }
    }

    @ViewBuilder
    var accessoryView: some View {
        switch player.accessory {
        case 1:
            HStack(spacing: size * 0.04) {
                Circle().stroke(Color.black, lineWidth: size * 0.012).frame(width: size * 0.15, height: size * 0.15)
                Circle().stroke(Color.black, lineWidth: size * 0.012).frame(width: size * 0.15, height: size * 0.15)
            }
            .offset(y: -size * 0.15)
        case 2:
            ZStack {
                Circle().fill(Color(hex: "#3B82F6"))
                    .frame(width: size * 0.42, height: size * 0.30)
                    .offset(y: -size * 0.37)
                    .mask(Rectangle().frame(height: size * 0.14).offset(y: -size * 0.42))
                Capsule().fill(Color(hex: "#1E40AF"))
                    .frame(width: size * 0.32, height: size * 0.05)
                    .offset(x: size * 0.10, y: -size * 0.30)
            }
        case 3:
            ZStack {
                Circle().fill(Color(hex: "#E0447A")).frame(width: size * 0.08, height: size * 0.08).offset(x: -size * 0.07, y: -size * 0.36)
                Circle().fill(Color(hex: "#E0447A")).frame(width: size * 0.08, height: size * 0.08).offset(x: size * 0.07, y: -size * 0.36)
                Circle().fill(Color(hex: "#C0392B")).frame(width: size * 0.05, height: size * 0.05).offset(y: -size * 0.36)
            }
        case 4:
            ZStack {
                Ellipse().fill(Color(hex: "#2C2C2C")).frame(width: size * 0.55, height: size * 0.09).offset(y: -size * 0.34)
                RoundedRectangle(cornerRadius: size * 0.05).fill(Color(hex: "#2C2C2C")).frame(width: size * 0.28, height: size * 0.20).offset(y: -size * 0.42)
            }
        case 5:
            Circle().stroke(Color(hex: "#FFD93D"), lineWidth: size * 0.02)
                .frame(width: size * 0.56, height: size * 0.56)
                .offset(y: -size * 0.14)
                .mask(Rectangle().frame(height: size * 0.12).offset(y: -size * 0.34))
        case 6:
            HStack(spacing: size * 0.56) {
                Circle().fill(Color(hex: "#F1D77E")).frame(width: size * 0.05, height: size * 0.05)
                Circle().fill(Color(hex: "#F1D77E")).frame(width: size * 0.05, height: size * 0.05)
            }
            .offset(y: -size * 0.08)
        default:
            EmptyView()
        }
    }
}

// MARK: - Фигуры
struct SmileShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY),
                       control: CGPoint(x: rect.midX, y: rect.maxY * 2.4))
        return p
    }
}

struct FilledSmileShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY),
                       control: CGPoint(x: rect.midX, y: rect.maxY * 2.0))
        p.closeSubpath()
        return p
    }
}
