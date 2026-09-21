import SwiftUI

struct AvatarView: View {

    let player: Player
    var size: CGFloat = 200

    var body: some View {
        ZStack {
            // Если задан PNG (Аня, Демьян) — показываем его
            if let imageName = player.imageName,
               let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                drawnAvatar
            }
        }
        .frame(width: size, height: size)
    }

    // MARK: - Нарисованный персонаж

    private var drawnAvatar: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            let age = player.ageGroup
            let bodyScale = age.bodyScale
            let headMul = age.headMultiplier

            // Пропорции (в долях от размера)
            let legRatio = age.legRatio
            let headSize = w * 0.52 * headMul
            let bodyWidth = w * 0.40
            let totalH = h * bodyScale

            ZStack {
                // Тень под ногами
                Ellipse()
                    .fill(Color.black.opacity(0.15))
                    .frame(width: w * 0.42, height: h * 0.035)
                    .position(x: w / 2, y: h * 0.97)

                // === Волосы (сзади) — если слой первый ===
                // === Одежда (сзади) — если слой первый ===
                // === Аксессуар (сзади) — если слой первый ===
                // Рисуем по порядку, соблюдая layerOrder

                ForEach(Array(player.layerOrder.enumerated()), id: \.offset) { _, slot in
                    layerView(slot: slot,
                              w: w, h: h,
                              bodyWidth: bodyWidth,
                              headSize: headSize,
                              legRatio: legRatio,
                              totalH: totalH)
                }

                // Ноги, ступни, руки — всегда поверх фона, но под одеждой верхней части
                // Рисуем их первыми, чтобы они были видны только там, где нет одежды
                // (по сути, они под всеми слоями кроме фона)
            }
            .frame(width: w, height: h)
        }
    }

    // MARK: - Слой

    @ViewBuilder
    private func layerView(slot: LayerSlot,
                           w: CGFloat, h: CGFloat,
                           bodyWidth: CGFloat,
                           headSize: CGFloat,
                           legRatio: CGFloat,
                           totalH: CGFloat) -> some View {
        switch slot {
        case .hair:
            hairLayer(w: w, h: h, headSize: headSize)
        case .outfit:
            outfitLayer(w: w, h: h, bodyWidth: bodyWidth,
                        legRatio: legRatio, headSize: headSize)
        case .accessory:
            accessoryLayer(w: w, h: h, headSize: headSize)
        }
    }

    // MARK: - Одежда (тело + ноги + руки)

    private func outfitLayer(w: CGFloat, h: CGFloat,
                             bodyWidth: CGFloat,
                             legRatio: CGFloat,
                             headSize: CGFloat) -> some View {
        let bodyTop = h * 0.5 - headSize * 0.4
        let bodyBottom = h * 0.5 + totalBodyH(h: h, legRatio: legRatio)
        let skin = Palette.skinTones[safe: player.skinTone] ?? Palette.skinTones[1]
        let outfit = Palette.outfitColors[safe: player.outfitColor] ?? Palette.outfitColors[0]

        return ZStack {
            // === Ноги (штаны/юбка или кожа) ===
            legView(w: w, h: h, legRatio: legRatio, outfit: outfit, skin: skin)

            // === Руки ===
            armView(w: w, h: h, bodyWidth: bodyWidth, bodyTop: bodyTop, skin: skin)

            // === Торс ===
            torsoView(w: w, h: h, bodyWidth: bodyWidth,
                      bodyTop: bodyTop, bodyBottom: bodyBottom,
                      outfit: outfit, skin: skin)

            // === Шея ===
            Rectangle()
                .fill(skin)
                .frame(width: w * 0.10, height: h * 0.04)
                .position(x: w / 2, y: bodyTop - h * 0.01)
        }
    }

    private func totalBodyH(h: CGFloat, legRatio: CGFloat) -> CGFloat {
        let bodyH = h * 0.42
        return bodyH * (1 - legRatio)
    }

    private func legView(w: CGFloat, h: CGFloat,
                         legRatio: CGFloat,
                         outfit: Color,
                         skin: Color) -> some View {
        let bodyBottom = h * 0.5 + totalBodyH(h: h, legRatio: legRatio)
        let legTop = bodyBottom - h * 0.02
        let legH = h * legRatio * 0.95
        let legW = w * 0.11
        let gap = w * 0.04

        let legColor = (player.outfitStyle == 2 || player.outfitStyle == 6)
            ? skin // платье/сарафан — ноги видны
            : outfit // брюки/комбинезон — ноги в одежде

        return ZStack {
            // Левая нога
            RoundedRectangle(cornerRadius: legW / 2)
                .fill(legColor)
                .frame(width: legW, height: legH)
                .position(x: w / 2 - legW / 2 - gap / 2,
                          y: legTop + legH / 2)

            // Правая нога
            RoundedRectangle(cornerRadius: legW / 2)
                .fill(legColor)
                .frame(width: legW, height: legH)
                .position(x: w / 2 + legW / 2 + gap / 2,
                          y: legTop + legH / 2)

            // Ботинки
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(hex: "#1F2937"))
                    .frame(width: legW * 1.2, height: h * 0.025)
                    .position(x: w / 2 - legW / 2 - gap / 2,
                              y: legTop + legH - h * 0.01)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(hex: "#1F2937"))
                    .frame(width: legW * 1.2, height: h * 0.025)
                    .position(x: w / 2 + legW / 2 + gap / 2,
                              y: legTop + legH - h * 0.01)
            }
        }
    }

    private func armView(w: CGFloat, h: CGFloat,
                         bodyWidth: CGFloat,
                         bodyTop: CGFloat,
                         skin: Color) -> some View {
        let armW = w * 0.085
        let armH = h * 0.28
        let armX = bodyWidth / 2 + armW * 0.6
        let armY = bodyTop + armH * 0.55

        return ZStack {
            RoundedRectangle(cornerRadius: armW / 2)
                .fill(skin)
                .frame(width: armW, height: armH)
                .position(x: w / 2 - armX, y: armY)

            RoundedRectangle(cornerRadius: armW / 2)
                .fill(skin)
                .frame(width: armW, height: armH)
                .position(x: w / 2 + armX, y: armY)

            // Кисти рук
            Circle()
                .fill(skin)
                .frame(width: armW * 1.05, height: armW * 1.05)
                .position(x: w / 2 - armX, y: armY + armH / 2 + armW * 0.3)

            Circle()
                .fill(skin)
                .frame(width: armW * 1.05, height: armW * 1.05)
                .position(x: w / 2 + armX, y: armY + armH / 2 + armW * 0.3)
        }
    }

    private func torsoView(w: CGFloat, h: CGFloat,
                           bodyWidth: CGFloat,
                           bodyTop: CGFloat,
                           bodyBottom: CGFloat,
                           outfit: Color,
                           skin: Color) -> some View {
        let bodyH = bodyBottom - bodyTop

        return RoundedRectangle(cornerRadius: bodyWidth * 0.35)
            .fill(outfit)
            .frame(width: bodyWidth, height: bodyH)
            .overlay(
                RoundedRectangle(cornerRadius: bodyWidth * 0.35)
                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
            )
            .overlay(
                VStack {
                    Spacer()
                    // Воротник
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.25))
                        .frame(width: bodyWidth * 0.35, height: 3)
                        .padding(.top, 6)
                    Spacer()
                }
            )
            .position(x: w / 2, y: bodyTop + bodyH / 2)
    }

    // MARK: - Голова

    private func hairLayer(w: CGFloat, h: CGFloat, headSize: CGFloat) -> some View {
        let headCenterY = h * 0.32
        let hairColor = Palette.hairColors[safe: player.hairColor] ?? Palette.hairColors[0]

        return ZStack {
            // Сама голова (рисуем в этом слое, чтобы волосы лежали относительно неё)
            headView(w: w, h: h, headSize: headSize, headCenterY: headCenterY)

            // Волосы
            hairView(w: w, h: h, headSize: headSize,
                     headCenterY: headCenterY, color: hairColor)
        }
    }

    private func headView(w: CGFloat, h: CGFloat,
                          headSize: CGFloat,
                          headCenterY: CGFloat) -> some View {
        let skin = Palette.skinTones[safe: player.skinTone] ?? Palette.skinTones[1]

        return ZStack {
            // Уши
            Circle()
                .fill(skin)
                .frame(width: headSize * 0.16, height: headSize * 0.16)
                .position(x: w / 2 - headSize * 0.5,
                          y: headCenterY + headSize * 0.05)
            Circle()
                .fill(skin)
                .frame(width: headSize * 0.16, height: headSize * 0.16)
                .position(x: w / 2 + headSize * 0.5,
                          y: headCenterY + headSize * 0.05)

            // Голова
            RoundedRectangle(cornerRadius: headSize * 0.42)
                .fill(skin)
                .frame(width: headSize, height: headSize * 0.95)
                .overlay(
                    RoundedRectangle(cornerRadius: headSize * 0.42)
                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                )
                .position(x: w / 2, y: headCenterY)

            // Глаза
            eyesView(headCenterY: headCenterY, headSize: headSize,
                     w: w)

            // Рот
            mouthView(headCenterY: headCenterY, headSize: headSize,
                      w: w)
        }
    }

    private func eyesView(headCenterY: CGFloat, headSize: CGFloat, w: CGFloat) -> some View {
        let eyeColor = Palette.eyeColors[safe: player.eyeColor] ?? Palette.eyeColors[0]
        let eyeY = headCenterY - headSize * 0.03
        let eyeSpacing = headSize * 0.22
        let eyeW = headSize * 0.14
        let eyeH = headSize * 0.16

        return ZStack {
            // Белки (для некоторых стилей)
            if player.eyeStyle == 0 || player.eyeStyle == 2 || player.eyeStyle == 4 {
                Capsule()
                    .fill(Color.white)
                    .frame(width: eyeW, height: eyeH)
                    .position(x: w / 2 - eyeSpacing, y: eyeY)
                Capsule()
                    .fill(Color.white)
                    .frame(width: eyeW, height: eyeH)
                    .position(x: w / 2 + eyeSpacing, y: eyeY)
            }

            // Зрачки
            Circle()
                .fill(eyeColor)
                .frame(width: eyeH * 0.85, height: eyeH * 0.85)
                .position(x: w / 2 - eyeSpacing, y: eyeY)
            Circle()
                .fill(eyeColor)
                .frame(width: eyeH * 0.85, height: eyeH * 0.85)
                .position(x: w / 2 + eyeSpacing, y: eyeY)

            // Блики
            Circle()
                .fill(Color.white)
                .frame(width: eyeH * 0.28, height: eyeH * 0.28)
                .position(x: w / 2 - eyeSpacing + 2, y: eyeY - 2)
            Circle()
                .fill(Color.white)
                .frame(width: eyeH * 0.28, height: eyeH * 0.28)
                .position(x: w / 2 + eyeSpacing + 2, y: eyeY - 2)

            // Ресницы (стиль 5)
            if player.eyeStyle == 5 {
                Capsule()
                    .fill(Color.black)
                    .frame(width: eyeW * 1.2, height: 1.5)
                    .position(x: w / 2 - eyeSpacing, y: eyeY - eyeH * 0.4)
                Capsule()
                    .fill(Color.black)
                    .frame(width: eyeW * 1.2, height: 1.5)
                    .position(x: w / 2 + eyeSpacing, y: eyeY - eyeH * 0.4)
            }
        }
    }

    private func mouthView(headCenterY: CGFloat, headSize: CGFloat, w: CGFloat) -> some View {
        let mouthY = headCenterY + headSize * 0.22
        let mouthW = headSize * 0.18

        return Group {
            switch player.mouthStyle {
            case 0: // Улыбка
                SmileShape()
                    .stroke(Color.black, lineWidth: 2)
                    .frame(width: mouthW, height: mouthW * 0.5)
                    .position(x: w / 2, y: mouthY)
            case 1: // Нейтральный
                Capsule()
                    .fill(Color.black)
                    .frame(width: mouthW * 0.7, height: 2)
                    .position(x: w / 2, y: mouthY)
            case 2: // Грустный
                SadShape()
                    .stroke(Color.black, lineWidth: 2)
                    .frame(width: mouthW, height: mouthW * 0.5)
                    .position(x: w / 2, y: mouthY)
            case 3: // Открытый
                Ellipse()
                    .fill(Color.black)
                    .frame(width: mouthW * 0.5, height: mouthW * 0.35)
                    .position(x: w / 2, y: mouthY)
            case 4: // Смех
                Ellipse()
                    .fill(Color.black)
                    .frame(width: mouthW * 0.8, height: mouthW * 0.5)
                    .position(x: w / 2, y: mouthY)
            default: // Удивление
                Circle()
                    .fill(Color.black)
                    .frame(width: mouthW * 0.3, height: mouthW * 0.3)
                    .position(x: w / 2, y: mouthY)
            }
        }
    }

    private func hairView(w: CGFloat, h: CGFloat,
                          headSize: CGFloat,
                          headCenterY: CGFloat,
                          color: Color) -> some View {
        let top = headCenterY - headSize * 0.45
        let hs = player.hairStyle

        return ZStack {
            switch hs {
            case 0: // Короткие
                RoundedRectangle(cornerRadius: headSize * 0.4)
                    .fill(color)
                    .frame(width: headSize * 1.02, height: headSize * 0.5)
                    .position(x: w / 2, y: top + headSize * 0.28)
            case 1: // Длинные
                Group {
                    RoundedRectangle(cornerRadius: headSize * 0.4)
                        .fill(color)
                        .frame(width: headSize * 1.05, height: headSize * 0.45)
                        .position(x: w / 2, y: top + headSize * 0.26)
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color)
                        .frame(width: headSize * 0.95, height: headSize * 0.7)
                        .position(x: w / 2, y: headCenterY + headSize * 0.35)
                }
            case 2: // Хвостик
                Group {
                    Circle()
                        .fill(color)
                        .frame(width: headSize * 0.45, height: headSize * 0.45)
                        .position(x: w / 2 + headSize * 0.42,
                                  y: top + headSize * 0.15)
                    RoundedRectangle(cornerRadius: headSize * 0.4)
                        .fill(color)
                        .frame(width: headSize * 1.0, height: headSize * 0.42)
                        .position(x: w / 2, y: top + headSize * 0.24)
                }
            case 3: // Два хвоста
                Group {
                    Circle()
                        .fill(color)
                        .frame(width: headSize * 0.4, height: headSize * 0.4)
                        .position(x: w / 2 - headSize * 0.5,
                                  y: top + headSize * 0.2)
                    Circle()
                        .fill(color)
                        .frame(width: headSize * 0.4, height: headSize * 0.4)
                        .position(x: w / 2 + headSize * 0.5,
                                  y: top + headSize * 0.2)
                    RoundedRectangle(cornerRadius: headSize * 0.4)
                        .fill(color)
                        .frame(width: headSize * 1.0, height: headSize * 0.42)
                        .position(x: w / 2, y: top + headSize * 0.24)
                }
            case 4: // Пучок
                Group {
                    Circle()
                        .fill(color)
                        .frame(width: headSize * 0.5, height: headSize * 0.5)
                        .position(x: w / 2, y: top - headSize * 0.05)
                    RoundedRectangle(cornerRadius: headSize * 0.4)
                        .fill(color)
                        .frame(width: headSize * 1.0, height: headSize * 0.4)
                        .position(x: w / 2, y: top + headSize * 0.24)
                }
            case 5: // Кудри
                Group {
                    ForEach(0..<5, id: \.self) { i in
                        Circle()
                            .fill(color)
                            .frame(width: headSize * 0.32,
                                   height: headSize * 0.32)
                            .position(x: w / 2 + CGFloat(i - 2) * headSize * 0.22,
                                      y: top + headSize * 0.18)
                    }
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(color)
                            .frame(width: headSize * 0.4,
                                   height: headSize * 0.35)
                            .position(x: w / 2 - headSize * 0.45,
                                      y: top + headSize * 0.5 + CGFloat(i) * headSize * 0.22)
                    }
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(color)
                            .frame(width: headSize * 0.4,
                                   height: headSize * 0.35)
                            .position(x: w / 2 + headSize * 0.45,
                                      y: top + headSize * 0.5 + CGFloat(i) * headSize * 0.22)
                    }
                }
            case 6: // Косички
                Group {
                    RoundedRectangle(cornerRadius: headSize * 0.4)
                        .fill(color)
                        .frame(width: headSize * 1.0, height: headSize * 0.42)
                        .position(x: w / 2, y: top + headSize * 0.24)
                    ForEach(0..<4, id: \.self) { i in
                        Circle()
                            .fill(color)
                            .frame(width: headSize * 0.16,
                                   height: headSize * 0.16)
                            .position(x: w / 2 - headSize * 0.45,
                                      y: top + headSize * 0.55 + CGFloat(i) * headSize * 0.14)
                    }
                    ForEach(0..<4, id: \.self) { i in
                        Circle()
                            .fill(color)
                            .frame(width: headSize * 0.16,
                                   height: headSize * 0.16)
                            .position(x: w / 2 + headSize * 0.45,
                                      y: top + headSize * 0.55 + CGFloat(i) * headSize * 0.14)
                    }
                }
            case 7: // Ирокез
                Group {
                    ForEach(0..<5, id: \.self) { i in
                        Triangle()
                            .fill(color)
                            .frame(width: headSize * 0.16,
                                   height: headSize * 0.28)
                            .position(x: w / 2 + CGFloat(i - 2) * headSize * 0.16,
                                      y: top + headSize * 0.05)
                    }
                }
            case 8: // Прямые
                Group {
                    RoundedRectangle(cornerRadius: headSize * 0.4)
                        .fill(color)
                        .frame(width: headSize * 1.05, height: headSize * 0.42)
                        .position(x: w / 2, y: top + headSize * 0.24)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                        .frame(width: headSize * 0.98, height: headSize * 0.45)
                        .position(x: w / 2, y: headCenterY + headSize * 0.35)
                }
            case 9: // Волны
                Group {
                    RoundedRectangle(cornerRadius: headSize * 0.4)
                        .fill(color)
                        .frame(width: headSize * 1.05, height: headSize * 0.45)
                        .position(x: w / 2, y: top + headSize * 0.26)
                    ForEach(0..<3, id: \.self) { i in
                        Ellipse()
                            .fill(color)
                            .frame(width: headSize * 0.85,
                                   height: headSize * 0.28)
                            .position(x: w / 2,
                                      y: headCenterY + headSize * 0.2 + CGFloat(i) * headSize * 0.28)
                    }
                }
            case 10: // Каре
                Group {
                    RoundedRectangle(cornerRadius: headSize * 0.4)
                        .fill(color)
                        .frame(width: headSize * 1.05, height: headSize * 0.5)
                        .position(x: w / 2, y: top + headSize * 0.28)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                        .frame(width: headSize * 1.02, height: headSize * 0.32)
                        .position(x: w / 2, y: headCenterY + headSize * 0.15)
                }
            default: // Лысый
                EmptyView()
            }
        }
    }

    // MARK: - Аксессуар

    private func accessoryLayer(w: CGFloat, h: CGFloat,
                                headSize: CGFloat) -> some View {
        let headCenterY = h * 0.32
        let top = headCenterY - headSize * 0.45

        return Group {
            switch player.accessory {
            case 1: // Очки
                glassesView(w: w, headCenterY: headCenterY, headSize: headSize)
            case 2: // Кепка
                capView(w: w, top: top, headSize: headSize)
            case 3: // Бант
                bowView(w: w, top: top, headSize: headSize)
            case 4: // Шляпа
                hatView(w: w, top: top, headSize: headSize)
            case 5: // Ободок
                headbandView(w: w, top: top, headSize: headSize)
            case 6: // Серёжки
                earringsView(w: w, headCenterY: headCenterY, headSize: headSize)
            case 7: // Маска
                maskView(w: w, headCenterY: headCenterY, headSize: headSize)
            default:
                EmptyView()
            }
        }
    }

    private func glassesView(w: CGFloat, headCenterY: CGFloat, headSize: CGFloat) -> some View {
        let eyeY = headCenterY - headSize * 0.03
        let r = headSize * 0.13
        let spacing = headSize * 0.22

        return ZStack {
            Circle()
                .stroke(Color.black, lineWidth: 2)
                .frame(width: r * 1.6, height: r * 1.6)
                .position(x: w / 2 - spacing, y: eyeY)
            Circle()
                .stroke(Color.black, lineWidth: 2)
                .frame(width: r * 1.6, height: r * 1.6)
                .position(x: w / 2 + spacing, y: eyeY)
            Rectangle()
                .fill(Color.black)
                .frame(width: spacing * 0.6, height: 1.5)
                .position(x: w / 2, y: eyeY)
        }
    }

    private func capView(w: CGFloat, top: CGFloat, headSize: CGFloat) -> some View {
        ZStack {
            Ellipse()
                .fill(Color(hex: "#1F2937"))
                .frame(width: headSize * 1.1, height: headSize * 0.5)
                .position(x: w / 2, y: top + headSize * 0.3)
            Path { p in
                p.move(to: CGPoint(x: 0, y: 0))
                p.addLine(to: CGPoint(x: headSize * 0.5, y: 0))
                p.addLine(to: CGPoint(x: headSize * 0.5, y: headSize * 0.12))
                p.closeSubpath()
            }
            .fill(Color(hex: "#0F172A"))
            .frame(width: headSize * 0.5, height: headSize * 0.12)
            .position(x: w / 2 + headSize * 0.3,
                      y: top + headSize * 0.42)
        }
    }

    private func bowView(w: CGFloat, top: CGFloat, headSize: CGFloat) -> some View {
        ZStack {
            Triangle()
                .fill(Color(hex: "#EC4899"))
                .frame(width: headSize * 0.22, height: headSize * 0.18)
                .rotationEffect(.degrees(90))
                .position(x: w / 2 - headSize * 0.14,
                          y: top + headSize * 0.35)
            Triangle()
                .fill(Color(hex: "#EC4899"))
                .frame(width: headSize * 0.22, height: headSize * 0.18)
                .rotationEffect(.degrees(-90))
                .position(x: w / 2 + headSize * 0.14,
                          y: top + headSize * 0.35)
            Circle()
                .fill(Color(hex: "#BE185D"))
                .frame(width: headSize * 0.08, height: headSize * 0.08)
                .position(x: w / 2, y: top + headSize * 0.35)
        }
    }

    private func hatView(w: CGFloat, top: CGFloat, headSize: CGFloat) -> some View {
        ZStack {
            // Поля
            Ellipse()
                .fill(Color(hex: "#8B5A2B"))
                .frame(width: headSize * 1.5, height: headSize * 0.18)
                .position(x: w / 2, y: top + headSize * 0.42)
            // Купол
            RoundedRectangle(cornerRadius: headSize * 0.2)
                .fill(Color(hex: "#A0704A"))
                .frame(width: headSize * 0.7, height: headSize * 0.45)
                .position(x: w / 2, y: top + headSize * 0.22)
            // Лента
            Rectangle()
                .fill(Color(hex: "#1F2937"))
                .frame(width: headSize * 0.7, height: headSize * 0.06)
                .position(x: w / 2, y: top + headSize * 0.35)
        }
    }

    private func headbandView(w: CGFloat, top: CGFloat, headSize: CGFloat) -> some View {
        Capsule()
            .fill(Color(hex: "#8B5CF6"))
            .frame(width: headSize * 1.05, height: headSize * 0.08)
            .position(x: w / 2, y: top + headSize * 0.35)
    }

    private func earringsView(w: CGFloat, headCenterY: CGFloat, headSize: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(Color(hex: "#FBBF24"))
                .frame(width: headSize * 0.08, height: headSize * 0.08)
                .position(x: w / 2 - headSize * 0.52,
                          y: headCenterY + headSize * 0.14)
            Circle()
                .fill(Color(hex: "#FBBF24"))
                .frame(width: headSize * 0.08, height: headSize * 0.08)
                .position(x: w / 2 + headSize * 0.52,
                          y: headCenterY + headSize * 0.14)
        }
    }

    private func maskView(w: CGFloat, headCenterY: CGFloat, headSize: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: "#1F2937"))
                .frame(width: headSize * 0.7, height: headSize * 0.22)
                .position(x: w / 2,
                          y: headCenterY - headSize * 0.03)
            // Прорези для глаз
            Ellipse()
                .fill(Color.white)
                .frame(width: headSize * 0.14, height: headSize * 0.07)
                .position(x: w / 2 - headSize * 0.18,
                          y: headCenterY - headSize * 0.03)
            Ellipse()
                .fill(Color.white)
                .frame(width: headSize * 0.14, height: headSize * 0.07)
                .position(x: w / 2 + headSize * 0.18,
                          y: headCenterY - headSize * 0.03)
        }
    }
}

// MARK: - Вспомогательные формы

struct SmileShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY),
            control: CGPoint(x: rect.midX, y: rect.maxY * 2)
        )
        return p
    }
}

struct SadShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY),
            control: CGPoint(x: rect.midX, y: -rect.maxY * 0.5)
        )
        return p
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

// MARK: - Безопасный доступ к массиву

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
