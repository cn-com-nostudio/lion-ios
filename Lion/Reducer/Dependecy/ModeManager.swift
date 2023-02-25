// ModeManager.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import ManagedSettings
import XCTestDynamicOverlay

extension DependencyValues {
    var modeManager: ModeManager { self[ModeManager.self] }
}

struct ModeManager {
    var clearAllSettings: () async -> Void
    var denyAppInstallation: (_ isDenied: Bool) async -> Void
    var denyAppRemoval: (_ isDenied: Bool) async -> Void
    var setBlockAppTokens: (_ applications: Set<ApplicationToken>?) async -> Void
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
        }
    )

    static let testValue: Self = .init(
        clearAllSettings: XCTUnimplemented("\(Self.self).clearAllSettings"),
        denyAppInstallation: XCTUnimplemented("\(Self.self).denyAppInstallation"),
        denyAppRemoval: XCTUnimplemented("\(Self.self).denyAppRemoval"),
        setBlockAppTokens: XCTUnimplemented("\(Self.self).setBlockAppTokens")
    )
}
