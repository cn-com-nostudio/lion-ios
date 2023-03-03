// ScheduleItem.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/2.

import DeviceActivity
import ManagedSettings
import MobileCore

public struct TimeComponent: Codable {
    let hour: Int
    let minute: Int
    let second: Int

    public init(hour: Int,
                minute: Int,
                second: Int)
    {
        self.hour = hour
        self.minute = minute
        self.second = second
    }

    init(_ dateComponents: DateComponents) {
        hour = dateComponents.hour ?? 0
        minute = dateComponents.minute ?? 0
        second = dateComponents.second ?? 0
    }

    var dateComponent: DateComponents {
        .init(hour: hour, minute: minute, second: second)
    }
}

public typealias EventName = String

extension DeviceActivityEvent {
    init(_ event: Event) {
        self.init(
            applications: event.applications,
            threshold: event.threshold.dateComponent
        )
    }
}

public struct Event: Codable {
    let applications: Set<ApplicationToken>
    let threshold: TimeComponent

    public init(_ event: DeviceActivityEvent) {
        applications = event.applications
        threshold = TimeComponent(event.threshold)
    }
}

public struct DailyScheduleItem: Identifiable {
    public typealias ID = UUID
    public typealias EventID = UUID
    public let id: ID
    let start: TimeComponent
    let end: TimeComponent
    let weekdays: SortedSet<Weekday>
    let events: [EventID: Event]

    public init(id: ID,
                start: TimeComponent,
                end: TimeComponent,
                weekdays: SortedSet<Weekday>,
                events: [EventID: Event])
    {
        self.id = id
        self.start = start
        self.end = end
        self.weekdays = weekdays
        self.events = events
    }
}

extension DailyScheduleItem.ID {
    var activityName: DeviceActivityName {
        .shield(uuidString)
    }
}

extension DailyScheduleItem.EventID {
    func event(happenOn weekday: Weekday) -> DeviceActivityEvent.Name {
        .event(happenOn: weekday, name: uuidString)
    }
}

struct ActivityScheduleItem: Identifiable {
    var id: DeviceActivityName {
        activity
    }

    let activity: DeviceActivityName
    let schedule: DeviceActivitySchedule
    let events: [DeviceActivityEvent.Name: DeviceActivityEvent]
}

extension ActivityScheduleItem {
    init(_ item: DailyScheduleItem) {
        activity = item.id.activityName

        schedule = .init(
            intervalStart: item.start.dateComponent,
            intervalEnd: item.end.dateComponent,
            repeats: true,
            warningTime: DateComponents(second: 10)
        )

        var activityEvents: [DeviceActivityEvent.Name: DeviceActivityEvent] = [:]
        item.weekdays.forEach { weekday in
            item.events.forEach {
                let eventName: DeviceActivityEvent.Name = $0.key.event(happenOn: weekday)
                let activityEvent: DeviceActivityEvent = .init($0.value)
                activityEvents[eventName] = activityEvent
            }
        }

        events = activityEvents
    }
}
