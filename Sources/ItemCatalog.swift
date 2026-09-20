import SwiftUI

struct CatalogItem: Identifiable, Hashable {
    let id: String
    let name: String
    let emoji: String
    let imageName: String?
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
        // ========== МЕБЕЛЬ ==========
        CatalogItem(id: "bed", name: "Кровать", emoji: "🛏️", imageName: "bedDouble", size: 90, category: .furniture),
        CatalogItem(id: "bedSingle", name: "Односпальная", emoji: "🛏️", imageName: "bedSingle", size: 75, category: .furniture),
        CatalogItem(id: "bedBunk", name: "Двухъярусная", emoji: "🛏️", imageName: "bedBunk", size: 90, category: .furniture),
        CatalogItem(id: "sofa", name: "Диван", emoji: "🛋️", imageName: "loungeSofa", size: 85, category: .furniture),
        CatalogItem(id: "sofaCorner", name: "Угловой диван", emoji: "🛋️", imageName: "loungeSofaCorner", size: 90, category: .furniture),
        CatalogItem(id: "sofaLong", name: "Длинный диван", emoji: "🛋️", imageName: "loungeSofaLong", size: 100, category: .furniture),
        CatalogItem(id: "chair", name: "Стул", emoji: "🪑", imageName: "chair", size: 55, category: .furniture),
        CatalogItem(id: "chairModern", name: "Кресло", emoji: "🪑", imageName: "chairModernCushion", size: 60, category: .furniture),
        CatalogItem(id: "chairRounded", name: "Мягкий стул", emoji: "🪑", imageName: "chairRounded", size: 55, category: .furniture),
        CatalogItem(id: "table", name: "Стол", emoji: "🪑", imageName: "table", size: 60, category: .furniture),
        CatalogItem(id: "tableRound", name: "Круглый стол", emoji: "🪑", imageName: "tableRound", size: 60, category: .furniture),
        CatalogItem(id: "sideTable", name: "Столик", emoji: "🪑", imageName: "sideTable", size: 55, category: .furniture),
        CatalogItem(id: "coffeeTable", name: "Журнальный столик", emoji: "🪑", imageName: "tableCoffee", size: 60, category: .furniture),
        CatalogItem(id: "lamp", name: "Лампа", emoji: "💡", imageName: "lampRoundFloor", size: 50, category: .furniture),
        CatalogItem(id: "lampTable", name: "Настольная лампа", emoji: "💡", imageName: "lampRoundTable", size: 40, category: .furniture),
        CatalogItem(id: "lampSquare", name: "Торшер", emoji: "💡", imageName: "lampSquareFloor", size: 55, category: .furniture),
        CatalogItem(id: "tv", name: "ТВ", emoji: "📺", imageName: "televisionModern", size: 70, category: .furniture),
        CatalogItem(id: "tvVintage", name: "Ретро-ТВ", emoji: "📺", imageName: "televisionVintage", size: 70, category: .furniture),
        CatalogItem(id: "fridge", name: "Холодильник", emoji: "🧊", imageName: "kitchenFridge", size: 75, category: .furniture),
        CatalogItem(id: "fridgeLarge", name: "Большой холодильник", emoji: "🧊", imageName: "kitchenFridgeLarge", size: 85, category: .furniture),
        CatalogItem(id: "stove", name: "Плита", emoji: "🔥", imageName: "kitchenStove", size: 70, category: .furniture),
        CatalogItem(id: "microwave", name: "Микроволновка", emoji: "📦", imageName: "kitchenMicrowave", size: 50, category: .furniture),
        CatalogItem(id: "sink", name: "Раковина", emoji: "🚰", imageName: "kitchenSink", size: 60, category: .furniture),
        CatalogItem(id: "washer", name: "Стиралка", emoji: "🧺", imageName: "washer", size: 70, category: .furniture),
        CatalogItem(id: "desk", name: "Рабочий стол", emoji: "🖥️", imageName: "desk", size: 70, category: .furniture),
        CatalogItem(id: "laptop", name: "Ноутбук", emoji: "💻", imageName: "laptop", size: 45, category: .furniture),
        CatalogItem(id: "bookcase", name: "Шкаф с книгами", emoji: "📚", imageName: "bookcaseClosed", size: 75, category: .furniture),
        CatalogItem(id: "books", name: "Книги", emoji: "📚", imageName: "books", size: 45, category: .furniture),
        CatalogItem(id: "speaker", name: "Колонка", emoji: "🔊", imageName: "speaker", size: 50, category: .furniture),
        CatalogItem(id: "radio", name: "Радио", emoji: "📻", imageName: "radio", size: 50, category: .furniture),
        CatalogItem(id: "plantBig", name: "Большое растение", emoji: "🌿", imageName: "pottedPlant", size: 70, category: .furniture),
        CatalogItem(id: "plantSmall", name: "Маленькое растение", emoji: "🌱", imageName: "plantSmall1", size: 45, category: .furniture),
        CatalogItem(id: "rug", name: "Ковёр", emoji: "🟫", imageName: "rugSquare", size: 70, category: .furniture),
        CatalogItem(id: "rugRound", name: "Круглый ковёр", emoji: "⭕", imageName: "rugRound", size: 70, category: .furniture),
        CatalogItem(id: "trashcan", name: "Мусорка", emoji: "🗑️", imageName: "trashcan", size: 45, category: .furniture),
        CatalogItem(id: "pillow", name: "Подушка", emoji: "🛋️", imageName: "pillow", size: 45, category: .furniture),
        CatalogItem(id: "toilet", name: "Унитаз", emoji: "🚽", imageName: "toilet", size: 55, category: .furniture),
        CatalogItem(id: "bathtub", name: "Ванна", emoji: "🛁", imageName: "bathtub", size: 80, category: .furniture),
        CatalogItem(id: "shower", name: "Душ", emoji: "🚿", imageName: "shower", size: 70, category: .furniture),
        CatalogItem(id: "stairs", name: "Лестница", emoji: "🪜", imageName: "stairs", size: 80, category: .furniture),
        CatalogItem(id: "door", name: "Дверь", emoji: "🚪", imageName: "doorway", size: 70, category: .furniture),

