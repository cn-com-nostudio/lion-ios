// ModeSettings.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import DependenciesAdditions
import Foundation
import ManagedSettings
import UIKit

enum Mode: Codable, Equatable {
    case child
    case loan

    var name: String {
        switch self {
        case .child:
            return "child mode"

        case .loan:
            return "loan mode"
        }
    }
}

extension ModeSettings.State {
    static let child: Self = .init(
        mode: .child,
        isOn: false,
        isPresented: false,
        isDenyAppRemoval: false,
        isDenyAppInstallation: false,
        isBlockApps: true,
        blockAppsSettings: .init(isPresented: false),
        isShieldApps: true,
        shieldAppsSettings: .default
    )

    static let loan: Self = .init(
        mode: .loan,
        isOn: false,
        isPresented: false,
        isDenyAppRemoval: false,
        isDenyAppInstallation: false,
        isBlockApps: true,
        blockAppsSettings: .init(isPresented: false),
        isShieldApps: true,
        shieldAppsSettings: .default
    )
}

struct ModeSettings: ReducerProtocol {
    struct State: Codable, Equatable {
        let mode: Mode
        var isOn: Bool

        var turnOnTimes: Int = 0

        @NotCoded var isSetting: Bool = false

        @NotCoded var isPresented: Bool

        var isDenyAppRemoval: Bool
        var isDenyAppInstallation: Bool

        var isBlockApps: Bool
        var blockAppsSettings: AppsSelection.State

        var isShieldApps: Bool
        var shieldAppsSettings: ShieldAppsSettings.State

        var denyAppInstallationTurnOnTimes: Int = 0
        @NotCoded var showDenyAppInstallationTip: Bool = false

        var denyAppRemovalTurnOnTimes: Int = 0
        @NotCoded var showDenyAppRemovalTip: Bool = false
    }

    enum Action: Equatable {
        case willToggleIsOn(Bool)
        case toggleIsOn(Bool)
        case updateIsOn(Bool)

        case updateIsSetting(Bool)

        case toggleIsPresented(Bool)
        case updateIsPresented(Bool)

        case toggleIsDenyAppRemoval(Bool)
        case updateIsDenyAppRemoval(Bool)

        case willToggleIsDenyAppInstallation(Bool)
        case toggleIsDenyAppInstallation(Bool)
        case updateIsDenyAppInstallation(Bool)

        case toggleIsBlockApps(Bool)
        case updateIsBlockApps(Bool)

        case toggleIsShieldApps(Bool)
        case updateIsShieldApps(Bool)

        case blockAppsSettings(AppsSelection.Action)
        case shieldAppsSettings(ShieldAppsSettings.Action)

        case toggleShowDenyAppInstallationTip(Bool)
        case toggleShowDenyAppRemovalTip(Bool)

        case none
    }

    @Dependency(\.uuid) var uuid
    @Dependency(\.modeManager) var modeManager
    @Dependency(\.shieldAppsMonitor) var shieldAppsMonitor
//    @Dependency(\.application) var application
//    @Dependency(\.memberState) var memberState

    struct CancelToken: Hashable {}

    func turnOn(_ state: State) async throws {
        if state.isShieldApps {
            let items = state.shieldAppsSettings.items.elements.filter(\.isOn)
            try shieldAppsMonitor.startMonitoringItems(items)
        } else {
            let items = state.shieldAppsSettings.items.elements
            shieldAppsMonitor.stopMonitoringItems(items)
        }

        if state.isBlockApps {
            modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
        } else {
            modeManager.setBlockAppTokens([])
        }
        modeManager.denyAppInstallation(state.isDenyAppInstallation)
        modeManager.denyAppRemoval(state.isDenyAppRemoval)
    }

