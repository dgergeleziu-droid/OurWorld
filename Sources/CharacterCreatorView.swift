import SwiftUI

struct CharacterCreatorView: View {
    @EnvironmentObject var store: CharacterStore
    @Environment(\.dismiss) var dismiss

    @State private var draft: Player
    private let isEditing: Bool
    private let onSave: ((Player) -> Void)?

    init(existing: Player? = nil, onSave: ((Player) -> Void)? = nil) {
        if let existing = existing {
            _draft = State(initialValue: existing)
            isEditing = true
        } else {
            _draft = State(initialValue: Player())
            isEditing = false
        }
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#FDF6EC").ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 22) {
                        AvatarView(player: draft, size: 190)
                            .padding(.top, 20)

                        // Имя
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Имя")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(hex: "#6B7280"))
                            TextField("Например, Аня", text: $draft.name)
                                .textFieldStyle(.plain)
                                .font(.system(size: 17, design: .rounded))
                                .foregroundColor(Color(hex: "#111827"))
                                .padding(14)
                                .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
                                .shadow(color: .black.opacity(0.05), radius: 4)
                        }
                        .padding(.horizontal, 20)

                        // Палитры
                        paletteRow(title: "Цвет кожи", colors: Palette.skinColors, selected: $draft.skinColorIndex)
                        paletteRow(title: "Цвет волос", colors: Palette.hairColors, selected: $draft.hairColorIndex)

                        // Причёска
                        optionsRow(
                            title: "Причёска",
                            options: ["Короткая", "Длинная", "Пучок", "Хвост", "Кудри"],
                            selected: $draft.hairStyleIndex
                        )

                        paletteRow(title: "Цвет одежды", colors: Palette.clothesColors, selected: $draft.clothesColorIndex)

                        // Стиль одежды
                        optionsRow(
                            title: "Одежда",
                            options: ["Футболка", "Платье", "Худи"],
                            selected: $draft.clothesStyleIndex
                        )

                        paletteRow(title: "Цвет глаз", colors: Palette.eyeColors, selected: $draft.eyeColorIndex)

                        // Сохранить
                        Button {
                            save()
                        } label: {
                            Text(isEditing ? "Сохранить" : "Создать персонажа")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(hex: "#3B82F6"))
                                .cornerRadius(16)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 6)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle(isEditing ? "Редактор" : "Новый персонаж")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") { dismiss() }
                        .foregroundColor(Color(hex: "#3B82F6"))
                }
            }
        }
    }

    func paletteRow(title: String, colors: [String], selected: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(Color(hex: "#6B7280"))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(colors.enumerated()), id: \.offset) { idx, hex in
                        Button {
                            selected.wrappedValue = idx
                        } label: {
                            Circle()
                                .fill(Color(hex: hex))
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Circle()
                                        .stroke(Color(hex: "#3B82F6"), lineWidth: selected.wrappedValue == idx ? 3 : 0)
                                        .padding(2)
                                )
                                .shadow(color: .black.opacity(0.08), radius: 3)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }

    func optionsRow(title: String, options: [String], selected: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(Color(hex: "#6B7280"))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(options.enumerated()), id: \.offset) { idx, name in
                        Button {
                            selected.wrappedValue = idx
                        } label: {
                            Text(name)
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(selected.wrappedValue == idx ? .white : Color(hex: "#6B7280"))
                                .padding(.horizontal, 16).padding(.vertical, 10)
                                .background(
                                    Capsule().fill(selected.wrappedValue == idx ? Color(hex: "#3B82F6") : Color.white)
                                )
                                .shadow(color: .black.opacity(0.05), radius: 3)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }

    func save() {
        let trimmed = draft.name.trimmingCharacters(in: .whitespaces)
        draft.name = trimmed.isEmpty ? "Персонаж" : trimmed

        if isEditing {
            store.update(draft)
            onSave?(draft)
        } else {
            store.add(draft)
        }
        dismiss()
    }
}
