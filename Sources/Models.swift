import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (r, g, b) = (0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: 1)
    }
}

// MARK: - Возраст

enum AgeGroup: String, Codable, CaseIterable, Identifiable {
    case baby   = "Малыш"
    case child  = "Ребёнок"
    case teen   = "Подросток"
    case adult  = "Взрослый"
    case elder  = "Пожилой"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .baby:  return "figure.child"
        case .child: return "figure.child.circle"
        case .teen:  return "figure.walk"
        case .adult: return "figure.stand"
        case .elder: return "figure.walk.motion"
        }
    }

    var bodyScale: CGFloat {
        switch self {
        case .baby:  return 0.62
        case .child: return 0.78
        case .teen:  return 0.90
        case .adult: return 1.00
        case .elder: return 1.00
        }
    }

    var headMultiplier: CGFloat {
        switch self {
        case .baby:  return 1.42
        case .child: return 1.22
        case .teen:  return 1.08
        case .adult: return 1.00
        case .elder: return 1.00
        }
    }

    var legRatio: CGFloat {
        switch self {
        case .baby:  return 0.32
        case .child: return 0.38
        case .teen:  return 0.44
        case .adult: return 0.48
        case .elder: return 0.46
        }
    }
}

// MARK: - Слой

enum LayerSlot: String, Codable, CaseIterable, Identifiable {
    case hair       = "Волосы"
    case outfit     = "Одежда"
    case accessory  = "Аксессуар"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .hair:      return "comb.fill"
        case .outfit:    return "tshirt.fill"
        case .accessory: return "eyeglasses"
        }
    }
}

// MARK: - Локации

enum LocationID: String, CaseIterable, Identifiable, Codable {
    case home = "Дом"
    case cafe = "Кафе"
    case park = "Парк"
    case beach = "Пляж"
    case shop = "Магазин"
    case hospital = "Больница"
    case school = "Школа"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .cafe: return "cup.and.saucer.fill"
        case .park: return "tree.fill"
        case .beach: return "beach.umbrella.fill"
        case .shop: return "cart.fill"
        case .hospital: return "cross.case.fill"
        case .school: return "book.fill"
        }
    }

    var roofColor: String {
        switch self {
        case .home: return "#D2683C"
        case .cafe: return "#A0522D"
        case .park: return "#5BAF50"
        case .beach: return "#E8A030"
        case .shop: return "#8B5CF6"
        case .hospital: return "#EF4444"
        case .school: return "#3B82F6"
        }
    }

    var wallColor: String {
        switch self {
        case .home: return "#FCD9A8"
        case .cafe: return "#D4A57A"
        case .park: return "#8ED17D"
        case .beach: return "#FFE0A3"
        case .shop: return "#C4B5FD"
        case .hospital: return "#F5F5F5"
        case .school: return "#BFDBFE"
        }
    }

    var color: String { roofColor }

    var mapPosition: CGPoint {
        switch self {
        case .home:     return CGPoint(x: 0.20, y: 0.64)
        case .cafe:     return CGPoint(x: 0.66, y: 0.62)
        case .park:     return CGPoint(x: 0.42, y: 0.72)
        case .beach:    return CGPoint(x: 0.82, y: 0.68)
        case .shop:     return CGPoint(x: 0.15, y: 0.82)
        case .hospital: return CGPoint(x: 0.50, y: 0.87)
        case .school:   return CGPoint(x: 0.82, y: 0.83)
        }
    }
}

// MARK: - Персонаж

