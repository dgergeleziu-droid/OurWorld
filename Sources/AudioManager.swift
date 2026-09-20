import Foundation
import AVFoundation

@MainActor
class AudioManager: ObservableObject {
    static let shared = AudioManager()

    private var player: AVAudioPlayer?

    private init() { }

    // Папка для аудиофайлов — Documents
    private var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func voiceURL(fileName: String) -> URL {
        documentsURL.appendingPathComponent(fileName)
    }

    func playVoice(fileName: String) {
        let url = voiceURL(fileName: fileName)
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("⚠️ Файл не найден: \(url.path)")
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player?.stop()
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Ошибка воспроизведения: \(error)")
        }
    }

    func deleteVoice(fileName: String) {
        let url = voiceURL(fileName: fileName)
        try? FileManager.default.removeItem(at: url)
    }
}
