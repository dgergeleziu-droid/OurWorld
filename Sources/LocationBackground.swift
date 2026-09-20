import SwiftUI

struct LocationBackground: View {
    let location: LocationID

    var body: some View {
        GeometryReader { geo in
            switch location {
            case .home: HomeScene(size: geo.size)
            case .cafe: CafeScene(size: geo.size)
            case .park: ParkScene(size: geo.size)
            case .beach: BeachScene(size: geo.size)
            case .space: SpaceScene(size: geo.size)
            }
        }
        .ignoresSafeArea()
    }
}

struct HomeScene: View {
    let size: CGSize

    var body: some View {
        ZStack {
            // Стены
            Color(hex: "#FFF4D6")

            // Пол
            Rectangle()
                .fill(Color(hex: "#E8B77A"))
                .frame(height: size.height * 0.35)
                .position(x: size.width / 2, y: size.height * 0.83)

            // Плинтус
            Rectangle()
                .fill(Color(hex: "#B8854A"))
                .frame(height: 6)
                .position(x: size.width / 2, y: size.height * 0.655)

            // Окно
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#8ED4F0"))
                .frame(width: 140, height: 110)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "#B8854A"), lineWidth: 8)
                )
                .overlay(
                    VStack(spacing: 0) {
                        Spacer()
                        Rectangle().fill(Color(hex: "#B8854A")).frame(height: 5)
                        Spacer()
                    }
                )
                .position(x: size.width * 0.5, y: size.height * 0.28)

            // Облака в окне
            Circle().fill(.white).frame(width: 25, height: 15)
                .position(x: size.width * 0.45, y: size.height * 0.24)
            Circle().fill(.white).frame(width: 18, height: 12)
                .position(x: size.width * 0.55, y: size.height * 0.26)

            // Кровать
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "#B8854A"))
                    .frame(width: 150, height: 60)
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(hex: "#EF4444"))
                    .frame(width: 148, height: 32)
                    .offset(y: -10)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(hex: "#FDE68A"))
                    .frame(width: 34, height: 24)
                    .offset(x: -50, y: -22)
            }
            .position(x: size.width * 0.22, y: size.height * 0.72)

            // Стол
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(hex: "#8B5A2B"))
                    .frame(width: 110, height: 12)
                    .offset(y: -20)
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(hex: "#8B5A2B"))
                    .frame(width: 8, height: 30)
                    .offset(x: -45, y: 5)
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(hex: "#8B5A2B"))
                    .frame(width: 8, height: 30)
                    .offset(x: 45, y: 5)
            }
            .position(x: size.width * 0.75, y: size.height * 0.72)
        }
    }
}

struct CafeScene: View {
    let size: CGSize

    var body: some View {
        ZStack {
            Color(hex: "#F5E6D3")

            // Пол в полоску
            VStack(spacing: 0) {
                Spacer()
                HStack(spacing: 0) {
                    ForEach(0..<8, id: \.self) { i in
                        Rectangle()
                            .fill(i % 2 == 0 ? Color(hex: "#B8854A") : Color(hex: "#8B5A2B"))
                    }
                }
                .frame(height: size.height * 0.35)
            }

            // Окно кафе
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(hex: "#A7D8F0"))
                .frame(width: 180, height: 90)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: "#5A3A1E"), lineWidth: 8)
                )
                .position(x: size.width * 0.5, y: size.height * 0.22)

            // Стойка
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "#8B5A2B"))
                .frame(width: size.width * 0.9, height: 20)
                .position(x: size.width * 0.5, y: size.height * 0.55)

            // Столики
            ForEach(0..<2, id: \.self) { i in
                Circle()
                    .fill(Color(hex: "#FEF3C7"))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Circle().stroke(Color(hex: "#8B5A2B"), lineWidth: 5)
                    )
                    .position(x: size.width * (0.25 + 0.5 * CGFloat(i)), y: size.height * 0.78)
            }
        }
    }
}

struct ParkScene: View {
    let size: CGSize

    var body: some View {
        ZStack {
            // Небо
            LinearGradient(
                colors: [Color(hex: "#A7D8F0"), Color(hex: "#DCF0FB")],
                startPoint: .top, endPoint: .bottom
            )

            // Солнце
            Circle()
                .fill(Color(hex: "#FCD34D"))
                .frame(width: 70, height: 70)
                .position(x: size.width * 0.85, y: size.height * 0.14)

            // Облака
            Cloud().position(x: size.width * 0.2, y: size.height * 0.12)
            Cloud().scaleEffect(0.7).position(x: size.width * 0.65, y: size.height * 0.18)

            // Трава
            Rectangle()
                .fill(Color(hex: "#7BC96F"))
                .frame(height: size.height * 0.35)
                .position(x: size.width / 2, y: size.height * 0.83)

            // Деревья
            Tree().position(x: size.width * 0.15, y: size.height * 0.68)
            Tree().scaleEffect(0.9).position(x: size.width * 0.85, y: size.height * 0.68)

            // Лавочка
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(hex: "#8B5A2B"))
                .frame(width: 100, height: 12)
                .position(x: size.width * 0.5, y: size.height * 0.78)
        }
    }
}

