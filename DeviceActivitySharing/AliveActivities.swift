// AliveActivities.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/2.

import DeviceActivity

public typealias ActivityName = String

// Activities that in schedule duration.
public struct AliveActivities: Codable {
    private var activities: Set<ActivityName> = []

    mutating func add(activity: DeviceActivityName) {
        activities.insert(activity.rawValue)
    }

    mutating func remove(activity: DeviceActivityName) {
        activities.remove(activity.rawValue)
    }

//    public var todayShieldApplications: Set<ApplicationToken> {
//        let applications = activities
//            .filter(\.key.isShieldActivityName)
//            .flatMap(\.value)
//            .filter(\.key.isTodayEvent)
//            .map(\.value)
//            .flatMap(\.applications)
//
//        return Set(applications)
//    }
}
