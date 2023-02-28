// DeviceActivityMonitorExtension.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/24.

import DeviceActivity
import Foundation
import ManagedSettings

extension ManagedSettingsStore.Name {
    static let lion: Self = .init("cn.com.nostudio.lion")
}

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    private let store: ManagedSettingsStore = .init(named: .lion)
    private var appScheduler: AppsScheduler = .init()

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        appScheduler.intervalDidStart(for: activity)
        let applications = appScheduler.shield.applications
        if store.shield.applications != applications {
            store.shield.applications = applications
        }
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        appScheduler.intervalDidEnd(for: activity)
        let applications = appScheduler.shield.applications
        if store.shield.applications != applications {
            store.shield.applications = applications
        }
    }
}
