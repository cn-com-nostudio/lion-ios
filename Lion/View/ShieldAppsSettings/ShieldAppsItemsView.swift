// ShieldAppsItemsView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import SwiftUI

struct ShieldAppsItemsView: View {
    let store: StoreOf<ShieldAppsSettings>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 16) {
                ForEachStore(
                    store.scope(
                        state: \.items,
                        action: ShieldAppsSettings.Action.items(id:action:)
                    )
                ) { itemStore in
                    WithViewStore(itemStore) { itemViewStore in
                        ShieldAppsItemView(
                            store: itemStore,
                            tapAction: {
                                viewStore.send(.selectedItem(itemViewStore.id))
                            }
                        )
                    }
                }
            }
        }
    }
}

struct ShieldAppsItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ShieldAppsItemsView(
            store: Store(
                initialState: .default,
                reducer: ShieldAppsSettings()
            )
        )
        .background(Color(.veryLightGreen))
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
