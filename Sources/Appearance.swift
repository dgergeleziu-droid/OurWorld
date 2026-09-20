import SwiftUI

// MARK: - Расширение палитры: новые цвета и стили
extension Palette {

    static let skinTones: [Color] = [
        Color(hex: "#FFF1E0"), Color(hex: "#FBD5B0"), Color(hex: "#F3C39A"),
        Color(hex: "#E8B283"), Color(hex: "#C98A5B"), Color(hex: "#A86B3D"),
        Color(hex: "#7B4A2A"), Color(hex: "#5A3520")
    ]
    static let skinNames = ["Фарфор","Светлая","Персик","Тёплая","Загар","Смуглая","Тёмная","Глубокая"]

    static let hairColors: [Color] = [
        Color(hex: "#1E1410"), Color(hex: "#3B2515"), Color(hex: "#6B3F24"),
        Color(hex: "#A56B3F"), Color(hex: "#E0BE7D"), Color(hex: "#F1D77E"),
        Color(hex: "#B44A2C"), Color(hex: "#E0447A"), Color(hex: "#7B4BC8"),
        Color(hex: "#4A90E2"), Color(hex: "#3EB49B"), Color(hex: "#E8B23D")
    ]
    static let hairNames = ["Чёрный","Каштан","Русый","Светло-русый","Блонд","Золотой","Рыжий","Розовый","Фиолет","Синий","Зелёный","Оранж"]

    static let eyeColors: [Color] = [
        Color(hex: "#241A12"), Color(hex: "#0F4C81"), Color(hex: "#3E7B54"),
        Color(hex: "#6B4A2D"), Color(hex: "#8B6BC6"), Color(hex: "#C68A2D")
    ]
    static let eyeNames = ["Карие","Синие","Зелёные","Орех","Фиолет","Янтарь"]

    static let outfitColors: [Color] = [
        Color(hex: "#FF6B6B"), Color(hex: "#4ECDC4"), Color(hex: "#FFD93D"),
        Color(hex: "#A8E6CF"), Color(hex: "#F093B7"), Color(hex: "#B39DDB"),
        Color(hex: "#FFB4A2"), Color(hex: "#81D4FA"), Color(hex: "#FFF4A3"),
        Color(hex: "#A5D6A7"), Color(hex: "#FFCC80"), Color(hex: "#9575CD")
    ]
    static let outfitNames = ["Коралл","Бирюза","Жёлтый","Мята","Розовый","Лаванда","Персик","Голубой","Лимон","Травяной","Песочный","Сиреневый"]

    static let hairStyleNames = ["Короткие","Длинные","Хвостики","Пучок","Кудри","Косички","Ирокез","Прямые","Волны","Лысый"]
    static let eyeStyleNames = ["Обычные","Большие","Малые","Крупные","Полу","Тильт"]
    static let mouthStyleNames = ["Улыбка","Открытая","Бантик","Прямая","Кружок","Уголки"]
    static let outfitStyleNames = ["Футболка","Платье","Свитер","Топ","Рубашка","Куртка","Сарафан","Худи","Туника","Костюм","Пуловер","Кроп"]
    static let accessoryNames = ["Без","Очки","Кепка","Бант","Шляпа","Ободок","Серёжки","Маска"]
}

// MARK: - Безопасный доступ к массиву
extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
