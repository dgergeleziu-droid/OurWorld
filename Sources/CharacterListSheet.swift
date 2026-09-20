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
                                HStack(spacing: 14) {
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
                                }
                                .padding(.horizontal, 20)
                            }
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
