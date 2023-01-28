// ModeSettingsView.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/14.

import ComposableArchitecture
import FamilyControls
import SwiftUI

struct ModeSettingsView: View {
    let store: StoreOf<ModeSettings>
    let header: ModeHeader

    var body: some View {
        WithViewStore(store) { _ in
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ModeSettingsHeaderView(
                            header: header,
                            store: store
                        )
                        .aspectRatio(0.975, contentMode: .fit)

                        HStack {
                            Text(header.aboutTip)
                                .font(.lion.caption1)
                            Image(systemIcon: .questionmarkCircle)
                        }
                        .foregroundColor(.secondary)
                        .padding([.top, .leading])

                        ModeItemsView(
                            store: store
                        )
                        .padding()
                    }
                }
            }
        }
    }
}

struct ModeSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ModeSettingsView(
            store: Store(
                initialState: .child,
                reducer: ModeSettings()
            ),
            header: ModeHeaders[.child]
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
//        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
