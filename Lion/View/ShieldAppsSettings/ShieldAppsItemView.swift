// ShieldAppsItemView.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/14.

import ComposableArchitecture
import SwiftUI

struct ShieldAppsItemView: View {
    let store: StoreOf<ShieldAppsItem>

    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(viewStore.timeInterval.start.time.display) - \(viewStore.timeInterval.end.time.display)")
                        .foregroundColor(.primary)
                        .font(.title3.weight(.semibold))
                    HStack(spacing: 0) {
                        Text(.nOfApps(viewStore.selectedApps.appTokens.count))
                        if let weekdaysDescriptions = viewStore.weekdays.shortDescriptions() {
                            Text(", ")
                            Text(weekdaysDescriptions)
                                .lineLimit(1)
                        }
                    }
                    .foregroundColor(.secondary.opacity(0.7))
                    .font(.callout.weight(.regular))
                }
                Spacer()
                Toggle(
                    "",
                    isOn: viewStore.binding(
                        get: \.isOn,
                        send: ShieldAppsItem.Action.toggleIsOn
                    )
                )
                .frame(width: 50)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
        }
    }
}

struct ShieldAppsItemView_Previews: PreviewProvider {
    static var previews: some View {
        ShieldAppsItemView(
            store: Store(
                initialState: .init(id: UUID()),
                reducer: ShieldAppsItem()
            )
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}

extension SortedSet where Element == Weekday {
    func shortDescriptions(separator: String = ", ") -> LocalizedStringKey? {
        guard count > 0 else {
            return nil
        }

        if count == Element.allCases.count {
            return .everyDay
        } else if count == 5, contains(allIn: .workdays) {
            return .everyWorkday
        } else if count == 2, contains(allIn: .weekend) {
            return .everyWeekend
        } else {
            return LocalizedStringKey(map { $0.shortWeekdaySymbols() }.joined(separator: separator))
        }
    }
}
