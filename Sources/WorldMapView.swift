import SwiftUI

struct WorldMapView: View {

    @EnvironmentObject var worldStore: WorldStore
    @EnvironmentObject var characterStore: CharacterStore

    @State private var showMenu = false
    @State private var appeared = false
    @State private var sunPulse = false
    @State private var cloudOffset1: CGFloat = -200
    @State private var cloudOffset2: CGFloat = 400

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    // === Небо ===
                    LinearGradient(
                        colors: [
                            Color(hex: "#AEE2FF"),
                            Color(hex: "#DCF3FF"),
                            Color(hex: "#FFEFD5")
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()

                    // === Солнце ===
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color(hex: "#FFE066"), Color(hex: "#FFB84D")],
                                center: .center,
                                startRadius: 5,
                                endRadius: 70
                            )
                        )
                        .frame(width: 110, height: 110)
                        .shadow(color: Color(hex: "#FFD700").opacity(0.6), radius: 30)
                        .scaleEffect(sunPulse ? 1.08 : 1.0)
                        .position(x: geo.size.width * 0.85, y: geo.size.height * 0.15)
                        .onAppear {
                            withAnimation(
                                .easeInOut(duration: 2.0).repeatForever(autoreverses: true)
                            ) {
                                sunPulse = true
                            }
                        }

                    // === Облака ===
                    cloudShape
                        .position(x: geo.size.width * 0.5 + cloudOffset1,
                                  y: geo.size.height * 0.12)
                    cloudShape
                        .opacity(0.85)
                        .position(x: geo.size.width * 0.3 + cloudOffset2,
                                  y: geo.size.height * 0.22)

                    // === Трава ===
                    VStack(spacing: 0) {
                        Spacer()
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#8FD16B"), Color(hex: "#6BB84C")],
                                    startPoint: .top, endPoint: .bottom
                                )
                            )
                            .frame(height: geo.size.height * 0.45)
                    }
                    .ignoresSafeArea()

                    // === Дорожки (декоративные) ===
                    pathShape(in: geo.size)

                    // === Заголовок ===
                    VStack {
                        Text("OurWorld")
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                            .shadow(color: .white.opacity(0.6), radius: 4, y: 2)
                            .padding(.top, 16)
                        Spacer()
                    }

                    // === Здания ===
                    ForEach(Array(LocationID.allCases.enumerated()), id: \.element.id) { index, location in
                        NavigationLink(value: location) {
                            BuildingView(location: location)
                        }
                        .buttonStyle(BounceButtonStyle())
                        .position(
                            x: geo.size.width * location.mapPosition.x,
                            y: geo.size.height * location.mapPosition.y
                        )
                        .opacity(appeared ? 1 : 0)
                        .scaleEffect(appeared ? 1.0 : 0.6)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.7)
                            .delay(Double(index) * 0.08),
                            value: appeared
                        )
                    }

                    // === Кнопка меню (правый верхний угол) ===
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                showMenu = true
                            } label: {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color(hex: "#111827"))
                                    .frame(width: 48, height: 48)
                                    .background(.white.opacity(0.95))
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.12), radius: 8, y: 3)
                            }
                            .padding(.trailing, 20)
                            .padding(.top, 60)
                        }
                        Spacer()
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationBarHidden(true)
            .navigationDestination(for: LocationID.self) { location in
                LocationView(location: location)
                    .environmentObject(worldStore)
                    .environmentObject(characterStore)
            }
        }
        .sheet(isPresented: $showMenu) {
            MenuView()
                .environmentObject(worldStore)
                .environmentObject(characterStore)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                appeared = true
            }
            animateClouds()
        }
    }

    // MARK: - Облако

    private var cloudShape: some View {
        ZStack {
            Ellipse()
                .fill(Color.white)
                .frame(width: 100, height: 50)
            Ellipse()
                .fill(Color.white)
                .frame(width: 70, height: 60)
                .offset(x: -35, y: -8)
            Ellipse()
                .fill(Color.white)
                .frame(width: 60, height: 50)
                .offset(x: 35, y: -5)
        }
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }

    // MARK: - Дорожки

    private func pathShape(in size: CGSize) -> some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: size.height * 0.62))
            path.addCurve(
                to: CGPoint(x: size.width, y: size.height * 0.58),
                control1: CGPoint(x: size.width * 0.35, y: size.height * 0.52),
                control2: CGPoint(x: size.width * 0.65, y: size.height * 0.68)
            )
        }
        .stroke(
            Color(hex: "#E8C99B"),
            style: StrokeStyle(lineWidth: 28, lineCap: .round)
        )
        .shadow(color: .black.opacity(0.08), radius: 3, y: 2)
    }

    // MARK: - Анимация облаков

    private func animateClouds() {
        withAnimation(
            .linear(duration: 25).repeatForever(autoreverses: false)
        ) {
            cloudOffset1 = 500
        }
        withAnimation(
            .linear(duration: 35).repeatForever(autoreverses: false)
        ) {
            cloudOffset2 = 500
        }
    }
}

// MARK: - Здание на карте

struct BuildingView: View {

    let location: LocationID

    var body: some View {
        VStack(spacing: 0) {
            // Крыша
            RoofShape()
                .fill(Color(hex: location.roofColor))
                .frame(width: 76, height: 38)
                .shadow(color: .black.opacity(0.15), radius: 3, y: 2)

            // Стены
            ZStack {
                Rectangle()
                    .fill(Color(hex: location.wallColor))
                    .frame(width: 66, height: 58)
                    .shadow(color: .black.opacity(0.12), radius: 3, y: 3)

                // Окна
                HStack(spacing: 6) {
                    window
                    window
                }
                .offset(y: -8)

                // Дверь
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(hex: location.roofColor).opacity(0.85))
                    .frame(width: 18, height: 26)
                    .offset(y: 16)

                // Иконка локации на двери
                Image(systemName: location.icon)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .offset(y: 16)
            }
        }
        .scaleEffect(1.0)
    }

    private var window: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color(hex: "#BFE6FF"))
            .frame(width: 16, height: 14)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.white, lineWidth: 2)
            )
    }
}

// MARK: - Форма крыши

struct RoofShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Стиль кнопки (пружинка при нажатии)

struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.6),
                       value: configuration.isPressed)
    }
}
