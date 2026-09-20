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
            case .hospital: HospitalScene(size: geo.size)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Дом
struct HomeScene: View {
    let size: CGSize
    var body: some View {
        ZStack {
            Color(hex: "#F4E4C1")

            // Пол
            Rectangle().fill(Color(hex: "#E0B77A"))
                .frame(height: size.height * 0.30)
                .position(x: size.width / 2, y: size.height * 0.85)

            // Плинтус
            Rectangle().fill(Color(hex: "#C69457"))
                .frame(height: 6)
                .position(x: size.width / 2, y: size.height * 0.70)

            // Окно с видом
            ZStack {
                Image("colored_talltrees")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 150)
                    .clipped()
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "#8B5A2B"), lineWidth: 10)
                    .frame(width: 200, height: 150)
            }
            .position(x: size.width * 0.5, y: size.height * 0.32)
        }
    }
}

// MARK: - Кафе
struct CafeScene: View {
    let size: CGSize
    var body: some View {
        ZStack {
            Color(hex: "#F5E6D3")

            // Полосатая стена
            VStack(spacing: 0) {
                Spacer()
                HStack(spacing: 0) {
                    ForEach(0..<12, id: \.self) { i in
                        Rectangle()
                            .fill(i % 2 == 0 ? Color(hex: "#C69167") : Color(hex: "#8B5A2B"))
                    }
                }
                .frame(height: size.height * 0.35)
            }

            // Окно с видом на лес
            ZStack {
                Image("colored_forest")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 220, height: 130)
                    .clipped()
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(hex: "#5A3A1E"), lineWidth: 10)
                    .frame(width: 220, height: 130)
            }
            .position(x: size.width * 0.5, y: size.height * 0.28)
        }
    }
}

// MARK: - Парк (фото-фон)
struct ParkScene: View {
    let size: CGSize
    var body: some View {
        ZStack {
            Image("colored_talltrees")
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .clipped()
        }
    }
}

// MARK: - Пляж (фото-фон)
struct BeachScene: View {
    let size: CGSize
    var body: some View {
        ZStack {
            Image("colored_desert")
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .clipped()
        }
    }
}

// MARK: - Космос
struct SpaceScene: View {
    let size: CGSize
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "#0F172A"), Color(hex: "#312E81")],
                           startPoint: .top, endPoint: .bottom)

            // Звёзды
            ForEach(0..<50, id: \.self) { _ in
                Circle()
                    .fill(.white)
                    .frame(width: CGFloat.random(in: 1...3),
                           height: CGFloat.random(in: 1...3))
                    .position(x: CGFloat.random(in: 0...size.width),
                              y: CGFloat.random(in: 0...size.height * 0.9))
            }

            // Луна
            Image("moon_full")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .position(x: size.width * 0.75, y: size.height * 0.28)

            // Земля
            Ellipse().fill(Color(hex: "#E5E7EB"))
                .frame(width: size.width * 1.2, height: 80)
                .position(x: size.width * 0.5, y: size.height * 0.95)
        }
    }
}

// MARK: - Больница
struct HospitalScene: View {
    let size: CGSize
    var body: some View {
        ZStack {
            Color(hex: "#F0F9FF")

            Rectangle().fill(Color(hex: "#CBD5E1"))
                .frame(height: 6)
                .position(x: size.width / 2, y: size.height * 0.65)

            // Красный крест
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(hex: "#EF4444"))
                    .frame(width: 90, height: 25)
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(hex: "#EF4444"))
                    .frame(width: 25, height: 90)
            }
            .position(x: size.width * 0.5, y: size.height * 0.3)
        }
    }
}