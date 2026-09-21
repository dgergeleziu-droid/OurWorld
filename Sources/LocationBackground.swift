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

// MARK: - Фон локации (изометрия)

struct LocationBackground: View {

    let location: LocationID

    static let floorZone = FloorZone.standard

    private let backWallTop: CGFloat    = 0.06
    private let backWallBottom: CGFloat = 0.55
    private let backWallLeft: CGFloat   = 0.15
    private let backWallRight: CGFloat  = 0.85

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                ceilingShape(w: w, h: h)
                    .fill(ceilingColor)

                leftWallShape(w: w, h: h)
                    .fill(sideWallColor)
                rightWallShape(w: w, h: h)
                    .fill(sideWallColor)

                backWallShape(w: w, h: h)
                    .fill(backWallColor)

                floorShape(w: w, h: h)
                    .fill(
                        LinearGradient(
                            colors: [floorColor.opacity(0.85), floorColor],
                            startPoint: .top, endPoint: .bottom
                        )
                    )

                baseboardShape(w: w, h: h)
                    .fill(baseboardColor)

                windowView(w: w, h: h)

                locationDecor(w: w, h: h)
            }
        }
        .ignoresSafeArea()
    }

    // MARK: Формы

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
        let thickness: CGFloat = 0.012
        p.move(to: CGPoint(x: w * backWallLeft, y: h * backWallBottom))
        p.addLine(to: CGPoint(x: w * backWallRight, y: h * backWallBottom))
        p.addLine(to: CGPoint(x: w * backWallRight, y: h * (backWallBottom + thickness)))
        p.addLine(to: CGPoint(x: w * backWallLeft, y: h * (backWallBottom + thickness)))
        p.closeSubpath()
        return p
    }

    // MARK: Окно

    private func windowView(w: CGFloat, h: CGFloat) -> some View {
        let winW = w * 0.18
        let winH = h * 0.28
        let cx   = w * 0.5
        let cy   = h * (backWallTop + (backWallBottom - backWallTop) * 0.45)

        return ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#BFE6FF"))
                .frame(width: winW, height: winH)

            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 6)
                .frame(width: winW, height: winH)

            Rectangle()
                .fill(Color.white)
                .frame(width: 6, height: winH)

            Rectangle()
                .fill(Color.white)
                .frame(width: winW, height: 6)
        }
        .position(x: cx, y: cy)
    }

    // MARK: Декор по локации

    @ViewBuilder
    private func locationDecor(w: CGFloat, h: CGFloat) -> some View {
        switch location {
        case .home:
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: "#FFB6C1"))
                .frame(width: w * 0.09, height: h * 0.16)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(hex: "#8B5A2B"), lineWidth: 5)
                )
                .position(x: w * 0.28, y: h * 0.22)

        case .cafe:
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#6F4E37"))
                .frame(width: w * 0.12, height: h * 0.10)
                .overlay(
                    Image(systemName: "cup.and.saucer.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 22))
                )
                .position(x: w * 0.28, y: h * 0.22)

        case .shop:
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "#FF8A65"))
                .frame(width: w * 0.10, height: h * 0.12)
                .overlay(
                    Image(systemName: "tag.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                )
                .position(x: w * 0.28, y: h * 0.22)

        case .hospital:
            ZStack {
                Circle().fill(.white).frame(width: 60, height: 60)
                RoundedRectangle(cornerRadius: 4).fill(Color(hex: "#E85C5C"))
                    .frame(width: 40, height: 12)
                RoundedRectangle(cornerRadius: 4).fill(Color(hex: "#E85C5C"))
                    .frame(width: 12, height: 40)
            }
            .position(x: w * 0.28, y: h * 0.22)

        case .school:
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "#2E6B4F"))
                .frame(width: w * 0.22, height: h * 0.22)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "#8B5A2B"), lineWidth: 6)
                )
                .position(x: w * 0.32, y: h * 0.24)

        case .park, .beach:
            EmptyView()
        }
    }

    // MARK: Цвета

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
        backWallColor.opacity(0.88)
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
        backWallColor.opacity(0.6)
    }
}
