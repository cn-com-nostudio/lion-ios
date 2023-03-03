// ShieldAppsItem+ScheduleItem.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/2.

import DeviceActivity
import DeviceActivitySharing
import MobileCore

extension DateComponents {
    static let zero: Self = .init(second: 0)
}

extension TimeComponent {
    init(_ time: HourMinute.State) {
        self.init(hour: time.hour, minute: time.minute, second: 0)
    }
}

extension Event {
    init(_ appsSelection: AppsSelection.State) {
        let event = DeviceActivityEvent(
            applications: appsSelection.appTokens,
            categories: appsSelection.categoryTokens,
            threshold: .zero
        )
        self = .init(event)
    }
}

extension DailyScheduleItem {
    init(_ item: ShieldAppsItem.State) {
        let id = item.id

        let start: TimeComponent = .init(item.timeDuration.start.time)
        let end: TimeComponent = .init(item.timeDuration.end.time)

        let weekdays = item.weekdays

        let eventID = item.selectedAppsGroupID
        let event = Event(item.selectedApps)

        self = .init(id: id,
                     start: start,
                     end: end,
                     weekdays: weekdays,
                     events: [eventID: event])
    }
}
