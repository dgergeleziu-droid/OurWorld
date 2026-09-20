import SwiftUI

struct SplashView: View {
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 0.8

    var body: some View {
        ZStack {
            // Градиентный фон (можно заменить на свой цвет)
            LinearGradient(
                colors: [Color(hex: "#FDF6EC"), Color(hex: "#FCE7F3")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 12) {
                // Название игры
                Text("OurWorld")
                    .font(.system(size: 54, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))

                // Подпись
                Text("Дёма&Анютка")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "#6B7280"))
            }
            .opacity(opacity)
            .scaleEffect(scale)
        }
        .onAppear {
            // Плавное появление
            withAnimation(.easeOut(duration: 1.0)) {
                opacity = 1.0
                scale = 1.0
            }
        }
    }
}
