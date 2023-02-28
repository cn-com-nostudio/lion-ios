// ShieldAppsMonitor.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import DeviceActivity
import FamilyControls
import Foundation
import XCTestDynamicOverlay

extension DependencyValues {
    var shieldAppsMonitor: ShieldAppsMonitor { self[ShieldAppsMonitor.self] }
}

struct ShieldAppsMonitor {
    var startMonitoringItems: ([ShieldAppsItem.State]) throws -> Void
    var stopMonitoringAll: () throws -> Void
//    var startMonitoringItem: (ShieldAppsItem.State) async throws -> Void
//    var stopMonitoringItem: (ShieldAppsItem.State) async throws -> Void
}

extension ShieldAppsMonitor: DependencyKey {
    static var scheduler = ShieldAppsScheduler()
    static let center = AuthorizationCenter.shared

    static var liveValue: Self = .init(
        startMonitoringItems: { items in
            try scheduler.startMonitoring(items: items)
        },
        stopMonitoringAll: {
            scheduler.stopMonitoringAll()
        }
//        startMonitoringItem: { item in
//            try await center.requestAuthorization(for: .individual)
//            try await scheduler.startMonitoring(item: item)
//        },
//        stopMonitoringItem: { item in
//            try await center.requestAuthorization(for: .individual)
//            scheduler.stopMonitoring(item: item)
//        }
    )

    static let testValue: Self = .init(
        startMonitoringItems: XCTUnimplemented("\(Self.self).startMonitoringItems"),
        stopMonitoringAll: XCTUnimplemented("\(Self.self).stopMonitoringItems")
//        startMonitoringItem: XCTUnimplemented("\(Self.self).startMonitoringItem"),
//        stopMonitoringItem: XCTUnimplemented("\(Self.self).stopMonitoringItem")
    )
}
