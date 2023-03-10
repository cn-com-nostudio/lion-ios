// ModeItemView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import FamilyControls
import SwiftUI

extension VerticalAlignment {
    private enum HAlignment: AlignmentID {
        static func defaultValue(in dimensions: ViewDimensions) -> CGFloat {
            dimensions[.bottom]
        }
    }

    static let hAlignment = VerticalAlignment(HAlignment.self)
}

struct ModeItemView: View {
    let item: ModeItem

    @Binding var isOn: Bool
    var settingsAction: (() -> Void)?

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: item.gradient,
                startPoint: .top,
                endPoint: .bottom
            )
            HStack(alignment: .hAlignment, spacing: 10) {
                Image(systemIcon: item.icon)
                    .foregroundColor(.white)
                    .alignmentGuide(.hAlignment) { $0[VerticalAlignment.center] }
                    .font(.system(size: item.iconSize))

                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Group {
                            if item.hasToggle {
                                Toggle(item.name, isOn: $isOn)
                            } else {
                                HStack {
                                    Text(item.name)
                                        .lineLimit(1)
                                    Spacer()
                                }
                            }
                        }
                        .foregroundColor(.white)
                        .font(.lion.title2)
                        .alignmentGuide(.hAlignment) {
                            $0[VerticalAlignment.center]
                        }
                        .frame(height: 30)

                        Text(item.tip)
                            .foregroundColor(.white.opacity(0.8))
                            .font(.lion.caption1)
                            .lineLimit(1)
                    }
                    Spacer()
                    if item.hasSubSettings {
                        HStack {
                            Text(item.subSettingsTip)
                                .lineLimit(1)
                                .foregroundColor(.white.opacity(0.8))
                                .font(.lion.caption1)
                            Spacer()

                            Button(
                                action: {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    settingsAction?()
                                },
                                label: {
                                    Text(item.subSettingsName)
                                        .padding(12)
                                        .frame(height: 36)
                                }
                            )
                            .buttonStyle(SettingButton())
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 12)
        }
        .cornerRadius(16)
        .aspectRatio(2.4, contentMode: .fit)
    }
}

struct ModeItemView_Previews: PreviewProvider {
    static var previews: some View {
        ModeItemView(
            item: ModeItems.blockApps(subSettingsTip: ""),
            isOn: .constant(true)
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
        .padding(20)
    }
}
