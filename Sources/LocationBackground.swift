import SwiftUI

struct LocationBackground: View {
    let location: LocationID

    var body: some View {
        ZStack {
            switch location {
            case .home:     homeBackground
            case .cafe:     cafeBackground
            case .park:     parkBackground
            case .beach:    beachBackground
            case .shop:     shopBackground
            case .hospital: hospitalBackground
            case .school:   schoolBackground
            }
        }
        .ignoresSafeArea()
    }

    // MARK: - Дом
    private var homeBackground: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#FFE9D6"), Color(hex: "#FFD1B3")],
                startPoint: .top, endPoint: .bottom
            )
            VStack(spacing: 0) {
                Rectangle().fill(Color(hex: "#F5D9B8")).frame(height: 120)
                Spacer()
            }
            VStack(spacing: 0) {
                Spacer()
                Rectangle().fill(Color(hex: "#C89B6E")).frame(height: 140)
            }
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#BFE6FF"))
                .frame(width: 180, height: 120)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white, lineWidth: 8)
                )
                .overlay(Rectangle().fill(Color.white).frame(width: 8))
                .overlay(Rectangle().fill(Color.white).frame(height: 8))
                .offset(y: -60)
        }
    }

    // MARK: - Кафе
    private var cafeBackground: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#FFE0C2"), Color(hex: "#FFC59A")],
                startPoint: .top, endPoint: .bottom
            )
            VStack(spacing: 0) {
                Rectangle().fill(Color(hex: "#E8B07A")).frame(height: 130)
                Spacer()
            }
            VStack(spacing: 0) {
                Spacer()
                Rectangle().fill(Color(hex: "#A9714B")).frame(height: 150)
            }
            HStack(spacing: 24) {
                ForEach(0..<5, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(hex: "#FFB27A"))
                        .frame(width: 40, height: 50)
                }
            }
            .offset(y: -40)
        }
    }

    // MARK: - Парк
    private var parkBackground: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#AEE2FF"), Color(hex: "#E6F7FF")],
                startPoint: .top, endPoint: .bottom
            )
            Circle()
                .fill(Color(hex: "#FFE066"))
                .frame(width: 90, height: 90)
                .offset(x: 260, y: -160)
                .shadow(color: .yellow.opacity(0.6), radius: 20)
            VStack(spacing: 0) {
                Spacer()
                Rectangle().fill(Color(hex: "#8FD16B")).frame(height: 200)
            }
            HStack(spacing: 40) {
                cloud
                cloud
                cloud
            }
            .offset(y: -180)
        }
    }

    private var cloud: some View {
        ZStack {
            Circle().fill(.white).frame(width: 50, height: 50)
            Circle().fill(.white).frame(width: 40, height: 40).offset(x: -25)
            Circle().fill(.white).frame(width: 40, height: 40).offset(x: 25)
        }
    }

    // MARK: - Пляж
    private var beachBackground: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#AEE2FF"), Color(hex: "#DCF3FF")],
                startPoint: .top, endPoint: .bottom
            )
            VStack(spacing: 0) {
                Spacer().frame(height: 100)
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#4FC3F7"), Color(hex: "#81D4FA")],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .frame(height: 160)
            }
            VStack(spacing: 0) {
                Spacer()
                Rectangle().fill(Color(hex: "#FFE9A8")).frame(height: 180)
            }
            Circle()
                .fill(Color(hex: "#FFD54F"))
                .frame(width: 100, height: 100)
                .offset(x: 260, y: -180)
                .shadow(color: .yellow.opacity(0.7), radius: 25)
        }
    }

    // MARK: - Магазин
    private var shopBackground: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#E7F7D4"), Color(hex: "#C8E8A8")],
                startPoint: .top, endPoint: .bottom
            )
            VStack(spacing: 0) {
                Rectangle().fill(Color(hex: "#D9E8C5")).frame(height: 130)
                Spacer()
            }
            VStack(spacing: 0) {
                Spacer()
                Rectangle().fill(Color(hex: "#B8966E")).frame(height: 140)
            }
            HStack(spacing: 20) {
                ForEach(0..<6, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(hex: "#FF9A76"))
                        .frame(width: 44, height: 54)
                }
            }
            .offset(y: -30)
        }
    }

    // MARK: - Больница
    private var hospitalBackground: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#EAF6FF"), Color(hex: "#C9E7FB")],
                startPoint: .top, endPoint: .bottom
            )
            VStack(spacing: 0) {
                Rectangle().fill(Color(hex: "#F2FAFF")).frame(height: 130)
                Spacer()
            }
            VStack(spacing: 0) {
                Spacer()
                Rectangle().fill(Color(hex: "#B9D4E5")).frame(height: 140)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 100, height: 100)
                Rectangle().fill(Color(hex: "#E85C5C")).frame(width: 70, height: 22)
                Rectangle().fill(Color(hex: "#E85C5C")).frame(width: 22, height: 70)
            }
            .offset(y: -50)
        }
    }

    // MARK: - Школа
    private var schoolBackground: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#FFF4D6"), Color(hex: "#FCE1A8")],
                startPoint: .top, endPoint: .bottom
            )
            VStack(spacing: 0) {
                Rectangle().fill(Color(hex: "#F9E8C2")).frame(height: 130)
                Spacer()
            }
            VStack(spacing: 0) {
                Spacer()
                Rectangle().fill(Color(hex: "#B8875A")).frame(height: 140)
            }
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#2E6B4F"))
                .frame(width: 260, height: 130)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: "#8B5A2B"), lineWidth: 10)
                )
                .offset(y: -50)
        }
    }
}
