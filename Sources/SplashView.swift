import SwiftUI

struct SplashView: View {

    // Заголовок «OurWorld» — по одной букве
    @State private var visibleLetters: Int = 0

    // Подпись «Дёма&Анютка»
    @State private var subtitleOpacity: Double = 0.0
    @State private var subtitleOffset: CGFloat = 12

    // Сердечко
    @State private var heartOpacity: Double = 0.0
    @State private var heartScale: CGFloat = 0.6
    @State private var heartPulse: Bool = false

    // Общий фон
    @State private var bgOpacity: Double = 1.0

    private let title = "OurWorld"

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

                // === Заголовок «OurWorld» по буквам ===
                HStack(spacing: 2) {
                    ForEach(Array(title.enumerated()), id: \.offset) { index, char in
                        Text(String(char))
                            .font(.system(size: 64, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                            .shadow(
                                color: Color(hex: "#EC4899").opacity(0.15),
                                radius: 12, x: 0, y: 4
                            )
                            .opacity(index < visibleLetters ? 1 : 0)
                            .scaleEffect(index < visibleLetters ? 1.0 : 0.7)
                            .offset(y: index < visibleLetters ? 0 : -10)
                            .animation(
                                .spring(response: 0.45, dampingFraction: 0.7),
                                value: visibleLetters
                            )
                    }
                }

                // === Подпись «Дёма&Анютка» ===
                Text("Дёма&Анютка")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "#6B7280"))
                    .opacity(subtitleOpacity)
                    .offset(y: subtitleOffset)

                // === Пульсирующее сердечко ===
                Image(systemName: "heart.fill")
                    .font(.system(size: 30))
                    .foregroundColor(Color(hex: "#EC4899"))
                    .shadow(color: Color(hex: "#EC4899").opacity(0.4), radius: 10)
                    .padding(.top, 20)
                    .opacity(heartOpacity)
                    .scaleEffect(heartPulse ? 1.15 : 0.95)
                    .animation(
                        .easeInOut(duration: 0.7)
                        .repeatForever(autoreverses: true),
                        value: heartPulse
                    )
            }
            .opacity(bgOpacity)
        }
        .onAppear {
            playIntro()
        }
    }

    // MARK: - Сценарий анимации

    private func playIntro() {

        // 1. Буквы «OurWorld» — по одной, каждые 0.08 сек
        for i in 1...title.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.08) {
                visibleLetters = i
            }
        }

        // 2. Подпись «Дёма&Анютка» — после букв
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.05) {
            withAnimation(.easeOut(duration: 0.5)) {
                subtitleOpacity = 1.0
                subtitleOffset = 0
            }
        }

        // 3. Сердечко — появляется и начинает пульсировать
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.45) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                heartOpacity = 1.0
                heartScale = 1.0
            }
            // запускаем пульсацию
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                heartPulse = true
            }
        }

        // 4. Общее затухание на последних 0.3 сек (2.2...2.5)
        //    ВАЖНО: если переход на карту происходит извне
        //    (в OurWorldApp по таймеру 2.5 сек), этот блок можно убрать.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            withAnimation(.easeIn(duration: 0.3)) {
                bgOpacity = 0.0
            }
        }
    }
}
