// AppsPickerButton.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import MobileCore
import SwiftUI

struct AppsPickerButton: View {
    let store: StoreOf<AppsSelection>

    var body: some View {
        WithViewStore(store) { viewStore in

            VStack(alignment: .leading) {
                Text("App")
                    .foregroundColor(.lion.secondary)
                    .font(.lion.caption1)
                    .padding(.horizontal)
                HStack {
                    Text(.limitApps)
                        .font(.lion.headline)
                        .foregroundColor(.lion.primary)
                    Spacer()
                    Text(.nOfApps(viewStore.appTokens.count))
                        .font(.lion.headline)
                        .foregroundColor(.lion.secondary)
                    Image(systemIcon: .chevronForward)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)

                Spacer().frame(height: 16)

                Text(.limitAppsTip)
                    .font(.lion.caption2)
                    .foregroundColor(.lion.primary.opacity(0.3))
                    .lineSpacing(5)
                    .padding()
                    .background(Color(.veryLightGray))
                    .cornerRadius(16)
            }
            .onTapGesture {
                viewStore.send(.toggleIsPresented(true))
            }
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isPresented,
                    send: AppsSelection.Action.toggleIsPresented
                )
            ) {
                AppsPicker(store: store)
            }
        }
    }
}

struct AppsPickerButton_Previews: PreviewProvider {
    @State static var selected: SortedSet<Weekday> = .init()

    static var previews: some View {
        AppsPickerButton(
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
