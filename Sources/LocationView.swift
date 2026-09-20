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

                // === Фон локации (изометрия) ===
                LocationBackground(location: location)

                // === Предметы на полу ===
                ForEach(worldStore.items(in: location)) { item in
                    DraggableItem(
                        item: item,
                        geoSize: geo.size,
                        floorZone: floorZone,
                        onMove: { x, y in
                            worldStore.moveItem(item, x: x, y: y)
                        },
                        onDelete: {
                            withAnimation(AppAnimation.fade) {
                                worldStore.removeItem(item)
                            }
                            showSnackbar("Предмет удалён")
                        }
                    )
                }

                // === Персонажи на полу ===
                ForEach(worldStore.players(in: location)) { placed in
                    if let player = characterStore.player(by: placed.playerID) {
                        DraggablePlayer(
                            placed: placed,
                            player: player,
                            geoSize: geo.size,
                            floorZone: floorZone,
                            onMove: { x, y in
                                worldStore.movePlayer(placed, x: x, y: y)
                            },
                            onTap: {
                                selectedPlayer = player
                            }
                        )
                    }
                }

                // === Верхний бар ===
                topBar

                // === Нижние кнопки ===
                bottomBar

                // === Snackbar ===
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
        .sheet(isPresented: $showCatalog) {
            ItemCatalogView { item in
                let c = floorZone.center
                worldStore.addItem(item, at: c.x, y: c.y, in: location)
                showSnackbar("\(item.name) добавлен")
            }
        }
        .sheet(isPresented: $showCharacters) {
            CharacterListSheet(location: location)
        }
        .sheet(item: $selectedPlayer) { player in
            PlayerDetailView(player: player)
        }
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
                        "Персонажи (\(worldStore.players(in: location).count))",
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
    let geoSize: CGSize
    let floorZone: FloorZone
    let onMove: (Double, Double) -> Void
    let onDelete: () -> Void

    @State private var dragOffset: CGSize = .zero
    @State private var dragging: Bool = false

    var body: some View {
        ItemOnSceneView(item: item)
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
            .scaleEffect(dragging ? 1.08 : 1.0)
            .zIndex(dragging ? 100 : 0)
            .animation(AppAnimation.tap, value: dragging)
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
        AvatarView(player: player)
            .frame(width: 180, height: 180)
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
            .animation(AppAnimation.tap, value: dragging)
    }
}
