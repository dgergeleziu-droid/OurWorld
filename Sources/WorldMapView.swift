import SwiftUI

struct WorldMapView: View {

    @EnvironmentObject var worldStore: WorldStore
    @EnvironmentObject var characterStore: CharacterStore

    @State private var showMenu = false
    @State private var appeared = false
    @State private var sunPulse = false
    @State private var cloudOffset1: CGFloat = -200
    @State private var cloudOffset2: CGFloat = 400

    // Сортировка по глубине: верхние (дальние) рисуются раньше, нижние (ближние) — поверх
    private var sortedLocations: [LocationID] {
        LocationID.allCases.sorted { $0.mapPosition.y < $1.mapPosition.y }
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let W = geo.size.width
                let H = geo.size.height

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
                    sunView(W: W, H: H)

                    // Облака
                    cloudsLayer(W: W, H: H)

                    // Земля — изометрическая трапеция
                    IsoGroundShape()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "#A8DE7A"),
                                    Color(hex: "#8FD16B"),
                                    Color(hex: "#6BB84C")
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: W, height: H)
                        .ignoresSafeArea()

                    // Горизонтальные линии-плитки, уходящие в перспективу
                    groundTileLines(W: W, H: H)

                    // Дорожка в перспективе
                    IsoRoadShape()
                        .fill(Color(hex: "#E8C99B"))
                        .frame(width: W, height: H)
                        .opacity(0.9)

                    // Декор — 3D деревья и кусты
                    decorLayer(W: W, H: H)

                    // Заголовок
                    VStack {
                        Text("OurWorld")
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                            .shadow(color: .white.opacity(0.6), radius: 4, y: 2)
                            .padding(.top, 16)
                        Spacer()
                    }
                    .allowsHitTesting(false)

                    // Здания и парк (в порядке глубины)
                    ForEach(Array(sortedLocations.enumerated()), id: \.element.id) { index, location in
                        NavigationLink(value: location) {
                            Group {
                                if location == .park {
                                    IsoParkView()
                                } else {
                                    IsoBuildingView(location: location)
                                }
                            }
                        }
                        .buttonStyle(BounceButtonStyle())
                        .position(
                            x: W * location.mapPosition.x,
                            y: H * location.mapPosition.y
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
                    menuButton
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

    // MARK: - Солнце

    private func sunView(W: CGFloat, H: CGFloat) -> some View {
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
            .position(x: W * 0.85, y: H * 0.15)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 2.0).repeatForever(autoreverses: true)
                ) {
                    sunPulse = true
                }
            }
    }

    // MARK: - Облака

    private func cloudsLayer(W: CGFloat, H: CGFloat) -> some View {
        ZStack {
            cloudShape
                .position(x: W * 0.5 + cloudOffset1, y: H * 0.12)
            cloudShape
                .opacity(0.85)
                .position(x: W * 0.3 + cloudOffset2, y: H * 0.22)
        }
    }

    private var cloudShape: some View {
        ZStack {
            Ellipse().fill(Color.white).frame(width: 100, height: 50)
            Ellipse().fill(Color.white).frame(width: 70, height: 60).offset(x: -35, y: -8)
            Ellipse().fill(Color.white).frame(width: 60, height: 50).offset(x: 35, y: -5)
        }
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }

    // MARK: - Линии-плитки на земле

    private func groundTileLines(W: CGFloat, H: CGFloat) -> some View {
        ZStack {
            ForEach(0..<6, id: \.self) { i in
                let t = CGFloat(i) / 5.0
                let y = H * (0.44 + t * 0.56)
                let widthFactor = 0.70 + t * 0.30
                Rectangle()
                    .fill(Color.black.opacity(0.06))
                    .frame(width: W * widthFactor, height: 1)
                    .position(x: W / 2, y: y)
            }
        }
        .allowsHitTesting(false)
    }

    // MARK: - Декор

    private func decorLayer(W: CGFloat, H: CGFloat) -> some View {
        ZStack {
            IsoTree(size: 44).position(x: W * 0.10, y: H * 0.62)
            IsoTree(size: 36).position(x: W * 0.92, y: H * 0.58)
            IsoBush(size: 28).position(x: W * 0.22, y: H * 0.86)
            IsoBush(size: 32).position(x: W * 0.78, y: H * 0.82)
            IsoTree(size: 40).position(x: W * 0.05, y: H * 0.90)
            IsoTree(size: 40).position(x: W * 0.95, y: H * 0.88)
        }
        .allowsHitTesting(false)
    }

    // MARK: - Кнопка меню

    private var menuButton: some View {
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

    // MARK: - Анимация облаков

    private func animateClouds() {
        withAnimation(.linear(duration: 25).repeatForever(autoreverses: false)) {
            cloudOffset1 = 500
        }
        withAnimation(.linear(duration: 35).repeatForever(autoreverses: false)) {
            cloudOffset2 = 500
        }
    }
}

