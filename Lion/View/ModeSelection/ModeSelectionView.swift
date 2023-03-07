// ModeSelectionView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/7.

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
                                root: store,
                                store: store.scope(
                                    state: \.childMode,
                                    action: Root.Action.childMode
                                ),
                                header: ModeHeaders[viewStore.childMode]
                            )

                            ModePreview(
                                root: store,
                                store: store.scope(
                                    state: \.loanMode,
                                    action: Root.Action.loanMode
                                ),
                                header: ModeHeaders[viewStore.loanMode]
                            )
                            .fullScreenCover(
                                isPresented: viewStore.binding(
                                    get: \.products.isMemberPurchasePresented,
                                    send: { .products(.toggleIsMemberPurchasePresented($0)) }
                                )
                            ) {
                                ProductPurchaseView(
                                    store: store.scope(
                                        state: \.products,
                                        action: Root.Action.products
                                    )
                                )
                            }
                        }
                    }

                    VStack {
                        topBar(isMember: viewStore.products.isMember) {
                            viewStore.send(.products(.toggleIsMemberPurchasePresented(true)))
                        }
                        .padding(.horizontal, 20)
                        Spacer()
                        bottomBar {
                            viewStore.send(.toggleIsMorePageShow(true))
                        }
                        .padding(.horizontal, 32)
                    }
                }
            }
            .fullScreenCover(
                isPresented: viewStore.binding(
                    get: \.isMorePageShow,
                    send: Root.Action.toggleIsMorePageShow
                )
            ) {
                MoreView(store: store)
            }
        }
    }

    func topBar(isMember: Bool, beAMemberAction: @escaping () -> Void) -> some View {
        HStack {
            Image(.cat)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 60)

            Spacer()

            if !isMember {
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    beAMemberAction()
                } label: {
                    HStack {
                        Image(.beAMember)
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

    func bottomBar(settingsAction: @escaping () -> Void) -> some View {
        HStack {
            NavigationLink {
                WebView(url: MoreItem.quickHelp().link)
                    .navigationTitle(.quickHelp)
                    .onAppear {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
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
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                settingsAction()
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
