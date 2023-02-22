// AppInfo.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/19.

import ComposableArchitecture
import Foundation
import XCTestDynamicOverlay

extension DependencyValues {
    var appInfo: AppInfo { self[AppInfo.self] }
}

struct AppInfo {
    var name: () -> String
    var version: () -> String
    var buildVersion: () -> String
}

extension AppInfo: DependencyKey {
    static let bundle: Bundle = .main

    static var liveValue: Self = .init(
        name: {
            (bundle.infoDictionary?["BundleDisplayName"] as? String) ?? ""
        },
        version: {
            (bundle.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
        },
        buildVersion: {
            (bundle.infoDictionary?["CFBundleVersion"] as? String) ?? ""
        }
    )

    static let testValue: Self = .init(
        name: XCTUnimplemented("\(Self.self).name"),
        version: XCTUnimplemented("\(Self.self).version"),
        buildVersion: XCTUnimplemented("\(Self.self).buildVersion")
    )
}
