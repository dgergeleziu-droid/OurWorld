import SwiftUI

struct SplashView: View {
    @State private var textOpacity: Double = 0.0
    @State private var textScale: CGFloat = 0.85
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            // Градиентный фон
            LinearGradient(
                colors: [
                    Color(hex: "#FDF6EC"),
                    Color(hex: "#FCE7F3"),
                    Color(hex: "#FDF6EC")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 14) {
                // Название игры
                Text("OurWorld")
                    .font(.system(size: 64, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                    .shadow(color: Color(hex: "#EC4899").opacity(0.15), radius: 12, x: 0, y: 4)

                // Подпись
                Text("Дёма&Анютка")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "#6B7280"))

                // Крутящееся сердечко под надписью (через 1 сек)
                Image(systemName: "heart.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color(hex: "#EC4899"))
                    .padding(.top, 20)
                    .opacity(textOpacity)
            }
            .opacity(textOpacity)
            .scaleEffect(textScale)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.2)) {
                textOpacity = 1.0
                textScale = 1.0
            }
        }
    }
}
