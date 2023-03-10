// ModeSettingsView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import FamilyControls
import SwiftUI

struct ModeSettingsView: View {
    let store: StoreOf<ModeSettings>
    let header: ModeHeader

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                ZStack(alignment: .topTrailing) {
                    ScrollView {
                        VStack(spacing: 0) {
                            ModeSettingsHeaderView(
                                header: header,
                                store: store
                            )
                            .frame(height: 420)

                            VStack(alignment: .leading) {
                                NavigationLink {
                                    WebView(url: MoreItem.quickHelp().link)
                                        .navigationTitle(.quickHelp)
                                } label: {
                                    HStack {
                                        Text(header.aboutTip)
                                            .font(.lion.caption1)
                                        Image(systemIcon: .questionmarkCircle)
                                    }
                                    .foregroundColor(.secondary)
                                }

                                ModeItemsView(
                                    store: store
                                )
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical)
                        }
                    }
                    .ignoresSafeArea(edges: .top)
                    .scrollIndicators(.hidden)

                    CloseButton {
                        viewStore.send(.toggleIsPresented(false))
                    }
                    .padding(.trailing)
                    .statusBarHidden(true)
                }
            }
            .sheet(isPresented: viewStore.binding(
                get: \.showDenyAppInstallationTip,
                send: ModeSettings.Action.toggleShowDenyAppInstallationTip
            )) {
                DenyAppInstallationTipView {
                    viewStore.send(.toggleShowDenyAppInstallationTip(false))
                }
                .presentationDetents([.medium, .height(360)])
            }
            .sheet(isPresented: viewStore.binding(
                get: \.showBlockAppTip,
                send: ModeSettings.Action.toggleShowBlockAppTip
            )) {
                DenyAppRemovalTipView {
                    viewStore.send(.toggleShowBlockAppTip(false))
                    viewStore.send(.blockAppsSettings(.updateIsPresented(true)))
                }
                .presentationDetents([.medium, .height(400)])
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
