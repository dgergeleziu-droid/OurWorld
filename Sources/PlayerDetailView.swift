import SwiftUI

struct PlayerDetailView: View {
    @EnvironmentObject var characterStore: CharacterStore
    @Environment(\.dismiss) var dismiss
    let player: Player
    @State private var showEditor = false
    @State private var showVoiceRecorder = false
    @State private var confirmDelete = false
    @State private var currentPlayer: Player

    init(player: Player) {
        self.player = player
        _currentPlayer = State(initialValue: player)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#FDF6EC").ignoresSafeArea()

                VStack(spacing: 20) {
                    AvatarView(player: currentPlayer, size: 220)
                        .padding(.top, 20)

                    Text(currentPlayer.name)
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))

                    VStack(spacing: 10) {
                        Button {
                            showVoiceRecorder = true
                        } label: {
                            HStack {
                                Image(systemName: currentPlayer.voiceFileName == nil ? "mic.fill" : "mic.circle.fill")
                                Text(currentPlayer.voiceFileName == nil ? "Записать голос" : "Изменить голос")
                                Spacer()
                                if currentPlayer.voiceFileName != nil {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(hex: "#22C55E"))
                                }
                            }
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                            .padding(16)
                            .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
                            .shadow(color: .black.opacity(0.05), radius: 6)
                        }

                        if currentPlayer.voiceFileName != nil {
                            Button {
                                if let f = currentPlayer.voiceFileName {
                                    AudioManager.shared.playVoice(fileName: f)
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "play.circle.fill")
                                    Text("Прослушать голос")
                                    Spacer()
                                }
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(hex: "#111827"))
                                .padding(16)
                                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
                                .shadow(color: .black.opacity(0.05), radius: 6)
                            }
                        }

                        Button {
                            showEditor = true
                        } label: {
                            HStack {
                                Image(systemName: "pencil.circle.fill")
                                Text("Изменить внешность")
                                Spacer()
                            }
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                            .padding(16)
                            .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
                            .shadow(color: .black.opacity(0.05), radius: 6)
                        }

                        Button {
                            confirmDelete = true
                        } label: {
                            HStack {
                                Image(systemName: "trash.fill")
                                Text("Удалить персонажа")
                                Spacer()
                            }
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(hex: "#EF4444"))
                            .padding(16)
                            .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
                            .shadow(color: .black.opacity(0.05), radius: 6)
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer()
                }
            }
            .navigationTitle(currentPlayer.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Готово") { dismiss() }
                        .foregroundColor(Color(hex: "#3B82F6"))
                }
            }
            .sheet(isPresented: $showEditor) {
                CharacterCreatorView(existing: currentPlayer) { updated in
                    currentPlayer = updated
                    characterStore.update(updated)
                }
                .environmentObject(characterStore)
            }
            .sheet(isPresented: $showVoiceRecorder) {
                VoiceRecorderView(player: currentPlayer) { fileName in
                    currentPlayer.voiceFileName = fileName
                    characterStore.update(currentPlayer)
                }
            }
            .alert("Удалить персонажа?", isPresented: $confirmDelete) {
                Button("Удалить", role: .destructive) {
                    characterStore.delete(currentPlayer)
                    dismiss()
                }
                Button("Отмена", role: .cancel) { }
            }
        }
    }
}
