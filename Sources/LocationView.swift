import SwiftUI

struct LocationView: View {
    let location: LocationID

    @EnvironmentObject var worldStore: WorldStore
    @EnvironmentObject var characterStore: CharacterStore
    @Environment(\.dismiss) private var dismiss

    @State private var showCatalog = false
    @State private var showCharacters = false
    @State private var snackbar: String? = nil
    @State private var selectedPlayer: Player? = nil

    private var floorZone: FloorZone { LocationBackground.floorZone }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LocationBackground(location: location)

                // Предметы
                ForEach(worldStore.items(for: location)) { item in
                    if let catalog = catalogItem(for: item.catalogID) {
                        DraggableItem(
                            item: item,
                            catalog: catalog,
                            geoSize: geo.size,
                            floorZone: floorZone,
                            onMove: { x, y in
                                var updated = item
                                updated.x = x
                                updated.y = y
                                worldStore.updateItem(updated, in: location)
                            },
                            onDelete: {
                                withAnimation(AppAnimation.fade) {
                                    worldStore.removeItem(item, in: location)
                                }
                                showSnackbar("Предмет удалён")
                            }
                        )
                    }
                }

                // Персонажи
                ForEach(worldStore.positions(for: location)) { placed in
                    if let player = characterStore.player(by: placed.playerID) {
                        DraggablePlayer(
                            placed: placed,
                            player: player,
                            geoSize: geo.size,
                            floorZone: floorZone,
                            onMove: { x, y in
                                let updated = PlacedPlayer(
                                    id: placed.id,
                                    playerID: placed.playerID,
                                    locationRaw: placed.locationRaw,
                                    x: x,
                                    y: y
                                )
                                worldStore.setPosition(updated, in: location)
                            },
                            onTap: {
                                selectedPlayer = player
                            }
                        )
                    }
                }

                topBar
                bottomBar

                if let snackbar {
                    VStack {
                        Spacer()
                        Text(snackbar)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.black.opacity(0.8))
                            .clipShape(Capsule())
                            .padding(.bottom, 90)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            seedMissingCharacters()
        }
        .onChange(of: characterStore.players) { _ in
            seedMissingCharacters()
        }
        .sheet(isPresented: $showCatalog) {
            ItemCatalogView(location: location) { catalog in
                let c = floorZone.center
                let placed = PlacedItem(catalogID: catalog.id, x: c.x, y: c.y)
                worldStore.addItem(placed, to: location)
                showSnackbar("\(catalog.name) добавлен")
            }
            .environmentObject(worldStore)
        }
        .sheet(isPresented: $showCharacters) {
            CharacterListSheet()
                .environmentObject(characterStore)
                .environmentObject(worldStore)
        }
        .sheet(item: $selectedPlayer) { player in
            PlayerDetailView(player: player)
                .environmentObject(characterStore)
                .environmentObject(worldStore)
        }
    }

    // MARK: - Добавление отсутствующих персонажей

    /// Добавляет в локацию всех персонажей из хранилища,
    /// которых здесь ещё нет. Ничего не удаляет и не двигает существующих.
    private func seedMissingCharacters() {
        let allPlayers = characterStore.players
        guard !allPlayers.isEmpty else { return }

        let existing = worldStore.positions(for: location)
        let existingIDs = Set(existing.map { $0.playerID })

        let missing = allPlayers.filter { !existingIDs.contains($0.id) }
        guard !missing.isEmpty else { return }

        let zone = floorZone

        for (index, player) in missing.enumerated() {
            let totalSlots = existing.count + missing.count
            let slotIndex = existing.count + index

            let step = (zone.xMax - zone.xMin) / Double(totalSlots + 1)
            let x = zone.xMin + step * Double(slotIndex + 1)
            let y = zone.center.y

            let placed = PlacedPlayer(
                playerID: player.id,
                locationRaw: location.rawValue,
                x: x,
                y: y
            )
            worldStore.setPosition(placed, in: location)
        }
    }

    // MARK: - Поиск CatalogItem

    private func catalogItem(for id: String) -> CatalogItem? {
        ItemCatalog.all.first { $0.id == id }
    }

    // MARK: - Верхний бар

    private var topBar: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.bold())
                        .foregroundColor(Color(hex: "#111827"))
                        .frame(width: 44, height: 44)
                        .background(.white.opacity(0.92))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 6)
                }

                Text(location.rawValue)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(.white.opacity(0.92))
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.1), radius: 6)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)

            Spacer()
        }
    }

    // MARK: - Нижние кнопки

    private var bottomBar: some View {
        VStack {
            Spacer()
            HStack(spacing: 12) {
                Button {
                    showCatalog = true
                } label: {
                    Label("Предмет", systemImage: "plus")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .background(.white.opacity(0.92))
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.12), radius: 8)
                }

                Button {
                    showCharacters = true
                } label: {
                    Label(
                        "Персонажи (\(worldStore.positions(for: location).count))",
                        systemImage: "person.2.fill"
                    )
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#111827"))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(.white.opacity(0.92))
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.12), radius: 8)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }

    // MARK: - Snackbar

    private func showSnackbar(_ text: String) {
        withAnimation(AppAnimation.snackbar) {
            snackbar = text
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(AppAnimation.snackbar) {
                snackbar = nil
            }
        }
    }
}

