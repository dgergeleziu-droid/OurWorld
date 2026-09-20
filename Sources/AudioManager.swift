import Foundation
import AVFoundation
import Combine

@MainActor
class AudioManager: NSObject, ObservableObject {

    static let shared = AudioManager()

    // MARK: - Состояние записи (используется в VoiceRecorderView)
    @Published var isRecording: Bool = false
    @Published var recordingDuration: Double = 0

    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    private var timer: Timer?
    private var currentFileName: String?

    private override init() {
        super.init()
    }

    // MARK: - Пути
    private var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func voiceURL(fileName: String) -> URL {
        documentsURL.appendingPathComponent(fileName)
    }

    // MARK: - Разрешение на микрофон
    func requestPermission(completion: @escaping (Bool) -> Void) {
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission { granted in
                DispatchQueue.main.async { completion(granted) }
            }
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async { completion(granted) }
            }
        }
    }

    // MARK: - Начало записи. Возвращает true, если запись началась
    @discardableResult
    func startRecording(fileName: String) -> Bool {
        // Остановим плеер, чтобы не мешал
        player?.stop()

        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)

            let url = voiceURL(fileName: fileName)

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            let rec = try AVAudioRecorder(url: url, settings: settings)
            rec.record()

            recorder = rec
            currentFileName = fileName
            isRecording = true
            recordingDuration = 0

            // Таймер длительности
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                Task { @MainActor in
                    self.recordingDuration += 0.1
                    // Автостоп через 30 секунд
                    if self.recordingDuration >= 30 {
                        self.stopRecording()
                    }
                }
            }

            return true
        } catch {
            print("❌ Ошибка старта записи: \(error)")
            isRecording = false
            return false
        }
    }

    // MARK: - Стоп записи
    func stopRecording() {
        recorder?.stop()
        recorder = nil
        isRecording = false
        timer?.invalidate()
        timer = nil

        // Отключаем сессию, чтобы вернуть звук в нормальный режим
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    // MARK: - Проигрывание
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
            print("❌ Ошибка воспроизведения: \(error)")
        }
    }

    // MARK: - Удаление
    func deleteVoice(fileName: String) {
        let url = voiceURL(fileName: fileName)
        try? FileManager.default.removeItem(at: url)
    }
}
