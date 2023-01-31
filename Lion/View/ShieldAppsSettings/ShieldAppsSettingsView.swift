// ShieldAppsSettingsView.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/29.

import ComposableArchitecture
import SwiftUI

struct ShieldAppsSettingsView: View {
    let store: StoreOf<ShieldAppsSettings>

    var header: some View {
        Image(.games)
            .resizable()
            .frame(width: 128, height: 184)
            .cornerRadius(300)
            .background(
                RoundedRectangle(cornerRadius: 300)
                    .stroke(.white, lineWidth: 6)
                    .shadow(radius: 5, x: 0, y: 3.0)
            )
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 60) {
                header
                if viewStore.items.count > 0 {
                    ShieldAppsItemsView(store: store)
                } else {
                    ShieldAppsItemPlaceholder(
                        add: {
                            viewStore.send(.addItem)
                        }
                    )
                }
                Spacer()
            }
            .padding()
            .padding(.top, 48)
            .background(Color(.veryLightGreen))
            .toolbar {
                ToolbarItem(
                    placement: .navigationBarTrailing)
                {
                    Button {
                        viewStore.send(.addItem)
                    } label: {
                        Image(systemIcon: .plus)
                    }
                }
            }
        }
    }
}

struct ShieldAppsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ShieldAppsSettingsView(
            store: Store(
                initialState: .default,
                reducer: ShieldAppsSettings()
            )
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
