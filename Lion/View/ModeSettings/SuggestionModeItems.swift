// SuggestionModeItems.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/4.

import SwiftUI

struct SuggestionModeItems: View {
    let mode: ModeSettings.State

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(.suggesionModeSettings)
            HStack {
                ForEach(mode.itemsOn.indices, id: \.self) { index in
                    let item = mode.itemsOn[index]
                    VStack(spacing: 8) {
                        Image(systemIcon: item.icon)
                            .foregroundColor(.gray)
                        Text(item.name)
                    }
                    .frame(maxWidth: .infinity)

                    if index < mode.itemsOn.count - 1 {
                        Divider()
                            .frame(height: 50)
                    }
                }
            }
            .foregroundColor(.secondary)
            .font(.callout.weight(.regular))
        }
        .foregroundColor(.primary)
        .font(.title3.weight(.medium))
    }
}

struct SuggestionModeItems_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionModeItems(mode: .child)
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
            .previewDisplayName("\(Self.self)")
            .environment(\.locale, .init(identifier: "zh_CN"))
    }
}

extension Mode {
    var itemsOn: [ModeItem] {
        var items: [ModeItem] = []
        if isDenyAppRemoval {
            items.append(ModeItems.denyAppRemoval)
        }
        if isDenyAppInstallation {
            items.append(ModeItems.denyAppInstallation)
        }
        if isBlockApps {
            items.append(ModeItems.blockApps(subSettingsTip: ""))
        }
        return items
    }
}