// MARK: - Формы изометрии (мир)

struct IsoGroundShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        p.move(to: CGPoint(x: w * 0.20, y: h * 0.44))
        p.addLine(to: CGPoint(x: w * 0.80, y: h * 0.44))
        p.addLine(to: CGPoint(x: w, y: h))
        p.addLine(to: CGPoint(x: 0, y: h))
        p.closeSubpath()
        return p
    }
}

struct IsoRoadShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        p.move(to: CGPoint(x: w * 0.44, y: h * 0.46))
        p.addLine(to: CGPoint(x: w * 0.56, y: h * 0.46))
        p.addLine(to: CGPoint(x: w * 0.78, y: h))
        p.addLine(to: CGPoint(x: w * 0.22, y: h))
        p.closeSubpath()
        return p
    }
}

// MARK: - 3D здание

struct IsoBuildingView: View {
    let location: LocationID

    // Размеры
    private let wallW: CGFloat = 90
    private let wallH: CGFloat = 70
    private let roofH: CGFloat = 50
    private let sideDx: CGFloat = 22   // глубина вправо
    private let sideDy: CGFloat = 13   // глубина вверх

    // Общая рамка
    private let frameW: CGFloat = 140
    private let frameH: CGFloat = 160
    private let originX: CGFloat = 60
    private let originY: CGFloat = 145

    private var wallColor: Color { Color(hex: location.wallColor) }
    private var wallColorDark: Color { Color(hex: location.wallColor).opacity(0.65) }
    private var roofColor: Color { Color(hex: location.roofColor) }
    private var roofColorDark: Color { Color(hex: location.roofColor).opacity(0.62) }

    private func fx(_ lx: CGFloat) -> CGFloat { lx + originX }
    private func fy(_ ly: CGFloat) -> CGFloat { ly + originY }

    var body: some View {
        ZStack {
            groundShadow
            rightSideWall
            frontWall
            if location == .home { chimney }
            frontRoof
            rightRoof
            doorElement
            leftWindowElement
            rightWindowElement
            locationSignElement
            flowerPotElement
        }
        .frame(width: frameW, height: frameH)
    }

    // Тень на земле
    private var groundShadow: some View {
        Ellipse()
            .fill(Color.black.opacity(0.22))
            .frame(width: wallW * 1.15, height: 14)
            .blur(radius: 3)
            .position(x: fx(6), y: fy(4))
    }

    // Правая боковая стена
    private var rightSideWall: some View {
        RightWallShape(depthX: sideDx, depthY: sideDy, wallH: wallH)
            .fill(
                LinearGradient(
                    colors: [wallColorDark, wallColorDark.opacity(0.85)],
                    startPoint: .top, endPoint: .bottom
                )
            )
            .overlay(
                RightWallShape(depthX: sideDx, depthY: sideDy, wallH: wallH)
                    .stroke(Color.black.opacity(0.45), lineWidth: 1.5)
            )
            .frame(width: sideDx, height: wallH + sideDy)
            .position(x: fx(wallW / 2 + sideDx / 2),
                      y: fy(-wallH / 2 - sideDy / 2))
    }

