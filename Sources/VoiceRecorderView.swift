import SwiftUI

struct VoiceRecorderView: View {
    let player: Player
    let onSave: (String?) -> Void

    @Environment(\.dismiss) var dismiss
    @StateObject private var audio = AudioManager.shared
    @State private var tempFileName: String
    @State private var savedFileName: String?
    @State private var errorText: String?

    init(player: Player, onSave: @escaping (String?) -> Void) {
        self.player = player
        self.onSave = onSave
        let name = "voice_\(player.id.uuidString).m4a"
        _tempFileName = State(initialValue: name)
        _savedFileName = State(initialValue: player.voiceFileName)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#F9FAFB").ignoresSafeArea()

                VStack(spacing: 30) {
                    AvatarView(player: player, size: 140)
                        .padding(.top, 20)

                    Text(player.name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(hex: "#111827"))

                    Text("Запиши голос — персонаж будет «говорить» твоим голосом")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "#6B7280"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)

                    // Кнопка записи
                    Button {
                        toggleRecording()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(audio.isRecording ? Color(hex: "#EF4444") : Color(hex: "#3B82F6"))
                                .frame(width: 110, height: 110)
                                .shadow(color: (audio.isRecording ? Color(hex: "#EF4444") : Color(hex: "#3B82F6")).opacity(0.4), radius: 20)

                            if audio.isRecording {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white)
                                    .frame(width: 34, height: 34)
                            } else {
                                Image(systemName: "mic.fill")
                                    .font(.system(size: 44))
                                    .foregroundColor(.white)
                            }
                        }
                    }

                    Text(audio.isRecording ? String(format: "%.1f сек", audio.recordingTime) : "Нажми, чтобы записать")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(hex: "#6B7280"))

                    // Воспроизведение
                    if savedFileName != nil && !audio.isRecording {
                        Button {
                            if let name = savedFileName {
                                audio.playVoice(fileName: name)
                            }
                        } label: {
                            Label("Прослушать", systemImage: "play.circle.fill")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20).padding(.vertical, 12)
                                .background(Color(hex: "#22C55E"))
                                .cornerRadius(14)
                        }
                    }

                    if let err = errorText {
                        Text("⚠️ \(err)")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#EF4444"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }

                    Spacer()

                    // Кнопки внизу
                    HStack(spacing: 12) {
                        Button("Отмена") { dismiss() }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#6B7280"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(hex: "#E5E7EB"))
                            .cornerRadius(14)

                        Button("Сохранить") {
                            onSave(savedFileName)
                            dismiss()
                        }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(savedFileName == nil ? Color(hex: "#9CA3AF") : Color(hex: "#3B82F6"))
                        .cornerRadius(14)
                        .disabled(savedFileName == nil)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Голос персонажа")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func toggleRecording() {
        if audio.isRecording {
            // Стоп
            audio.stopRecording()
            // Проверяем, что файл создан
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(tempFileName)
            if FileManager.default.fileExists(atPath: path.path) {
                // Удаляем старый файл если был
                if let old = savedFileName, old != tempFileName {
                    audio.deleteVoice(fileName: old)
                }
                savedFileName = tempFileName
            } else {
                errorText = "Запись не удалась, попробуй ещё раз"
            }
        } else {
            // Запрос разрешения и старт
            audio.requestPermission { granted in
                if granted {
                    let ok = audio.startRecording(fileName: tempFileName)
                    if !ok { errorText = "Не удалось начать запись" }
                } else {
                    errorText = "Разреши доступ к микрофону в Настройках"
                }
            }
        }
    }
}
