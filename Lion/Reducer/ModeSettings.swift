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
            let aliveItems = state.shieldAppsSettings.items.elements
            try shieldAppsMonitor.startMonitoringItems(aliveItems)
        } else {
            try shieldAppsMonitor.stopMonitoringAll()
        }
        
        if state.isBlockApps {
            try modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
        } else {
            try modeManager.setBlockAppTokens([])
        }
        try modeManager.denyAppInstallation(state.isDenyAppInstallation)
        try modeManager.denyAppRemoval(state.isDenyAppRemoval)
    }

    func turnOff(state _: State) throws {
        try shieldAppsMonitor.stopMonitoringAll()
        try modeManager.setBlockAppTokens([])
        try modeManager.denyAppInstallation(false)
        try modeManager.denyAppRemoval(false)
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
                return .task { [state] in
                    try turnOff(state: state)
                    return .updateIsOn(false)
                }

            case let .updateIsOn(isOn):
                state.isOn = isOn
                state.isSetting = false
                return .none

            case let .toggleIsDenyAppInstallation(isOn):
                return .task(operation: { [state] in
                    if state.isOn {
                        try modeManager.denyAppInstallation(isOn)
                    }
                    return .updateIsDenyAppInstallation(isOn)
                })

            case let .updateIsDenyAppInstallation(isOn):
                state.isDenyAppInstallation = isOn
                return .none

            case let .toggleIsDenyAppRemoval(isOn):
                return .task(operation: { [state] in
                    if state.isOn {
                        try modeManager.denyAppRemoval(isOn)
                    }
                    return .updateIsDenyAppRemoval(isOn)
                })

            case let .updateIsDenyAppRemoval(isOn):
                state.isDenyAppRemoval = isOn
                return .none

            case .toggleIsBlockApps(true):
                return .task(operation: { [state] in
                    if state.isOn {
                        try modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
                    }
                    return .updateIsBlockApps(true)
                })

            case .toggleIsBlockApps(false):
                return .task(operation: { [state] in
                    if state.isOn {
                        try modeManager.setBlockAppTokens([])
                    }
                    return .updateIsBlockApps(false)
                })

            case let .updateIsBlockApps(isOn):
                state.isBlockApps = isOn
                return .none

            case .toggleIsShieldApps(true):
                return .task(operation: { [state] in
                    if state.isOn {
                        let aliveItems = state.shieldAppsSettings.items.elements
                        try shieldAppsMonitor.startMonitoringItems(aliveItems)
                    }
                    return .updateIsShieldApps(true)
                })

            case .toggleIsShieldApps(false):
                return .task(operation: { [state] in
                    if state.isOn {
                        try shieldAppsMonitor.stopMonitoringAll()
                    }
                    return .updateIsShieldApps(false)
                })

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
                    try modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
                }, onlyWhen: state.isOn && state.isBlockApps)

            case let .shieldAppsSettings(.willAddItem(item)):
                return .task(operation: { [state] in
                    if state.isOn, state.isShieldApps {
                        try shieldAppsMonitor.stopMonitoringAll()
                        var aliveItems = state.shieldAppsSettings.items
                        aliveItems[id: item.id] = item
                        try shieldAppsMonitor.startMonitoringItems(aliveItems.elements)
                    }
                    return .shieldAppsSettings(.addItem(item))
                })

            case let .shieldAppsSettings(.willUpdateItem(item)):
                return .task(operation: { [state] in
                    if state.isOn, state.isShieldApps {
                        try shieldAppsMonitor.stopMonitoringAll()
                        var aliveItems = state.shieldAppsSettings.items
                        aliveItems[id: item.id] = item
                        try shieldAppsMonitor.startMonitoringItems(aliveItems.elements)
                    }
                    return .shieldAppsSettings(.updateItem(item))
                })

            case let .shieldAppsSettings(.willDeleteItem(item)):
                return .task(operation: { [state] in
                    if state.isOn, state.isShieldApps {
                        try shieldAppsMonitor.stopMonitoringAll()
                        var aliveItems = state.shieldAppsSettings.items
                        aliveItems[id: item.id] = nil
                        try shieldAppsMonitor.startMonitoringItems(aliveItems.elements)
                    }
                    return .shieldAppsSettings(.deleteItem(item))
                })

//            case let .shieldAppsSettings(.willAddItem(item)):
//                return .task(operation: { [state] in
//                    if state.isOn, state.isShieldApps {
//                        try await shieldAppsMonitor.startMonitoringItem(item)
//                    }
//                    return .shieldAppsSettings(.addItem(item))
//                })
//
//            case let .shieldAppsSettings(.willUpdateItem(item)):
//                return .task(operation: { [state] in
//                    if state.isOn, state.isShieldApps {
//                        try await shieldAppsMonitor.startMonitoringItem(item)
//                    }
//                    return .shieldAppsSettings(.updateItem(item))
//                })
//
//            case let .shieldAppsSettings(.willDeleteItem(item)):
//                return .task(operation: { [state] in
//                    if state.isOn, state.isShieldApps {
//                        try await shieldAppsMonitor.stopMonitoringItem(item)
//                    }
//                    return .shieldAppsSettings(.deleteItem(item))
//                })

            default:
                return .none
            }
        }
    }
}
