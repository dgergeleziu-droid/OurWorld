import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3:
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: 1)
    }
}

struct Player: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var skinColorIndex: Int
    var hairColorIndex: Int
    var hairStyleIndex: Int
    var clothesColorIndex: Int
    var clothesStyleIndex: Int
    var eyeColorIndex: Int
    var voiceFileName: String?

    init(id: UUID = UUID(),
         name: String = "Персонаж",
         skinColorIndex: Int = 1,
         hairColorIndex: Int = 1,
         hairStyleIndex: Int = 0,
         clothesColorIndex: Int = 1,
         clothesStyleIndex: Int = 0,
         eyeColorIndex: Int = 0,
         voiceFileName: String? = nil) {
        self.id = id
        self.name = name
        self.skinColorIndex = skinColorIndex
        self.hairColorIndex = hairColorIndex
        self.hairStyleIndex = hairStyleIndex
        self.clothesColorIndex = clothesColorIndex
        self.clothesStyleIndex = clothesStyleIndex
        self.eyeColorIndex = eyeColorIndex
        self.voiceFileName = voiceFileName
    }
}

enum Palette {
    static let skinColors = ["#FFE8D6", "#FFD5B5", "#F1C27D", "#E0AC69", "#C68642", "#8D5524", "#6B4226"]
    static let hairColors = ["#2C1810", "#4A3124", "#8B4513", "#D2A679", "#FFD700", "#E91E63", "#9C27B0", "#00BCD4", "#4CAF50", "#F44336"]
    static let clothesColors = ["#EF4444", "#F97316", "#FBBF24", "#22C55E", "#14B8A6", "#3B82F6", "#8B5CF6", "#EC4899", "#0F172A", "#FFFFFF"]
    static let eyeColors = ["#2C1810", "#3B82F6", "#22C55E", "#8B4513", "#7C3AED", "#EC4899"]
}

enum LocationID: String, CaseIterable, Identifiable, Codable {
    case home = "Дом"
    case cafe = "Кафе"
    case park = "Парк"
    case beach = "Пляж"
    case space = "Космос"
    case hospital = "Больница"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .cafe: return "cup.and.saucer.fill"
        case .park: return "tree.fill"
        case .beach: return "beach.umbrella.fill"
        case .space: return "moon.stars.fill"
        case .hospital: return "cross.case.fill"
        }
    }

    var color: String {
        switch self {
        case .home: return "#F59E0B"
        case .cafe: return "#92400E"
        case .park: return "#22C55E"
        case .beach: return "#0EA5E9"
        case .space: return "#6366F1"
        case .hospital: return "#EF4444"
        }
    }
}

// Предмет, который можно положить на сцену
struct PlacedItem: Identifiable, Codable, Equatable {
    let id: UUID
    var catalogID: String
    var x: Double
    var y: Double
    var scale: Double

    init(id: UUID = UUID(), catalogID: String, x: Double, y: Double, scale: Double = 1.0) {
        self.id = id
        self.catalogID = catalogID
        self.x = x
        self.y = y
        self.scale = scale
    }
}

// Позиция персонажа на сцене
struct PlacedPlayer: Codable, Equatable {
    var playerID: UUID
    var x: Double
    var y: Double
}
