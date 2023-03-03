// DeviceActivityMonitorExtension.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/24.

import DeviceActivity
import DeviceActivitySharing
import ManagedSettings
import MobileCore

extension ManagedSettingsStore.Name {
    static let shared: Self = .init("cn.com.nostudio.lion")
}

struct Time: Comparable, Equatable {
    let hour: Int
    let minute: Int

    init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }

    static func < (lhs: Time, rhs: Time) -> Bool {
        if lhs.hour < rhs.hour {
            return true
        } else if lhs.hour == rhs.hour {
            return lhs.minute < rhs.minute
        } else {
            return false
        }
    }
}

extension DeviceActivityCenter {
    func todayEvents(for activity: DeviceActivityName) -> [DeviceActivityEvent] {
        events(for: activity)
            .filter(\.key.isTodayEvent)
            .map(\.value)
    }

    func isActivityInSchedule(_ activity: DeviceActivityName) -> Bool {
        guard let schedule = schedule(for: activity) else { return false }
        let nowDateComponent = Calendar.current.dateComponents([.hour, .minute], from: Date())
        let now = Time(hour: nowDateComponent.hour!, minute: nowDateComponent.minute!)

        let start = Time(hour: schedule.intervalStart.hour!, minute: schedule.intervalStart.minute!)
        let end = Time(hour: schedule.intervalEnd.hour!, minute: schedule.intervalEnd.minute!)

        return start <= now && now < end
    }

    func todayInScheduleShieldApplications() -> Set<ApplicationToken> {
        let inSchduleShieldActivities = activities
            .filter(\.isShieldActivityName)
            .filter(isActivityInSchedule(_:))

        let todayEvents = inSchduleShieldActivities
            .flatMap(events(for:))
            .filter(\.key.isTodayEvent)
            .map(\.value)

        let applications = todayEvents.flatMap(\.applications)
        return Set(applications)
    }
}

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    private let store: ManagedSettingsStore = .init(named: .shared)
    private let center: DeviceActivityCenter = .init()

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        if activity.isShieldActivityName {
            let applicationsToAdd = center
                .events(for: activity)
                .filter(\.key.isTodayEvent)
                .map(\.value)
                .flatMap(\.applications)

            let originalApplications = store.shield.applications ?? []
            let remainedApplications = originalApplications.union(applicationsToAdd)
            store.shield.applications = remainedApplications
        }
    }

//    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
//        super.eventDidReachThreshold(event, activity: activity)
//        guard event.isTodayEvent else { return }
//
//        if activity.isShieldActivityName {
//            let applicationsToAdd = center.events(for: activity)[event]?.applications ?? []
//            let originalApplications = store.shield.applications ?? []
//            let remainedApplications = originalApplications.union(applicationsToAdd)
//            store.shield.applications = remainedApplications
//        }
//    }

    // try it
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)

        var activities = center.activities
            .filter(\.isShieldActivityName)
            .filter(center.isActivityInSchedule(_:))

        activities.removeAll(where: { $0 == activity })

        let applications = activities
            .flatMap(center.events(for:))
            .filter(\.key.isTodayEvent)
            .map(\.value)
            .flatMap(\.applications)

        store.shield.applications = Set(applications)
    }

//    override func intervalWillEndWarning(for activity: DeviceActivityName) {
//        super.intervalWillEndWarning(for: activity)
//
//        if activity.isShieldActivityName {
//            let applicationsToRemove = center
//                .events(for: activity)
//                .filter(\.key.isTodayEvent)
//                .map(\.value)
//                .flatMap(\.applications)
//
//            let originalApplications = store.shield.applications ?? []
//            let remainedApplications = originalApplications.subtracting(applicationsToRemove)
//            store.shield.applications = remainedApplications
//        }
//    }

//    override func intervalDidEnd(for activity: DeviceActivityName) {
//        super.intervalDidEnd(for: activity)
//
//        let applications = center.todayInScheduleShieldApplications()
//        let count = applications.count
//        store.shield.applications = applications
//    }

//    override func intervalDidEnd(for activity: DeviceActivityName) {
//        super.intervalDidEnd(for: activity)
//        // 在这个回调里 activity 已经从 DeviceActivityCenter 中remove掉了
//
//        if activity.isShieldActivityName {
//            let applicationsToRemove = center
//                .events(for: activity)
//                .filter(\.key.isTodayEvent)
//                .map(\.value)
//                .flatMap(\.applications)
//
//            let originalApplications = store.shield.applications ?? []
//            let remainedApplications = originalApplications.subtracting(applicationsToRemove)
//            store.shield.applications = remainedApplications
//        }
//    }
}

extension Array where Element: Hashable {
    mutating func removeFirst(_ element: Element) {
        if let index = firstIndex(of: element) {
            remove(at: index)
        }
    }
}
