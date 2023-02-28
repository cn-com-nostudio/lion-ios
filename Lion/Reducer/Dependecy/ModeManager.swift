// ModeManager.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
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

extension ManagedSettingsStore.Name {
    static let lion: Self = .init("cn.com.nostudio.lion")
}

extension ModeManager: DependencyKey {
    static let sharedStore: ManagedSettingsStore = .init(named: .lion)
    static let center = AuthorizationCenter.shared

    static var liveValue: Self = .init(
        denyAppInstallation: { isDenied in
            guard sharedStore.application.denyAppInstallation != isDenied else { return }
            sharedStore.application.denyAppInstallation = isDenied
        },
        denyAppRemoval: { isDenied in
            guard sharedStore.application.denyAppRemoval != isDenied else { return }
            sharedStore.application.denyAppRemoval = isDenied
        },
        setBlockAppTokens: { appTokens in
            let applications = Set(appTokens.map(Application.init(token:)))
            guard sharedStore.application.blockedApplications != applications else { return }
            sharedStore.application.blockedApplications = applications
        }
    )

    static let testValue: Self = .init(
        denyAppInstallation: XCTUnimplemented("\(Self.self).denyAppInstallation"),
        denyAppRemoval: XCTUnimplemented("\(Self.self).denyAppRemoval"),
        setBlockAppTokens: XCTUnimplemented("\(Self.self).setBlockAppTokens")
    )
}
