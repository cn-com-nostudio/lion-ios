// ShieldAppsScheduler.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/14.

import ComposableArchitecture
import DeviceActivity
import Foundation
import ManagedSettings

struct ScheduleItem {
    let activity: DeviceActivityName
    let schedule: DeviceActivitySchedule
    let applications: Set<ApplicationToken>
}

// These name should align with app extension.
extension DeviceActivityEvent.Name {
    static let shieldSettings: Self = .init("shieldSettings")
}

struct ShieldAppsScheduler {
    private let center: DeviceActivityCenter

    init(center: DeviceActivityCenter = .init()) {
        self.center = center
    }

    func startMonitoring(items: [ShieldAppsItem.State]) throws {
        try items.forEach(startMonitoring(item:))
    }

    func startMonitoring(item: ShieldAppsItem.State) throws {
        try item.scheduleItems.forEach(startMonitoring(item:))
    }

    private func startMonitoring(item: ScheduleItem) throws {
        let event = DeviceActivityEvent(
            applications: item.applications,
            threshold: DateComponents(hour: 0, second: 0)
        )
        try center.startMonitoring(item.activity, during: item.schedule, events: [.shieldSettings: event])
    }

    func stopMonitoringAll() {
        center.stopMonitoring()
    }

    func stopMonitoring(item: ShieldAppsItem.State) {
        let activities = item.scheduleItems.map(\.activity)
        center.stopMonitoring(activities)
    }
}

extension ShieldAppsItem.State {
    var scheduleItems: [ScheduleItem] {
        weekdays.map { weekday in
            let activity = DeviceActivityName(id.uuidString + String(weekday.rawValue))
            let start = DateComponents(
                hour: timeInterval.start.time.hour,
                minute: timeInterval.start.time.minute,
                weekday: weekday.rawValue
            )
            let end = DateComponents(
                hour: timeInterval.end.time.hour,
                minute: timeInterval.end.time.minute,
                weekday: weekday.rawValue
            )
            let schedule = DeviceActivitySchedule(
                intervalStart: start,
                intervalEnd: end,
                repeats: true
            )
            return ScheduleItem(
                activity: activity,
                schedule: schedule,
                applications: selectedApps.appTokens
            )
        }
    }
}
