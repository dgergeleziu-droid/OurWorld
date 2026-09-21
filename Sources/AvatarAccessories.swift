import SwiftUI

struct AvatarAccessories: View {

    let player: Player
    let headSize: CGFloat
    let headCY: CGFloat
    let canvasW: CGFloat

    private var top: CGFloat { headCY - headSize * 0.5 }

    var body: some View {
        Group {
            switch player.accessory {
            case 1: glassesView
            case 2: capView
            case 3: bowView
            case 4: hatView
            case 5: headbandView
            case 6: earringsView
            case 7: maskView
            default: EmptyView()
            }
        }
    }

    private var glassesView: some View {
        let eyeY = headCY - headSize * 0.06
        let r = headSize * 0.13
        let spacing = headSize * 0.20

        return ZStack {
            Circle()
                .stroke(Color.black.opacity(0.85), lineWidth: 2.2)
                .frame(width: r * 1.7, height: r * 1.7)
                .position(x: canvasW / 2 - spacing, y: eyeY)
            Circle()
                .stroke(Color.black.opacity(0.85), lineWidth: 2.2)
                .frame(width: r * 1.7, height: r * 1.7)
                .position(x: canvasW / 2 + spacing, y: eyeY)
            Rectangle()
                .fill(Color.black.opacity(0.85))
                .frame(width: spacing * 0.6, height: 1.8)
                .position(x: canvasW / 2, y: eyeY)
        }
    }

    private var capView: some View {
        ZStack {
            Ellipse()
                .fill(Color(hex: "#1F2937"))
                .overlay(
                    Ellipse().stroke(Color.black.opacity(0.7), lineWidth: 1.5)
                )
                .frame(width: headSize * 1.05, height: headSize * 0.5)
                .position(x: canvasW / 2, y: top + headSize * 0.28)

            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "#0F172A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black.opacity(0.7), lineWidth: 1.4)
                )
                .frame(width: headSize * 0.5, height: headSize * 0.12)
                .position(
                    x: canvasW / 2 + headSize * 0.30,
                    y: top + headSize * 0.42
                )
        }
    }

    private var bowView: some View {
        ZStack {
            Triangle()
                .fill(Color(hex: "#EC4899"))
                .overlay(Triangle().stroke(Color.black.opacity(0.6), lineWidth: 1.4))
                .frame(width: headSize * 0.22, height: headSize * 0.18)
                .rotationEffect(.degrees(90))
                .position(
                    x: canvasW / 2 - headSize * 0.14,
                    y: top + headSize * 0.35
                )
            Triangle()
                .fill(Color(hex: "#EC4899"))
                .overlay(Triangle().stroke(Color.black.opacity(0.6), lineWidth: 1.4))
                .frame(width: headSize * 0.22, height: headSize * 0.18)
                .rotationEffect(.degrees(-90))
                .position(
                    x: canvasW / 2 + headSize * 0.14,
                    y: top + headSize * 0.35
                )
            Circle()
                .fill(Color(hex: "#BE185D"))
                .overlay(Circle().stroke(Color.black.opacity(0.6), lineWidth: 1.2))
                .frame(width: headSize * 0.09, height: headSize * 0.09)
                .position(x: canvasW / 2, y: top + headSize * 0.35)
        }
    }

    private var hatView: some View {
        ZStack {
            Ellipse()
                .fill(Color(hex: "#8B5A2B"))
                .overlay(Ellipse().stroke(Color.black.opacity(0.6), lineWidth: 1.5))
                .frame(width: headSize * 1.5, height: headSize * 0.18)
                .position(x: canvasW / 2, y: top + headSize * 0.42)
            RoundedRectangle(cornerRadius: headSize * 0.2)
                .fill(Color(hex: "#A0704A"))
                .overlay(
                    RoundedRectangle(cornerRadius: headSize * 0.2)
                        .stroke(Color.black.opacity(0.6), lineWidth: 1.5)
                )
                .frame(width: headSize * 0.7, height: headSize * 0.45)
                .position(x: canvasW / 2, y: top + headSize * 0.22)
            Rectangle()
                .fill(Color(hex: "#1F2937"))
                .frame(width: headSize * 0.7, height: headSize * 0.06)
                .position(x: canvasW / 2, y: top + headSize * 0.35)
        }
    }

    private var headbandView: some View {
        Capsule()
            .fill(Color(hex: "#8B5CF6"))
            .overlay(
                Capsule().stroke(Color.black.opacity(0.6), lineWidth: 1.4)
            )
            .frame(width: headSize * 1.05, height: headSize * 0.08)
            .position(x: canvasW / 2, y: top + headSize * 0.35)
    }

    private var earringsView: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "#FBBF24"))
                .overlay(Circle().stroke(Color.black.opacity(0.5), lineWidth: 1))
                .frame(width: headSize * 0.09, height: headSize * 0.09)
                .position(
                    x: canvasW / 2 - headSize * 0.55,
                    y: headCY + headSize * 0.15
                )
            Circle()
                .fill(Color(hex: "#FBBF24"))
                .overlay(Circle().stroke(Color.black.opacity(0.5), lineWidth: 1))
                .frame(width: headSize * 0.09, height: headSize * 0.09)
                .position(
                    x: canvasW / 2 + headSize * 0.55,
                    y: headCY + headSize * 0.15
                )
        }
    }

    private var maskView: some View {
        let eyeY = headCY - headSize * 0.06

        return ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "#1F2937"))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1.4)
                )
                .frame(width: headSize * 0.75, height: headSize * 0.24)
                .position(x: canvasW / 2, y: eyeY)

            Ellipse()
                .fill(Color.white)
                .frame(width: headSize * 0.15, height: headSize * 0.08)
                .position(x: canvasW / 2 - headSize * 0.19, y: eyeY)
            Ellipse()
                .fill(Color.white)
                .frame(width: headSize * 0.15, height: headSize * 0.08)
                .position(x: canvasW / 2 + headSize * 0.19, y: eyeY)
        }
    }
}
