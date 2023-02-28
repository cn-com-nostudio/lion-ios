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
        case updateIsDenyAppInstallation(Bool)
        case toggleIsDenyAppRemoval(Bool)
        case updateIsDenyAppRemoval(Bool)
        case toggleIsBlockApps(Bool)
        case updateIsBlockApps(Bool)
        case toggleIsShieldApps(Bool)
        case updateIsShieldApps(Bool)
//        case settingDone

        case blockAppsSettings(AppsSelection.Action)
        case shieldAppsSettings(ShieldAppsSettings.Action)
        case none
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

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .toggleIsPresented(isPresented):
                state.isPresented = isPresented
                return .none

            case .toggleIsOn(true):
                guard state.isOn != true else { return .none }
                state.isSetting = true
                return .task { [state] in
                    try await turnOn(state)
                    return .updateIsOn(true)
                }

            case .toggleIsOn(false):
                guard state.isOn != false else { return .none }
                state.isSetting = true
                return .task {
                    try await turnOff()
                    return .updateIsOn(false)
                }

            case let .updateIsOn(isOn):
                state.isOn = isOn
                state.isSetting = false
                return .none

            case let .toggleIsDenyAppInstallation(isOn):
                return .task(operation: {
                    try await modeManager.denyAppInstallation(isOn)
                    return .updateIsDenyAppInstallation(isOn)
                }, onlyWhen: state.isOn)

            case let .updateIsDenyAppInstallation(isOn):
                state.isDenyAppInstallation = isOn
                return .none

            case let .toggleIsDenyAppRemoval(isOn):
                return .task(operation: {
                    try await modeManager.denyAppRemoval(isOn)
                    return .updateIsDenyAppRemoval(isOn)
                }, onlyWhen: state.isOn)

            case let .updateIsDenyAppRemoval(isOn):
                state.isDenyAppRemoval = isOn
                return .none

            case .toggleIsBlockApps(true):
                return .task(operation: { [state] in
                    try await modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
                    return .updateIsBlockApps(true)
                }, onlyWhen: state.isOn)

            case .toggleIsBlockApps(false):
                return .task(operation: {
                    try await modeManager.setBlockAppTokens([])
                    return .updateIsBlockApps(false)
                }, onlyWhen: state.isOn)

            case let .updateIsBlockApps(isOn):
                state.isBlockApps = isOn
                return .none

            case .toggleIsShieldApps(true):
                return .task(operation: { [state] in
                    let aliveItems = state.shieldAppsSettings.items.elements // .filter(\.isOn)
                    try await shieldAppsMonitor.startMonitoringItems(aliveItems)
                    return .updateIsShieldApps(true)
                }, onlyWhen: state.isOn)

            case .toggleIsShieldApps(false):
                return .task(operation: {
                    try await shieldAppsMonitor.stopMonitoringAll()
                    try await Task.sleep(for: .milliseconds(800))
                    return .updateIsShieldApps(false)
                }, onlyWhen: state.isOn)

            case let .updateIsShieldApps(isOn):
                state.isShieldApps = isOn
                return .none

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

            case let .shieldAppsSettings(.willAddItem(item)):
                return .task(operation: { [state] in
                    try await shieldAppsMonitor.stopMonitoringAll()
                    try await Task.sleep(for: .milliseconds(100))
                    var aliveItems = state.shieldAppsSettings.items
                    aliveItems[id: item.id] = item
                    try await shieldAppsMonitor.startMonitoringItems(aliveItems.elements)
                    return .shieldAppsSettings(.addItem(item))
                }, onlyWhen: state.isOn && state.isShieldApps)

            case let .shieldAppsSettings(.willUpdateItem(item)):
                return .task(operation: { [state] in
                    try await shieldAppsMonitor.stopMonitoringAll()
                    try await Task.sleep(for: .milliseconds(100))
                    var aliveItems = state.shieldAppsSettings.items
                    aliveItems[id: item.id] = item
                    try await shieldAppsMonitor.startMonitoringItems(aliveItems.elements)
                    return .shieldAppsSettings(.updateItem(item))
                }, onlyWhen: state.isOn && state.isShieldApps)

            case let .shieldAppsSettings(.willDeleteItem(item)):
                return .task(operation: { [state] in
                    try await shieldAppsMonitor.stopMonitoringAll()
                    try await Task.sleep(for: .milliseconds(1000))
                    var aliveItems = state.shieldAppsSettings.items
                    aliveItems[id: item.id] = nil
                    try await shieldAppsMonitor.startMonitoringItems(aliveItems.elements)
                    return .shieldAppsSettings(.deleteItem(item))
                }, onlyWhen: state.isOn && state.isShieldApps)

//            case let .shieldAppsSettings(.addItem(item)):
//                return .fireAndForget({
//                    try await shieldAppsMonitor.startMonitoringItem(item)
//                }, onlyWhen: state.isOn && state.isShieldApps)
//
//            case let .shieldAppsSettings(.updateItem(item)):
//                return .fireAndForget({
////                    try await shieldAppsMonitor.stopMonitoringItem(item)
//                    try await shieldAppsMonitor.startMonitoringItem(item)
//                }, onlyWhen: state.isOn && state.isShieldApps)
//
//            case let .shieldAppsSettings(.deleteItem(item)):
//                return .fireAndForget({
//                    try await shieldAppsMonitor.stopMonitoringItem(item)
//                }, onlyWhen: state.isOn && state.isShieldApps)

            default:
                return .none
            }
        }
    }
}
