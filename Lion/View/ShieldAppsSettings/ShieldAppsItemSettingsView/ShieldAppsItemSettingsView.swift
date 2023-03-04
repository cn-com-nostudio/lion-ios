// ShieldAppsItemSettingsView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import FamilyControls
import SwiftUI

struct ShieldAppsItemSettingsView: View {
    let store: StoreOf<ShieldAppsItem>

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
                            action: ShieldAppsItem.Action.selectedApps
                        )
                    )

                    Spacer()

                    VStack(spacing: 16) {
                        doneButton {
                            viewStore.send(.editDone)
                        }
                        if !viewStore.isNew {
                            deleteButton {
                                viewStore.send(.delete)
                            }
                        }
                    }
                }
                .navigationBarTitle(.limitAppsOpen, displayMode: .inline)
                .toolbar {
                    ToolbarItem(
                        placement: .navigationBarLeading)
                    {
                        Button(.cancel) {
                            viewStore.send(.deselect)
                        }
                    }
                }
                .padding()
                .background(Color(.veryLightGreen))
            }
        }
    }

    @ViewBuilder
    func doneButton(
        //        isLoading: Bool,
//        isDisabled: Bool,
        action: @escaping () -> Void
    )
        -> some View
    {
        Button {
            action()
        } label: {
            Group {
//                if isLoading {
//                    ProgressView()
//                } else {
                Text(.done)
//                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
        }
        .buttonStyle(PrimaryButton())
//        .disabled(isDisabled)
//        .opacity(isDisabled ? 0.5 : 1.0)
    }

    @ViewBuilder
    func deleteButton(
        //        isLoading: Bool,
//        isDisabled: Bool,
        action: @escaping () -> Void
    )
        -> some View
    {
        Button {
            action()
        } label: {
            Group {
//                if isLoading {
//                    ProgressView()
//                } else {
                Text(.delete)
//                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
        }
        .buttonStyle(DeleteButton())
//        .disabled(isDisabled)
//        .opacity(isDisabled ? 0.5 : 1.0)
    }
}

struct ShieldAppsItemSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ShieldAppsItemSettingsView(
            store: Store(
                initialState: ShieldAppsItem.State(id: UUID()),
                reducer: ShieldAppsItem()
            )
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
