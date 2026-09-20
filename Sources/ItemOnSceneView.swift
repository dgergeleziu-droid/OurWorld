import SwiftUI

struct ItemOnSceneView: View {
    let catalog: CatalogItem
    var isDragging: Bool = false

    private var itemSize: CGFloat { catalog.size * 1.8 }

    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color.black.opacity(0.15))
                .frame(width: itemSize * 0.7, height: itemSize * 0.15)
                .offset(y: itemSize * 0.4)

            if let imageName = catalog.imageName,
               let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: itemSize, height: itemSize)
            } else {
                Text(catalog.emoji)
                    .font(.system(size: itemSize * 0.7))
            }
        }
        .frame(width: itemSize, height: itemSize)
        .contentShape(Rectangle())
        .scaleEffect(isDragging ? 1.15 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isDragging)
    }
}
