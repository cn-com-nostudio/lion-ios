// ModeSettings.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import DependenciesAdditions
import Foundation
import ManagedSettings
import UIKit

extension String {
    static let child: Self = "child mode"
    static let loan: Self = "loan mode"
}

extension ModeSettings.State {
    static let child: Self = .init(
        modeName: .child,
        isOn: false,
        isPresented: false,
        isDenyAppRemoval: true,
        isDenyAppInstallation: true,
        isBlockApps: false,
        blockAppsSettings: .none,
        isShieldApps: false,
        shieldAppsSettings: .default
    )

    static let loan: Self = .init(
        modeName: .loan,
        isOn: false,
        isPresented: false,
        isDenyAppRemoval: false,
        isDenyAppInstallation: true,
        isBlockApps: false,
        blockAppsSettings: .none,
        isShieldApps: false,
        shieldAppsSettings: .default
    )
}

struct ModeSettings: ReducerProtocol {
    struct State: Mode {
        let modeName: String
        var isOn: Bool
        @NotCoded var isPresented: Bool

        var isDenyAppRemoval: Bool
        var isDenyAppInstallation: Bool

        var isBlockApps: Bool
        var blockAppsSettings: AppsSelection.State

        var isShieldApps: Bool
        var shieldAppsSettings: ShieldAppsSettings.State

        @NotCoded var isSetting: Bool = false
    }

    enum Action: Equatable {
        case toggleIsPresented(Bool)
        case toggleIsOn(Bool)
        case updateIsOn(Bool)
        case toggleIsDenyAppInstallation(Bool)
        case toggleIsDenyAppRemoval(Bool)
        case toggleIsBlockApps(Bool)
        case toggleIsShieldApps(Bool)
//        case settingDone

        case blockAppsSettings(AppsSelection.Action)
        case shieldAppsSettings(ShieldAppsSettings.Action)
    }

    @Dependency(\.uuid) var uuid
    @Dependency(\.modeManager) var modeManager
    @Dependency(\.shieldAppsMonitor) var shieldAppsMonitor
    @Dependency(\.application) var application

    struct CancelToken: Hashable {}

    func turnOn(_ state: State) async throws {
        if state.isShieldApps {
            let aliveItems = state.shieldAppsSettings.items.elements // .filter(\.isOn)
            try await shieldAppsMonitor.startMonitoringItems(aliveItems)
        }
        if state.isBlockApps {
            try await modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
        }
        try await modeManager.denyAppInstallation(state.isDenyAppInstallation)
        try await modeManager.denyAppRemoval(state.isDenyAppRemoval)
    }

    func turnOff() async throws {
        try await shieldAppsMonitor.stopMonitoringAll()
        try await modeManager.setBlockAppTokens([])
        try await modeManager.denyAppInstallation(false)
        try await modeManager.denyAppRemoval(false)
    }

//    func turnOn(_ state: State) async throws {
//        Task {
//            if state.isShieldApps {
//                let aliveItems = state.shieldAppsSettings.items.elements // .filter(\.isOn)
//                try await shieldAppsMonitor.startMonitoringItems(aliveItems)
//            }
//        }
//        Task {
//            if state.isBlockApps {
//                try await modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
//            }
//        }
//        Task {
//            try await modeManager.denyAppInstallation(state.isDenyAppInstallation)
//        }
//        Task {
//            try await modeManager.denyAppRemoval(state.isDenyAppRemoval)
//        }
//    }
//
//    func turnOff() async throws {
//        Task {
//            try await shieldAppsMonitor.stopMonitoringAll()
//        }
//        Task {
//            try await modeManager.setBlockAppTokens([])
//        }
//        Task {
//            try await modeManager.denyAppInstallation(false)
//        }
//        Task {
//            try await modeManager.denyAppRemoval(false)
//        }
//    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .toggleIsPresented(isPresented):
                state.isPresented = isPresented
                return .none

