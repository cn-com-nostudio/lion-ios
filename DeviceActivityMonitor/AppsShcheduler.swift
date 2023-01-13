// AppsShcheduler.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/13.

import DeviceActivity
import ManagedSettings

// These name should align with container app.
extension DeviceActivityEvent.Name {
    static let shieldSettings: Self = .init("shieldSettings")
}

// incase that the data not consistence. we should reset all events and re-run.
extension DeviceActivityName {
    static let clearAll: Self = .init("clean all")
}

struct Settings: Codable {
    // String is DeviceActivityName.rawValue
    private var appTokens: [String: [ApplicationToken]] = [:]

    var applications: Set<ApplicationToken> {
        Set(appTokens.values.flatMap { $0 })
    }

    mutating func add(from event: DeviceActivityEvent, for activity: DeviceActivityName) {
        appTokens[activity.rawValue] = Array(event.applications)
    }

    mutating func delete(for activity: DeviceActivityName) {
        if activity == .clearAll {
            appTokens = [:]
        } else {
            appTokens[activity.rawValue] = nil
        }
    }
}

struct AppsScheduler {
    private let center: DeviceActivityCenter = .init()
    private(set) var shield: Settings = .init()
    private let shieldEventKey: DeviceActivityEvent.Name = .shieldSettings

    mutating func intervalDidStart(for activity: DeviceActivityName) {
        guard let shieldEvent = center.events(for: activity)[shieldEventKey] else { return }
        shield.add(from: shieldEvent, for: activity)
    }

    mutating func intervalDidEnd(for activity: DeviceActivityName) {
        shield.delete(for: activity)
    }
}