// ModeSettingsView.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/4.

import ComposableArchitecture
import FamilyControls
import SwiftUI

struct ModeSettingsView: View {
    let store: StoreOf<ModeSettings>
    let header: ModeHeader

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                ScrollView {
                    VStack {
                        ModeSettingsHeaderView(
                            header: header,
                            store: store
                        )
                        .aspectRatio(0.975, contentMode: .fit)

                        SuggestionModeItems(
                            mode: viewStore.state
                        )
                        .padding()

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
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
