// ShieldAppsItemView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import DeviceActivitySharing
import MobileCore
import SwiftUI

struct ShieldAppsItemView: View {
    let store: StoreOf<ShieldAppsItem>
    let tapAction: () -> Void

    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(viewStore.timeDuration.start.time.display) - \(viewStore.timeDuration.end.time.display)")
                        .foregroundColor(.lion.primary)
                        .font(.lion.title3)
                    HStack(spacing: 0) {
                        Text(.nOfApps(viewStore.selectedApps.appTokens.count))
                        if let weekdaysDescriptions = viewStore.weekdays.shortDescriptions() {
                            Text(", ")
                            Text(weekdaysDescriptions)
                                .lineLimit(1)
                        }
                    }
                    .foregroundColor(.lion.primary.opacity(0.3))
                    .font(.lion.caption1)
                }
                Spacer()
            }
            .padding()
            .background(Color.lion.white)
            .cornerRadius(16)
            .onTapGesture {
                tapAction()
            }
        }
    }
}

struct ShieldAppsItemView_Previews: PreviewProvider {
    static var previews: some View {
        ShieldAppsItemView(
            store: Store(
                initialState: .init(id: UUID()),
                reducer: ShieldAppsItem()
            ),
            tapAction: {}
        )
        .background(Color.red)
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
