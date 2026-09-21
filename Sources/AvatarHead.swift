import SwiftUI

struct AvatarHead: View {

    let player: Player
    let headSize: CGFloat
    let headCY: CGFloat
    let canvasW: CGFloat

    private var skin: Color {
        Palette.skinTones[safe: player.skinTone] ?? Palette.skinTones[1]
    }
    private var eye: Color {
        Palette.eyeColors[safe: player.eyeColor] ?? Palette.eyeColors[0]
    }

    var body: some View {
        ZStack {
            earsLayer
            headShape
            eyebrowsLayer
            eyesLayer
            noseLayer
            mouthLayer
            blushLayer
        }
    }

    // MARK: - Уши

    private var earsLayer: some View {
        ZStack {
            ear(side: -1)
            ear(side: 1)
        }
    }

    private func ear(side: CGFloat) -> some View {
        let sz = headSize * 0.16
        return Circle()
            .fill(skin)
            .overlay(
                Circle().stroke(Color.black.opacity(0.5), lineWidth: 1.4)
            )
            .frame(width: sz, height: sz)
            .position(
                x: canvasW / 2 + side * headSize * 0.48,
                y: headCY + headSize * 0.05
            )
    }

    // MARK: - Голова

    private var headShape: some View {
        RoundedRectangle(cornerRadius: headSize * 0.5)
            .fill(skin)
            .overlay(
                RoundedRectangle(cornerRadius: headSize * 0.5)
                    .stroke(Color.black.opacity(0.55), lineWidth: 1.8)
            )
            .frame(width: headSize, height: headSize * 1.02)
            .position(x: canvasW / 2, y: headCY)
    }

    // MARK: - Брови

    private var eyebrowsLayer: some View {
        ZStack {
            eyebrow(side: -1)
            eyebrow(side: 1)
        }
    }

    private func eyebrow(side: CGFloat) -> some View {
        let width: CGFloat
        let height: CGFloat
        let offsetY: CGFloat
        let rotation: Double

        switch player.eyebrowStyle {
        case 0: // обычные
            width = headSize * 0.14
            height = headSize * 0.026
            offsetY = -headSize * 0.24
            rotation = side < 0 ? 5 : -5
        case 1: // тонкие
            width = headSize * 0.13
            height = headSize * 0.016
            offsetY = -headSize * 0.24
            rotation = side < 0 ? 5 : -5
        case 2: // толстые
            width = headSize * 0.16
            height = headSize * 0.038
            offsetY = -headSize * 0.24
            rotation = side < 0 ? 3 : -3
        case 3: // приподнятые
            width = headSize * 0.13
            height = headSize * 0.024
            offsetY = -headSize * 0.28
            rotation = side < 0 ? 15 : -15
        case 4: // сердитые
            width = headSize * 0.14
            height = headSize * 0.026
            offsetY = -headSize * 0.22
            rotation = side < 0 ? -15 : 15
        default: // грустные
            width = headSize * 0.14
            height = headSize * 0.026
            offsetY = -headSize * 0.26
            rotation = side < 0 ? 15 : -15
        }

        return Capsule()
            .fill(Color.black.opacity(0.85))
            .frame(width: width, height: height)
            .rotationEffect(.degrees(rotation))
            .position(
                x: canvasW / 2 + side * headSize * 0.19,
                y: headCY + offsetY
            )
    }

    // MARK: - Глаза

    private var eyesLayer: some View {
        ZStack {
            eyeView(side: -1)
            eyeView(side: 1)
        }
    }

    private func eyeView(side: CGFloat) -> some View {
        let size = eyeSize
        let spacing = headSize * 0.20
        let cy = headCY - headSize * 0.06

        return ZStack {
            eyeWhite(size: size)
                .position(x: canvasW / 2 + side * spacing, y: cy)
            eyePupil(size: size)
                .position(x: canvasW / 2 + side * spacing, y: cy)
            eyeHighlights(size: size)
                .position(x: canvasW / 2 + side * spacing, y: cy)
            eyeExtra(size: size)
                .position(x: canvasW / 2 + side * spacing, y: cy)
        }
    }

    private var eyeSize: CGSize {
        switch player.eyeStyle {
        case 0: return CGSize(width: headSize * 0.20, height: headSize * 0.22)
        case 1: return CGSize(width: headSize * 0.22, height: headSize * 0.24)
        case 2: return CGSize(width: headSize * 0.20, height: headSize * 0.12)
        case 3: return CGSize(width: headSize * 0.22, height: headSize * 0.22)
        case 4: return CGSize(width: headSize * 0.20, height: headSize * 0.10)
        case 5: return CGSize(width: headSize * 0.20, height: headSize * 0.22)
        case 6: return CGSize(width: headSize * 0.22, height: headSize * 0.25)
        default: return CGSize(width: headSize * 0.21, height: headSize * 0.22)
        }
    }

    private func eyeWhite(size: CGSize) -> some View {
        Ellipse()
            .fill(Color.white)
            .overlay(
                Ellipse().stroke(Color.black.opacity(0.55), lineWidth: 1.4)
            )
            .frame(width: size.width, height: size.height)
    }

