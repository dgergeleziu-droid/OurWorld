import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var store: CharacterStore
    @State private var showCreator = false
    @State private var showDebug = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#FDF6EC").ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 26) {

                        // Заголовок
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Наш Мир")
                                .font(.system(size: 38, weight: .heavy, design: .rounded))
                                .foregroundColor(Color(hex: "#111827"))
                            Text("Песочница для двоих")
                                .font(.system(size: 15, design: .rounded))
                                .foregroundColor(Color(hex: "#6B7280"))
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)

                        // Персонажи
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text("Персонажи")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(hex: "#111827"))
                                Spacer()
                                Button {
                                    showCreator = true
                                } label: {
                                    HStack(spacing: 5) {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Создать")
                                    }
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 14).padding(.vertical, 9)
                                    .background(Color(hex: "#3B82F6"))
                                    .cornerRadius(22)
                                }
                            }
                            .padding(.horizontal, 20)

                            if store.players.isEmpty {
                                emptyPlayersView
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 14) {
                                        ForEach(store.players) { player in
                                            NavigationLink {
                                                PlayerDetailView(player: player)
                                            } label: {
                                                PlayerCard(player: player)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                        }

                        // Локации
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Локации")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "#111827"))
                                .padding(.horizontal, 20)

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                                ForEach(LocationID.allCases) { loc in
                                    NavigationLink {
                                        LocationView(location: loc)
                                    } label: {
                                        LocationCard(location: loc)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 40)
                    }
                }

                // 🔴 КНОПКА ДИАГНОСТИКИ — правый нижний угол
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            showDebug = true
                        } label: {
                            Image(systemName: "ladybug.fill")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Circle().fill(Color.red))
                                .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showCreator) {
            CharacterCreatorView()
                .environmentObject(store)
        }
        .sheet(isPresented: $showDebug) {
            DebugView()
                .environmentObject(store)
        }
    }

    var emptyPlayersView: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.crop.circle.badge.plus")
                .font(.system(size: 44))
                .foregroundColor(Color(hex: "#D1D5DB"))
            Text("Пока никого нет — создай первого персонажа")
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(Color(hex: "#6B7280"))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 34)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
        .padding(.horizontal, 20)
    }
}

struct PlayerCard: View {
    let player: Player

    var body: some View {
        VStack(spacing: 8) {
            AvatarView(player: player, size: 110)
            Text(player.name)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
                .lineLimit(1)
            if player.voiceFileName != nil {
                HStack(spacing: 3) {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 9))
                    Text("голос")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                }
                .foregroundColor(Color(hex: "#22C55E"))
            }
        }
        .frame(width: 140, height: 180)
        .background(RoundedRectangle(cornerRadius: 22).fill(Color.white))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

struct LocationCard: View {
    let location: LocationID

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(hex: location.color).opacity(0.15))
                    .frame(width: 76, height: 76)
                Image(systemName: location.icon)
                    .font(.system(size: 32))
                    .foregroundColor(Color(hex: location.color))
            }
            Text(location.rawValue)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(Color(hex: "#111827"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 22)
        .background(RoundedRectangle(cornerRadius: 22).fill(Color.white))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}
