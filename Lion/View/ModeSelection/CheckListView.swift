// CheckListView.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/28.

import ComposableArchitecture
import SwiftUI

struct CheckListView: View {
    let store: StoreOf<ModeSettings>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewSotre in
            HStack(alignment: .top, spacing: 50) {
                VStack(alignment: .leading, spacing: 5) {
                    CheckListRow(
                        name: .denyAppRemoval,
                        isChecked: viewSotre.isDenyAppRemoval
                    )
                    CheckListRow(
                        name: .denyAppInstallation,
                        isChecked: viewSotre.isDenyAppInstallation
                    )
                    CheckListRow(
                        name: .blockWebs,
                        isChecked: viewSotre.isBlockApps
                    )
                }

                VStack(alignment: .leading, spacing: 10) {
                    CheckListRow(
                        name: .shieldApps,
                        isChecked: false // viewSotre.isAntiAddictionSystemOn
                    )
                    CheckListRow(
                        name: .blockApps,
                        isChecked: false // viewSotre.isBlockWebs
                    )
                }
            }
            .foregroundColor(.gray)
            .font(.lion.caption2)
        }
    }
}

struct CheckListRow: View {
    @State var name: LocalizedStringKey
    @State var isChecked: Bool

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