            case .toggleIsOn(true):
                guard state.isOn != true else { return .none }
//                state.isOn = true
                state.isSetting = true
                return .task { [state] in
//                    let backgroundTaskID = await application.beginBackgroundTask(withName: "turnOnMode")
                    try await turnOn(state)
//                    await application.endBackgroundTask(backgroundTaskID)
                    return .updateIsOn(true)
                }
//                .debounce(id: CancelToken(), for: .milliseconds(50), scheduler: DispatchQueue.global())
//                .receive(on: DispatchQueue.main)
//                .eraseToEffect()

            case .toggleIsOn(false):
                guard state.isOn != false else { return .none }
//                state.isOn = false
                state.isSetting = true
                return .task {
//                    let backgroundTaskID = await application.beginBackgroundTask(withName: "turnOffMode")
                    try await turnOff()
//                    await application.endBackgroundTask(backgroundTaskID)
                    return .updateIsOn(false)
                }
//                .debounce(id: CancelToken(), for: .milliseconds(50), scheduler: DispatchQueue.global())
//                .receive(on: DispatchQueue.main)
//                .eraseToEffect()

            case let .updateIsOn(isOn):
                state.isOn = isOn
                state.isSetting = false
                return .none

            case let .toggleIsDenyAppInstallation(isOn):
                state.isDenyAppInstallation = isOn
                return .fireAndForget({
                    try await modeManager.denyAppInstallation(isOn)
                }, onlyWhen: state.isOn)

            case let .toggleIsDenyAppRemoval(isOn):
                state.isDenyAppRemoval = isOn
                return .fireAndForget({
                    try await modeManager.denyAppRemoval(isOn)
                }, onlyWhen: state.isOn)

            case .toggleIsBlockApps(true):
                state.isBlockApps = true
                return .fireAndForget({ [state] in
                    try await modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
                }, onlyWhen: state.isOn)

            case .toggleIsBlockApps(false):
                state.isBlockApps = false
                return .fireAndForget({
                    try await modeManager.setBlockAppTokens([])
                }, onlyWhen: state.isOn)

            case .toggleIsShieldApps(true):
                state.isShieldApps = true
                return .fireAndForget({ [state] in
                    let backgroundTaskID = await application.beginBackgroundTask(withName: "trunOnShieldApps")
                    let aliveItems = state.shieldAppsSettings.items.elements // .filter(\.isOn)
                    try await shieldAppsMonitor.startMonitoringItems(aliveItems)
                    await application.endBackgroundTask(backgroundTaskID)
                }, onlyWhen: state.isOn)

            case .toggleIsShieldApps(false):
                state.isShieldApps = false
                return .fireAndForget({
                    let backgroundTaskID = await application.beginBackgroundTask(withName: "turnOffShieldApps")
                    try await shieldAppsMonitor.stopMonitoringAll()
                    await application.endBackgroundTask(backgroundTaskID)
                }, onlyWhen: state.isOn)

            default:
                return .none
            }
        }

        Scope(state: \.blockAppsSettings, action: /Action.blockAppsSettings) {
            AppsSelection()
        }

        Scope(state: \.shieldAppsSettings, action: /Action.shieldAppsSettings) {
            ShieldAppsSettings()
        }

        Reduce { state, action in
            switch action {
            case .blockAppsSettings(.update):
                return .fireAndForget({ [state] in
                    try await modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
                }, onlyWhen: state.isOn && state.isBlockApps)

            case .shieldAppsSettings(.addItem),
                 .shieldAppsSettings(.updateItem),
                 .shieldAppsSettings(.deleteItem):
                return .fireAndForget({ [state] in
                    try await shieldAppsMonitor.stopMonitoringAll()
                    let aliveItems = state.shieldAppsSettings.items.elements // .filter(\.isOn)
                    try await shieldAppsMonitor.startMonitoringItems(aliveItems)
                }, onlyWhen: state.isOn)

            default:
                return .none
            }
        }
    }
}
