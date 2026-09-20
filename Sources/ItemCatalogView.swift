import SwiftUI

struct ItemCatalogView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var worldStore: WorldStore
    let location: LocationID
    let onSelect: (CatalogItem) -> Void

    @State private var selectedCategory: ItemCategory = .furniture

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#FDF6EC").ignoresSafeArea()

                VStack(spacing: 0) {
                    // Табы категорий
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(ItemCategory.allCases, id: \.self) { cat in
                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedCategory = cat
                                    }
                                } label: {
                                    Text(cat.rawValue)
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(selectedCategory == cat ? .white : Color(hex: "#4B5563"))
                                        .padding(.horizontal, 16).padding(.vertical, 10)
                                        .background(
                                            Capsule().fill(selectedCategory == cat ? Color(hex: "#3B82F6") : Color.white)
                                        )
                                        .shadow(color: .black.opacity(0.05), radius: 3, y: 2)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }

                    // Сетка
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ], spacing: 12) {
                            ForEach(ItemCatalog.all.filter { $0.category == selectedCategory }) { item in
                                Button {
                                    onSelect(item)
                                    dismiss()
                                } label: {
                                    VStack(spacing: 6) {
                                        Text(item.emoji)
                                            .font(.system(size: 44))
                                            .frame(height: 60)
                                        Text(item.name)
                                            .font(.system(size: 11, weight: .medium, design: .rounded))
                                            .foregroundColor(Color(hex: "#374151"))
                                            .lineLimit(1)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.white))
                                    .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Выбери предмет")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Закрыть") { dismiss() }
                        .foregroundColor(Color(hex: "#3B82F6"))
                }
            }
        }
    }
}
