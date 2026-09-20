import Foundation
import CoreGraphics

@MainActor
class WorldStore: ObservableObject {
    @Published var itemsByLocation: [String: [PlacedItem]] = [:]
    @Published var playersByLocation: [String: [PlacedPlayer]] = [:]

    private let itemsKey = "ourworld.items.v3"
    private let playersKey = "ourworld.positions.v3"

    init() {
        load()
    }

    func items(for location: LocationID) -> [PlacedItem] {
        itemsByLocation[location.rawValue] ?? []
    }

    func positions(for location: LocationID) -> [PlacedPlayer] {
        playersByLocation[location.rawValue] ?? []
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

    private func save() {
        if let data = try? JSONEncoder().encode(itemsByLocation) {
            UserDefaults.standard.set(data, forKey: itemsKey)
        }
        if let data = try? JSONEncoder().encode(playersByLocation) {
            UserDefaults.standard.set(data, forKey: playersKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: itemsKey),
           let decoded = try? JSONDecoder().decode([String: [PlacedItem]].self, from: data) {
            itemsByLocation = decoded
        }
        if let data = UserDefaults.standard.data(forKey: playersKey),
           let decoded = try? JSONDecoder().decode([String: [PlacedPlayer]].self, from: data) {
            playersByLocation = decoded
        }
    }
}
