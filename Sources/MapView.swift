import SwiftUI

struct MapView: View {
    @EnvironmentObject var characterStore: CharacterStore
    @State private var showCharacterSheet = false
    @State private var selectedPlayer: Player? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                // Фон карты — небо
                LinearGradient(
                    colors: [Color(hex: "#A7D8F0"), Color(hex: "#E0F2FE")],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                // Облака
                Cloud().position(x: 80, y: 120)
                Cloud().scaleEffect(0.7).position(x: 280, y: 180)
                Cloud().scaleEffect(1.1).position(x: 200, y: 250)

                // Земля
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 60)
                        .fill(Color(hex: "#86EFAC"))
                        .frame(height: 260)
                        .offset(y: 60)
                }
                .ignoresSafeArea(edges: .bottom)

                ScrollView {
                    VStack(spacing: 24) {
                        // Заголовок
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Наш Мир")
                                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                                    .foregroundColor(Color(hex: "#111827"))
                                Text("Тапни по локации")
                                    .font(.system(size: 14, design: .rounded))
                                    .foregroundColor(Color(hex: "#4B5563"))
                            }
                            Spacer()
                            Button {
                                showCharacterSheet = true
                            } label: {
                                ZStack {
                                    Circle().fill(Color.white).frame(width: 52, height: 52)
                                        .shadow(color: .black.opacity(0.15), radius: 6, y: 3)
                                    Image(systemName: "person.2.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(Color(hex: "#3B82F6"))
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)

                        // Карта локаций
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 20) {
                            ForEach(LocationID.allCases) { location in
                                NavigationLink {
                                    LocationView(location: location)
                                } label: {
                                    LocationBubble(location: location)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)

                        Spacer(minLength: 40)
                    }
                }

                // Мини-персонажи сверху (кто есть в игре)
                if !characterStore.players.isEmpty {
                    VStack {
                        HStack(spacing: 10) {
                            ForEach(characterStore.players.prefix(6)) { p in
                                Button {
                                    selectedPlayer = p
                                } label: {
                                    AvatarView(player: p, size: 52)
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showCharacterSheet) {
            CharacterListSheet()
                .environmentObject(characterStore)
        }
        .sheet(item: $selectedPlayer) { p in
            PlayerDetailView(player: p)
                .environmentObject(characterStore)
        }
    }
}

struct LocationBubble: View {
    let location: LocationID

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color(hex: location.color))
                    .frame(width: 110, height: 110)
                    .shadow(color: Color(hex: location.color).opacity(0.4), radius: 12, y: 6)

                Circle()
                    .stroke(Color.white, lineWidth: 5)
                    .frame(width: 110, height: 110)

                Image(systemName: location.icon)
                    .font(.system(size: 44))
                    .foregroundColor(.white)
            }
            Text(location.rawValue)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
        }
    }
}

struct Cloud: View {
    var body: some View {
        ZStack {
            Circle().fill(.white).frame(width: 40, height: 40).offset(x: -22)
            Circle().fill(.white).frame(width: 55, height: 55)
            Circle().fill(.white).frame(width: 40, height: 40).offset(x: 22)
        }
        .opacity(0.9)
    }
}
