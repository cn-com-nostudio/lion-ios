// TimeIntervalPicker.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import SwiftUI

struct TimeIntervalPicker: View {
    let store: StoreOf<TimeInterval>

    var body: some View {
        WithViewStore(store) { _ in
            VStack(alignment: .leading) {
                Text(.time)
                    .foregroundColor(.lion.secondary)
                    .font(.lion.caption1)
                    .padding(.horizontal)

                VStack {
                    TimePicker(
                        name: .from,
                        store: store.scope(
                            state: \.start,
                            action: TimeInterval.Action.start
                        )
                    )

                    Divider()
                        .opacity(0.5)

                    TimePicker(
                        name: .to,
                        store: store.scope(
                            state: \.end,
                            action: TimeInterval.Action.end
                        )
                    )
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
            }
        }
    }
}

struct TimeIntervalPicker_Previews: PreviewProvider {
    static var previews: some View {
        TimeIntervalPicker(
            store: Store(
                initialState: .default,
                reducer: TimeInterval()
            )
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}

struct TimePicker: View {
    let name: LocalizedStringKey
    let store: StoreOf<TimeSelection>

    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                DatePicker(
                    name,
                    selection:
                    viewStore.binding(
                        get: { $0.time.date() },
                        send: { TimeSelection.Action.time(.update($0)) }
                    ),
                    in: viewStore.selectRange,
                    displayedComponents: .hourAndMinute
                )
                .font(.lion.headline)

                Image(.selector)
                    .resizable()
                    .frame(width: 6, height: 14)
            }
        }
    }
}

struct TimePicker_Previews: PreviewProvider {
    static var previews: some View {
        TimePicker(
            name: .time,
            store: Store(
                initialState: .init(time: .min, min: .min, max: .max),
                reducer: TimeSelection()
            )
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
