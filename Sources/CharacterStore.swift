import Foundation
import SwiftUI

final class CharacterStore: ObservableObject {

    @Published var players: [Player] = []

    private let storageKey = "ourworld.players.v1"

    // Стабильные UUID, чтобы у Ани и Демьяна были одинаковые id при каждом запуске
    static let anyaID   = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
    static let demianID = UUID(uuidString: "22222222-2222-2222-2222-222222222222")!

    init() {
        load()
        seedDefaultCharactersIfNeeded()
    }

    // MARK: - Persistence

    func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        if let decoded = try? JSONDecoder().decode([Player].self, from: data) {
            players = decoded
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(players) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    // MARK: - CRUD

    func add(_ player: Player) {
        players.append(player)
        save()
    }

    func update(_ player: Player) {
        guard let idx = players.firstIndex(where: { $0.id == player.id }) else { return }
        players[idx] = player
        save()
    }

    func delete(_ player: Player) {
        players.removeAll { $0.id == player.id }
        save()
    }

    func player(by id: UUID) -> Player? {
        players.first { $0.id == id }
    }

    // MARK: - Seed

    /// Идемпотентно: добавляет Аню и Демьяна один раз.
    /// Если у пользователя уже есть Аня — она не дублируется, добавится только Демьян.
    func seedDefaultCharactersIfNeeded() {
        var changed = false

        if !players.contains(where: { $0.imageName == "anya" }) {
            players.append(Self.makeAnya())
            changed = true
        }
        if !players.contains(where: { $0.imageName == "demian" }) {
            players.append(Self.makeDemian())
            changed = true
        }

        if changed { save() }
    }

    // MARK: - Defaults

    static func makeAnya() -> Player {
        Player(
            id: anyaID,
            name: "Аня",
            voiceFileName: nil,
            imageName: "anya",
            skinTone: 2,
            hairStyle: 3,
            hairColor: 5,
            eyeStyle: 0,
            eyeColor: 1,
            mouthStyle: 0,
            outfitStyle: 0,
            outfitColor: 3,
            accessory: 0
        )
    }

    static func makeDemian() -> Player {
        Player(
            id: demianID,
            name: "Демьян",
            voiceFileName: nil,
            imageName: "demian",
            skinTone: 2,
            hairStyle: 0,
            hairColor: 4,
            eyeStyle: 0,
            eyeColor: 0,
            mouthStyle: 1,
            outfitStyle: 1,
            outfitColor: 1,
            accessory: 0
        )
    }
}
