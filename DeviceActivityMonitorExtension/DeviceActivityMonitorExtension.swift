// DeviceActivityMonitorExtension.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/4.

import DeviceActivity
import DeviceActivitySharing
import ManagedSettings

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    private let center: DeviceActivityCenter = .init()

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        let applications = center
            .events(for: activity)
            .filter(\.key.isTodayEvent)
            .map(\.value)
            .flatMap(\.applications)

        let store: ManagedSettingsStore = .store(of: activity)
        store.shield.applications = Set(applications)
    }

//    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
//        super.eventDidReachThreshold(event, activity: activity)
//        guard event.isTodayEvent else { return }
//        let applications = center.events(for: activity)[event]?.applications
//        let store: ManagedSettingsStore = .store(of: activity)
//        store.shield.applications = applications
//    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        let store: ManagedSettingsStore = .store(of: activity)
        store.clearAllSettings()
    }
}
