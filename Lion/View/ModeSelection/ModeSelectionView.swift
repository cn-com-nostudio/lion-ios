// ModeSelectionView.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/14.

import ComposableArchitecture
import FamilyControls
import ManagedSettings
import SwiftUI

struct ModeSelectionView: View {
    let store: StoreOf<Root>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                PagingView(config: .init(margin: 50, spacing: 30)) {
                    Group {
                        VStack(spacing: 50) {
                            ModePreview(
                                store: store.scope(
                                    state: \.childMode,
                                    action: Root.Action.childMode
                                ),
                                header: ModeHeaders[.child]
                            )

                            Button {
                                if viewStore.childMode.isOn {
                                    viewStore.send(.childMode(.toggleIsOn(false)))
                                } else {
                                    viewStore.send(.loanMode(.toggleIsOn(false)))
                                    viewStore.send(.childMode(.toggleIsOn(true)))
                                }
                            } label: {
                                Text(viewStore.childMode.isOn ? .stop : .start)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                            .buttonStyle(PrimaryButton())
                            .frame(width: 230)
                        }
                        VStack(spacing: 50) {
                            ModePreview(
                                store: store.scope(state: \.loanMode, action: Root.Action.loanMode),
                                header: ModeHeaders[.loan]
                            )
                            Button {
                                if viewStore.loanMode.isOn {
                                    viewStore.send(.loanMode(.toggleIsOn(false)))
                                } else {
                                    viewStore.send(.childMode(.toggleIsOn(false)))
                                    viewStore.send(.loanMode(.toggleIsOn(true)))
                                }
                            } label: {
                                Text(viewStore.loanMode.isOn ? .stop : .start)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                            .buttonStyle(PrimaryButton())
                            .frame(width: 230)
                        }
                    }
                    .aspectRatio(0.6, contentMode: .fit)
                }
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
