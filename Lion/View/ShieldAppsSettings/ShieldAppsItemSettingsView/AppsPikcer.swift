// AppsPikcer.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/28.

import ComposableArchitecture
import FamilyControls
import SwiftUI

struct AppsPicker: View {
    let store: StoreOf<AppsSelection>

    func selectionTip(selectedAmount: Int, maxSelectedAmount: Int) -> LocalizedStringKey {
        selectedAmount <= maxSelectedAmount
            ? .nOfAppsSelected(selectedAmount)
            : .nOfAppsSelected(selectedAmount, exceeds: maxSelectedAmount)
    }

    func tipColor(selectedAmount: Int, maxSelectedAmount: Int) -> Color {
        selectedAmount <= maxSelectedAmount
            ? .secondary
            : .red
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                Text(
                    selectionTip(
                        selectedAmount: viewStore.appTokens.count,
                        maxSelectedAmount: viewStore.maxSelectAmount
                    )
                )
                .font(.lion.caption2Bold)
                .foregroundColor(
                    tipColor(
                        selectedAmount: viewStore.appTokens.count,
                        maxSelectedAmount: viewStore.maxSelectAmount
                    )
                )
                .padding([.top, .horizontal])
                .frame(maxWidth: .infinity, alignment: .leading)
                FamilyActivityPicker(
                    selection: viewStore.binding(
                        get: { $0.selection },
                        send: AppsSelection.Action.update
                    )
                )
                .ignoresSafeArea()
                .navigationBarTitle(
                    .selectApps,
                    displayMode: .inline
                )
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(.cancel) {
                            viewStore.send(.toggleIsPresented(false))
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(.done) {
                            viewStore.send(.toggleIsPresented(false))
                        }
                        .fontWeight(.semibold)
                        .disabled(viewStore.appTokens.count > viewStore.maxSelectAmount)
                    }
                }
            }
        }
    }
}

struct AppsPicker_Previews: PreviewProvider {
    static var previews: some View {
        AppsPicker(
            store: Store(
                initialState: .none,
                reducer: AppsSelection()
            )
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
