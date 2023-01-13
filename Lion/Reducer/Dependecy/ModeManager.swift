// ModeManager.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/1.

import ComposableArchitecture
import ManagedSettings
import XCTestDynamicOverlay

extension DependencyValues {
    var modeManager: ModeManager { self[ModeManager.self] }
}

struct ModeManager {
    var clearAllSettings: () -> Void
    var denyAppInstallation: (_ isDenied: Bool) -> Void
    var denyAppRemoval: (_ isDenied: Bool) -> Void
    var setBlockAppTokens: (_ applications: Set<ApplicationToken>?) -> Void
    var setShieldAppTokens: (_ applications: Set<ApplicationToken>?) -> Void
}

extension ModeManager: DependencyKey {
    static let sharedStore = ManagedSettingsStore()

    static var liveValue: Self = .init(
        clearAllSettings: {
            sharedStore.clearAllSettings()
        },
        denyAppInstallation: { isDenied in
            sharedStore.application.denyAppInstallation = isDenied
        },
        denyAppRemoval: { isDenied in
            sharedStore.application.denyAppRemoval = isDenied
        },
        setBlockAppTokens: { appTokens in
            if let appTokens {
                let applications = Set(appTokens.map(Application.init(token:)))
                sharedStore.application.blockedApplications = applications
            } else {
                sharedStore.application.blockedApplications = nil
            }
        },
        setShieldAppTokens: { appTokens in
            if let appTokens {
                sharedStore.shield.applications = appTokens
            } else {
                sharedStore.shield.applications = nil
            }
        }
    )

    static let testValue: Self = .init(
        clearAllSettings: XCTUnimplemented("\(Self.self).clearAllSettings"),
        denyAppInstallation: XCTUnimplemented("\(Self.self).denyAppInstallation"),
        denyAppRemoval: XCTUnimplemented("\(Self.self).denyAppRemoval"),
        setBlockAppTokens: XCTUnimplemented("\(Self.self).setBlockAppTokens"),
        setShieldAppTokens: XCTUnimplemented("\(Self.self).setShieldAppTokens")
    )
}