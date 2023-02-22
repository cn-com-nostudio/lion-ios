// CheckListView.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/29.

import ComposableArchitecture
import SwiftUI

struct CheckListView: View {
    let store: StoreOf<ModeSettings>

    var body: some View {
        WithViewStore(store) { viewStore in
            HStack(alignment: .top, spacing: 50) {
                VStack(alignment: .leading, spacing: 6) {
                    CheckListRow(
                        name: .denyAppRemoval,
                        isChecked: viewStore.isDenyAppRemoval
                    )
                    CheckListRow(
                        name: .denyAppInstallation,
                        isChecked: viewStore.isDenyAppInstallation
                    )
                    CheckListRow(
                        name: .blockWebs,
                        isChecked: false
                    )
                }

                VStack(alignment: .leading, spacing: 6) {
                    CheckListRow(
                        name: .shieldApps,
                        isChecked: viewStore.isShieldApps
                    )
                    CheckListRow(
                        name: .blockApps,
                        isChecked: viewStore.isBlockApps
                    )
                }
            }
            .foregroundColor(.gray)
            .font(.lion.caption2)
        }
    }
}

struct CheckListRow: View {
    let name: LocalizedStringKey
    let isChecked: Bool

    var body: some View {
        HStack {
            Image(systemIcon: .checkmarkCircleFill)
                .foregroundColor(isChecked ? .green : Color(.systemGray5))
            Text(name)
                .lineLimit(1)
        }
    }
}

struct CheckListView_Previews: PreviewProvider {
    static var previews: some View {
        CheckListView(
            store: Store(
                initialState: ModeSettings.State.child,
                reducer: ModeSettings()
            )
        )
        .border(.red)
        .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
        .previewDisplayName("CehckListView")
        .environment(\.locale, .init(identifier: "zh_CN"))
//        .padding(70)
//        .aspectRatio(0.8, contentMode: .fit)
    }
}
