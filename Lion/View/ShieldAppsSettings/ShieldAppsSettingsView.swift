// ShieldAppsSettingsView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import SwiftUI

struct ShieldAppsSettingsView: View {
    let store: StoreOf<ShieldAppsSettings>

    func startSettingButton(_ action: @escaping () -> Void) -> some View {
        Button(
            action: action,
            label: {
                Text(.startSetting)
                    .frame(width: 230, height: 60)
            }
        )
        .buttonStyle(PrimaryButton())
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack {
                    Image(.games)
                        .resizable()
                        .frame(width: 230, height: 230)
                        .frame(maxWidth: .infinity)

                    VStack(spacing: 8) {
                        Text(.shieldApps)
                            .foregroundColor(.primary)
                            .font(.lion.title2)
                        Text(.limitAppsOpenTip)
                            .foregroundColor(.secondary)
                            .font(.lion.caption1)
                    }

                    if viewStore.items.count > 0 {
                        ShieldAppsItemsView(
                            store: store
                        )
                        .padding(.top)
                        .padding(.horizontal)
                    } else {
                        startSettingButton {
                            viewStore.send(.willAddItem)
                        }
                        .padding(.top, .two)
                    }
                    Spacer()
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
                                isNewItem: viewStore.isSelectedItemANewItem,
                                cancel: {
                                    viewStore.send(.deselectedItem)
                                },
                                done: {
                                    viewStore.send(.deselectedItem)
                                    if viewStore.isSelectedItemANewItem {
                                        viewStore.send(.addItem($0))
                                    } else {
                                        viewStore.send(.updateItem($0))
                                    }
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
            .toolbar {
                ToolbarItem(
                    placement: .navigationBarTrailing)
                {
                    Button {
                        viewStore.send(.willAddItem)
                    } label: {
                        Image(systemIcon: .plus)
                    }
                }
            }
            .background(Color(.veryLightGreen))
        }
    }
}

struct ShieldAppsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ShieldAppsSettingsView(
            store: Store(
                initialState: .init(isPresented: false, items: [.default, .default, .default]),
                reducer: ShieldAppsSettings()
            )
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
