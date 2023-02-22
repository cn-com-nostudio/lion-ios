// ShieldAppsItemPlaceholder.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/1/28.

import SwiftUI

struct ShieldAppsItemPlaceholder: View {
    var addAction: () -> Void

    var body: some View {
        VStack(spacing: 45) {
            VStack(spacing: 8) {
                Text(.shieldApps)
                    .foregroundColor(.primary)
                    .font(.lion.title2)
                Text(.limitAppsOpenTip)
                    .foregroundColor(.secondary)
                    .font(.lion.caption1)
            }

            Button(
                action: addAction,
                label: {
                    Text(.startSetting)
                        .frame(width: 230, height: 60)
                }
            )
            .buttonStyle(PrimaryButton())
        }
    }
}

struct ShieldAppsItemPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        ShieldAppsItemPlaceholder(
            addAction: {}
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
