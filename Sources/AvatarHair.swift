import SwiftUI

struct AvatarHair: View {

    let player: Player
    let headSize: CGFloat
    let headCY: CGFloat
    let canvasW: CGFloat

    private var hair: Color {
        Palette.hairColors[safe: player.hairColor] ?? Palette.hairColors[0]
    }

    private var top: CGFloat { headCY - headSize * 0.5 }

    var body: some View {
        Group {
            switch player.hairStyle {
            case 0: shortHair
            case 1: longHair
            case 2: ponytailHair
            case 3: twinTailsHair
            case 4: bunHair
            case 5: curlyHair
            case 6: braidsHair
            case 7: mohawkHair
            case 8: straightHair
            case 9: wavyHair
            case 10: bobHair
            default: EmptyView()
            }
        }
    }

    // MARK: - Базовая шапка волос

    private func cap(scaleW: CGFloat = 1.06,
                     scaleH: CGFloat = 0.55,
                     yOffset: CGFloat = 0.28) -> some View {
        RoundedRectangle(cornerRadius: headSize * 0.5)
            .fill(hair)
            .overlay(
                RoundedRectangle(cornerRadius: headSize * 0.5)
                    .stroke(Color.black.opacity(0.55), lineWidth: 1.6)
            )
            .frame(width: headSize * scaleW, height: headSize * scaleH)
            .position(x: canvasW / 2, y: top + headSize * yOffset)
    }

    // MARK: - 0. Короткие

    private var shortHair: some View {
        cap(scaleW: 1.06, scaleH: 0.55, yOffset: 0.28)
    }

    // MARK: - 1. Длинные