    // Передняя стена
    private var frontWall: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(
                    LinearGradient(
                        colors: [wallColor, wallColor.opacity(0.88)],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(width: wallW, height: wallH)

            HStack(spacing: 6) {
                ForEach(0..<10, id: \.self) { _ in
                    Rectangle().fill(Color.black.opacity(0.05)).frame(width: 1)
                }
            }
            .frame(height: wallH * 0.9)

            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.black.opacity(0.45), lineWidth: 1.8)
                .frame(width: wallW, height: wallH)
        }
        .frame(width: wallW, height: wallH)
        .position(x: fx(0), y: fy(-wallH / 2))
    }

    // Передняя крыша (треугольник)
    private var frontRoof: some View {
        FrontRoofShape()
            .fill(
                LinearGradient(
                    colors: [roofColor, roofColor.opacity(0.85)],
                    startPoint: .top, endPoint: .bottom
                )
            )
            .overlay(
                FrontRoofShape()
                    .stroke(Color.black.opacity(0.4), lineWidth: 1.8)
            )
            .frame(width: wallW, height: roofH)
            .position(x: fx(0), y: fy(-wallH - roofH / 2))
    }

    // Правый скат крыши
    private var rightRoof: some View {
        RightRoofShape(
            ridgeDx: sideDx,
            ridgeDy: sideDy,
            roofH: roofH,
            wallHalfW: wallW / 2
        )
        .fill(
            LinearGradient(
                colors: [roofColorDark, roofColorDark.opacity(0.8)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        .overlay(
            RightRoofShape(
                ridgeDx: sideDx,
                ridgeDy: sideDy,
                roofH: roofH,
                wallHalfW: wallW / 2
            )
            .stroke(Color.black.opacity(0.4), lineWidth: 1.8)
        )
        .frame(width: wallW / 2 + sideDx, height: roofH + sideDy)
        .position(
            x: fx((wallW / 2 + sideDx) / 2),
            y: fy(-wallH - roofH + (roofH + sideDy) / 2 - sideDy)
        )
    }

    // Дымоход
    private var chimney: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 1.5)
                .fill(Color(hex: "#8B5A2B"))
                .overlay(
                    RoundedRectangle(cornerRadius: 1.5)
                        .stroke(Color.black.opacity(0.5), lineWidth: 1.2)
                )
                .frame(width: 12, height: 26)

            RoundedRectangle(cornerRadius: 1.5)
                .fill(Color(hex: "#5C3B1E"))
                .frame(width: 16, height: 4)
                .offset(y: -14)
        }
        .position(x: fx(wallW * 0.28), y: fy(-wallH - roofH * 0.7))
    }

    // Дверь
    private var doorElement: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: location.roofColor).opacity(0.95))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black.opacity(0.4), lineWidth: 1.5)
                )
                .frame(width: 26, height: 36)

            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white.opacity(0.3))
                .frame(width: 18, height: 10)
                .offset(y: -7)

            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white.opacity(0.3))
                .frame(width: 18, height: 10)
                .offset(y: 6)

            Circle()
                .fill(Color(hex: "#FBBF24"))
                .frame(width: 4, height: 4)
                .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 0.5))
                .offset(x: 8, y: 2)
        }
        .position(x: fx(0), y: fy(-18))
    }

    // Окна
    private var leftWindowElement: some View {
        windowShape.position(x: fx(-wallW * 0.28), y: fy(-wallH * 0.65))
    }
    private var rightWindowElement: some View {
        windowShape.position(x: fx(wallW * 0.28), y: fy(-wallH * 0.65))
    }
    private var windowShape: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3).fill(Color.white).frame(width: 22, height: 24)
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(hex: "#BFE6FF"))
                .frame(width: 16, height: 18)
                .overlay(
                    LinearGradient(
                        colors: [Color.white.opacity(0.6), Color.clear],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    .frame(width: 16, height: 18)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                )
            Rectangle().fill(Color.white).frame(width: 2, height: 18)
            Rectangle().fill(Color.white).frame(width: 16, height: 2)
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.black.opacity(0.4), lineWidth: 1)
                .frame(width: 22, height: 24)
        }
    }

    // Табличка с иконкой
    private var locationSignElement: some View {
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
        .position(x: fx(0), y: fy(-wallH + 12))
    }

    // Цветочный горшок
    private var flowerPotElement: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(hex: "#C89B6E"))
                .frame(width: 10, height: 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.black.opacity(0.35), lineWidth: 0.8)
                )
            ZStack {
                Circle().fill(Color(hex: "#EC4899")).frame(width: 8, height: 8)
                Circle().fill(Color(hex: "#FBBF24")).frame(width: 3, height: 3)
            }
            .offset(y: -8)
        }
        .position(x: fx(-wallW * 0.35), y: fy(-4))
    }
}

