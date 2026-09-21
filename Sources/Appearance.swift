import SwiftUI

extension Palette {

    // MARK: - Кожа (10 оттенков)

    static let skinTones: [Color] = [
        Color(hex: "#FDE7D6"),
        Color(hex: "#F9D6B5"),
        Color(hex: "#EFC09A"),
        Color(hex: "#DEA47C"),
        Color(hex: "#C88A66"),
        Color(hex: "#A16B47"),
        Color(hex: "#7A4A32"),
        Color(hex: "#5A3520"),
        Color(hex: "#3F2416"),
        Color(hex: "#2A1810")
    ]

    static let skinNames: [String] = [
        "Очень светлая", "Светлая", "Тёплая", "Загорелая",
        "Средняя", "Карамель", "Шоколад", "Тёмная",
        "Очень тёмная", "Глубокая"
    ]

    // MARK: - Волосы (16 цветов)

    static let hairColors: [Color] = [
        Color(hex: "#1F1B16"),   // чёрный
        Color(hex: "#3B2A1A"),   // тёмно-каштановый
        Color(hex: "#5B3A1E"),   // каштан
        Color(hex: "#7A5230"),   // коричневый
        Color(hex: "#A06A3B"),   // светлый каштан
        Color(hex: "#C99B62"),   // тёмный блонд
        Color(hex: "#E4C28A"),   // блонд
        Color(hex: "#F0E1B9"),   // платиновый
        Color(hex: "#C44A3B"),   // рыжий
        Color(hex: "#8B3FE0"),   // фиолетовый
        Color(hex: "#3B82F6"),   // синий
        Color(hex: "#EC4899"),   // розовый
        Color(hex: "#22C55E"),   // зелёный
        Color(hex: "#F59E0B"),   // оранжевый
        Color(hex: "#6B7280"),   // седой
        Color(hex: "#FFFFFF")    // белый
    ]

    // MARK: - Глаза (8 цветов)

    static let eyeColors: [Color] = [
        Color(hex: "#1F1B16"),   // чёрный
        Color(hex: "#5B3A1E"),   // карий
        Color(hex: "#8B5CF6"),   // фиолетовый
        Color(hex: "#3B82F6"),   // синий
        Color(hex: "#22C55E"),   // зелёный
        Color(hex: "#92400E"),   // тёмно-карий
        Color(hex: "#14B8A6"),   // бирюзовый
        Color(hex: "#F59E0B")    // янтарный
    ]

    // MARK: - Одежда (16 цветов)

    static let outfitColors: [Color] = [
        Color(hex: "#1F2937"),   // тёмно-серый
        Color(hex: "#EF4444"),   // красный
        Color(hex: "#F59E0B"),   // оранжевый
        Color(hex: "#FBBF24"),   // жёлтый
        Color(hex: "#22C55E"),   // зелёный
        Color(hex: "#14B8A6"),   // бирюзовый
        Color(hex: "#3B82F6"),   // синий
        Color(hex: "#6366F1"),   // индиго
        Color(hex: "#8B5CF6"),   // фиолетовый
        Color(hex: "#EC4899"),   // розовый
        Color(hex: "#F472B6"),   // светло-розовый
        Color(hex: "#FFFFFF"),   // белый
        Color(hex: "#F5F5F5"),   // молочный
        Color(hex: "#9CA3AF"),   // серый
        Color(hex: "#78350F"),   // коричневый
        Color(hex: "#000000")    // чёрный
    ]

    // MARK: - Названия причёсок

    static let hairNames: [String] = [
        "Короткие",
        "Длинные",
        "Хвостик",
        "Два хвоста",
        "Пучок",
        "Кудри",
        "Косички",
        "Ирокез",
        "Прямые",
        "Волны",
        "Каре",
        "Лысый"
    ]

    // MARK: - Названия одежды

    static let outfitNames: [String] = [
        "Футболка",
        "Рубашка",
        "Платье",
        "Худи",
        "Свитер",
        "Комбинезон",
        "Сарафан",
        "Костюм",
        "Куртка",
        "Жилет",
        "Фартук",
        "Мантия"
    ]

    // MARK: - Названия рта

    static let mouthNames: [String] = [
        "Улыбка",
        "Спокойный",
        "Грустный",
        "Открытый",
        "Смех",
        "Удивление"
    ]

    // MARK: - Названия глаз

    static let eyeNames: [String] = [
        "Обычные",
        "Широкие",
        "Прищуренные",
        "Круглые",
        "Спящие",
        "С ресницами",
        "Удивлённые",
        "Довольные"
    ]

    // MARK: - Названия аксессуаров

    static let accessoryNames: [String] = [
        "Нет",
        "Очки",
        "Кепка",
        "Бант",
        "Шляпа",
        "Ободок",
        "Серёжки",
        "Маска"
    ]

    // MARK: - Названия бровей

    static let eyebrowNames: [String] = [
        "Обычные",
        "Тонкие",
        "Толстые",
        "Приподнятые",
        "Сердитые",
        "Грустные"
    ]
}
