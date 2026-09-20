import SwiftUI

struct CharacterListSheet: View {
    @EnvironmentObject var characterStore: CharacterStore
    @Environment(\.dismiss) var dismiss
    @State private var showCreator = false
    @State private var editingPlayer: Player? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#FDF6EC").ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        if characterStore.players.isEmpty {
                            emptyState
                        } else {
                            ForEach(characterStore.players) { player in
                                characterRow(player)
                            }
                        }

                        if !hasAnya || !hasDemian {
                            restoreButton
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Персонажи")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Закрыть") { dismiss() }
                        .foregroundColor(Color(hex: "#3B82F6"))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCreator = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "plus.circle.fill")
                            Text("Создать")
                        }
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#3B82F6"))
                    }
                }
            }
        }
        .sheet(isPresented: $showCreator) {
            CharacterCreatorView()
                .environmentObject(characterStore)
        }
        .sheet(item: $editingPlayer) { p in
            PlayerDetailView(player: p)
                .environmentObject(characterStore)
        }
    }

    // MARK: - Проверки наличия

    private var hasAnya: Bool {
        characterStore.players.contains { $0.imageName == "anya" }
    }

    private var hasDemian: Bool {
        characterStore.players.contains { $0.imageName == "demian" }
    }

    // MARK: - Кнопка восстановления

    private var restoreButton: some View {
        Button {
            characterStore.seedDefaultCharactersIfNeeded()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .font(.system(size: 26))
                    .foregroundColor(Color(hex: "#EC4899"))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Вернуть Аню и Демьяна")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                    Text("Базовые персонажи игры")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(Color(hex: "#6B7280"))
                }

                Spacer()

                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#EC4899"))
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color(hex: "#EC4899").opacity(0.35), lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
    }

    // MARK: - Строка персонажа

    private func characterRow(_ player: Player) -> some View {
        Button {
            editingPlayer = player
        } label: {
            HStack(spacing: 14) {
                AvatarView(player: player, size: 70)
                VStack(alignment: .leading, spacing: 4) {
                    Text(player.name)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                    if player.voiceFileName != nil {
                        HStack(spacing: 4) {
                            Image(systemName: "mic.fill")
                                .font(.system(size: 10))
                            Text("голос записан")
                                .font(.system(size: 11, design: .rounded))
                        }
                        .foregroundColor(Color(hex: "#22C55E"))
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(hex: "#9CA3AF"))
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 18).fill(Color.white))
            .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
    }

    // MARK: - Пустое состояние

    var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "person.crop.circle.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(Color(hex: "#D1D5DB"))
            Text("Пока никого нет")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
            Text("Нажми «Создать» вверху справа")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(Color(hex: "#6B7280"))
        }
        .padding(40)
    }
}
