import SwiftUI

struct MenuView: View {

    @EnvironmentObject var worldStore: WorldStore
    @EnvironmentObject var characterStore: CharacterStore
    @Environment(\.dismiss) private var dismiss

    // Настройки звука (сохраняются между запусками)
    @AppStorage("ourworld.musicEnabled") private var musicEnabled: Bool = true
    @AppStorage("ourworld.sfxEnabled")   private var sfxEnabled: Bool = true

    // Диалоги подтверждения
    @State private var showResetWorldAlert = false
    @State private var showResetCharactersAlert = false
    @State private var showCharactersSheet = false
    @State private var showAbout = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Фон — как в остальных экранах
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

                ScrollView {
                    VStack(spacing: 16) {

                        // === Персонажи ===
                        sectionTitle("Персонажи", icon: "person.2.fill")

                        menuRow(
                            icon: "person.crop.circle",
                            color: "#EC4899",
                            title: "Мои персонажи",
                            subtitle: "\(characterStore.players.count) шт."
                        ) {
                            showCharactersSheet = true
                        }

                        // === Звук ===
                        sectionTitle("Звук", icon: "speaker.wave.2.fill")

                        toggleRow(
                            icon: "music.note",
                            color: "#8B5CF6",
                            title: "Музыка",
                            isOn: $musicEnabled
                        )

                        toggleRow(
                            icon: "bell.fill",
                            color: "#F59E0B",
                            title: "Звуки",
                            isOn: $sfxEnabled
                        )

                        // === Прогресс ===
                        sectionTitle("Прогресс", icon: "shield.lefthalf.filled")

                        menuRow(
                            icon: "arrow.counterclockwise",
                            color: "#EF4444",
                            title: "Сбросить предметы",
                            subtitle: "Удалить всю мебель из всех локаций"
                        ) {
                            showResetWorldAlert = true
                        }

                        menuRow(
                            icon: "trash.fill",
                            color: "#DC2626",
                            title: "Сбросить персонажей",
                            subtitle: "Удалить всех, кроме Ани и Демьяна"
                        ) {
                            showResetCharactersAlert = true
                        }

                        // === О приложении ===
                        sectionTitle("О приложении", icon: "info.circle.fill")

                        menuRow(
                            icon: "heart.fill",
                            color: "#EC4899",
                            title: "OurWorld",
                            subtitle: "Дёма & Анютка ❤️ · v1.0"
                        ) {
                            showAbout = true
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                }
            }
            .navigationTitle("Меню")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Закрыть") { dismiss() }
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "#3B82F6"))
                }
            }
        }
        .sheet(isPresented: $showCharactersSheet) {
            CharacterListSheet()
                .environmentObject(characterStore)
                .environmentObject(worldStore)
        }
        .alert("Сбросить предметы?", isPresented: $showResetWorldAlert) {
            Button("Отмена", role: .cancel) { }
            Button("Сбросить", role: .destructive) {
                worldStore.itemsByLocation.removeAll()
                // Сохраняем пустое состояние
                saveEmptyItems()
            }
        } message: {
            Text("Вся мебель из всех локаций будет удалена. Это нельзя отменить.")
        }
        .alert("Сбросить персонажей?", isPresented: $showResetCharactersAlert) {
            Button("Отмена", role: .cancel) { }
            Button("Сбросить", role: .destructive) {
                resetCharacters()
            }
        } message: {
            Text("Все созданные персонажи будут удалены. Аня и Демьян останутся.")
        }
        .sheet(isPresented: $showAbout) {
            aboutSheet
        }
    }

    // MARK: - Заголовок раздела

    @ViewBuilder
    private func sectionTitle(_ text: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Color(hex: "#6B7280"))
            Text(text.uppercased())
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#6B7280"))
            Spacer()
        }
        .padding(.horizontal, 4)
        .padding(.top, 12)
    }

    // MARK: - Строка меню

    @ViewBuilder
    private func menuRow(
        icon: String,
        color: String,
        title: String,
        subtitle: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color(hex: color).opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: color))
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(Color(hex: "#6B7280"))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(hex: "#D1D5DB"))
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white)
            )
            .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
        }
        .buttonStyle(BounceButtonStyle())
    }

    // MARK: - Строка с Toggle

    @ViewBuilder
    private func toggleRow(
        icon: String,
        color: String,
        title: String,
        isOn: Binding<Bool>
    ) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color(hex: color).opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(hex: color))
            }

            Text(title)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))

            Spacer()

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(Color(hex: "#22C55E"))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white)
        )
        .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
    }

    // MARK: - О приложении

    private var aboutSheet: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "#FDF6EC"), Color(hex: "#FCE7F3")],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    Spacer()

                    Image(systemName: "heart.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color(hex: "#EC4899"))
                        .shadow(color: Color(hex: "#EC4899").opacity(0.4), radius: 20)

                    Text("OurWorld")
                        .font(.system(size: 42, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))

                    Text("Дёма & Анютка ❤️")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "#6B7280"))

                    Text("Версия 1.0")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                        .padding(.top, 8)

                    Spacer()

                    Text("Сделано с любовью для самой лучшей девочки")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 30)
                }
            }
            .navigationTitle("О приложении")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Закрыть") { showAbout = false }
                        .foregroundColor(Color(hex: "#3B82F6"))
                }
            }
        }
    }

    // MARK: - Сброс предметов

    private func saveEmptyItems() {
        // Просто перезаписываем UserDefaults пустым словарём
        if let data = try? JSONEncoder().encode([String: [PlacedItem]]()) {
            UserDefaults.standard.set(data, forKey: "ourworld.items.v4")
        }
    }

    // MARK: - Сброс персонажей

    private func resetCharacters() {
        // Удаляем всех, кроме Ани и Демьяна (по imageName)
        let keep = characterStore.players.filter {
            $0.imageName == "anya" || $0.imageName == "demian"
        }
        characterStore.players = keep
        characterStore.save()

        // Убираем позиции удалённых персонажей
        for player in characterStore.players {
            // ничего не делаем, оставляем
        }
        // Проще: очистить все позиции и дать seed заново расставить
        worldStore.playersByLocation.removeAll()
    }
}