    func turnOff(_ state: State) {
        let items = state.shieldAppsSettings.items.elements
        shieldAppsMonitor.stopMonitoringItems(items)
        modeManager.setBlockAppTokens([])
        modeManager.denyAppInstallation(false)
        modeManager.denyAppRemoval(false)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .updateIsPresented(isPresented):
                state.isPresented = isPresented
                return .none

            case let .updateIsSetting(isOn):
                state.isSetting = isOn
                return .none

            case .toggleIsOn(true):
                guard state.isOn != true else { return .none }
                return .run { [state] send in
                    await send(.updateIsSetting(true))
                    do {
                        try await turnOn(state)
                        await send(.updateIsOn(true))
                        await send(.updateIsSetting(false))
                    } catch {
                        await send(.updateIsSetting(false))
                    }
                }

            case .toggleIsOn(false):
                guard state.isOn != false else { return .none }
                return .run { [state] send in
                    await send(.updateIsSetting(true))
                    turnOff(state)
                    await send(.updateIsSetting(false))
                    await send(.updateIsOn(false))
                }

            case let .updateIsOn(isOn):
                state.isOn = isOn
                if isOn {
                    state.turnOnTimes += 1
                }
                return .none

            case let .toggleIsDenyAppInstallation(isOn) where state.isOn:
                return .task(operation: {
                    modeManager.denyAppInstallation(isOn)
                    return .updateIsDenyAppInstallation(isOn)
                })

            case let .toggleIsDenyAppInstallation(isOn) where !state.isOn:
                return .task(operation: {
                    .updateIsDenyAppInstallation(isOn)
                })

            case let .updateIsDenyAppInstallation(isOn):
                state.isDenyAppInstallation = isOn
                return .none

            case let .toggleIsDenyAppRemoval(isOn) where state.isOn:
                return .task(operation: {
                    modeManager.denyAppRemoval(isOn)
                    return .updateIsDenyAppRemoval(isOn)
                })

            case let .toggleIsDenyAppRemoval(isOn) where !state.isOn:
                return .task(operation: {
                    .updateIsDenyAppRemoval(isOn)
                })

            case let .updateIsDenyAppRemoval(isOn):
                state.isDenyAppRemoval = isOn
                return .none

            case .toggleIsBlockApps(true) where state.isOn:
                return .task(operation: { [state] in
                    modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
                    return .updateIsBlockApps(true)
                })

            case .toggleIsBlockApps(false) where state.isOn:
                return .task(operation: {
                    modeManager.setBlockAppTokens([])
                    return .updateIsBlockApps(false)
                })

            case let .toggleIsBlockApps(isOn) where !state.isOn:
                return .task(operation: {
                    .updateIsBlockApps(isOn)
                })

            case let .updateIsBlockApps(isOn):
                state.isBlockApps = isOn
                return .none

            case .toggleIsShieldApps(true) where state.isOn:
                return .task(operation: { [state] in
                    let items = state.shieldAppsSettings.items.elements.filter(\.isOn)
                    try shieldAppsMonitor.startMonitoringItems(items)
                    return .updateIsShieldApps(true)
                })

            case .toggleIsShieldApps(false) where state.isOn:
                return .task(operation: { [state] in
                    let items = state.shieldAppsSettings.items.elements
                    shieldAppsMonitor.stopMonitoringItems(items)
                    return .updateIsShieldApps(false)
                })

            case let .toggleIsShieldApps(isOn) where !state.isOn:
                return .task(operation: {
                    .updateIsShieldApps(isOn)
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
            case .blockAppsSettings(.update) where state.isOn && state.isBlockApps:
                return .fireAndForget { [state] in
                    modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
                }

            case let .shieldAppsSettings(.items(id: id, action: .toggleIsOn(isOn))) where state.isOn && state.isShieldApps:
                return .run { [state] send in
                    guard let item = state.shieldAppsSettings.items[id: id] else { return }
                    if isOn {
                        do {
                            try shieldAppsMonitor.startMonitoringItem(item)
                        } catch {
                            await send(.shieldAppsSettings(.items(id: item.id, action: .toggleIsOn(false))))
                        }
                    } else {
                        shieldAppsMonitor.stopMonitoringItem(item)
                    }
                }

            case let .shieldAppsSettings(.addItem(item)) where state.isOn && state.isShieldApps && item.isOn:
                return .run { send in
                    do {
                        try shieldAppsMonitor.startMonitoringItem(item)
                    } catch {
                        await send(.shieldAppsSettings(.items(id: item.id, action: .toggleIsOn(false))))
                    }
                }

            case let .shieldAppsSettings(.updateItem(item)) where state.isOn && state.isShieldApps && item.isOn:
                return .run { send in
                    do {
                        shieldAppsMonitor.stopMonitoringItem(item)
                        try shieldAppsMonitor.startMonitoringItem(item)
                    } catch {
                        await send(.shieldAppsSettings(.items(id: item.id, action: .toggleIsOn(false))))
                    }
                }

            case let .shieldAppsSettings(.deleteItem(item)) where state.isOn && state.isShieldApps && item.isOn:
                return .fireAndForget {
                    shieldAppsMonitor.stopMonitoringItem(item)
                }

            default:
                return .none
            }
        }

        Reduce { state, action in
            switch action {
            case .toggleIsDenyAppInstallation(true):
                state.denyAppInstallationTurnOnTimes += 1
                return .task { [state] in
                    .toggleShowDenyAppInstallationTip(state.denyAppInstallationTurnOnTimes == 1)
                }

            case .toggleIsDenyAppRemoval(true):
                state.denyAppRemovalTurnOnTimes += 1
                return .task { [state] in
                    .toggleShowDenyAppRemovalTip(state.denyAppRemovalTurnOnTimes == 1)
                }

            case let .toggleShowDenyAppInstallationTip(isOn):
                state.showDenyAppInstallationTip = isOn
                return .none

            case let .toggleShowDenyAppRemovalTip(isOn):
                state.showDenyAppRemovalTip = isOn
                return .none

            default:
                return .none
            }
        }
    }
}
