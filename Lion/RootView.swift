// RootView.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/29.

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: StoreOf<Root>

    var body: some View {
        ModeSelectionView(
            store: store
        )
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
