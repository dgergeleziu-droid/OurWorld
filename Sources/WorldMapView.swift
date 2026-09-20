import SwiftUI

struct WorldMapView: View {
    @EnvironmentObject var characterStore: CharacterStore
    @EnvironmentObject var worldStore: WorldStore

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Небо
                LinearGradient(
                    colors: [Color(hex: "#87CEEB"), Color(hex: "#B0E0FF")],
                    startPoint: .top, endPoint: .bottom
                ).ignoresSafeArea()

                // Солнце
                Circle()
                    .fill(Color(hex: "#FCD34D"))
                    .frame(width: 80, height: 80)
                    .position(x: geo.size.width - 80, y: 80)

                // Облака
                CloudView()
                    .position(x: geo.size.width * 0.2, y: 70)
                CloudView()
                    .scaleEffect(0.7)
                    .position(x: geo.size.width * 0.6, y: 110)

                // Трава
                Rectangle()
                    .fill(LinearGradient(
                        colors: [Color(hex: "#7BC96F"), Color(hex: "#5BAF50")],
                        startPoint: .top, endPoint: .bottom))
                    .frame(height: geo.size.height * 0.75)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.75)

                // Здания (локации)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        ForEach(LocationID.allCases) { loc in
                            NavigationLink {
                                LocationView(location: loc)
                            } label: {
                                BuildingCard(location: loc)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .frame(height: 380)
                .position(x: geo.size.width / 2, y: geo.size.height * 0.62)
            }
        }
        .navigationBarHidden(true)
        .overlay(alignment: .topLeading) {
            // Заголовок
            Text("Наш Мир")
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
                .padding(.horizontal, 24)
                .padding(.top, 16)
        }
    }
}

// MARK: - Облако
struct CloudView: View {
    var body: some View {
        ZStack {
            Circle().fill(.white).frame(width: 40, height: 40).offset(x: -20)
            Circle().fill(.white).frame(width: 55, height: 55)
            Circle().fill(.white).frame(width: 40, height: 40).offset(x: 20)
        }
    }
}

// MARK: - Здание-кнопка
struct BuildingCard: View {
    let location: LocationID

    private var wallColor: Color {
        switch location {
        case .home: return Color(hex: "#FCD9A8")
        case .cafe: return Color(hex: "#D4A57A")
        case .park: return Color(hex: "#8ED17D")
        case .beach: return Color(hex: "#FFE0A3")
        case .space: return Color(hex: "#7C7AE8")
        case .hospital: return Color(hex: "#F5F5F5")
        }
    }
    private var roofColor: Color {
        switch location {
        case .home: return Color(hex: "#D2683C")
        case .cafe: return Color(hex: "#A0522D")
        case .park: return Color(hex: "#5BAF50")
        case .beach: return Color(hex: "#E8A030")
        case .space: return Color(hex: "#4A48C0")
        case .hospital: return Color(hex: "#EF4444")
        }
    }
    private var iconColor: Color {
        switch location {
        case .home: return Color(hex: "#8B4513")
        case .cafe: return Color(hex: "#5A3A1E")
        case .park: return .white
        case .beach: return Color(hex: "#B86A00")
        case .space: return .white
        case .hospital: return Color(hex: "#EF4444")
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Крыша
            Triangle()
                .fill(roofColor)
                .frame(width: 160, height: 60)

            // Стены
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(wallColor)
                    .frame(width: 150, height: 160)

                // Окно (левое)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(hex: "#87CEEB"))
                    .frame(width: 40, height: 40)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(roofColor, lineWidth: 4))
                    .offset(x: -40, y: -40)

                // Окно (правое)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(hex: "#87CEEB"))
                    .frame(width: 40, height: 40)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(roofColor, lineWidth: 4))
                    .offset(x: 40, y: -40)

                // Дверь
                RoundedRectangle(cornerRadius: 4)
                    .fill(roofColor)
                    .frame(width: 44, height: 70)
                    .offset(y: 45)

                // Иконка локации на двери
                Image(systemName: location.icon)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .offset(y: 45)
            }

            // Подпись
            Text(location.rawValue)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
                .padding(.horizontal, 22)
                .padding(.vertical, 8)
                .background(Capsule().fill(.white))
                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                .offset(y: 10)
        }
    }
}

// MARK: - Треугольник (крыша)
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
