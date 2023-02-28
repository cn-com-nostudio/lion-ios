// TimeIntervalPicker.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import SwiftUI

struct TimeDurationPicker: View {
    let store: StoreOf<TimeDuration>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                Text(.time)
                    .foregroundColor(.lion.secondary)
                    .font(.lion.caption1)
                    .padding(.horizontal)

                VStack {
                    TimePicker(
                        name: .from,
                        selectRange: viewStore.startRange,
                        store: store.scope(
                            state: \.start,
                            action: TimeDuration.Action.start
                        )
                    )

                    Divider()
                        .opacity(0.5)

                    TimePicker(
                        name: .to,
                        selectRange: viewStore.endRange,
                        store: store.scope(
                            state: \.end,
                            action: TimeDuration.Action.end
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

struct TimeDurationPicker_Previews: PreviewProvider {
    static var previews: some View {
        TimeDurationPicker(
            store: Store(
                initialState: .default,
                reducer: TimeDuration()
            )
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}

struct TimePicker: View {
    let name: LocalizedStringKey
    let selectRange: ClosedRange<Date>
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
                    in: selectRange,
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
            selectRange: .allDay,
            store: Store(
                initialState: .init(time: .min),
                reducer: TimeSelection()
            )
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
