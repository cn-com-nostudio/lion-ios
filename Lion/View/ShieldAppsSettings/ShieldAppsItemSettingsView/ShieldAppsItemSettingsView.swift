// ShieldAppsItemSettingsView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import FamilyControls
import SwiftUI

struct ShieldAppsItemSettingsView: View {
    let store: StoreOf<ShieldAppsItem>
    var isNewItem: Bool
    var cancel: () -> Void
    var done: (ShieldAppsItem.State) -> Void
    var delete: (ShieldAppsItem.State) -> Void

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                VStack(alignment: .leading, spacing: 30) {
                    TimeDurationPicker(
                        store: store.scope(
                            state: \.timeDuration,
                            action: ShieldAppsItem.Action.timeDuration
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
                        if !isNewItem {
                            deleteButton { delete(viewStore.state) }
                        }
                    }
                }
                .navigationBarTitle(.limitAppsOpen, displayMode: .inline)
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
            .onAppear {
                if isNewItem {
                    viewStore.send(.selectApps(.toggleIsPresented(true)))
                }
            }
        }
    }

    @ViewBuilder
    func doneButton(_ action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(.done)
                .font(.lion.title3)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
        }
        .buttonStyle(PrimaryButton())
    }

    @ViewBuilder
    func deleteButton(_ action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(.delete)
                .font(.lion.title3)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
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
            isNewItem: false,
            cancel: {},
            done: { _ in },
            delete: { _ in }
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