        // ========== ЕДА ==========
        CatalogItem(id: "apple", name: "Яблоко", emoji: "🍎", imageName: "apple", size: 40, category: .food),
        CatalogItem(id: "banana", name: "Банан", emoji: "🍌", imageName: "banana", size: 40, category: .food),
        CatalogItem(id: "cherries", name: "Вишня", emoji: "🍒", imageName: "cherries", size: 40, category: .food),
        CatalogItem(id: "grapes", name: "Виноград", emoji: "🍇", imageName: "grapes", size: 40, category: .food),
        CatalogItem(id: "lemon", name: "Лимон", emoji: "🍋", imageName: "lemon", size: 40, category: .food),
        CatalogItem(id: "orange", name: "Апельсин", emoji: "🍊", imageName: "orange", size: 40, category: .food),
        CatalogItem(id: "pear", name: "Груша", emoji: "🍐", imageName: "pear", size: 40, category: .food),
        CatalogItem(id: "strawberry", name: "Клубника", emoji: "🍓", imageName: "strawberry", size: 35, category: .food),
        CatalogItem(id: "watermelon", name: "Арбуз", emoji: "🍉", imageName: "watermelon", size: 55, category: .food),
        CatalogItem(id: "pineapple", name: "Ананас", emoji: "🍍", imageName: "pineapple", size: 55, category: .food),
        CatalogItem(id: "tomato", name: "Помидор", emoji: "🍅", imageName: "tomato", size: 35, category: .food),
        CatalogItem(id: "cake", name: "Торт", emoji: "🎂", imageName: "cake", size: 55, category: .food),
        CatalogItem(id: "pizza", name: "Пицца", emoji: "🍕", imageName: "pizza", size: 55, category: .food),
        CatalogItem(id: "coffee", name: "Кофе", emoji: "☕", imageName: "cup-coffee", size: 45, category: .food),
        CatalogItem(id: "tea", name: "Чай", emoji: "🍵", imageName: "cup-tea", size: 45, category: .food),
        CatalogItem(id: "icecream", name: "Мороженое", emoji: "🍦", imageName: "ice-cream", size: 45, category: .food),
        CatalogItem(id: "sushi", name: "Суши", emoji: "🍣", imageName: "sushi-salmon", size: 45, category: .food),
        CatalogItem(id: "burger", name: "Бургер", emoji: "🍔", imageName: "burger", size: 50, category: .food),
        CatalogItem(id: "hotdog", name: "Хот-дог", emoji: "🌭", imageName: "hot-dog", size: 50, category: .food),
        CatalogItem(id: "donut", name: "Пончик", emoji: "🍩", imageName: "donut", size: 45, category: .food),
        CatalogItem(id: "croissant", name: "Круассан", emoji: "🥐", imageName: "croissant", size: 45, category: .food),
        CatalogItem(id: "bread", name: "Хлеб", emoji: "🍞", imageName: "loaf", size: 50, category: .food),
        CatalogItem(id: "cheese", name: "Сыр", emoji: "🧀", imageName: "cheese", size: 40, category: .food),
        CatalogItem(id: "pancakes", name: "Блины", emoji: "🥞", imageName: "pancakes", size: 50, category: .food),
        CatalogItem(id: "wine", name: "Вино", emoji: "🍷", imageName: "wine-red", size: 45, category: .food),
        CatalogItem(id: "soda", name: "Газировка", emoji: "🥤", imageName: "soda-can", size: 40, category: .food),
        CatalogItem(id: "eggs", name: "Яйца", emoji: "🥚", imageName: "egg", size: 35, category: .food),
        CatalogItem(id: "fish", name: "Рыба", emoji: "🐟", imageName: "fish", size: 45, category: .food),

