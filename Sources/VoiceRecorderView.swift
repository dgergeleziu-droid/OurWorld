import SwiftUI
import AVFoundation

struct VoiceRecorderView: View {
    @Environment(\.dismiss) var dismiss
    let player: Player
    let onSave: (String?) -> Void

    @State private var recorder: AVAudioRecorder?
    @State private var isRecording = false
    @State private var secondsElapsed: Double = 0
    @State private var timer: Timer?
    @State private var recordedFileName: String?
    @State private var hasPermission = false
    @State private var isSaved = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "#FDF6EC"), Color(hex: "#FCE7F3")],
                    startPoint: .top, endPoint: .bottom
                ).ignoresSafeArea()

                VStack(spacing: 26) {
                    Spacer()

                    Text(player.name)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))

                    Text("Голос персонажа")
                        .font(.system(size: 15, design: .rounded))
                        .foregroundColor(Color(hex: "#6B7280"))

                    Text(formattedTime)
                        .font(.system(size: 56, weight: .heavy, design: .monospaced))
                        .foregroundColor(isRecording ? Color(hex: "#EF4444") : Color(hex: "#111827"))
                        .padding(.vertical, 10)

                    Button {
                        if isRecording { stopRecording() } else { startRecording() }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(isRecording ? Color(hex: "#EF4444") : Color(hex: "#3B82F6"))
                                .frame(width: 120, height: 120)
                                .shadow(color: .black.opacity(0.2), radius: 12, y: 6)

                            if isRecording {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.white)
                                    .frame(width: 40, height: 40)
                            } else {
                                Image(systemName: "mic.fill")
                                    .font(.system(size: 44, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }

                    if isRecording {
                        Text("Идёт запись... Нажми квадрат, чтобы остановить")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#6B7280"))
                            .multilineTextAlignment(.center)
                    } else if recordedFileName != nil {
                        HStack(spacing: 20) {
                            Button {
                                if let name = recordedFileName {
                                    AudioManager.shared.playVoice(fileName: name)
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "play.circle.fill")
                                    Text("Прослушать")
                                }
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20).padding(.vertical, 12)
                                .background(Color(hex: "#22C55E"))
                                .cornerRadius(14)
                            }

                            Button {
                                if let name = recordedFileName {
                                    AudioManager.shared.deleteVoice(fileName: name)
                                }
                                recordedFileName = nil
                                secondsElapsed = 0
                                startRecording()
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "arrow.counterclockwise")
                                    Text("Заново")
                                }
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20).padding(.vertical, 12)
                                .background(Color(hex: "#F59E0B"))
                                .cornerRadius(14)
                            }
                        }
                    } else {
                        Text("Нажми микрофон и скажи что-нибудь")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#6B7280"))
                    }

                    Spacer()

                    HStack(spacing: 12) {
                        Button {
                            if !isSaved, let name = recordedFileName {
                                AudioManager.shared.deleteVoice(fileName: name)
                            }
                            if isRecording { stopRecording() }
                            dismiss()
                        } label: {
                            Text("Отмена")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(hex: "#6B7280"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(Color.white)
                                .cornerRadius(14)
                                .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
                        }

                        Button {
                            stopRecording()
                            isSaved = true
                            onSave(recordedFileName)
                            dismiss()
                        } label: {
                            Text("Сохранить")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(recordedFileName == nil ? Color.gray : Color(hex: "#3B82F6"))
                                .cornerRadius(14)
                                .shadow(color: .black.opacity(0.1), radius: 6, y: 2)
                        }
                        .disabled(recordedFileName == nil)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Запись голоса")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            requestMicrophonePermission()
        }
    }

    private var formattedTime: String {
        let m = Int(secondsElapsed) / 60
        let s = Int(secondsElapsed) % 60
        return String(format: "%02d:%02d", m, s)
    }

    private func requestMicrophonePermission() {
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission { granted in
                DispatchQueue.main.async { hasPermission = granted }
            }
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async { hasPermission = granted }
            }
        }
    }

    private func startRecording() {
        guard hasPermission else { return }

        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)

            let name = "voice_\(UUID().uuidString).m4a"
            let url = AudioManager.shared.voiceURL(fileName: name)

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            let rec = try AVAudioRecorder(url: url, settings: settings)
            rec.record()

            recorder = rec
            recordedFileName = name
            isRecording = true
            secondsElapsed = 0

            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                secondsElapsed += 0.1
                if secondsElapsed >= 30 {
                    stopRecording()
                }
            }
        } catch {
            print("Ошибка записи: \(error)")
        }
    }

    private func stopRecording() {
        recorder?.stop()
        recorder = nil
        isRecording = false
        timer?.invalidate()
        timer = nil
    }
}
