// AppsPickerButton.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/8.

import ComposableArchitecture
import SwiftUI

struct AppsPickerButton: View {
    let store: StoreOf<AppsSelection>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                Text("App")
                HStack {
                    Text(.limitApps)
                    Spacer()
                    Text(.nOfApps(viewStore.appTokens.count))
                    Image(systemIcon: .chevronForward)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)

                Spacer().frame(height: 16)

                Text(.limitAppsTip)
                    .font(.footnote.weight(.regular))
                    .foregroundColor(Color.secondary)
                    .padding()
                    .background(Color(.veryLightGray))
                    .cornerRadius(16)
            }
            .onTapGesture {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                    viewStore.send(.toggleIsPresented(true))
                }
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
