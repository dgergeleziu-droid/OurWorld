import SwiftUI

// MARK: - Форма улыбки

struct TocaSmile: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY + rect.height * 0.25))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.25),
            control: CGPoint(x: rect.midX, y: rect.maxY * 1.9)
        )
        return p
    }
}

// MARK: - Треугольник (для ирокеза и банта)

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

// MARK: - Кривой рот «спокойный»

struct TocaFlatMouth: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return p
    }
}

// MARK: - Кривой рот «удивление» (О)

struct TocaOvalMouth: Shape {
    func path(in rect: CGRect) -> Path {
        Path(ellipseIn: rect)
    }
}

// MARK: - Безопасный доступ к массиву

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Утилита: контур

struct OutlineModifier: ViewModifier {
    var width: CGFloat = 1.6
    var color: Color = Color.black.opacity(0.6)

    func body(content: Content) -> some View {
        content.overlay(
            content
                .mask(content)
        )
    }
}
