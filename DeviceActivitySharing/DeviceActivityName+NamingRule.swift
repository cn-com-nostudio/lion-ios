// DeviceActivityName+NamingRule.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/1.

import DeviceActivity
import MobileCore

// Event 1(event_name)      Apps group 1      5 minutes
// Event 2(event_name)      Apps group 2      10 minutes
// 10:00    ----------      20:00  (schedule)
//              Activity  (activity)
/*
 public func startMonitoring(
 _ activity: DeviceActivityName,
 during schedule: DeviceActivitySchedule,
 events: [DeviceActivityEvent.Name : DeviceActivityEvent] = [:]
 ) throws
 */

let shiledActivityPrefix = "shield_"

extension DeviceActivityName {
    // 命名规则为 "shield_{activity_name}"
    static func shield(_ name: String) -> Self {
        .init(shiledActivityPrefix + name)
    }
}

public extension DeviceActivityName {
    var isShieldActivityName: Bool {
        rawValue.hasPrefix(shiledActivityPrefix)
    }
}

let separator = "."

extension DeviceActivityEvent.Name {
    // 命名规则 "weekday.{weekday_number}.{event_name}"
    static func event(happenOn weekday: Weekday, name: String) -> Self {
        let eventName = ["weekday", String(weekday.rawValue), name].joined(separator: separator)
        return .init(eventName)
    }
}

public extension DeviceActivityEvent.Name {
    var isTodayEvent: Bool {
        let components = rawValue.components(separatedBy: separator)
        guard components.count == 3 else { return false }
        guard let weekdayNumber = Int(components[1]) else { return false }
        guard let weekday = Weekday(rawValue: weekdayNumber) else { return false }
        return Date().weekday() == weekday
    }
}
