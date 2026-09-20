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

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LocationBackground(location: location)

                // Предметы
                ForEach(worldStore.items(for: location)) { item in
                    if let catalog = ItemCatalog.item(byID: item.catalogID) {
                        ItemOnSceneView(
                            catalog: catalog,
                            isDragging: draggingItemID == item.id
                        )
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
                                    var updated = item
                                    updated.x = initialPosition.x + v.translation.width
                                    updated.y = initialPosition.y + v.translation.height
                                    worldStore.updateItem(updated, in: location)
                                    draggingItemID = nil
                                    dragOffset = .zero
                                }
                        )
                        // 👇 УДАЛЕНИЕ: двойной тап вместо долгого нажатия
                        .onTapGesture(count: 2) {
                            worldStore.removeItem(item, in: location)
                        }
                    }
                }

                // Персонажи
                ForEach(characterStore.players) { player in
                    let pos = position(for: player, in: geo.size)

                    AvatarView(
                        player: player,
                        size: 110,
                        isDragging: draggingPlayerID == player.id
                    )
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
                                let placed = PlacedPlayer(playerID: player.id, x: newX, y: newY)
                                worldStore.setPosition(placed, in: location)
                                draggingPlayerID = nil
                                dragOffset = .zero
                            }
                    )
                    // Одиночный тап по персонажу — открывает карточку с голосом и удалением
                    .onTapGesture(count: 1) {
                        if let voice = player.voiceFileName {
                            AudioManager.shared.playVoice(fileName: voice)
                        }
                        showSelectedPlayerSheet = player
                    }
                }

                // Верхняя панель
                VStack {
                    HStack(spacing: 10) {
                        Spacer()

                        Button {
                            showCharactersPicker = true
                        } label: {
                            HStack(spacing: 5) {
                                Image(systemName: "person.2.fill")
                                Text("\(characterStore.players.count)")
                            }
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#111827"))
                            .padding(.horizontal, 14).padding(.vertical, 10)
                            .background(Capsule().fill(Color.white))
                            .shadow(color: .black.opacity(0.12), radius: 6, y: 3)
                        }

                        Button {
                            showCatalog = true
                        } label: {
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
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    Spacer()

                    // Подсказка
                    Text("Перетаскивай пальцем. Двойной тап по предмету — удалить. Тап по персонажу — карточка.")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 14).padding(.vertical, 8)
                        .background(Color.black.opacity(0.55))
                        .cornerRadius(16)
                        .padding(.bottom, 20)
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
            CharacterListSheet()
                .environmentObject(characterStore)
        }
        .sheet(item: $showSelectedPlayerSheet) { p in
            PlayerDetailView(player: p)
                .environmentObject(characterStore)
        }
    }

    func addItemToScene(catalog: CatalogItem) {
        let size = UIScreen.main.bounds.size
        let placed = PlacedItem(
            catalogID: catalog.id,
            x: Double(size.width / 2 + CGFloat.random(in: -60...60)),
            y: Double(size.height / 2 + CGFloat.random(in: -80...80))
        )
        worldStore.addItem(placed, to: location)
    }

    func position(for player: Player, in size: CGSize) -> CGPoint {
        if let placed = worldStore.positions(for: location).first(where: { $0.playerID == player.id }) {
            return CGPoint(x: placed.x, y: placed.y)
        }
        return CGPoint(x: size.width / 2, y: size.height * 0.7)
    }
}
