import Foundation
import CoreGraphics

@MainActor
class WorldStore: ObservableObject {
    @Published var itemsByLocation: [String: [PlacedItem]] = [:]
    @Published var playersByLocation: [String: [PlacedPlayer]] = [:]

    private let itemsKey = "ourworld.items.v4"
    private let playersKey = "ourworld.positions.v4"

    init() { load() }

    // MARK: - Предметы
    func items(for location: LocationID) -> [PlacedItem] {
        itemsByLocation[location.rawValue] ?? []
    }
    func addItem(_ item: PlacedItem, to location: LocationID) {
        var arr = itemsByLocation[location.rawValue] ?? []
        arr.append(item)
        itemsByLocation[location.rawValue] = arr
        save()
    }
    func updateItem(_ item: PlacedItem, in location: LocationID) {
        guard var arr = itemsByLocation[location.rawValue],
              let idx = arr.firstIndex(where: { $0.id == item.id }) else { return }
        arr[idx] = item
        itemsByLocation[location.rawValue] = arr
        save()
    }
    func removeItem(_ item: PlacedItem, in location: LocationID) {
        guard var arr = itemsByLocation[location.rawValue] else { return }
        arr.removeAll { $0.id == item.id }
        itemsByLocation[location.rawValue] = arr
        save()
    }

    // MARK: - Персонажи
    func positions(for location: LocationID) -> [PlacedPlayer] {
        playersByLocation[location.rawValue] ?? []
    }
    func setPosition(_ pos: PlacedPlayer, in location: LocationID) {
        var arr = playersByLocation[location.rawValue] ?? []
        if let idx = arr.firstIndex(where: { $0.playerID == pos.playerID }) {
            arr[idx] = pos
        } else {
            arr.append(pos)
        }
        playersByLocation[location.rawValue] = arr
        save()
    }

    // Очистить все позиции персонажа (при удалении)
    func removePositions(forPlayer playerID: UUID) {
        for (key, arr) in playersByLocation {
            playersByLocation[key] = arr.filter { $0.playerID != playerID }
        }
        save()
    }

    // MARK: - Save / Load
    private func save() {
        if let d = try? JSONEncoder().encode(itemsByLocation) {
            UserDefaults.standard.set(d, forKey: itemsKey)
        }
        if let d = try? JSONEncoder().encode(playersByLocation) {
            UserDefaults.standard.set(d, forKey: playersKey)
        }
    }
    private func load() {
        if let d = UserDefaults.standard.data(forKey: itemsKey),
           let dec = try? JSONDecoder().decode([String: [PlacedItem]].self, from: d) {
            itemsByLocation = dec
        }
        if let d = UserDefaults.standard.data(forKey: playersKey),
           let dec = try? JSONDecoder().decode([String: [PlacedPlayer]].self, from: d) {
            playersByLocation = dec
        }
    }
}
