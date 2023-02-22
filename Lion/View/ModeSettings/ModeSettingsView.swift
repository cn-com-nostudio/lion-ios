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
                            .aspectRatio(1, contentMode: .fit)

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

                    CloseButton {
                        viewStore.send(.toggleIsPresented(false))
                    }
                    .padding(.trailing)
                }
            }
            .statusBar(hidden: true)
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
