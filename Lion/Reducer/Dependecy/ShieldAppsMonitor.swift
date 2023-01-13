// ShieldAppsMonitor.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/6.

import ComposableArchitecture
import DeviceActivity
import XCTestDynamicOverlay

extension DependencyValues {
    var shieldAppsMonitor: ShieldAppsMonitor { self[ShieldAppsMonitor.self] }
}

struct ShieldAppsMonitor {
    var startMonitoringItems: ([ShieldAppsItem.State]) throws -> Void
    var stopMonitoringAll: () -> Void
    var startMonitoringItem: (ShieldAppsItem.State) throws -> Void
    var stopMonitoringItem: (ShieldAppsItem.State) -> Void
}

extension ShieldAppsMonitor: DependencyKey {
    static var scheduler = ShieldAppsScheduler()

    static var liveValue: Self = .init(
        startMonitoringItems: { items in
            try scheduler.startMonitoring(items: items)
        },
        stopMonitoringAll: {
            scheduler.stopMonitoringAll()
        },
        startMonitoringItem: { item in
            try scheduler.startMonitoring(item: item)
        },
        stopMonitoringItem: { item in
            scheduler.stopMonitoring(item: item)
        }
    )

    static let testValue: Self = .init(
        startMonitoringItems: XCTUnimplemented("\(Self.self).startMonitoringItems"),
        stopMonitoringAll: XCTUnimplemented("\(Self.self).stopMonitoringItems"),
        startMonitoringItem: XCTUnimplemented("\(Self.self).startMonitoringItem"),
        stopMonitoringItem: XCTUnimplemented("\(Self.self).stopMonitoringItem")
    )
}
