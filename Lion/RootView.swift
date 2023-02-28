// RootView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import BackgroundTasks
import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: StoreOf<Root>

    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        WithViewStore(store) { viewStore in
            Group {
                if viewStore.passwordLock.isPasswordUnlockPresented {
                    PasswordUnlockView(
                        store: store.scope(
                            state: \.passwordLock,
                            action: Root.Action.passwordLock
                        )
                    )
                } else if !viewStore.isIntroduceRead {
                    IntroduceView(store: store)
                } else if viewStore.needRequestScreenTimeAccessPermission {
                    GrantAccessView(store: store)
                } else {
                    appMainView
                }
            }
            .onAppear {
                viewStore.send(.appLaunched)
            }
            .onChange(of: scenePhase) { newValue in
                if newValue == .active {
                    viewStore.send(.requestScreenTimeAccessPermission)
                }
            }
        }
    }

    var appMainView: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                ModeSelectionView(
                    store: store
                )
            }
            .fullScreenCover(
                isPresented: viewStore.binding(
                    get: \.member.isMemberPurchasePresented,
                    send: { .member(.toggleIsMemberPurchasePresented($0)) }
                )
            ) {
                ProductPurchaseView(
                    store: store.scope(
                        state: \.member,
                        action: Root.Action.member
                    )
                )
            }
            .onAppear {
                viewStore.send(.member(.yearlyMember(.syncPurchaseStateIfNeeded)))
                viewStore.send(.member(.lifetimeMember(.syncPurchaseStateIfNeeded)))
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            store: Store(
                initialState: .default,
                reducer: Root()
            )
        ).environment(\.locale, .init(identifier: "zh_CN"))
    }
}
