// ShieldAppsItemPlaceholder.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/28.

import SwiftUI

struct ShieldAppsItemPlaceholder: View {
    var add: () -> Void
    var header: some View {
        VStack(spacing: 8) {
            Text(.limitAppsOpen)
                .foregroundColor(.primary)
                .font(.title.weight(.semibold))
            Text(.limitAppsOpenTip)
                .foregroundColor(.secondary)
                .font(.callout.weight(.semibold))
        }
    }

    @ViewBuilder
    func itemPlaceholder(addAction _: () -> Void) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("9:00 - 18:00")
                    .foregroundColor(.primary)
                    .font(.title3.weight(.semibold))
                Text(.nOfApps(0))
                    .foregroundColor(.secondary.opacity(0.7))
                    .font(.callout.weight(.regular))
            }
            Spacer()
            Button(
                action: add,
                label: {
                    Text(.add)
                        .frame(width: 80, height: 40)
                }
            )
            .buttonStyle(PrimaryButton())
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }

    var body: some View {
        VStack(spacing: 36) {
            header
            itemPlaceholder {}
        }
    }
}

struct ShieldAppsItemPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        ShieldAppsItemPlaceholder(
            add: {}
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
