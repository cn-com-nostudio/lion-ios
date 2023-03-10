// AppsShcheduler.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

//// AppsShcheduler.swift
//// Copyright (c) 2023 Nostudio
//// Created by Jerry X T Wang on 2023/2/22.
//
// import DeviceActivity
// import Foundation
// import ManagedSettings
//
//
//// incase that the data not consistence. we should reset all events and re-run.
// extension DeviceActivityName {
//    static let clearAllShieldSettings: Self = .init("clean all shield settings")
// }
//
// struct Settings: Codable {
//    // String is DeviceActivityName.rawValue
//    private(set) var appTokens: [String: [ApplicationToken]] = [:]
//
//    var applications: Set<ApplicationToken> {
//        Set(appTokens.values.flatMap { $0 })
//    }
//
//    mutating func add(from event: DeviceActivityEvent, for activity: DeviceActivityName) {
//        appTokens[activity.rawValue] = Array(event.applications)
//    }
//
//    mutating func delete(for activity: DeviceActivityName) {
//        appTokens[activity.rawValue] = nil
//    }
//
//    mutating func clearAll() {
//        appTokens = [:]
//    }
// }
//
// struct AppsScheduler {
//    private let center: DeviceActivityCenter = .init()
//    private let cache: UserDefaultCache<Settings>
//
//    private let shieldEventKey: DeviceActivityEvent.Name = .shieldSettings
//    private let shieldSettingsCacheKey = CacheKey<Settings>("shield_settings")
//    private(set) var shield: Settings {
//        didSet {
//            try? cache.save(shield, for: shieldSettingsCacheKey)
//        }
//    }
//
//    init(cache: UserDefaultCache<Settings> = .init()) {
//        self.cache = cache
//        if let shield = try? cache.load(from: shieldSettingsCacheKey) {
//            self.shield = shield
//        } else {
//            shield = .init()
//        }
//    }
//
//    mutating func intervalDidStart(for activity: DeviceActivityName) {
//        guard let shieldEvent = center.events(for: activity)[shieldEventKey] else { return }
//        let name = activity.rawValue
//        let applications = shieldEvent.applications
//        let applicationsCount = shieldEvent.applications.count
//        let originalApplications = shield.appTokens
//        let originalApplicationsCount = shield.appTokens.count
//        shield.add(from: shieldEvent, for: activity)
//        let afterApplications = shield.applications
//        let afterApplicationsCount = shield.applications.count
//    }
//
//    mutating func intervalDidEnd(for activity: DeviceActivityName) {
//        if activity == .clearAllShieldSettings {
//            shield.clearAll()
//        } else {
//            let originalApplications = shield.appTokens
//            let originalApplicationsCount = shield.appTokens.count
//            shield.delete(for: activity)
//            let afterApplications = shield.applications
//            let afterApplicationsCount = shield.applications.count
//        }
//    }
// }
