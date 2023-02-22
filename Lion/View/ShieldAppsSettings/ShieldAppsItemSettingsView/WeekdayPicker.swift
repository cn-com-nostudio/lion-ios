// WeekdayPicker.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/29.

import ComposableArchitecture
import SwiftUI

struct WeekdayPicker: View {
    let store: Store<SortedSet<Weekday>, ShieldAppsItem.WeekdayAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                Text(.repeat)
                    .foregroundColor(.lion.secondary)
                    .font(.lion.caption1)
                    .padding(.horizontal)

                HStack(spacing: 8) {
                    ForEach(Weekday.allCases) { weekday in
                        Toggle(
                            isOn: viewStore.binding(
                                get: {
                                    $0.contains(weekday)
                                }, send: { isOn in
                                    print("\(weekday) is \(isOn ? "On" : "Off")")
                                    return isOn ? .addWeekday(weekday) : .removeWeekday(weekday)
                                }
                            ),
                            label: {
                                Text(weekday.veryShortWeekdaySymbols())
                                    .frame(width: 44, height: 44)
                                    .font(.lion.headline)
                                    .foregroundColor(.lion.primary)
                            }
                        )
                        .toggleStyle(WeekdayToggleStyle())
                    }
                }
            }
        }
    }
}

// struct WeekdayPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        WeekdayPicker(
//            store: Store(initialState: <#T##R.State#>, reducer: <#T##R#>)
//        )
//        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
//        .previewDisplayName("\(Self.self)")
//        .environment(\.locale, .init(identifier: "zh_CN"))
//    }
// }

struct WeekdayToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            configuration
                .label
                .background(configuration.isOn ? .yellow : .white)
                .cornerRadius(22)
        }
    }
}
