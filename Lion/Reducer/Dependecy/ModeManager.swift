// ModeManager.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import DeviceActivitySharing
import FamilyControls
import ManagedSettings
import XCTestDynamicOverlay

extension DependencyValues {
    var modeManager: ModeManager { self[ModeManager.self] }
}

struct ModeManager {
    var denyAppInstallation: (_ isDenied: Bool) -> Void
    var denyAppRemoval: (_ isDenied: Bool) -> Void
    var setBlockAppTokens: (_ applications: Set<ApplicationToken>) -> Void
}

extension ModeManager: DependencyKey {
    static let sharedStore: ManagedSettingsStore = .init(named: .shared)

    static var liveValue: Self = .init(
        denyAppInstallation: { isDenied in
            sharedStore.application.denyAppInstallation = isDenied
        },
        denyAppRemoval: { isDenied in
            sharedStore.application.denyAppRemoval = isDenied
        },
        setBlockAppTokens: { appTokens in
            let applications = Set(appTokens.map(Application.init(token:)))
            sharedStore.application.blockedApplications = applications
        }
    )

    static let testValue: Self = .init(
        denyAppInstallation: XCTUnimplemented("\(Self.self).denyAppInstallation"),
        denyAppRemoval: XCTUnimplemented("\(Self.self).denyAppRemoval"),
        setBlockAppTokens: XCTUnimplemented("\(Self.self).setBlockAppTokens")
    )
}
