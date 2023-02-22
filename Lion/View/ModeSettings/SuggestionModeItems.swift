// SuggestionModeItems.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

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
                    HStack(spacing: 32) {
                        Image(systemIcon: .hourglass)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(.denyAppInstallation)
                                .foregroundColor(.lion.primary)
                                .font(.lion.headline)
                            Text(.denyAppInstallationTip)
                                .foregroundColor(.lion.secondary)
                                .font(.lion.caption1)
                        }
                    }
                    HStack(spacing: 32) {
                        Image(systemIcon: .hourglass)
                            .font(.lion.largeTitle)
                            .foregroundColor(.blue)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(.denyAppInstallation)
                                .foregroundColor(.lion.primary)
                                .font(.lion.headline)
                            Text(.denyAppRemovalTip)
                                .foregroundColor(.lion.secondary)
                                .font(.lion.caption1)
                        }
                    }.padding()
                }
            }
        }
    }
}

private struct DenyAppInstallationItem: View {
    var body: some View {
        HStack(spacing: 32) {
            Image(systemIcon: .hourglass)
                .font(.lion.largeTitle)
                .foregroundColor(.blue)

            VStack(alignment: .leading, spacing: 4) {
                Text(.denyAppInstallation)
                    .foregroundColor(.lion.primary)
                    .font(.lion.headline)
                Text(.denyAppRemovalTip)
                    .foregroundColor(.lion.secondary)
                    .font(.lion.caption1)
            }
        }
    }
}

struct SuggestionModeItems_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionModeItems(mode: .child)
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
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
