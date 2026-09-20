import SwiftUI

struct LocationView: View {
    @EnvironmentObject var characterStore: CharacterStore
    @EnvironmentObject var worldStore: WorldStore
    let location: LocationID

    @State private var showCatalog = false
    @State private var draggingItemID: UUID? = nil
    @State private var draggingPlayerID: UUID? = nil
    @State private var dragOffset: CGSize = .zero
    @State private var initialPosition: CGPoint = .zero
    @State private var showCharactersPicker = false
    @State private var showSelectedPlayerSheet: Player? = nil
    @State private var snackbarMessage: String? = nil

    private let playerSize: CGFloat = 180

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LocationBackground(location: location)
                    .opacity(0.98)

                // Предметы с анимацией появления
                ForEach(Array(worldStore.items(for: location).enumerated()), id: \.element.id) { index, item in
                    if let catalog = ItemCatalog.item(byID: item.catalogID) {
                        ItemOnSceneView(catalog: catalog, isDragging: draggingItemID == item.id)
                            .position(
                                x: item.x + (draggingItemID == item.id ? dragOffset.width : 0),
                                y: item.y + (draggingItemID == item.id ? dragOffset.height : 0)
                            )
                            .gesture(
                                DragGesture(minimumDistance: 10)
                                    .onChanged { v in
                                        if draggingItemID == nil {
                                            draggingItemID = item.id
                                            initialPosition = CGPoint(x: item.x, y: item.y)
                                        }
                                        dragOffset = v.translation
                                    }
                                    .onEnded { v in
                                        var upd = item
                                        upd.x = initialPosition.x + v.translation.width
                                        upd.y = initialPosition.y + v.translation.height
                                        worldStore.updateItem(upd, in: location)
                                        draggingItemID = nil
                                        dragOffset = .zero
                                    }
                            )
                            .onTapGesture(count: 2) {
                                withAnimation(AppAnimation.fadeExit) {
                                    worldStore.removeItem(item, in: location)
                                }
                                showSnackbar("Удалено: \(catalog.name)")
                            }
                            .fadeScaleEnter()
                    }
                }

                // Персонажи
                ForEach(characterStore.players) { player in
                    let pos = position(for: player, in: geo.size)
                    AvatarView(player: player, size: playerSize, isDragging: draggingPlayerID == player.id)
                        .position(
                            x: pos.x + (draggingPlayerID == player.id ? dragOffset.width : 0),
                            y: pos.y + (draggingPlayerID == player.id ? dragOffset.height : 0)
                        )
                        .gesture(
                            DragGesture(minimumDistance: 10)
                                .onChanged { v in
                                    if draggingPlayerID == nil {
                                        draggingPlayerID = player.id
                                        initialPosition = pos
                                    }
                                    dragOffset = v.translation
                                }
                                .onEnded { v in
                                    let newX = initialPosition.x + v.translation.width
                                    let newY = initialPosition.y + v.translation.height
                                    let placed = PlacedPlayer(playerID: player.id,
                                                              locationRaw: location.rawValue,
                                                              x: newX, y: newY)
                                    worldStore.setPosition(placed, in: location)
                                    draggingPlayerID = nil
                                    dragOffset = .zero
                                }
                        )
                        .onTapGesture(count: 1) {
                            if let voice = player.voiceFileName {
                                AudioManager.shared.playVoice(fileName: voice)
                            }
                            showSelectedPlayerSheet = player
                        }
                        .fadeScaleEnter()
                }

                // Верхняя панель
                VStack {
                    HStack(spacing: 10) {
                        Spacer()
                        Button { showCharactersPicker = true } label: {
                            HStack(spacing: 5) {
                                Image(systemName: "person.2.fill")
                                Text("\(characterStore.players.count)")
                            }
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                            .padding(.horizontal, 14).padding(.vertical, 10)
                            .background(Capsule().fill(.white))
                            .shadow(color: .black.opacity(0.12), radius: 6, y: 3)
                        }
                        .buttonStyle(BounceButtonStyle())

                        Button { showCatalog = true } label: {
                            HStack(spacing: 5) {
                                Image(systemName: "plus.circle.fill")
                                Text("Предмет")
                            }
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14).padding(.vertical, 10)
                            .background(Capsule().fill(Color(hex: "#3B82F6")))
                            .shadow(color: Color(hex: "#3B82F6").opacity(0.4), radius: 6, y: 3)
                        }
                        .buttonStyle(BounceButtonStyle())
                    }
                    .padding(.horizontal, 16).padding(.top, 8)
                    Spacer()
                }

                // ===== SNACKBAR внизу (design_snackbar_in) =====
                if let msg = snackbarMessage {
                    VStack {
                        Spacer()
                        Text(msg)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20).padding(.vertical, 12)
                            .background(Capsule().fill(Color.black.opacity(0.85)))
                            .shadow(color: .black.opacity(0.3), radius: 10, y: 4)
                            .padding(.bottom, 30)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(10)
                }
            }
        }
        .navigationTitle(location.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCatalog) {
            ItemCatalogView(location: location) { catalog in
                addItemToScene(catalog: catalog)
            }
            .environmentObject(worldStore)
        }
        .sheet(isPresented: $showCharactersPicker) {
            CharacterListSheet().environmentObject(characterStore)
        }
        .sheet(item: $showSelectedPlayerSheet) { p in
            PlayerDetailView(player: p).environmentObject(characterStore)
        }
    }

    func addItemToScene(catalog: CatalogItem) {
        let size = UIScreen.main.bounds.size
        let placed = PlacedItem(
            catalogID: catalog.id,
            x: Double(size.width / 2 + CGFloat.random(in: -60...60)),
            y: Double(size.height / 2 + CGFloat.random(in: -80...80))
        )
        withAnimation(AppAnimation.fadeEnter) {
            worldStore.addItem(placed, to: location)
        }
        showSnackbar("Добавлено: \(catalog.name)")
    }

    func showSnackbar(_ message: String) {
        withAnimation(AppAnimation.snackbar) {
            snackbarMessage = message
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(AppAnimation.fadeExit) {
                snackbarMessage = nil
            }
        }
    }

    func position(for player: Player, in size: CGSize) -> CGPoint {
        if let placed = worldStore.positions(for: location).first(where: { $0.playerID == player.id }) {
            return CGPoint(x: placed.x, y: placed.y)
        }
        return CGPoint(x: size.width / 2, y: size.height * 0.65)
    }
}