struct Player: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var voiceFileName: String?
    var imageName: String?

    var ageGroup: AgeGroup

    // Внешность
    var skinTone: Int
    var hairStyle: Int
    var hairColor: Int
    var eyeStyle: Int
    var eyeColor: Int
    var eyebrowStyle: Int
    var mouthStyle: Int
    var outfitStyle: Int
    var outfitColor: Int
    var accessory: Int

    // Layering
    var layerOrder: [LayerSlot]

    init(id: UUID = UUID(),
         name: String = "",
         voiceFileName: String? = nil,
         imageName: String? = nil,
         ageGroup: AgeGroup = .adult,
         skinTone: Int = 1,
         hairStyle: Int = 0,
         hairColor: Int = 1,
         eyeStyle: Int = 0,
         eyeColor: Int = 0,
         eyebrowStyle: Int = 0,
         mouthStyle: Int = 0,
         outfitStyle: Int = 0,
         outfitColor: Int = 0,
         accessory: Int = 0,
         layerOrder: [LayerSlot] = [.hair, .outfit, .accessory]) {
        self.id = id
        self.name = name
        self.voiceFileName = voiceFileName
        self.imageName = imageName
        self.ageGroup = ageGroup
        self.skinTone = skinTone
        self.hairStyle = hairStyle
        self.hairColor = hairColor
        self.eyeStyle = eyeStyle
        self.eyeColor = eyeColor
        self.eyebrowStyle = eyebrowStyle
        self.mouthStyle = mouthStyle
        self.outfitStyle = outfitStyle
        self.outfitColor = outfitColor
        self.accessory = accessory
        self.layerOrder = layerOrder
    }

    enum CodingKeys: String, CodingKey {
        case id, name, voiceFileName, imageName
        case ageGroup
        case skinTone, hairStyle, hairColor
        case eyeStyle, eyeColor, eyebrowStyle, mouthStyle
        case outfitStyle, outfitColor, accessory
        case layerOrder
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try c.decodeIfPresent(String.self, forKey: .name) ?? "Друг"
        voiceFileName = try c.decodeIfPresent(String.self, forKey: .voiceFileName)
        imageName = try c.decodeIfPresent(String.self, forKey: .imageName)
        ageGroup = try c.decodeIfPresent(AgeGroup.self, forKey: .ageGroup) ?? .adult
        skinTone = try c.decodeIfPresent(Int.self, forKey: .skinTone) ?? 1
        hairStyle = try c.decodeIfPresent(Int.self, forKey: .hairStyle) ?? 0
        hairColor = try c.decodeIfPresent(Int.self, forKey: .hairColor) ?? 1
        eyeStyle = try c.decodeIfPresent(Int.self, forKey: .eyeStyle) ?? 0
        eyeColor = try c.decodeIfPresent(Int.self, forKey: .eyeColor) ?? 0
        eyebrowStyle = try c.decodeIfPresent(Int.self, forKey: .eyebrowStyle) ?? 0
        mouthStyle = try c.decodeIfPresent(Int.self, forKey: .mouthStyle) ?? 0
        outfitStyle = try c.decodeIfPresent(Int.self, forKey: .outfitStyle) ?? 0
        outfitColor = try c.decodeIfPresent(Int.self, forKey: .outfitColor) ?? 0
        accessory = try c.decodeIfPresent(Int.self, forKey: .accessory) ?? 0
        layerOrder = try c.decodeIfPresent([LayerSlot].self, forKey: .layerOrder)
            ?? [.hair, .outfit, .accessory]
    }
}

// MARK: - Предмет на сцене

struct PlacedItem: Identifiable, Codable, Hashable {
    var id: UUID
    var catalogID: String
    var x: Double
    var y: Double
    init(id: UUID = UUID(), catalogID: String, x: Double, y: Double) {
        self.id = id; self.catalogID = catalogID; self.x = x; self.y = y
    }
}

// MARK: - Персонаж на сцене

struct PlacedPlayer: Identifiable, Codable, Hashable {
    var id: UUID
    var playerID: UUID
    var locationRaw: String
    var x: Double
    var y: Double

    init(id: UUID = UUID(), playerID: UUID, locationRaw: String, x: Double, y: Double) {
        self.id = id; self.playerID = playerID
        self.locationRaw = locationRaw; self.x = x; self.y = y
    }
}

enum Palette { }
