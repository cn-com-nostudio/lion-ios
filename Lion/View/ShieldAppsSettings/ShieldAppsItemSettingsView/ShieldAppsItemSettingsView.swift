// ShieldAppsItemSettingsView.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/14.

import ComposableArchitecture
import FamilyControls
import SwiftUI

struct ShieldAppsItemSettingsView: View {
    let store: StoreOf<ShieldAppsItem>
    var cancel: () -> Void
    var done: (ShieldAppsItem.State) -> Void
    var delete: (ShieldAppsItem.State) -> Void

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                VStack(alignment: .leading, spacing: 30) {
                    TimeIntervalPicker(
                        store: store.scope(
                            state: \.timeInterval,
                            action: ShieldAppsItem.Action.timeInterval
                        )
                    )

                    WeekdayPicker(
                        store: store.scope(
                            state: \.weekdays,
                            action: ShieldAppsItem.Action.weekday
                        )
                    )

                    AppsPickerButton(
                        store: store.scope(
                            state: \.selectedApps,
                            action: ShieldAppsItem.Action.selectApps
                        )
                    )

                    Spacer()

                    VStack(spacing: 16) {
                        doneButton { done(viewStore.state) }
                        deleteButton { delete(viewStore.state) }
                    }
                }
                .navigationBarTitle(.limitAppsOpen, displayMode: .inline)
                .navigationBarTitle(.selectApps, displayMode: .inline)
                .toolbar {
                    ToolbarItem(
                        placement: .navigationBarLeading)
                    {
                        Button(.cancel) { cancel() }
                    }
                }
                .padding()
                .background(Color(.veryLightGreen))
            }
        }
    }

    @ViewBuilder
    func doneButton(_ action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(.done)
                .padding()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(PrimaryButton())
    }

    @ViewBuilder
    func deleteButton(_ action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(.delete)
                .padding()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(DeleteButton())
    }
}

struct ShieldAppsItemSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ShieldAppsItemSettingsView(
            store: Store(
                initialState: ShieldAppsItem.State(id: UUID()),
                reducer: ShieldAppsItem()
            ),
            cancel: {},
            done: { _ in },
            delete: { _ in }
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
