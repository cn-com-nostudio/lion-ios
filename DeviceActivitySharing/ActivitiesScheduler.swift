// ActivitiesScheduler.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/5.

import DeviceActivity
import ManagedSettings
import MobileCore

public struct ActivitiesScheduler {
    private let center: DeviceActivityCenter = .init()

    public init() {}

    public func startMonitoring(items: [DailyScheduleItem]) throws {
        let activityScheduleItems = items.map(ActivityScheduleItem.init)
        try startMonitoring(items: activityScheduleItems)
    }

    public func stopMonitoring(items: [DailyScheduleItem]) {
        let activityScheduleItems = items.map(ActivityScheduleItem.init)
        stopMonitoring(items: activityScheduleItems)
    }

    public func startMonitoring(item: DailyScheduleItem) throws {
        try startMonitoring(item: ActivityScheduleItem(item))
    }

    public func stopMonitoring(item: DailyScheduleItem) {
        stopMonitoring(item: ActivityScheduleItem(item))
    }

    private func startMonitoring(items: [ActivityScheduleItem]) throws {
        try items.forEach { item in
            try startMonitoring(item: item)
        }
    }

    private func startMonitoring(item: ActivityScheduleItem) throws {
        try center.startMonitoring(
            item.activity,
            during: item.schedule,
            events: item.events
        )
    }

    private func stopMonitoring(items: [ActivityScheduleItem]) {
        let activities = items.map(\.activity)
        center.stopMonitoring(activities)

        activities.forEach { activity in
            let store: ManagedSettingsStore = .store(of: activity)
            store.clearAllSettings()
        }
    }

    private func stopMonitoring(item: ActivityScheduleItem) {
        center.stopMonitoring([item.activity])
        let store: ManagedSettingsStore = .store(of: item.activity)
        store.clearAllSettings()
    }
}