    private var longHair: some View {
        ZStack {
            // Заднее полотно
            RoundedRectangle(cornerRadius: headSize * 0.45)
                .fill(hair)
                .overlay(
                    RoundedRectangle(cornerRadius: headSize * 0.45)
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.6)
                )
                .frame(width: headSize * 1.08, height: headSize * 1.5)
                .position(
                    x: canvasW / 2,
                    y: headCY + headSize * 0.35
                )
            cap(scaleW: 1.06, scaleH: 0.52, yOffset: 0.26)
        }
    }

    // MARK: - 2. Хвостик

    private var ponytailHair: some View {
        ZStack {
            // Хвост справа
            Circle()
                .fill(hair)
                .overlay(
                    Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.6)
                )
                .frame(width: headSize * 0.42, height: headSize * 0.42)
                .position(
                    x: canvasW / 2 + headSize * 0.55,
                    y: top + headSize * 0.05
                )
            // Спускающаяся часть хвоста
            RoundedRectangle(cornerRadius: headSize * 0.15)
                .fill(hair)
                .overlay(
                    RoundedRectangle(cornerRadius: headSize * 0.15)
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.6)
                )
                .frame(width: headSize * 0.22, height: headSize * 0.5)
                .position(
                    x: canvasW / 2 + headSize * 0.62,
                    y: top + headSize * 0.4
                )
            cap()
        }
    }

    // MARK: - 3. Два хвоста

    private var twinTailsHair: some View {
        ZStack {
            Circle()
                .fill(hair)
                .overlay(
                    Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.6)
                )
                .frame(width: headSize * 0.36, height: headSize * 0.36)
                .position(
                    x: canvasW / 2 - headSize * 0.58,
                    y: top + headSize * 0.15
                )
            Circle()
                .fill(hair)
                .overlay(
                    Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.6)
                )
                .frame(width: headSize * 0.36, height: headSize * 0.36)
                .position(
                    x: canvasW / 2 + headSize * 0.58,
                    y: top + headSize * 0.15
                )
            cap()
        }
    }

    // MARK: - 4. Пучок

    private var bunHair: some View {
        ZStack {
            Circle()
                .fill(hair)
                .overlay(
                    Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.6)
                )
                .frame(width: headSize * 0.34, height: headSize * 0.34)
                .position(
                    x: canvasW / 2,
                    y: top - headSize * 0.08
                )
            cap(scaleW: 1.06, scaleH: 0.5, yOffset: 0.26)
        }
    }

    // MARK: - 5. Кудри

    private var curlyHair: some View {
        ZStack {
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(hair)
                    .overlay(
                        Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                    )
                    .frame(width: headSize * 0.28, height: headSize * 0.28)
                    .position(
                        x: canvasW / 2 + CGFloat(i - 2) * headSize * 0.20,
                        y: top + headSize * 0.15
                    )
            }
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(hair)
                    .overlay(
                        Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                    )
                    .frame(width: headSize * 0.30, height: headSize * 0.30)
                    .position(
                        x: canvasW / 2 - headSize * 0.48,
                        y: top + headSize * 0.55 + CGFloat(i) * headSize * 0.18
                    )
                Circle()
                    .fill(hair)
                    .overlay(
                        Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                    )
                    .frame(width: headSize * 0.30, height: headSize * 0.30)
                    .position(
                        x: canvasW / 2 + headSize * 0.48,
                        y: top + headSize * 0.55 + CGFloat(i) * headSize * 0.18
                    )
            }
        }
    }

    // MARK: - 6. Косички

    private var braidsHair: some View {
        ZStack {
            cap(scaleW: 1.06, scaleH: 0.52, yOffset: 0.26)
            ForEach(0..<4, id: \.self) { i in
                Circle()
                    .fill(hair)
                    .overlay(
                        Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.2)
                    )
                    .frame(width: headSize * 0.13, height: headSize * 0.13)
                    .position(
                        x: canvasW / 2 - headSize * 0.48,
                        y: top + headSize * 0.55 + CGFloat(i) * headSize * 0.14
                    )
                Circle()
                    .fill(hair)
                    .overlay(
                        Circle().stroke(Color.black.opacity(0.55), lineWidth: 1.2)
                    )
                    .frame(width: headSize * 0.13, height: headSize * 0.13)
                    .position(
                        x: canvasW / 2 + headSize * 0.48,
                        y: top + headSize * 0.55 + CGFloat(i) * headSize * 0.14
                    )
            }
        }
    }

    // MARK: - 7. Ирокез

    private var mohawkHair: some View {
        ZStack {
            cap(scaleW: 1.02, scaleH: 0.35, yOffset: 0.24)
            ForEach(0..<5, id: \.self) { i in
                Triangle()
                    .fill(hair)
                    .overlay(
                        Triangle().stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                    )
                    .frame(width: headSize * 0.13, height: headSize * 0.28)
                    .position(
                        x: canvasW / 2 + CGFloat(i - 2) * headSize * 0.14,
                        y: top + headSize * 0.10
                    )
            }
        }
    }

    // MARK: - 8. Прямые

    private var straightHair: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(hair)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                )
                .frame(width: headSize * 0.16, height: headSize * 0.75)
                .position(
                    x: canvasW / 2 - headSize * 0.48,
                    y: top + headSize * 0.6
                )
            RoundedRectangle(cornerRadius: 6)
                .fill(hair)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                )
                .frame(width: headSize * 0.16, height: headSize * 0.75)
                .position(
                    x: canvasW / 2 + headSize * 0.48,
                    y: top + headSize * 0.6
                )
            cap(scaleW: 1.06, scaleH: 0.55, yOffset: 0.28)
        }
    }

    // MARK: - 9. Волны

    private var wavyHair: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { i in
                Ellipse()
                    .fill(hair)
                    .overlay(
                        Ellipse().stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                    )
                    .frame(width: headSize * 0.24, height: headSize * 0.20)
                    .position(
                        x: canvasW / 2 - headSize * 0.46,
                        y: top + headSize * 0.5 + CGFloat(i) * headSize * 0.16
                    )
                Ellipse()
                    .fill(hair)
                    .overlay(
                        Ellipse().stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                    )
                    .frame(width: headSize * 0.24, height: headSize * 0.20)
                    .position(
                        x: canvasW / 2 + headSize * 0.46,
                        y: top + headSize * 0.5 + CGFloat(i) * headSize * 0.16
                    )
            }
            cap(scaleW: 1.06, scaleH: 0.5, yOffset: 0.26)
        }
    }

    // MARK: - 10. Каре

    private var bobHair: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(hair)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                )
                .frame(width: headSize * 0.22, height: headSize * 0.45)
                .position(
                    x: canvasW / 2 - headSize * 0.48,
                    y: top + headSize * 0.78
                )
            RoundedRectangle(cornerRadius: 8)
                .fill(hair)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black.opacity(0.55), lineWidth: 1.4)
                )
                .frame(width: headSize * 0.22, height: headSize * 0.45)
                .position(
                    x: canvasW / 2 + headSize * 0.48,
                    y: top + headSize * 0.78
                )
            cap(scaleW: 1.08, scaleH: 0.6, yOffset: 0.30)
        }
    }
}
