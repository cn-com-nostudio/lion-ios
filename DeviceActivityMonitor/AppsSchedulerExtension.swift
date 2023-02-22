// AppsSchedulerExtension.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/1/28.

import DeviceActivity
import Foundation
import ManagedSettings

class AppsSchedulerExtension: DeviceActivityMonitor {
    private let store: ManagedSettingsStore = .init()
    private var appScheduler: AppsScheduler = .init()

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        appScheduler.intervalDidStart(for: activity)
        let applications = appScheduler.shield.applications
        store.shield.applications = applications
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        appScheduler.intervalDidEnd(for: activity)
        let applications = appScheduler.shield.applications
        store.shield.applications = applications
    }
}
