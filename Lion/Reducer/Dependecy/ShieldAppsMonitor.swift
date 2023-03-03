// ShieldAppsMonitor.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import DeviceActivitySharing
import ManagedSettings
import XCTestDynamicOverlay

extension DependencyValues {
    var shieldAppsMonitor: ShieldAppsMonitor { self[ShieldAppsMonitor.self] }
}

struct ShieldAppsMonitor {
    var startMonitoringItems: (_ items: [ShieldAppsItem.State]) throws -> Void
    var stopMonitoringAll: () -> Void
//    var startMonitoringItem: (_ item: ShieldAppsItem.State) throws -> Void
//    var stopMonitoringItem: (_ item: ShieldAppsItem.State) -> Void
}

extension ShieldAppsMonitor: DependencyKey {
    static let center = ActivitiesScheduler()
    static let store: ManagedSettingsStore = .init(named: .shared)

    static var liveValue: Self = .init(
        startMonitoringItems: { items in
            try center.startMonitoring(items: items.map(DailyScheduleItem.init))
        },
        stopMonitoringAll: {
            center.stopMonitoringAll()
            store.shield.applications = nil
        }
//        startMonitoringItem: { item in
//            try center.startMonitoring(item: DailyScheduleItem(item))
//        },
//        stopMonitoringItem: { item in
//            center.stopMonitoring(item: DailyScheduleItem(item))
        ////            let originalApplications = store.shield.applications ?? []
        ////            let remainedApplications = originalApplications.subtracting(item.selectedApps.appTokens)
        ////            store.shield.applications = remainedApplications
//        }
    )

    static let testValue: Self = .init(
        startMonitoringItems: XCTUnimplemented("\(Self.self).startMonitoringItems"),
        stopMonitoringAll: XCTUnimplemented("\(Self.self).stopMonitoringAll")
//        startMonitoringItem: XCTUnimplemented("\(Self.self).startMonitoringItem"),
//        stopMonitoringItem: XCTUnimplemented("\(Self.self).stopMonitoringItem")
    )
}
