import Foundation

@MainActor
class CharacterStore: ObservableObject {
    @Published var players: [Player] = []

    private let playersKey = "ourworld.players.v3"

    init() { load() }

    func add(_ player: Player) {
        players.append(player)
        save()
    }

    func update(_ player: Player) {
        if let idx = players.firstIndex(where: { $0.id == player.id }) {
            players[idx] = player
            save()
        }
    }

    func delete(_ player: Player) {
        if let voice = player.voiceFileName {
            AudioManager.shared.deleteVoice(fileName: voice)
        }
        players.removeAll { $0.id == player.id }
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(players) {
            UserDefaults.standard.set(data, forKey: playersKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: playersKey),
           let decoded = try? JSONDecoder().decode([Player].self, from: data) {
            players = decoded
        }
    }
}
