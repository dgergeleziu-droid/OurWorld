import SwiftUI

// MARK: - HEX → Color
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

// MARK: - Локации
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
        case .space: return "sparkles"
        case .hospital: return "cross.case.fill"
        }
    }

    var color: String {
        switch self {
        case .home: return "#F59E0B"
        case .cafe: return "#B45309"
        case .park: return "#22C55E"
        case .beach: return "#38BDF8"
        case .space: return "#6366F1"
        case .hospital: return "#EF4444"
        }
    }
}

// MARK: - Персонаж
struct Player: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var voiceFileName: String?

    // Если задано — показываем эту картинку вместо нарисованного персонажа
    var imageName: String?

    // Внешность (для нарисованных персонажей)
    var skinTone: Int
    var hairStyle: Int
    var hairColor: Int
    var eyeStyle: Int
    var eyeColor: Int
    var mouthStyle: Int
    var outfitStyle: Int
    var outfitColor: Int
    var accessory: Int

    init(
        id: UUID = UUID(),
        name: String = "",
        voiceFileName: String? = nil,
        imageName: String? = nil,
        skinTone: Int = 1,
        hairStyle: Int = 0,
        hairColor: Int = 1,
        eyeStyle: Int = 0,
        eyeColor: Int = 0,
        mouthStyle: Int = 0,
        outfitStyle: Int = 0,
        outfitColor: Int = 0,
        accessory: Int = 0
    ) {
        self.id = id
        self.name = name
        self.voiceFileName = voiceFileName
        self.imageName = imageName
        self.skinTone = skinTone
        self.hairStyle = hairStyle
        self.hairColor = hairColor
        self.eyeStyle = eyeStyle
        self.eyeColor = eyeColor
        self.mouthStyle = mouthStyle
        self.outfitStyle = outfitStyle
        self.outfitColor = outfitColor
        self.accessory = accessory
    }

    enum CodingKeys: String, CodingKey {
        case id, name, voiceFileName, imageName
        case skinTone, hairStyle, hairColor
        case eyeStyle, eyeColor, mouthStyle
        case outfitStyle, outfitColor, accessory
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try c.decodeIfPresent(String.self, forKey: .name) ?? "Друг"
        voiceFileName = try c.decodeIfPresent(String.self, forKey: .voiceFileName)
        imageName = try c.decodeIfPresent(String.self, forKey: .imageName)
        skinTone = try c.decodeIfPresent(Int.self, forKey: .skinTone) ?? 1
        hairStyle = try c.decodeIfPresent(Int.self, forKey: .hairStyle) ?? 0
        hairColor = try c.decodeIfPresent(Int.self, forKey: .hairColor) ?? 1
        eyeStyle = try c.decodeIfPresent(Int.self, forKey: .eyeStyle) ?? 0
        eyeColor = try c.decodeIfPresent(Int.self, forKey: .eyeColor) ?? 0
        mouthStyle = try c.decodeIfPresent(Int.self, forKey: .mouthStyle) ?? 0
        outfitStyle = try c.decodeIfPresent(Int.self, forKey: .outfitStyle) ?? 0
        outfitColor = try c.decodeIfPresent(Int.self, forKey: .outfitColor) ?? 0
        accessory = try c.decodeIfPresent(Int.self, forKey: .accessory) ?? 0
    }
}

// MARK: - Предмет на сцене
struct PlacedItem: Identifiable, Codable, Hashable {
    var id: UUID
    var catalogID: String
    var x: Double
    var y: Double

    init(id: UUID = UUID(), catalogID: String, x: Double, y: Double) {
        self.id = id
        self.catalogID = catalogID
        self.x = x
        self.y = y
    }
}

// MARK: - Позиция персонажа на сцене
struct PlacedPlayer: Identifiable, Codable, Hashable {
    var id: UUID
    var playerID: UUID
    var x: Double
    var y: Double

    init(id: UUID = UUID(), playerID: UUID, x: Double, y: Double) {
        self.id = id
        self.playerID = playerID
        self.x = x
        self.y = y
    }
}

// MARK: - Базовая палитра (расширяется в Appearance.swift)
enum Palette { }
