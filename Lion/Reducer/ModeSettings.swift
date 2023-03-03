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
        isDenyAppRemoval: false,
        isDenyAppInstallation: false,
        isBlockApps: true,
        blockAppsSettings: .none,
        isShieldApps: true,
        shieldAppsSettings: .default
    )

    static let loan: Self = .init(
        modeName: .loan,
        isOn: false,
        isPresented: false,
        isDenyAppRemoval: false,
        isDenyAppInstallation: false,
        isBlockApps: true,
        blockAppsSettings: .none,
        isShieldApps: true,
        shieldAppsSettings: .default
    )
}

struct ModeSettings: ReducerProtocol {
    struct State: Mode {
        let modeName: String
        var isOn: Bool

        @NotCoded var isSetting: Bool = false

        @NotCoded var isPresented: Bool

        var isDenyAppRemoval: Bool
        var isDenyAppInstallation: Bool

        var isBlockApps: Bool
        var blockAppsSettings: AppsSelection.State

        var isShieldApps: Bool
        var shieldAppsSettings: ShieldAppsSettings.State
    }

    enum Action: Equatable {
        case toggleIsOn(Bool)
        case updateIsOn(Bool)

        case updateIsSetting(Bool)

        case toggleIsPresented(Bool)

        case toggleIsDenyAppRemoval(Bool)
        case updateIsDenyAppRemoval(Bool)

        case toggleIsDenyAppInstallation(Bool)
        case updateIsDenyAppInstallation(Bool)

        case toggleIsBlockApps(Bool)
        case updateIsBlockApps(Bool)

        case toggleIsShieldApps(Bool)
        case updateIsShieldApps(Bool)

        case blockAppsSettings(AppsSelection.Action)
        case shieldAppsSettings(ShieldAppsSettings.Action)

        case none
    }

    @Dependency(\.uuid) var uuid
    @Dependency(\.modeManager) var modeManager
    @Dependency(\.shieldAppsMonitor) var shieldAppsMonitor
//    @Dependency(\.application) var application

    struct CancelToken: Hashable {}

    func turnOn(_ state: State) async throws {
        if state.isShieldApps {
            let items = state.shieldAppsSettings.items.elements
            try shieldAppsMonitor.startMonitoringItems(items)
        } else {
            shieldAppsMonitor.stopMonitoringAll()
        }

        if state.isBlockApps {
            modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
        } else {
            modeManager.setBlockAppTokens([])
        }
        modeManager.denyAppInstallation(state.isDenyAppInstallation)
        modeManager.denyAppRemoval(state.isDenyAppRemoval)
    }

    func turnOff() {
        shieldAppsMonitor.stopMonitoringAll()
        modeManager.setBlockAppTokens([])
        modeManager.denyAppInstallation(false)
        modeManager.denyAppRemoval(false)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .toggleIsPresented(isPresented):
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
                return .run { send in
                    await send(.updateIsSetting(true))
                    turnOff()
                    await send(.updateIsSetting(false))
                    await send(.updateIsOn(false))
                }

            case let .updateIsOn(isOn):
                state.isOn = isOn
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
                    let items = state.shieldAppsSettings.items.elements
                    try shieldAppsMonitor.startMonitoringItems(items)
                    return .updateIsShieldApps(true)
                })

            case .toggleIsShieldApps(false) where state.isOn:
                return .task(operation: {
                    shieldAppsMonitor.stopMonitoringAll()
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

            case let .shieldAppsSettings(.willAddItem(item)) where state.isOn && state.isShieldApps:
                return .run(operation: { [state] send in
                    await send(.shieldAppsSettings(.selectedItem(.updateIsUpdating(true))))
                    do {
                        shieldAppsMonitor.stopMonitoringAll()
                        var aliveItems = state.shieldAppsSettings.items
                        aliveItems[id: item.id] = item
                        try shieldAppsMonitor.startMonitoringItems(aliveItems.elements)
//                        try shieldAppsMonitor.startMonitoringItem(item)
                        await send(.shieldAppsSettings(.addItem(item)))
                        await send(.shieldAppsSettings(.selectedItem(.updateIsUpdating(false))))
                    } catch {
                        await send(.shieldAppsSettings(.selectedItem(.updateIsUpdating(false))))
                    }
                })

            case let .shieldAppsSettings(.willAddItem(item)) where !(state.isOn && state.isShieldApps):
                return .task(operation: {
                    .shieldAppsSettings(.addItem(item))
                })

            case let .shieldAppsSettings(.willUpdateItem(item)) where state.isOn && state.isShieldApps:
                return .run(operation: { [state] send in
                    await send(.shieldAppsSettings(.selectedItem(.updateIsUpdating(true))))
                    do {
                        shieldAppsMonitor.stopMonitoringAll()
                        var aliveItems = state.shieldAppsSettings.items
                        aliveItems[id: item.id] = item
                        try shieldAppsMonitor.startMonitoringItems(aliveItems.elements)
//                        shieldAppsMonitor.stopMonitoringItem(item)
//                        try await Task.sleep(for: .milliseconds(1000))
//                        try shieldAppsMonitor.startMonitoringItem(item)
                        await send(.shieldAppsSettings(.updateItem(item)))
                        await send(.shieldAppsSettings(.selectedItem(.updateIsUpdating(false))))
                    } catch {
                        await send(.shieldAppsSettings(.selectedItem(.updateIsUpdating(false))))
                    }
                })

            case let .shieldAppsSettings(.willUpdateItem(item)) where !(state.isOn && state.isShieldApps):
                return .task(operation: {
                    .shieldAppsSettings(.updateItem(item))
                })

            case let .shieldAppsSettings(.willDeleteItem(item)) where state.isOn && state.isShieldApps:
                return .run(operation: { [state] send in
                    await send(.shieldAppsSettings(.selectedItem(.updateIsDeleting(true))))
                    do {
                        shieldAppsMonitor.stopMonitoringAll()
                        var aliveItems = state.shieldAppsSettings.items
                        aliveItems[id: item.id] = nil
                        try shieldAppsMonitor.startMonitoringItems(aliveItems.elements)
//                        shieldAppsMonitor.stopMonitoringItem(item)
                        await send(.shieldAppsSettings(.deleteItem(item)))
                        await send(.shieldAppsSettings(.selectedItem(.updateIsDeleting(false))))
                    } catch {
                        await send(.shieldAppsSettings(.selectedItem(.updateIsDeleting(false))))
                    }
                })

            case let .shieldAppsSettings(.willDeleteItem(item)) where !(state.isOn && state.isShieldApps):
                return .task(operation: {
                    .shieldAppsSettings(.deleteItem(item))
                })

            default:
                return .none
            }
        }
    }
}
