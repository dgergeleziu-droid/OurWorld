import SwiftUI

struct CharacterCreatorView: View {
    @EnvironmentObject var store: CharacterStore
    @Environment(\.dismiss) var dismiss
    var existing: Player? = nil
    var onSave: ((Player) -> Void)? = nil

    @State private var draft: Player
    @State private var category: CreatorCategory = .skin

    enum CreatorCategory: String, CaseIterable {
        case skin = "Кожа"
        case hair = "Причёска"
        case hairColor = "Волосы"
        case eyes = "Глаза"
        case eyeColor = "Цвет глаз"
        case mouth = "Рот"
        case outfit = "Одежда"
        case outfitColor = "Цвет одежды"
        case accessory = "Аксессуар"
    }

    init(existing: Player? = nil, onSave: ((Player) -> Void)? = nil) {
        self.existing = existing
        self.onSave = onSave
        let initial = existing ?? Player(
            skinTone: Int.random(in: 0..<Palette.skinTones.count),
            hairStyle: Int.random(in: 0..<9),
            hairColor: Int.random(in: 0..<Palette.hairColors.count),
            outfitStyle: Int.random(in: 0..<Palette.outfitStyleNames.count),
            outfitColor: Int.random(in: 0..<Palette.outfitColors.count)
        )
        _draft = State(initialValue: initial)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "#FDF6EC"), Color(hex: "#FCE7F3")],
                    startPoint: .top, endPoint: .bottom
                ).ignoresSafeArea()

                VStack(spacing: 0) {
                    previewArea
                    categoryTabs
                    optionsArea
                    nameField
                }
            }
            .navigationTitle(existing == nil ? "Новый друг" : "Редактировать")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                        .foregroundColor(Color(hex: "#6B7280"))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") { save() }
                        .bold()
                        .foregroundColor(Color(hex: "#3B82F6"))
                }
            }
        }
    }

    // MARK: - Превью
    var previewArea: some View {
        ZStack {
            // Подложка-круг
            Circle()
                .fill(Color.white)
                .frame(width: 230, height: 230)
                .shadow(color: .black.opacity(0.08), radius: 12, y: 6)

            AvatarView(player: draft, size: 200)
        }
        .padding(.top, 8)
        .padding(.bottom, 6)
    }

    // MARK: - Вкладки категорий
    var categoryTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(CreatorCategory.allCases, id: \.self) { cat in
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) { category = cat }
                    } label: {
                        Text(cat.rawValue)
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(category == cat ? .white : Color(hex: "#4B5563"))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule().fill(category == cat
                                               ? Color(hex: "#3B82F6")
                                               : Color.white)
                            )
                            .overlay(Capsule().stroke(Color(hex: "#E5E7EB"), lineWidth: 1))
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 6)
    }

    // MARK: - Опции под вкладкой
    var optionsArea: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                switch category {
                case .skin:
                    ForEach(0..<Palette.skinTones.count, id: \.self) { i in
                        colorCircle(color: Palette.skinTones[i], selected: draft.skinTone == i) {
                            draft.skinTone = i
                        }
                    }
                case .hairColor:
                    ForEach(0..<Palette.hairColors.count, id: \.self) { i in
                        colorCircle(color: Palette.hairColors[i], selected: draft.hairColor == i) {
                            draft.hairColor = i
                        }
                    }
                case .eyeColor:
                    ForEach(0..<Palette.eyeColors.count, id: \.self) { i in
                        colorCircle(color: Palette.eyeColors[i], selected: draft.eyeColor == i) {
                            draft.eyeColor = i
                        }
                    }
                case .outfitColor:
                    ForEach(0..<Palette.outfitColors.count, id: \.self) { i in
                        colorCircle(color: Palette.outfitColors[i], selected: draft.outfitColor == i) {
                            draft.outfitColor = i
                        }
                    }
                case .hair:
                    ForEach(0..<Palette.hairStyleNames.count, id: \.self) { i in
                        styleButton(
                            title: Palette.hairStyleNames[i],
                            preview: AnyView(
                                AvatarView(player: playerWithHair(i), size: 60)
                            ),
                            selected: draft.hairStyle == i
                        ) { draft.hairStyle = i }
                    }
                case .eyes:
                    ForEach(0..<Palette.eyeStyleNames.count, id: \.self) { i in
                        styleButton(
                            title: Palette.eyeStyleNames[i],
                            preview: AnyView(eyePreview(style: i)),
                            selected: draft.eyeStyle == i
                        ) { draft.eyeStyle = i }
                    }
                case .mouth:
                    ForEach(0..<Palette.mouthStyleNames.count, id: \.self) { i in
                        styleButton(
                            title: Palette.mouthStyleNames[i],
                            preview: AnyView(mouthPreview(style: i)),
                            selected: draft.mouthStyle == i
                        ) { draft.mouthStyle = i }
                    }
                case .outfit:
                    ForEach(0..<Palette.outfitStyleNames.count, id: \.self) { i in
                        styleButton(
                            title: Palette.outfitStyleNames[i],
                            preview: AnyView(
                                AvatarView(player: playerWithOutfit(i), size: 60)
                            ),
                            selected: draft.outfitStyle == i
                        ) { draft.outfitStyle = i }
                    }
                case .accessory:
                    ForEach(0..<Palette.accessoryNames.count, id: \.self) { i in
                        styleButton(
                            title: Palette.accessoryNames[i],
                            preview: AnyView(
                                AvatarView(player: playerWithAccessory(i), size: 60)
                            ),
                            selected: draft.accessory == i
                        ) { draft.accessory = i }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 110)
    }

    // MARK: - Поле имени
    var nameField: some View {
        HStack(spacing: 10) {
            Image(systemName: "person.fill")
                .foregroundColor(Color(hex: "#9CA3AF"))
            TextField("Имя персонажа", text: $draft.name)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14).fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
        )
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 20)
    }

    // MARK: - Вспомогательные для превью
    private func playerWithHair(_ i: Int) -> Player {
        var p = draft; p.hairStyle = i; return p
    }
    private func playerWithOutfit(_ i: Int) -> Player {
        var p = draft; p.outfitStyle = i; return p
    }
    private func playerWithAccessory(_ i: Int) -> Player {
        var p = draft; p.accessory = i; return p
    }

    func colorCircle(color: Color, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Circle().fill(color)
                    .frame(width: 58, height: 58)
                    .overlay(
                        Circle().stroke(selected ? Color(hex: "#3B82F6") : Color(hex: "#E5E7EB"),
                                       lineWidth: selected ? 4 : 2)
                    )
                if selected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2)
                }
            }
        }
    }

    func styleButton(title: String, preview: AnyView, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selected ? Color(hex: "#3B82F6") : Color(hex: "#E5E7EB"),
                                       lineWidth: selected ? 3 : 1)
                        )
                    preview
                        .frame(width: 60, height: 60)
                        .scaleEffect(0.95)
                        .clipped()
                }
                .frame(width: 78, height: 78)

                Text(title)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(selected ? Color(hex: "#3B82F6") : Color(hex: "#6B7280"))
                    .lineLimit(1)
            }
        }
    }

    func eyePreview(style: Int) -> some View {
        let d: CGFloat = {
            switch style {
            case 0: return 26
            case 1: return 34
            case 2: return 20
            case 3: return 30
            case 4: return 22
            default: return 28
            }
        }()
        return ZStack {
            Circle().fill(Color.white).frame(width: d, height: d)
            Circle().fill(Palette.eyeColors[safe: draft.eyeColor] ?? .blue)
                .frame(width: d * 0.68, height: d * 0.68)
            Circle().fill(Color.black)
                .frame(width: d * 0.38, height: d * 0.38)
            Circle().fill(Color.white)
                .frame(width: d * 0.16, height: d * 0.16)
                .offset(x: -d * 0.16, y: -d * 0.16)
        }
    }

    func mouthPreview(style: Int) -> some View {
        Group {
            switch style {
            case 0:
                SmileShape().stroke(Color(hex: "#8B2C1A"), lineWidth: 3)
                    .frame(width: 30, height: 15)
            case 1:
                ZStack {
                    FilledSmileShape().fill(Color(hex: "#C0392B")).frame(width: 30, height: 22)
                    FilledSmileShape().fill(Color.white).frame(width: 24, height: 8).offset(y: -6)
                }
            case 2:
                Capsule().fill(Color(hex: "#C0392B")).frame(width: 30, height: 4)
            case 3:
                Capsule().fill(Color(hex: "#8B2C1A")).frame(width: 26, height: 4)
            case 4:
                Circle().fill(Color(hex: "#8B2C1A")).frame(width: 16, height: 16)
            default:
                HStack(spacing: 8) {
                    SmileShape().stroke(Color(hex: "#8B2C1A"), lineWidth: 2.5)
                        .frame(width: 10, height: 8)
                    SmileShape().stroke(Color(hex: "#8B2C1A"), lineWidth: 2.5)
                        .frame(width: 10, height: 8)
                }
            }
        }
    }

    // MARK: - Сохранение
    func save() {
        var final = draft
        if final.name.trimmingCharacters(in: .whitespaces).isEmpty {
            final.name = "Друг"
        }
        if let onSave = onSave {
            onSave(final)
        } else if existing != nil {
            store.update(final)
        } else {
            store.add(final)
        }
        dismiss()
    }
}