// MARK: - 3D Парк (без здания)

struct IsoParkView: View {

    private let frameW: CGFloat = 150
    private let frameH: CGFloat = 160

    var body: some View {
        ZStack {
            groundPad
            pathCross
            bench
            treeBig
            treeSmall
            bushLeft
            bushRight
            flowers
        }
        .frame(width: frameW, height: frameH)
    }

    // Земляная площадка (трапеция как у iso-мира)
    private var groundPad: some View {
        ZStack {
            ParkGroundShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: "#B5E58A"),
                            Color(hex: "#8FD16B")
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .overlay(
                    ParkGroundShape()
                        .stroke(Color.black.opacity(0.25), lineWidth: 1.5)
                )
                .frame(width: frameW * 0.95, height: frameH * 0.5)
                .offset(y: frameH * 0.18)

            Ellipse()
                .fill(Color.black.opacity(0.18))
                .frame(width: frameW * 0.9, height: 10)
                .blur(radius: 3)
                .offset(y: frameH * 0.42)
        }
    }

    // Перекрещивающиеся дорожки из песка
    private var pathCross: some View {
        ZStack {
            Rectangle()
                .fill(Color(hex: "#E8C99B"))
                .frame(width: 14, height: frameH * 0.45)
                .offset(y: frameH * 0.2)
                .opacity(0.9)

            Ellipse()
                .fill(Color(hex: "#E8C99B"))
                .frame(width: 90, height: 30)
                .offset(y: frameH * 0.18)
                .opacity(0.9)
        }
    }

    // Скамейка
    private var bench: some View {
        ZStack {
            HStack(spacing: 22) {
                Capsule().fill(Color(hex: "#5C3B1E"))
                    .frame(width: 4, height: 12)
                Capsule().fill(Color(hex: "#5C3B1E"))
                    .frame(width: 4, height: 12)
            }
            .offset(y: 6)

            RoundedRectangle(cornerRadius: 3)
                .fill(Color(hex: "#A6714A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color.black.opacity(0.4), lineWidth: 1.3)
                )
                .frame(width: 46, height: 8)

            RoundedRectangle(cornerRadius: 2)
                .fill(Color(hex: "#A6714A"))
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.black.opacity(0.4), lineWidth: 1.2)
                )
                .frame(width: 46, height: 4)
                .offset(y: -10)

            HStack(spacing: 4) {
                ForEach(0..<4, id: \.self) { _ in
                    Capsule()
                        .fill(Color(hex: "#5C3B1E"))
                        .frame(width: 3, height: 8)
                }
            }
            .offset(y: -5)
        }
        .position(x: frameW * 0.5, y: frameH * 0.72)
    }

    // Большое дерево (главный акцент парка)
    private var treeBig: some View {
        IsoTree(size: 70)
            .position(x: frameW * 0.27, y: frameH * 0.42)
    }

    // Дерево поменьше
    private var treeSmall: some View {
        IsoTree(size: 48)
            .position(x: frameW * 0.76, y: frameH * 0.48)
    }

    // Кусты
    private var bushLeft: some View {
        IsoBush(size: 28)
            .position(x: frameW * 0.12, y: frameH * 0.72)
    }
    private var bushRight: some View {
        IsoBush(size: 32)
            .position(x: frameW * 0.88, y: frameH * 0.7)
    }

    // Клумбы с цветами
    private var flowers: some View {
        ZStack {
            flowerDots(count: 5, x: frameW * 0.55, y: frameH * 0.82,
                       spreadX: 40, spreadY: 8, color: Color(hex: "#EC4899"))
            flowerDots(count: 5, x: frameW * 0.20, y: frameH * 0.86,
                       spreadX: 34, spreadY: 6, color: Color(hex: "#FBBF24"))
            flowerDots(count: 4, x: frameW * 0.80, y: frameH * 0.86,
                       spreadX: 30, spreadY: 6, color: Color(hex: "#F87171"))
        }
    }

    private func flowerDots(count: Int, x: CGFloat, y: CGFloat,
                            spreadX: CGFloat, spreadY: CGFloat,
                            color: Color) -> some View {
        ZStack {
            ForEach(0..<count, id: \.self) { i in
                let t = CGFloat(i) / CGFloat(max(count - 1, 1))
                let dx = (t - 0.5) * spreadX
                let dy = sin(t * .pi) * spreadY - spreadY * 0.5
                ZStack {
                    Circle()
                        .fill(color)
                        .frame(width: 6, height: 6)
                    Circle()
                        .fill(Color.white.opacity(0.8))
                        .frame(width: 2, height: 2)
                }
                .offset(x: dx, y: dy)
            }
        }
        .position(x: x, y: y)
    }
}