// MARK: - Перетаскиваемый предмет

private struct DraggableItem: View {
    let item: PlacedItem
    let catalog: CatalogItem
    let geoSize: CGSize
    let floorZone: FloorZone
    let onMove: (Double, Double) -> Void
    let onDelete: () -> Void

    @State private var dragOffset: CGSize = .zero
    @State private var dragging: Bool = false

    var body: some View {
        ItemOnSceneView(catalog: catalog, isDragging: dragging)
            .position(
                x: CGFloat(item.x) * geoSize.width + dragOffset.width,
                y: CGFloat(item.y) * geoSize.height + dragOffset.height
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragging = true
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        let newX = (CGFloat(item.x) * geoSize.width + value.translation.width) / geoSize.width
                        let newY = (CGFloat(item.y) * geoSize.height + value.translation.height) / geoSize.height
                        let c = floorZone.clamp(x: Double(newX), y: Double(newY))
                        onMove(c.x, c.y)
                        dragOffset = .zero
                        dragging = false
                    }
            )
            .onTapGesture(count: 2) {
                onDelete()
            }
            .zIndex(dragging ? 100 : 0)
    }
}

// MARK: - Перетаскиваемый персонаж

private struct DraggablePlayer: View {
    let placed: PlacedPlayer
    let player: Player
    let geoSize: CGSize
    let floorZone: FloorZone
    let onMove: (Double, Double) -> Void
    let onTap: () -> Void

    @State private var dragOffset: CGSize = .zero
    @State private var dragging: Bool = false

    var body: some View {
        AvatarView(player: player, size: 180)
            .position(
                x: CGFloat(placed.x) * geoSize.width + dragOffset.width,
                y: CGFloat(placed.y) * geoSize.height + dragOffset.height
            )
            .gesture(
                DragGesture(minimumDistance: 6)
                    .onChanged { value in
                        dragging = true
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        let newX = (CGFloat(placed.x) * geoSize.width + value.translation.width) / geoSize.width
                        let newY = (CGFloat(placed.y) * geoSize.height + value.translation.height) / geoSize.height
                        let c = floorZone.clamp(x: Double(newX), y: Double(newY))
                        onMove(c.x, c.y)
                        dragOffset = .zero
                        dragging = false
                    }
            )
            .onTapGesture {
                if !dragging { onTap() }
            }
            .scaleEffect(dragging ? 1.05 : 1.0)
            .zIndex(dragging ? 100 : 0)
    }
}
