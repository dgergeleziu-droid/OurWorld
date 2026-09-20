import SwiftUI

struct LocationView: View {
    @EnvironmentObject var store: CharacterStore
    let location: LocationID

    @State private var activeIndex: Int = 0
    @State private var positions: [UUID: CGPoint] = [:]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LocationBackground(location: location)

                ForEach(Array(store.players.enumerated()), id: \.element.id) { idx, player in
                    let pos = positions[player.id] ?? defaultPosition(for: idx, in: geo.size)

                    AvatarView(player: player, size: 90)
                        .position(pos)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                activeIndex = idx
                            }
                            if let v = player.voiceFileName {
                                AudioManager.shared.playVoice(fileName: v)
                            }
                        }
                        .overlay(
                            Circle()
                                .stroke(activeIndex == idx ? Color.white : Color.clear, lineWidth: 3)
                                .frame(width: 100, height: 100)
                                .shadow(color: .black.opacity(0.25), radius: 3)
                                .position(pos)
                                .allowsHitTesting(false)
                        )
                }

                VStack {
                    Spacer()
                    if !store.players.isEmpty {
                        HStack(spacing: 8) {
                            Image(systemName: "hand.tap.fill")
                                .foregroundColor(.white)
                            Text("Тапни по месту — \(activeName) пойдёт туда")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16).padding(.vertical, 10)
                        .background(Color.black.opacity(0.55))
                        .cornerRadius(22)
                        .padding(.bottom, 30)
                    }
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { value in
                        moveActive(to: value.location)
                    }
            )
        }
        .navigationTitle(location.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if store.players.isEmpty {
                VStack(spacing: 14) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 54))
                        .foregroundColor(Color(hex: "#D1D5DB"))
                    Text("Сначала создай персонажа")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                    Text("Вернись в меню и нажми «Создать»")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(Color(hex: "#6B7280"))
                }
                .padding(30)
                .background(RoundedRectangle(cornerRadius: 22).fill(Color.white))
                .shadow(color: .black.opacity(0.15), radius: 20)
                .padding(40)
            }
        }
    }

    var activeName: String {
        guard !store.players.isEmpty else { return "персонаж" }
        let idx = min(activeIndex, store.players.count - 1)
        return store.players[idx].name
    }

    func moveActive(to point: CGPoint) {
        guard !store.players.isEmpty else { return }
        let idx = min(activeIndex, store.players.count - 1)
        let id = store.players[idx].id
        withAnimation(.easeInOut(duration: 0.55)) {
            positions[id] = point
        }
    }

    func defaultPosition(for index: Int, in size: CGSize) -> CGPoint {
        CGPoint(x: size.width / 2 + CGFloat(index) * 70 - 35,
                y: size.height / 2)
    }
}
