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
                            viewStore.send(.selectNewItem)
                        }
                        .padding(.top, .two)
                    }
                    Spacer()
                }
            }
            .scrollIndicators(.hidden)
            .sheet(
                isPresented:
                viewStore.binding(
                    get: { $0.selectedItem != nil },
                    send: .deselectItem
                ),
                content: {
                    IfLetStore(
                        store.scope(
                            state: \.selectedItem,
                            action: ShieldAppsSettings.Action.selectedItem
                        ),
                        then: {
                            ShieldAppsItemSettingsView(
                                store: $0,
                                cancel: {
                                    viewStore.send(.deselectItem)
                                },
                                done: {
                                    if $0.isNew {
                                        viewStore.send(.willAddItem($0))
                                    } else {
                                        viewStore.send(.willUpdateItem($0))
                                    }
                                },
                                delete: {
                                    viewStore.send(.willDeleteItem($0))
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
                        viewStore.send(.selectNewItem)
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
                initialState: .init(isPresented: false, items: [.new, .new, .new]),
                reducer: ShieldAppsSettings()
            )
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
