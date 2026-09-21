import SwiftUI

struct AvatarView: View {

    let player: Player
    var size: CGFloat = 200

    var body: some View {
        ZStack {
            if let imageName = player.imageName,
               let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                TocaAvatar(player: player, size: size)
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Toca Boca рендер

struct TocaAvatar: View {

    let player: Player
    let size: CGFloat

    private var W: CGFloat { size }
    private var H: CGFloat { size }

    private var headCenterYRatio: CGFloat { 0.30 }
    private var headHeightRatio: CGFloat { 0.55 }
    private var headWidthRatio: CGFloat { 0.55 }

    private var headSize: CGFloat {
        H * headHeightRatio * player.ageGroup.headMultiplier
    }
    private var headCY: CGFloat {
        H * headCenterYRatio
    }

    var body: some View {
        ZStack {
            // Тень на земле
            Ellipse()
                .fill(Color.black.opacity(0.12))
                .frame(width: W * 0.35, height: H * 0.025)
                .position(x: W / 2, y: H * 0.99)

            // Тело + ноги + руки
            AvatarBody(player: player, size: size)

            // Голова
            AvatarHead(
                player: player,
                headSize: headSize,
                headCY: headCY,
                canvasW: W
            )

            // Задние длинные волосы
            AvatarHair(
                player: player,
                headSize: headSize,
                headCY: headCY,
                canvasW: W
            )

            // Аксессуар
            AvatarAccessories(
                player: player,
                headSize: headSize,
                headCY: headCY,
                canvasW: W
            )
        }
        .frame(width: W, height: H)
        .scaleEffect(player.ageGroup.bodyScale)
    }
}