// Трапеция-площадка под парком
struct ParkGroundShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        p.move(to: CGPoint(x: w * 0.15, y: 0))
        p.addLine(to: CGPoint(x: w * 0.85, y: 0))
        p.addLine(to: CGPoint(x: w, y: h))
        p.addLine(to: CGPoint(x: 0, y: h))
        p.closeSubpath()
        return p
    }
}

// MARK: - 3D деревья и кусты

struct IsoTree: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color.black.opacity(0.2))
                .frame(width: size * 0.7, height: size * 0.15)
                .offset(y: size * 0.42)

            Capsule()
                .fill(Color(hex: "#8B5A2B"))
                .overlay(Capsule().stroke(Color.black.opacity(0.4), lineWidth: 1.2))
                .frame(width: size * 0.13, height: size * 0.45)
                .offset(y: size * 0.18)

            Circle()
                .fill(Color(hex: "#4CAF50"))
                .overlay(Circle().stroke(Color.black.opacity(0.35), lineWidth: 1.5))
                .frame(width: size * 0.95, height: size * 0.95)

            Circle()
                .fill(Color(hex: "#66BB6A"))
                .frame(width: size * 0.5, height: size * 0.5)
                .offset(x: -size * 0.12, y: -size * 0.12)
        }
    }
}

struct IsoBush: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color.black.opacity(0.2))
                .frame(width: size * 1.0, height: size * 0.15)
                .offset(y: size * 0.4)

            Ellipse()
                .fill(Color(hex: "#4CAF50"))
                .overlay(Ellipse().stroke(Color.black.opacity(0.35), lineWidth: 1.4))
                .frame(width: size, height: size * 0.85)

            Ellipse()
                .fill(Color(hex: "#66BB6A"))
                .frame(width: size * 0.45, height: size * 0.4)
                .offset(x: -size * 0.15, y: -size * 0.12)
        }
    }
}

// MARK: - Shapes для 3D дома

struct FrontRoofShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: rect.height))
        p.addLine(to: CGPoint(x: rect.width / 2, y: 0))
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.closeSubpath()
        return p
    }
}

struct RightWallShape: Shape {
    let depthX: CGFloat
    let depthY: CGFloat
    let wallH: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: depthY))
        p.addLine(to: CGPoint(x: depthX, y: 0))
        p.addLine(to: CGPoint(x: depthX, y: wallH))
        p.addLine(to: CGPoint(x: 0, y: wallH + depthY))
        p.closeSubpath()
        return p
    }
}

struct RightRoofShape: Shape {
    let ridgeDx: CGFloat
    let ridgeDy: CGFloat
    let roofH: CGFloat
    let wallHalfW: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: ridgeDy))
        p.addLine(to: CGPoint(x: wallHalfW, y: roofH + ridgeDy))
        p.addLine(to: CGPoint(x: wallHalfW + ridgeDx, y: roofH))
        p.addLine(to: CGPoint(x: ridgeDx, y: 0))
        p.closeSubpath()
        return p
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
