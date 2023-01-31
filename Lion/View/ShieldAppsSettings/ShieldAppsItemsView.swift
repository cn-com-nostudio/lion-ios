// ShieldAppsItemsView.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/29.

import ComposableArchitecture
import SwiftUI

struct ShieldAppsItemsView: View {
    let store: StoreOf<ShieldAppsSettings>

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack(alignment: .leading) {
                    Text(.timeIntervalToLimitAppsOpen)
                        .foregroundColor(.secondary)
                        .font(.footnote.weight(.semibold))
                    VStack(spacing: 16) {
                        ForEachStore(
                            store.scope(
                                state: \.items,
                                action: ShieldAppsSettings.Action.items(id:action:)
                            )
                        ) { itemStore in
                            WithViewStore(itemStore) { itemViewStore in
                                ShieldAppsItemView(
                                    store: itemStore
                                )
                                .onTapGesture {
                                    viewStore.send(.selectedItem(itemViewStore.id))
                                }
                            }
                        }
                    }
                }
            }
            .sheet(
                isPresented:
                viewStore.binding(
                    get: { $0.selectedItem != nil },
                    send: .deselectedItem
                ),
                content: {
                    IfLetStore(
                        store.scope(
                            state: \.selectedItem,
                            action: ShieldAppsSettings.Action.item
                        ),
                        then: {
                            ShieldAppsItemSettingsView(
                                store: $0,
                                cancel: {
                                    viewStore.send(.deselectedItem)
                                },
                                done: {
                                    viewStore.send(.deselectedItem)
                                    viewStore.send(.updateItem($0))
                                },
                                delete: {
                                    viewStore.send(.deselectedItem)
                                    viewStore.send(.deleteItem($0))
                                }
                            )
                        }
                    )
                }
            )
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
