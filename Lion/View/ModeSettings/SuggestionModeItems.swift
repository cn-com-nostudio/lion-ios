// SuggestionModeItems.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/14.

import SwiftUI

struct SuggestionModeItems: View {
    let mode: ModeSettings.State

    var body: some View {
        VStack {
            Text(LocalizedStringKey(mode.modeName))
                .font(.lion.title2)
                .foregroundColor(.lion.primary)
            VStack {
                Text(.suggesionModeSettings)
                    .font(.lion.caption1)
                    .foregroundColor(.lion.secondary)
                List {
                    <#code#>
                }
            }
        }
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
