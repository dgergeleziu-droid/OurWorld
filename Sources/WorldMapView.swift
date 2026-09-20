import SwiftUI

struct WorldMapView: View {
    @EnvironmentObject var characterStore: CharacterStore
    @EnvironmentObject var worldStore: WorldStore

    @State private var cloudsOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // ===== ФОН =====
                LinearGradient(
                    colors: [Color(hex: "#87CEEB"), Color(hex: "#B0E0FF")],
                    startPoint: .top, endPoint: .bottom
                ).ignoresSafeArea()

                // Солнце с пульсацией
                Circle()
                    .fill(Color(hex: "#FCD34D"))
                    .frame(width: 90, height: 90)
                    .position(x: geo.size.width - 80, y: 80)
                    .shadow(color: Color(hex: "#FCD34D").opacity(0.6), radius: 25)
                    .pulse()

                // Облака (плавно плывут)
                CloudShape()
                    .position(x: geo.size.width * 0.20 + cloudsOffset, y: 90)
                CloudShape().scaleEffect(0.7)
                    .position(x: geo.size.width * 0.65 + cloudsOffset * 0.6, y: 120)
                CloudShape().scaleEffect(0.5)
                    .position(x: geo.size.width * 0.90 + cloudsOffset * 0.4, y: 70)

                // Трава
                Rectangle()
                    .fill(LinearGradient(
                        colors: [Color(hex: "#7BC96F"), Color(hex: "#5BAF50")],
                        startPoint: .top, endPoint: .bottom))
                    .frame(height: geo.size.height * 0.72)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.78)

                // Дорожки
                Path { p in
                    p.move(to: CGPoint(x: geo.size.width * 0.20, y: geo.size.height * 0.55))
                    p.addLine(to: CGPoint(x: geo.size.width * 0.50, y: geo.size.height * 0.70))
                    p.addLine(to: CGPoint(x: geo.size.width * 0.80, y: geo.size.height * 0.60))
                }
                .stroke(Color(hex: "#C9A96E").opacity(0.7),
                        style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round))

                // ===== ЗДАНИЯ с анимацией появления =====
                ForEach(Array(LocationID.allCases.enumerated()), id: \.element) { index, loc in
                    NavigationLink {
                        LocationView(location: loc)
                            .environmentObject(characterStore)
                            .environmentObject(worldStore)
                    } label: {
                        BuildingView(location: loc)
                    }
                    .buttonStyle(BounceButtonStyle())
                    .position(
                        x: geo.size.width * loc.mapPosition.x,
                        y: geo.size.height * loc.mapPosition.y
                    )
                    .staggered(index: index)
                }

                // Заголовок
                VStack {
                    HStack {
                        Text("Наш Мир")
                            .font(.system(size: 34, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                            .shadow(color: .white.opacity(0.8), radius: 6)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.linear(duration: 30).repeatForever(autoreverses: true)) {
                cloudsOffset = 60
            }
        }
    }
}

// MARK: - Кнопка с пружинкой при нажатии
struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(AppAnimation.tap, value: configuration.isPressed)
    }
}

// MARK: - Облако
struct CloudShape: View {
    var body: some View {
        ZStack {
            Circle().fill(.white).frame(width: 44, height: 44).offset(x: -22)
            Circle().fill(.white).frame(width: 60, height: 60)
            Circle().fill(.white).frame(width: 44, height: 44).offset(x: 22)
        }
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

// MARK: - Здание
struct BuildingView: View {
    let location: LocationID

    var body: some View {
        VStack(spacing: 0) {
            Triangle()
                .fill(Color(hex: location.roofColor))
                .frame(width: 70, height: 26)
                .shadow(color: .black.opacity(0.15), radius: 3, y: 2)

            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(hex: location.wallColor))
                    .frame(width: 68, height: 60)
                    .overlay(RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(hex: location.roofColor).opacity(0.5), lineWidth: 2))

                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(hex: "#87CEEB"))
                        .frame(width: 14, height: 14)
                        .overlay(RoundedRectangle(cornerRadius: 2)
                            .stroke(Color(hex: location.roofColor), lineWidth: 2))
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(hex: "#87CEEB"))
                        .frame(width: 14, height: 14)
                        .overlay(RoundedRectangle(cornerRadius: 2)
                            .stroke(Color(hex: location.roofColor), lineWidth: 2))
                }
                .offset(y: -14)

                ZStack {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(hex: location.roofColor))
                        .frame(width: 20, height: 26)
                    Image(systemName: location.icon)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                }
                .offset(y: 12)
            }

            Text(location.rawValue)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
                .padding(.horizontal, 10).padding(.vertical, 3)
                .background(Capsule().fill(.white))
                .shadow(color: .black.opacity(0.1), radius: 3, y: 2)
                .offset(y: -4)
        }
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
