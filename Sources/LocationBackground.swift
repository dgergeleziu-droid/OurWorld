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

struct HomeScene: View {
    let size: CGSize
    var body: some View {
        ZStack {
            Color(hex: "#FFF4D6")
            Rectangle().fill(Color(hex: "#E8B77A"))
                .frame(height: size.height * 0.35)
                .position(x: size.width / 2, y: size.height * 0.83)
            Rectangle().fill(Color(hex: "#B8854A"))
                .frame(height: 6)
                .position(x: size.width / 2, y: size.height * 0.655)
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#8ED4F0"))
                .frame(width: 140, height: 110)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "#B8854A"), lineWidth: 8))
                .position(x: size.width * 0.5, y: size.height * 0.28)
            Circle().fill(.white).frame(width: 25, height: 15)
                .position(x: size.width * 0.45, y: size.height * 0.24)
            Circle().fill(.white).frame(width: 18, height: 12)
                .position(x: size.width * 0.55, y: size.height * 0.26)
        }
    }
}

struct CafeScene: View {
    let size: CGSize
    var body: some View {
        ZStack {
            Color(hex: "#F5E6D3")
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
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(hex: "#A7D8F0"))
                .frame(width: 180, height: 90)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#5A3A1E"), lineWidth: 8))
                .position(x: size.width * 0.5, y: size.height * 0.22)
        }
    }
}

struct ParkScene: View {
    let size: CGSize
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "#A7D8F0"), Color(hex: "#DCF0FB")],
                           startPoint: .top, endPoint: .bottom)
            Circle().fill(Color(hex: "#FCD34D"))
                .frame(width: 70, height: 70)
                .position(x: size.width * 0.85, y: size.height * 0.14)
            BigCloud().position(x: size.width * 0.2, y: size.height * 0.12)
            BigCloud().scaleEffect(0.7).position(x: size.width * 0.65, y: size.height * 0.18)
            Rectangle().fill(Color(hex: "#7BC96F"))
                .frame(height: size.height * 0.35)
                .position(x: size.width / 2, y: size.height * 0.83)
        }
    }
}

struct BeachScene: View {
    let size: CGSize
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "#FCD34D"), Color(hex: "#FDE68A")],
                           startPoint: .top, endPoint: .bottom)
            Rectangle().fill(Color(hex: "#38BDF8"))
                .frame(height: size.height * 0.4)
                .position(x: size.width / 2, y: size.height * 0.55)
            Rectangle().fill(Color(hex: "#FDE68A"))
                .frame(height: size.height * 0.25)
                .position(x: size.width / 2, y: size.height * 0.88)
        }
    }
}

struct SpaceScene: View {
    let size: CGSize
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "#0F172A"), Color(hex: "#312E81")],
                           startPoint: .top, endPoint: .bottom)
            ForEach(0..<50, id: \.self) { _ in
                Circle()
                    .fill(.white)
                    .frame(width: CGFloat.random(in: 1...3),
                           height: CGFloat.random(in: 1...3))
                    .position(x: CGFloat.random(in: 0...size.width),
                              y: CGFloat.random(in: 0...size.height * 0.9))
            }
            Circle()
                .fill(LinearGradient(colors: [Color(hex: "#F59E0B"), Color(hex: "#B45309")],
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 90, height: 90)
                .position(x: size.width * 0.75, y: size.height * 0.3)
            Ellipse().fill(Color(hex: "#E5E7EB"))
                .frame(width: size.width * 1.2, height: 80)
                .position(x: size.width * 0.5, y: size.height * 0.95)
        }
    }
}

struct HospitalScene: View {
    let size: CGSize
    var body: some View {
        ZStack {
            Color(hex: "#F0F9FF")
            Rectangle().fill(Color(hex: "#CBD5E1"))
                .frame(height: 6)
                .position(x: size.width / 2, y: size.height * 0.65)
            // Крест
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

struct BigCloud: View {
    var body: some View {
        ZStack {
            Circle().fill(.white).frame(width: 30, height: 30).offset(x: -15)
            Circle().fill(.white).frame(width: 40, height: 40)
            Circle().fill(.white).frame(width: 30, height: 30).offset(x: 15)
        }
    }
}
