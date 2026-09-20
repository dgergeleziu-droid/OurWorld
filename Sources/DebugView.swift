import SwiftUI

struct DebugView: View {
    @EnvironmentObject var characterStore: CharacterStore
    @Environment(\.dismiss) var dismiss

    @State private var showAll = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // 1. Картинки в бандле
                    section(title: "1. Картинки в бандле приложения") {
                        checkImage("anya")
                        checkImage("bedDouble")
                        checkImage("loungeSofa")
                        checkImage("kitchenFridge")
                        checkImage("chair")
                        checkImage("tree01")
                        checkImage("cloud1")
                        checkImage("apple")
                    }

                    // 2. Персонажи
                    section(title: "2. Персонажи (CharacterStore)") {
                        infoLine("Всего персонажей", "\(characterStore.players.count)")
                        ForEach(characterStore.players) { p in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("• \(p.name)")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("imageName: \(p.imageName ?? "—")")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            .padding(.leading, 8)
                        }
                        if characterStore.players.isEmpty {
                            Text("⚠️ ПУСТО — ни одного персонажа")
                                .foregroundColor(.red)
                        }
                    }

                    // 3. Каталог предметов
                    section(title: "3. Каталог предметов") {
                        infoLine("Всего предметов", "\(ItemCatalog.all.count)")
                        let withImage = ItemCatalog.all.filter { $0.imageName != nil }.count
                        infoLine("Из них с картинками", "\(withImage)")

                        if ItemCatalog.all.isEmpty {
                            Text("⚠️ ItemCatalog.all ПУСТ")
                                .foregroundColor(.red)
                        }
                    }

                    // 4. Проверка конкретных предметов
                    section(title: "4. Первые 5 предметов каталога") {
                        ForEach(ItemCatalog.all.prefix(5)) { item in
                            HStack {
                                Text(item.name)
                                    .font(.system(size: 13, weight: .medium))
                                Spacer()
                                Text(item.imageName ?? "—")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                    }

                    // 5. Версия iOS / SDK
                    section(title: "5. Система") {
                        infoLine("iOS", UIDevice.current.systemVersion)
                        infoLine("Устройство", UIDevice.current.model)
                        infoLine("Bundle ID", Bundle.main.bundleIdentifier ?? "—")
                    }
                }
                .padding()
            }
            .navigationTitle("Диагностика")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Закрыть") { dismiss() }
                }
            }
        }
    }

    // MARK: - Секция
    @ViewBuilder
    func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
            content()
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
        }
    }

    // MARK: - Проверка картинки
    @ViewBuilder
    func checkImage(_ name: String) -> some View {
        HStack {
            if UIImage(named: name) != nil {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("\(name).png — НАЙДЕНА")
                    .font(.system(size: 13))
                Spacer()
                Image(name)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .background(Color.gray.opacity(0.1))
            } else {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                Text("\(name) — НЕ найдена")
                    .font(.system(size: 13))
                    .foregroundColor(.red)
            }
        }
    }

    // MARK: - Строка с инфо
    @ViewBuilder
    func infoLine(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 13))
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.blue)
        }
    }
}
