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
                    // Небо
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

                    // Солнце
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

                    // Облака
                    cloudShape
                        .position(x: geo.size.width * 0.5 + cloudOffset1,
                                  y: geo.size.height * 0.12)
                    cloudShape
                        .opacity(0.85)
                        .position(x: geo.size.width * 0.3 + cloudOffset2,
                                  y: geo.size.height * 0.22)

                    // Трава
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

                    // Дорожка
                    pathShape(in: geo.size)

                    // Заголовок
                    VStack {
                        Text("OurWorld")
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                            .shadow(color: .white.opacity(0.6), radius: 4, y: 2)
                            .padding(.top, 16)
                        Spacer()
                    }

                    // Здания
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

                    // Кнопка меню
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

    // MARK: - Дорожка

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

// MARK: - Детализированное здание

struct BuildingView: View {

    let location: LocationID

    private let houseW: CGFloat = 110
    private let wallH: CGFloat = 80
    private let roofH: CGFloat = 55
    private let foundationH: CGFloat = 8

    var body: some View {
        ZStack(alignment: .bottom) {
            // Тень на земле
            Ellipse()
                .fill(Color.black.opacity(0.18))
                .frame(width: houseW * 0.95, height: 14)
                .blur(radius: 2)
                .offset(y: 4)

            VStack(spacing: 0) {
                roof
                walls
                foundation
            }
            .offset(y: -8)
        }
        .frame(width: houseW, height: wallH + roofH + foundationH + 20)
    }

    // MARK: Крыша

    private var roof: some View {
        ZStack(alignment: .bottom) {
            if location == .home {
                chimney
                    .offset(x: houseW * 0.25, y: -roofH + 18)
            }

            RoofShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: location.roofColor),
                            Color(hex: location.roofColor).opacity(0.85)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: houseW, height: roofH)
                .overlay(
                    VStack(spacing: 6) {
                        ForEach(0..<4, id: \.self) { _ in
                            Rectangle()
                                .fill(Color.white.opacity(0.15))
                                .frame(height: 1)
                        }
                    }
                    .frame(width: houseW * 0.7)
                    .offset(y: -6)
                )
                .overlay(
                    RoofShape()
                        .stroke(Color.black.opacity(0.3), lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.15), radius: 3, y: 2)
        }
    }

    // MARK: Стены

    private var walls: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: location.wallColor),
                            Color(hex: location.wallColor).opacity(0.88)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: houseW * 0.9, height: wallH)
                .overlay(
                    Rectangle()
                        .stroke(Color.black.opacity(0.25), lineWidth: 1.5)
                )
                .overlay(
                    HStack(spacing: 8) {
                        ForEach(0..<7, id: \.self) { _ in
                            Rectangle()
                                .fill(Color.black.opacity(0.05))
                                .frame(width: 1)
                        }
                    }
                    .frame(height: wallH * 0.85)
                )

            HStack(spacing: 10) {
                window
                window
            }
            .offset(y: -wallH * 0.55)

            VStack(spacing: 2) {
                steps
                door
            }
            .offset(y: 2)

            locationSign
                .offset(y: -wallH + 14)

            flowerPot
                .offset(x: -houseW * 0.32, y: -4)
        }
    }

    // MARK: Фундамент

    private var foundation: some View {
        Rectangle()
            .fill(Color(hex: "#9CA3AF"))
            .frame(width: houseW * 0.95, height: foundationH)
            .overlay(
                Rectangle()
                    .stroke(Color.black.opacity(0.3), lineWidth: 1)
            )
            .overlay(
                HStack(spacing: 4) {
                    ForEach(0..<8, id: \.self) { _ in
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 3, height: 3)
                    }
                }
            )
    }

    // MARK: Детали

    private var window: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.white)
                .frame(width: 22, height: 24)

            RoundedRectangle(cornerRadius: 2)
                .fill(Color(hex: "#BFE6FF"))
                .frame(width: 16, height: 18)
                .overlay(
                    LinearGradient(
                        colors: [Color.white.opacity(0.6), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: 16, height: 18)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                )

            Rectangle()
                .fill(Color.white)
                .frame(width: 2, height: 18)
            Rectangle()
                .fill(Color.white)
                .frame(width: 16, height: 2)

            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.black.opacity(0.35), lineWidth: 1)
                .frame(width: 22, height: 24)

            Rectangle()
                .fill(Color.white)
                .frame(width: 26, height: 3)
                .offset(y: 14)
        }
    }

    private var door: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: location.roofColor).opacity(0.9))
                .frame(width: 26, height: 36)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black.opacity(0.35), lineWidth: 1.5)
                )

            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white.opacity(0.25))
                .frame(width: 18, height: 10)
                .offset(y: -8)

            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white.opacity(0.25))
                .frame(width: 18, height: 10)
                .offset(y: 6)

            Circle()
                .fill(Color(hex: "#FBBF24"))
                .frame(width: 4, height: 4)
                .overlay(
                    Circle().stroke(Color.black.opacity(0.3), lineWidth: 0.5)
                )
                .offset(x: 8, y: 2)
        }
    }

    private var steps: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(hex: "#9CA3AF"))
                .frame(width: 34, height: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.black.opacity(0.3), lineWidth: 0.8)
                )
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(hex: "#B4BCC7"))
                .frame(width: 38, height: 4)
                .offset(y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.black.opacity(0.3), lineWidth: 0.8)
                )
        }
        .offset(y: 36)
    }

    private var chimney: some View {
        ZStack {
            Rectangle()
                .fill(Color(hex: "#8B5A2B"))
                .frame(width: 12, height: 28)
                .overlay(
                    Rectangle()
                        .stroke(Color.black.opacity(0.4), lineWidth: 1.2)
                )
                .overlay(
                    VStack(spacing: 3) {
                        ForEach(0..<5, id: \.self) { _ in
                            Rectangle()
                                .fill(Color.white.opacity(0.15))
                                .frame(height: 0.8)
                        }
                    }
                )

            Rectangle()
                .fill(Color(hex: "#5C3B1E"))
                .frame(width: 16, height: 4)
                .offset(y: -16)
        }
    }

    private var locationSign: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white)
                .frame(width: 34, height: 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(hex: location.roofColor), lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.15), radius: 2, y: 1)

            Image(systemName: location.icon)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(hex: location.roofColor))
        }
    }

    private var flowerPot: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(hex: "#C89B6E"))
                .frame(width: 10, height: 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.black.opacity(0.3), lineWidth: 0.8)
                )

            ZStack {
                Circle()
                    .fill(Color(hex: "#EC4899"))
                    .frame(width: 8, height: 8)
                Circle()
                    .fill(Color(hex: "#FBBF24"))
                    .frame(width: 3, height: 3)
            }
            .offset(y: -8)
        }
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

// MARK: - Стиль кнопки

struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.6),
                       value: configuration.isPressed)
    }
}