        // ========== ДЕКОР ==========
        CatalogItem(id: "flower", name: "Цветок", emoji: "🌷", imageName: "plantSmall2", size: 45, category: .decor),
        CatalogItem(id: "balloon", name: "Шарик", emoji: "🎈", imageName: nil, size: 45, category: .decor),
        CatalogItem(id: "painting", name: "Картина", emoji: "🖼️", imageName: nil, size: 55, category: .decor),
        CatalogItem(id: "candle", name: "Свеча", emoji: "🕯️", imageName: nil, size: 40, category: .decor),

        // ========== ПРИРОДА ==========
        CatalogItem(id: "tree", name: "Дерево", emoji: "🌳", imageName: "tree01", size: 100, category: .nature),
        CatalogItem(id: "tree2", name: "Ёлка", emoji: "🌲", imageName: "tree15", size: 100, category: .nature),
        CatalogItem(id: "sun", name: "Солнце", emoji: "☀️", imageName: "sun", size: 70, category: .nature),
        CatalogItem(id: "moon", name: "Луна", emoji: "🌙", imageName: "moon_full", size: 60, category: .nature),
        CatalogItem(id: "cloud", name: "Облако", emoji: "☁️", imageName: "cloud1", size: 60, category: .nature),
        CatalogItem(id: "grass", name: "Трава", emoji: "🌾", imageName: "grass1", size: 50, category: .nature),
        CatalogItem(id: "fence", name: "Забор", emoji: "🚧", imageName: "fence", size: 60, category: .nature),
        CatalogItem(id: "castle", name: "Замок", emoji: "🏰", imageName: "castle_beige", size: 100, category: .nature),

        // ========== ИГРУШКИ ==========
        CatalogItem(id: "ball", name: "Мяч", emoji: "⚽", imageName: nil, size: 45, category: .toys),
        CatalogItem(id: "rocket", name: "Ракета", emoji: "🚀", imageName: nil, size: 70, category: .toys),
        CatalogItem(id: "car", name: "Машина", emoji: "🚗", imageName: nil, size: 65, category: .toys),
        CatalogItem(id: "guitar", name: "Гитара", emoji: "🎸", imageName: nil, size: 60, category: .toys),
        CatalogItem(id: "crown", name: "Корона", emoji: "👑", imageName: nil, size: 45, category: .toys),
    ]

    static func item(byID id: String) -> CatalogItem? {
        all.first { $0.id == id }
    }
}
