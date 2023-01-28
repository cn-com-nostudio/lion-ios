// ModeItemsView.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/28.

import ComposableArchitecture
import FamilyControls
import SwiftUI

struct ModeItemsView: View {
    let store: StoreOf<ModeSettings>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 16) {
                ModeItemView(
                    item: ModeItems.blockApps(
                        subSettingsTip: .nOfBlockedApps(viewStore.blockAppsSettings.appTokens.count)
                    ),
                    isOn: viewStore.binding(
                        get: \.isBlockApps,
                        send: ModeSettings.Action.toggleIsBlockApps
                    ),
                    settingsAction: {
                        viewStore.send(.blockAppsSettings(.toggleIsPresented(true)))
                    }
                )
                .sheet(
                    isPresented: viewStore.binding(
                        get: \.blockAppsSettings.isPresented,
                        send: { .blockAppsSettings(.toggleIsPresented($0)) }
                    )
                ) {
                    AppsPicker(
                        store: store.scope(
                            state: \.blockAppsSettings,
                            action: ModeSettings.Action.blockAppsSettings
                        )
                    )
                }

                ModeItemView(
                    item: ModeItems.denyAppRemoval,
                    isOn: viewStore.binding(
                        get: \.isDenyAppRemoval,
                        send: ModeSettings.Action.toggleIsDenyAppRemoval
                    )
                )

                ModeItemView(
                    item: ModeItems.denyAppInstallation,
                    isOn: viewStore.binding(
                        get: \.isDenyAppInstallation,
                        send: ModeSettings.Action.toggleIsDenyAppInstallation
                    )
                )

                ModeItemView(
                    item: ModeItems.shieldApps,
                    isOn: viewStore.binding(
                        get: \.isShieldApps,
                        send: ModeSettings.Action.toggleIsShieldApps
                    ),
                    settingsAction: {
                        viewStore.send(.shieldAppsSettings(.toggleIsPresented(true)))
                    }
                )
                .navigationDestination(
                    isPresented: viewStore.binding(
                        get: \.shieldAppsSettings.isPresented,
                        send: {
                            .shieldAppsSettings(.toggleIsPresented($0))
                        }
                    ),
                    destination: {
                        ShieldAppsSettingsView(
                            store: store.scope(
                                state: \.shieldAppsSettings,
                                action: ModeSettings.Action.shieldAppsSettings
                            )
                        )
                    }
                )
            }
        }
    }
}

struct ModeItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ModeItemsView(
            store: Store(
                initialState: .child,
                reducer: ModeSettings()
            )
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
