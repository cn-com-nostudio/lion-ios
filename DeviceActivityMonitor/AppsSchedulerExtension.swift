// AppsSchedulerExtension.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/13.

import DeviceActivity
import Foundation
import ManagedSettings

class AppsSchedulerExtension: DeviceActivityMonitor {
    private let store: ManagedSettingsStore = .init()
    private var appScheduler: AppsScheduler = .init()
    private let userDefault: UserDefaults = .standard

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        appScheduler.intervalDidStart(for: activity)
        store.shield.applications = appScheduler.shield.applications
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        appScheduler.intervalDidEnd(for: activity)
        store.shield.applications = appScheduler.shield.applications
    }
}
