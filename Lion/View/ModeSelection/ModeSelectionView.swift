// ModeSelectionView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/1/28.

import ComposableArchitecture
import FamilyControls
import ManagedSettings
import SwiftUI

struct ModeSelectionView: View {
    let store: StoreOf<Root>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                ZStack {
                    Image(.background)
                        .resizable()
                        .ignoresSafeArea()
                    PagingView(config: .init(margin: 50, spacing: 30)) {
                        Group {
                            ModePreview(
                                store: store.scope(
                                    state: \.childMode,
                                    action: Root.Action.childMode
                                ),
                                header: ModeHeaders[viewStore.childMode],
                                action: {
                                    if viewStore.loanMode.isOn {
                                        viewStore.send(.loanMode(.toggleIsOn(false)))
                                    }
                                    viewStore.send(.childMode(.toggleIsOn(!viewStore.childMode.isOn)))
                                }
                            )

                            ModePreview(
                                store: store.scope(
                                    state: \.loanMode,
                                    action: Root.Action.loanMode
                                ),
                                header: ModeHeaders[viewStore.loanMode],
                                action: {
                                    if viewStore.childMode.isOn {
                                        viewStore.send(.childMode(.toggleIsOn(false)))
                                    }
                                    viewStore.send(.loanMode(.toggleIsOn(!viewStore.loanMode.isOn)))
                                }
                            )
                        }
                        .aspectRatio(0.6, contentMode: .fit)
                    }
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Image(.hiddingCat)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 24)

                                Spacer()

                                if viewStore.member.isMember {
                                    Image(.pro)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 24)
                                } else {
                                    Button {
                                        viewStore.send(.member(.toggleIsMemberPurchasePresented(true)))
                                    } label: {
                                        HStack {
                                            Image(.beMember)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)

                                            Image(.pro)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        .frame(height: 24)
                                    }
                                }
                            }
                        }
                    }
                }

                HStack {
                    NavigationLink {
                        WebView(url: MoreItem.quickHelp().link)
                            .navigationTitle(.quickHelp)
                    } label: {
                        VStack {
                            Image(.boat)
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text(.quickHelp)
                        }
                    }

                    Spacer()

                    Button {
                        viewStore.send(.toggleIsMorePageShow(true))
                    } label: {
                        VStack {
                            Image(.settings)
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text(.settings)
                        }
                    }
                }
                .font(.lion.caption2)
                .foregroundColor(.lion.secondary)
                .padding(.horizontal, .two)
            }
            .fullScreenCover(
                isPresented: viewStore.binding(
                    get: \.isMorePageShow,
                    send: Root.Action.toggleIsMorePageShow
                )) {
                    MoreView(
                        store: store
                    )
            }
        }
    }
}

struct ModeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ModeSelectionView(
            store: Store(
                initialState: .default,
                reducer: Root()
            )
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
        .previewDisplayName("ModeSelectionView")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
