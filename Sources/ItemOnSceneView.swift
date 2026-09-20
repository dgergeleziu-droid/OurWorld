import SwiftUI

struct ItemOnSceneView: View {
    let catalog: CatalogItem
    var isDragging: Bool = false

    var body: some View {
        ZStack {
            // Тень
            Ellipse()
                .fill(Color.black.opacity(0.15))
                .frame(width: catalog.size * 0.7, height: catalog.size * 0.15)
                .offset(y: catalog.size * 0.4)

            if let imageName = catalog.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: catalog.size, height: catalog.size)
            } else {
                Text(catalog.emoji)
                    .font(.system(size: catalog.size * 0.7))
            }
        }
        .frame(width: catalog.size, height: catalog.size)  // ← важно: задаёт область нажатия
        .contentShape(Rectangle())                          // ← важно: делает всю область кликабельной
        .scaleEffect(isDragging ? 1.15 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isDragging)
    }
}
