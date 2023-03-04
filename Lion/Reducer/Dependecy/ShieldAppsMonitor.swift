// ShieldAppsMonitor.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import DeviceActivitySharing
import XCTestDynamicOverlay

extension DependencyValues {
    var shieldAppsMonitor: ShieldAppsMonitor { self[ShieldAppsMonitor.self] }
}

struct ShieldAppsMonitor {
    var startMonitoringItems: (_ items: [ShieldAppsItem.State]) throws -> Void
    var stopMonitoringItems: (_ items: [ShieldAppsItem.State]) -> Void
    var startMonitoringItem: (_ item: ShieldAppsItem.State) throws -> Void
    var stopMonitoringItem: (_ item: ShieldAppsItem.State) -> Void
}

extension ShieldAppsMonitor: DependencyKey {
    static let center = ActivitiesScheduler()

    static var liveValue: Self = .init(
        startMonitoringItems: { items in
            try center.startMonitoring(items: items.map(DailyScheduleItem.init))
        },
        stopMonitoringItems: { items in
            center.stopMonitoring(items: items.map(DailyScheduleItem.init))
        },
        startMonitoringItem: { item in
            try center.startMonitoring(item: DailyScheduleItem(item))
        },
        stopMonitoringItem: { item in
            center.stopMonitoring(item: DailyScheduleItem(item))
        }
    )

    static let testValue: Self = .init(
        startMonitoringItems: XCTUnimplemented("\(Self.self).startMonitoringItems"),
        stopMonitoringItems: XCTUnimplemented("\(Self.self).stopMonitoringItems"),
        startMonitoringItem: XCTUnimplemented("\(Self.self).startMonitoringItem"),
        stopMonitoringItem: XCTUnimplemented("\(Self.self).stopMonitoringItem")
    )
}
