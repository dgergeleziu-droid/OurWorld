import SwiftUI

struct CatalogItem: Identifiable, Hashable {
    let id: String
    let name: String
    let emoji: String
    let size: CGFloat
    let category: ItemCategory
}

enum ItemCategory: String, CaseIterable {
    case furniture = "Мебель"
    case food = "Еда"
    case decor = "Декор"
    case nature = "Природа"
    case toys = "Игрушки"
}

enum ItemCatalog {
    static let all: [CatalogItem] = [
        // Мебель
        CatalogItem(id: "bed", name: "Кровать", emoji: "🛏️", size: 90, category: .furniture),
        CatalogItem(id: "sofa", name: "Диван", emoji: "🛋️", size: 85, category: .furniture),
        CatalogItem(id: "chair", name: "Стул", emoji: "🪑", size: 55, category: .furniture),
        CatalogItem(id: "table", name: "Стол", emoji: "🪑", size: 60, category: .furniture),
        CatalogItem(id: "lamp", name: "Лампа", emoji: "💡", size: 50, category: .furniture),
        CatalogItem(id: "mirror", name: "Зеркало", emoji: "🪞", size: 55, category: .furniture),
        CatalogItem(id: "tv", name: "ТВ", emoji: "📺", size: 70, category: .furniture),
        CatalogItem(id: "clock", name: "Часы", emoji: "🕰️", size: 50, category: .furniture),
        CatalogItem(id: "bathtub", name: "Ванна", emoji: "🛁", size: 80, category: .furniture),
        CatalogItem(id: "toilet", name: "Унитаз", emoji: "🚽", size: 55, category: .furniture),

        // Еда
        CatalogItem(id: "apple", name: "Яблоко", emoji: "🍎", size: 40, category: .food),
        CatalogItem(id: "banana", name: "Банан", emoji: "🍌", size: 40, category: .food),
        CatalogItem(id: "cake", name: "Торт", emoji: "🎂", size: 55, category: .food),
        CatalogItem(id: "pizza", name: "Пицца", emoji: "🍕", size: 55, category: .food),
        CatalogItem(id: "coffee", name: "Кофе", emoji: "☕", size: 45, category: .food),
        CatalogItem(id: "icecream", name: "Мороженое", emoji: "🍦", size: 45, category: .food),
        CatalogItem(id: "sushi", name: "Суши", emoji: "🍣", size: 45, category: .food),
        CatalogItem(id: "burger", name: "Бургер", emoji: "🍔", size: 50, category: .food),
        CatalogItem(id: "donut", name: "Пончик", emoji: "🍩", size: 45, category: .food),
        CatalogItem(id: "wine", name: "Вино", emoji: "🍷", size: 45, category: .food),

        // Декор
        CatalogItem(id: "plant", name: "Растение", emoji: "🪴", size: 55, category: .decor),
        CatalogItem(id: "flower", name: "Цветок", emoji: "🌷", size: 45, category: .decor),
        CatalogItem(id: "balloon", name: "Шарик", emoji: "🎈", size: 45, category: .decor),
        CatalogItem(id: "gift", name: "Подарок", emoji: "🎁", size: 50, category: .decor),
        CatalogItem(id: "book", name: "Книга", emoji: "📚", size: 45, category: .decor),
        CatalogItem(id: "painting", name: "Картина", emoji: "🖼️", size: 55, category: .decor),
        CatalogItem(id: "candle", name: "Свеча", emoji: "🕯️", size: 40, category: .decor),
        CatalogItem(id: "teddy", name: "Мишка", emoji: "🧸", size: 55, category: .decor),

        // Природа
        CatalogItem(id: "tree", name: "Дерево", emoji: "🌳", size: 100, category: .nature),
        CatalogItem(id: "sun", name: "Солнце", emoji: "☀️", size: 70, category: .nature),
        CatalogItem(id: "moon", name: "Луна", emoji: "🌙", size: 60, category: .nature),
        CatalogItem(id: "star", name: "Звезда", emoji: "⭐", size: 50, category: .nature),
        CatalogItem(id: "rainbow", name: "Радуга", emoji: "🌈", size: 80, category: .nature),

        // Игрушки
        CatalogItem(id: "ball", name: "Мяч", emoji: "⚽", size: 45, category: .toys),
        CatalogItem(id: "rocket", name: "Ракета", emoji: "🚀", size: 70, category: .toys),
        CatalogItem(id: "car", name: "Машина", emoji: "🚗", size: 65, category: .toys),
        CatalogItem(id: "guitar", name: "Гитара", emoji: "🎸", size: 60, category: .toys),
        CatalogItem(id: "crown", name: "Корона", emoji: "👑", size: 45, category: .toys),
    ]

    static func item(byID id: String) -> CatalogItem? {
        all.first { $0.id == id }
    }
}
