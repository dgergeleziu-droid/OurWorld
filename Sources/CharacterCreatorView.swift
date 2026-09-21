import SwiftUI

struct CharacterCreatorView: View {

    @EnvironmentObject var characterStore: CharacterStore
    @Environment(\.dismiss) private var dismiss

    @State private var draft: Player
    @State private var editingName: String

    /// Колбэк при сохранении существующего персонажа.
    /// Если nil — значит создаём нового и сами добавляем в стор.
    var onSave: ((Player) -> Void)? = nil

    private var isEditingExisting: Bool { onSave != nil }

    // MARK: - Init

    init() {
        let start = Player(name: "Друг")
        _draft = State(initialValue: start)
        _editingName = State(initialValue: start.name)
        self.onSave = nil
    }

    init(existing: Player, onSave: @escaping (Player) -> Void) {
        _draft = State(initialValue: existing)
        _editingName = State(initialValue: existing.name)
        self.onSave = onSave
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#FDF6EC").ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {

                        previewSection

                        nameSection

                        ageSection

                        skinSection

                        hairSection

                        eyesSection

                        mouthSection

                        outfitSection

                        accessorySection

                        layerSection

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
            }
            .navigationTitle(isEditingExisting ? "Редактор" : "Создание персонажа")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") { dismiss() }
                        .foregroundColor(Color(hex: "#3B82F6"))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        saveCharacter()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Сохранить")
                        }
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#22C55E"))
                    }
                }
            }
        }
    }

    // MARK: - Превью

    private var previewSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#FCE7F3"), Color(hex: "#FDF6EC")],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(height: 240)
                .shadow(color: .black.opacity(0.06), radius: 10, y: 4)

            AvatarView(player: draft, size: 220)
        }
    }

    // MARK: - Имя

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionTitle("Имя")
            TextField("Имя персонажа", text: $editingName)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                .onChange(of: editingName) { newValue in
                    draft.name = newValue.isEmpty ? "Друг" : newValue
                }
        }
    }

    // MARK: - Возраст

    private var ageSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Возраст")
            HStack(spacing: 8) {
                ForEach(AgeGroup.allCases) { age in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            draft.ageGroup = age
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: age.icon)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(draft.ageGroup == age
                                                 ? .white
                                                 : Color(hex: "#6B7280"))
                            Text(age.rawValue)
                                .font(.system(size: 9, weight: .semibold, design: .rounded))
                                .foregroundColor(draft.ageGroup == age
                                                 ? .white
                                                 : Color(hex: "#6B7280"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(draft.ageGroup == age
                                      ? Color(hex: "#3B82F6")
                                      : Color.white)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 3, y: 1)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Кожа

    private var skinSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Цвет кожи")
            colorRow(
                colors: Palette.skinTones,
                selectedIndex: draft.skinTone,
                onSelect: { draft.skinTone = $0 }
            )
        }
    }

    // MARK: - Волосы

    private var hairSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Причёска")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(0..<Palette.hairNames.count, id: \.self) { i in
                        Button {
                            draft.hairStyle = i
                        } label: {
                            VStack(spacing: 4) {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: "#FDF6EC"))
                                        .frame(width: 44, height: 44)
                                    Text("\(i + 1)")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(Color(hex: "#4B5563"))
                                }
                                Text(Palette.hairNames[i])
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundColor(Color(hex: "#6B7280"))
                            }
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(draft.hairStyle == i
                                          ? Color(hex: "#3B82F6").opacity(0.15)
                                          : Color.white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(draft.hairStyle == i
                                            ? Color(hex: "#3B82F6")
                                            : Color.clear,
                                            lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }

            sectionTitle("Цвет волос")
            colorRow(
                colors: Palette.hairColors,
                selectedIndex: draft.hairColor,
                onSelect: { draft.hairColor = $0 }
            )
        }
    }

    // MARK: - Глаза

    private var eyesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Форма глаз")
            HStack(spacing: 8) {
                ForEach(0..<6, id: \.self) { i in
                    Button {
                        draft.eyeStyle = i
                    } label: {
                        Text("\(i + 1)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(draft.eyeStyle == i
                                             ? .white
                                             : Color(hex: "#4B5563"))
                            .frame(width: 40, height: 40)
                            .background(
                                Circle().fill(draft.eyeStyle == i
                                              ? Color(hex: "#3B82F6")
                                              : Color.white)
                            )
                            .overlay(
                                Circle().stroke(Color.black.opacity(0.08), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }

            sectionTitle("Цвет глаз")
            colorRow(
                colors: Palette.eyeColors,
                selectedIndex: draft.eyeColor,
                onSelect: { draft.eyeColor = $0 }
            )
        }
    }

    // MARK: - Рот

    private var mouthSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Рот")
            HStack(spacing: 8) {
                ForEach(0..<Palette.mouthNames.count, id: \.self) { i in
                    Button {
                        draft.mouthStyle = i
                    } label: {
                        VStack(spacing: 2) {
                            Image(systemName: mouthIcon(i))
                                .font(.system(size: 20))
                                .foregroundColor(draft.mouthStyle == i
                                                 ? .white
                                                 : Color(hex: "#4B5563"))
                            Text(Palette.mouthNames[i])
                                .font(.system(size: 8, weight: .medium))
                                .foregroundColor(draft.mouthStyle == i
                                                 ? .white
                                                 : Color(hex: "#6B7280"))
                        }
                        .frame(width: 52, height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(draft.mouthStyle == i
                                      ? Color(hex: "#3B82F6")
                                      : Color.white)
                        )
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
        }
    }

    private func mouthIcon(_ i: Int) -> String {
        switch i {
        case 0: return "face.smiling"
        case 1: return "minus"
        case 2: return "face.dashed"
        case 3: return "circle"
        case 4: return "face.smiling.inverse"
        default: return "circle.dashed"
        }
    }

    // MARK: - Одежда

    private var outfitSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Одежда")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(0..<Palette.outfitNames.count, id: \.self) { i in
                        Button {
                            draft.outfitStyle = i
                        } label: {
                            VStack(spacing: 4) {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: "#FDF6EC"))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "tshirt.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color(hex: "#4B5563"))
                                }
                                Text(Palette.outfitNames[i])
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundColor(Color(hex: "#6B7280"))
                            }
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(draft.outfitStyle == i
                                          ? Color(hex: "#3B82F6").opacity(0.15)
                                          : Color.white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(draft.outfitStyle == i
                                            ? Color(hex: "#3B82F6")
                                            : Color.clear,
                                            lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }

            sectionTitle("Цвет одежды")
            colorRow(
                colors: Palette.outfitColors,
                selectedIndex: draft.outfitColor,
                onSelect: { draft.outfitColor = $0 }
            )
        }
    }

    // MARK: - Аксессуар

    private var accessorySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Аксессуар")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(0..<Palette.accessoryNames.count, id: \.self) { i in
                        Button {
                            draft.accessory = i
                        } label: {
                            Text(Palette.accessoryNames[i])
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(draft.accessory == i
                                                 ? .white
                                                 : Color(hex: "#4B5563"))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule().fill(draft.accessory == i
                                                   ? Color(hex: "#3B82F6")
                                                   : Color.white)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    // MARK: - Слои

    private var layerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Порядок слоёв (что поверх чего)")

            Text("Нажми ↑ чтобы поднять слой вперёд, ↓ чтобы убрать назад")
                .font(.system(size: 11, design: .rounded))
                .foregroundColor(Color(hex: "#9CA3AF"))

            VStack(spacing: 8) {
                ForEach(Array(draft.layerOrder.enumerated()), id: \.offset) { index, slot in
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#E5E7EB"))
                                .frame(width: 32, height: 32)
                            Text("\(index + 1)")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color(hex: "#4B5563"))
                        }

                        Image(systemName: slot.icon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#3B82F6"))
                            .frame(width: 24)

                        Text(slot.rawValue)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))

                        Spacer()

                        Button {
                            moveUp(index)
                        } label: {
                            Image(systemName: "arrow.up")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(index == 0
                                                 ? Color(hex: "#D1D5DB")
                                                 : Color(hex: "#3B82F6"))
                                .frame(width: 32, height: 32)
                                .background(Circle().fill(Color(hex: "#F3F4F6")))
                        }
                        .buttonStyle(.plain)
                        .disabled(index == 0)

                        Button {
                            moveDown(index)
                        } label: {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(index == draft.layerOrder.count - 1
                                                 ? Color(hex: "#D1D5DB")
                                                 : Color(hex: "#3B82F6"))
                                .frame(width: 32, height: 32)
                                .background(Circle().fill(Color(hex: "#F3F4F6")))
                        }
                        .buttonStyle(.plain)
                        .disabled(index == draft.layerOrder.count - 1)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white)
                    )
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                }
            }
        }
    }

    private func moveUp(_ index: Int) {
        guard index > 0, index < draft.layerOrder.count else { return }
        var order = draft.layerOrder
        order.swapAt(index, index - 1)
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            draft.layerOrder = order
        }
    }

    private func moveDown(_ index: Int) {
        guard index >= 0, index < draft.layerOrder.count - 1 else { return }
        var order = draft.layerOrder
        order.swapAt(index, index + 1)
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            draft.layerOrder = order
        }
    }

    // MARK: - Общие компоненты

    private func sectionTitle(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.system(size: 11, weight: .bold, design: .rounded))
            .foregroundColor(Color(hex: "#6B7280"))
            .padding(.horizontal, 4)
    }

    private func colorRow(colors: [Color],
                          selectedIndex: Int,
                          onSelect: @escaping (Int) -> Void) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(0..<colors.count, id: \.self) { i in
                    Button {
                        onSelect(i)
                    } label: {
                        ZStack {
                            Circle()
                                .fill(colors[i])
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(Color.black.opacity(0.1), lineWidth: 1)
                                )
                            if selectedIndex == i {
                                Circle()
                                    .stroke(Color(hex: "#3B82F6"), lineWidth: 3)
                                    .frame(width: 46, height: 46)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 4)
        }
    }

    // MARK: - Сохранение

    private func saveCharacter() {
        if let onSave {
            // Режим редактирования: отдаём обновлённого наверх
            onSave(draft)
        } else {
            // Режим создания: добавляем в стор сами
            characterStore.add(draft)
        }
        dismiss()
    }
}