struct BeachScene: View {
    let size: CGSize

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#FCD34D"), Color(hex: "#FDE68A")],
                startPoint: .top, endPoint: .bottom
            )

            // Море
            Rectangle()
                .fill(Color(hex: "#38BDF8"))
                .frame(height: size.height * 0.4)
                .position(x: size.width / 2, y: size.height * 0.55)

            // Волны
            ForEach(0..<3, id: \.self) { i in
                Capsule()
                    .fill(.white.opacity(0.7))
                    .frame(width: 60, height: 6)
                    .position(x: size.width * (0.2 + 0.3 * CGFloat(i)),
                              y: size.height * (0.58 + 0.02 * CGFloat(i)))
            }

            // Песок
            Rectangle()
                .fill(Color(hex: "#FDE68A"))
                .frame(height: size.height * 0.25)
                .position(x: size.width / 2, y: size.height * 0.88)

            // Зонт
            Umbrella().position(x: size.width * 0.2, y: size.height * 0.68)

            // Мяч
            Circle().fill(Color(hex: "#EF4444"))
                .frame(width: 30, height: 30)
                .position(x: size.width * 0.7, y: size.height * 0.85)
        }
    }
}

struct SpaceScene: View {
    let size: CGSize

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#0F172A"), Color(hex: "#312E81")],
                startPoint: .top, endPoint: .bottom
            )

            // Звёзды
            ForEach(0..<40, id: \.self) { i in
                Circle()
                    .fill(.white)
                    .frame(width: CGFloat.random(in: 1...3),
                           height: CGFloat.random(in: 1...3))
                    .position(
                        x: CGFloat.random(in: 0...size.width),
                        y: CGFloat.random(in: 0...size.height * 0.9)
                    )
            }

            // Планета
            Circle()
                .fill(
                    LinearGradient(colors: [Color(hex: "#F59E0B"), Color(hex: "#B45309")],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 90, height: 90)
                .position(x: size.width * 0.75, y: size.height * 0.3)

            // Луна (поверхность)
            Ellipse()
                .fill(Color(hex: "#E5E7EB"))
                .frame(width: size.width * 1.2, height: 80)
                .position(x: size.width * 0.5, y: size.height * 0.95)

            // Кратеры
            Circle().fill(Color(hex: "#9CA3AF")).frame(width: 20, height: 20)
                .position(x: size.width * 0.3, y: size.height * 0.93)
            Circle().fill(Color(hex: "#9CA3AF")).frame(width: 14, height: 14)
                .position(x: size.width * 0.7, y: size.height * 0.96)
        }
    }
}

// Простые фигуры
struct Cloud: View {
    var body: some View {
        ZStack {
            Circle().fill(.white).frame(width: 30, height: 30).offset(x: -15)
            Circle().fill(.white).frame(width: 40, height: 40)
            Circle().fill(.white).frame(width: 30, height: 30).offset(x: 15)
        }
    }
}

struct Tree: View {
    var body: some View {
        ZStack {
            // Ствол
            Capsule()
                .fill(Color(hex: "#8B5A2B"))
                .frame(width: 18, height: 60)
                .offset(y: 30)
            // Крона
            Circle().fill(Color(hex: "#22C55E"))
                .frame(width: 80, height: 80)
                .offset(y: -20)
            Circle().fill(Color(hex: "#16A34A"))
                .frame(width: 60, height: 60)
                .offset(x: -25, y: -10)
            Circle().fill(Color(hex: "#16A34A"))
                .frame(width: 60, height: 60)
                .offset(x: 25, y: -10)
        }
    }
}

struct Umbrella: View {
    var body: some View {
        ZStack {
            // Палочка
            Rectangle()
                .fill(Color(hex: "#8B5A2B"))
                .frame(width: 4, height: 100)
                .offset(y: 30)
            // Купол
            SemiCircle()
                .fill(Color(hex: "#EF4444"))
                .frame(width: 120, height: 60)
                .offset(y: -20)
            SemiCircle()
                .fill(Color(hex: "#FCD34D"))
                .frame(width: 40, height: 60)
                .offset(y: -20)
        }
    }
}

struct SemiCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addArc(center: CGPoint(x: rect.midX, y: rect.maxY),
                 radius: rect.width / 2,
                 startAngle: .degrees(180),
                 endAngle: .degrees(0),
                 clockwise: false)
        p.closeSubpath()
        return p
    }
}
