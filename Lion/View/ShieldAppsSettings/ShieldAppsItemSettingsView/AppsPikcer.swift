// AppsPikcer.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import FamilyControls
import SwiftUI

struct AppsPicker: View {
    let store: StoreOf<AppsSelection>

    @State private var selection: FamilyActivitySelection = .init(includeEntireCategory: true)

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
                        selectedAmount: selection.applicationTokens.count,
                        maxSelectedAmount: viewStore.maxSelectAmount
                    )
                )
                .font(.lion.caption2Bold)
                .foregroundColor(
                    tipColor(
                        selectedAmount: selection.applicationTokens.count,
                        maxSelectedAmount: viewStore.maxSelectAmount
                    )
                )
                .padding([.top, .horizontal])
                .frame(maxWidth: .infinity, alignment: .leading)
                FamilyActivityPicker(
                    selection: $selection
                )
                .ignoresSafeArea()
                .navigationBarTitle(
                    .selectApps,
                    displayMode: .inline
                )
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(.cancel) {
                            viewStore.send(.updateIsPresented(false))
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(.done) {
                            viewStore.send(.updateIsPresented(false))
                            viewStore.send(.update(selection))
                        }
                        .fontWeight(.semibold)
                        .disabled(selection.applicationTokens.count > viewStore.maxSelectAmount)
                    }
                }
            }
            .onAppear {
                selection.applicationTokens = viewStore.appTokens
                selection.categoryTokens = viewStore.categoryTokens
            }
        }
    }
}

struct AppsPicker_Previews: PreviewProvider {
    static var previews: some View {
        AppsPicker(
            store: Store(
                initialState: .init(isPresented: false),
                reducer: AppsSelection()
            )
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