    private func eyePupil(size: CGSize) -> some View {
        let pupilW: CGFloat = (player.eyeStyle == 2 || player.eyeStyle == 4)
            ? size.width * 0.5 : size.width * 0.68
        let pupilH = (player.eyeStyle == 2 || player.eyeStyle == 4)
            ? size.height * 0.55 : size.height * 0.68

        return Ellipse()
            .fill(eye)
            .frame(width: pupilW, height: pupilH)
    }

    private func eyeHighlights(size: CGSize) -> some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: size.width * 0.26, height: size.width * 0.26)
                .offset(x: -size.width * 0.14, y: -size.height * 0.16)

            Circle()
                .fill(Color.white.opacity(0.85))
                .frame(width: size.width * 0.13, height: size.width * 0.13)
                .offset(x: size.width * 0.12, y: size.height * 0.15)
        }
    }

    @ViewBuilder
    private func eyeExtra(size: CGSize) -> some View {
        if player.eyeStyle == 5 {
            // Ресницы
            ZStack {
                Capsule()
                    .fill(Color.black)
                    .frame(width: size.width * 1.2, height: 1.8)
                    .offset(y: -size.height * 0.45)
                Capsule()
                    .fill(Color.black)
                    .frame(width: 1.8, height: size.height * 0.2)
                    .offset(x: size.width * 0.55, y: -size.height * 0.35)
            }
        } else if player.eyeStyle == 7 {
            // Довольные — глаз как дуга
            TocaSmile()
                .stroke(Color.black, lineWidth: 2.2)
                .frame(width: size.width * 0.9, height: size.height * 0.5)
        }
    }

    // MARK: - Нос

    private var noseLayer: some View {
        let w = headSize * 0.05
        let h = headSize * 0.035

        return Ellipse()
            .fill(skin.opacity(0.9))
            .overlay(
                Ellipse().stroke(Color.black.opacity(0.4), lineWidth: 1.2)
            )
            .frame(width: w, height: h)
            .position(
                x: canvasW / 2,
                y: headCY + headSize * 0.09
            )
    }

    // MARK: - Рот

    private var mouthLayer: some View {
        Group {
            switch player.mouthStyle {
            case 0: smileMouth
            case 1: flatMouth
            case 2: sadMouth
            case 3: openMouth
            case 4: laughMouth
            default: surprisedMouth
            }
        }
    }

    private var smileMouth: some View {
        TocaSmile()
            .stroke(
                Color.black.opacity(0.85),
                style: StrokeStyle(lineWidth: 2.2, lineCap: .round)
            )
            .frame(width: headSize * 0.16, height: headSize * 0.08)
            .position(
                x: canvasW / 2,
                y: headCY + headSize * 0.24
            )
    }

    private var flatMouth: some View {
        Capsule()
            .fill(Color.black.opacity(0.85))
            .frame(width: headSize * 0.10, height: 2.2)
            .position(
                x: canvasW / 2,
                y: headCY + headSize * 0.25
            )
    }

    private var sadMouth: some View {
        TocaSmile()
            .stroke(
                Color.black.opacity(0.85),
                style: StrokeStyle(lineWidth: 2.2, lineCap: .round)
            )
            .frame(width: headSize * 0.16, height: headSize * 0.08)
            .rotationEffect(.degrees(180))
            .position(
                x: canvasW / 2,
                y: headCY + headSize * 0.28
            )
    }

    private var openMouth: some View {
        Ellipse()
            .fill(Color(hex: "#4A2C2A"))
            .overlay(
                Ellipse().stroke(Color.black.opacity(0.7), lineWidth: 1.4)
            )
            .frame(width: headSize * 0.10, height: headSize * 0.13)
            .position(
                x: canvasW / 2,
                y: headCY + headSize * 0.26
            )
    }

    private var laughMouth: some View {
        Ellipse()
            .fill(Color(hex: "#4A2C2A"))
            .overlay(
                Ellipse().stroke(Color.black.opacity(0.7), lineWidth: 1.4)
            )
            .overlay(
                Ellipse()
                    .fill(Color(hex: "#E85C5C"))
                    .frame(width: headSize * 0.06, height: headSize * 0.04)
                    .offset(y: headSize * 0.03)
            )
            .frame(width: headSize * 0.16, height: headSize * 0.16)
            .position(
                x: canvasW / 2,
                y: headCY + headSize * 0.26
            )
    }

    private var surprisedMouth: some View {
        Circle()
            .fill(Color(hex: "#4A2C2A"))
            .overlay(
                Circle().stroke(Color.black.opacity(0.7), lineWidth: 1.4)
            )
            .frame(width: headSize * 0.08, height: headSize * 0.08)
            .position(
                x: canvasW / 2,
                y: headCY + headSize * 0.26
            )
    }

    // MARK: - Румянец

    private var blushLayer: some View {
        ZStack {
            blush(side: -1)
            blush(side: 1)
        }
    }

    private func blush(side: CGFloat) -> some View {
        Ellipse()
            .fill(Color(hex: "#F4A0A0").opacity(0.45))
            .frame(width: headSize * 0.14, height: headSize * 0.08)
            .position(
                x: canvasW / 2 + side * headSize * 0.32,
                y: headCY + headSize * 0.15
            )
    }
}
