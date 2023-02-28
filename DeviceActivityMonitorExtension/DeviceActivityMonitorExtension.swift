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
//    private var appScheduler: AppsScheduler = .init()
    private let center: DeviceActivityCenter = .init()
    private let shieldEventKey: DeviceActivityEvent.Name = .shieldSettings

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        if let shieldEvent = center.events(for: activity)[shieldEventKey] {
            let applications = store.shield.applications ?? []
            for app in applications {
                let token = app.hashValue
                print(token)
            }
            let applicationsToAdd = shieldEvent.applications
            for app1 in applicationsToAdd {
                let token = app1.hashValue
                print(token)
            }
            let totalApplications = applications.union(applicationsToAdd)
            store.shield.applications = totalApplications
        }
    }

//    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
//        let applicationsToAdd = center.events(for: activity)[event]?.applications ?? []
//        let originalApplications = store.shield.applications ?? []
//        let totalApplications = originalApplications.union(applicationsToAdd)
//        store.shield.applications = totalApplications
//    }

//    override func intervalDidEnd(for activity: DeviceActivityName) {
//        super.intervalDidEnd(for: activity)
//        if let shieldEvent = center.events(for: activity)[shieldEventKey] {
//            let applications = store.shield.applications ?? []
//            for app in applications {
//                let token = app.hashValue
//                print(token)
//            }
//            let applicationsToDelete = shieldEvent.applications
//            for app1 in applicationsToDelete {
//                let token = app1.hashValue
//                print(token)
//            }
//            let remainedApplications = applications.subtracting(applicationsToDelete)
//            store.shield.applications = remainedApplications
//        }
//
//        if let shieldEvent = center.events(for: activity)[shieldEventKey] {
//            let applications = shieldEvent.applications
//            store.shield.applications = applications
//        }
//    }
}

// private let shieldDeviceActivityNamePrefix = "shiled_device_activity_"
// private let shieldEventKey: DeviceActivityEvent.Name = .shieldSettings
//
// extension DeviceActivityCenter {
//    var shieldActivities: [DeviceActivityName] {
//        activities.filter { $0.rawValue.hasPrefix(shieldDeviceActivityNamePrefix) }
//    }
//
//    var shieldApplications: Set<ApplicationToken> {
//        var applications: Set<ApplicationToken> = []
//        for activity in shieldActivities {
//            if let apps = events(for: activity)[shieldEventKey]?.applications {
//                applications = applications.union(apps)
//            }
//        }
//        return applications
//    }
// }
