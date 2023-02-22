// ModeSettings.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/1/28.

import ComposableArchitecture
import Foundation
import ManagedSettings

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
    }

    enum Action: Equatable {
        case toggleIsPresented(Bool)
        case toggleIsOn(Bool)
        case toggleIsDenyAppInstallation(Bool)
        case toggleIsDenyAppRemoval(Bool)
        case toggleIsBlockApps(Bool)
        case toggleIsShieldApps(Bool)

        case blockAppsSettings(AppsSelection.Action)
        case shieldAppsSettings(ShieldAppsSettings.Action)
    }

    @Dependency(\.uuid) var uuid
    @Dependency(\.modeManager) var modeManager
    @Dependency(\.shieldAppsMonitor) var shieldAppsMonitor

    func turnOn(_ state: State) throws {
        modeManager.denyAppInstallation(state.isDenyAppInstallation)
        modeManager.denyAppRemoval(state.isDenyAppRemoval)
        if state.isBlockApps {
            modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
        }
        if state.isShieldApps {
            let aliveItems = state.shieldAppsSettings.items.elements.filter(\.isOn)
            try shieldAppsMonitor.startMonitoringItems(aliveItems)
        }
    }

    func turnOff() {
        modeManager.clearAllSettings()
        shieldAppsMonitor.stopMonitoringAll()
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .toggleIsPresented(isPresented):
                state.isPresented = isPresented
                return .none

            case .toggleIsOn(true):
                state.isOn = true
                return .fireAndForget { [state] in
                    try turnOn(state)
                }

            case .toggleIsOn(false):
                state.isOn = false
                return .fireAndForget {
                    turnOff()
                }

            case let .toggleIsDenyAppInstallation(isOn):
                state.isDenyAppInstallation = isOn
                return .fireAndForget({
                    modeManager.denyAppInstallation(isOn)
                }, onlyWhen: state.isOn)

            case let .toggleIsDenyAppRemoval(isOn):
                state.isDenyAppRemoval = isOn
                return .fireAndForget({
                    modeManager.denyAppRemoval(isOn)
                }, onlyWhen: state.isOn)

            case .toggleIsBlockApps(true):
                state.isBlockApps = true
                return .fireAndForget({ [state] in
                    modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
                }, onlyWhen: state.isOn)

            case .toggleIsBlockApps(false):
                state.isBlockApps = false
                return .fireAndForget({
                    modeManager.setBlockAppTokens(nil)
                }, onlyWhen: state.isOn)

            case .toggleIsShieldApps(true):
                state.isShieldApps = true
                return .fireAndForget({ [state] in
                    let aliveItems = state.shieldAppsSettings.items.elements.filter(\.isOn)
                    try shieldAppsMonitor.startMonitoringItems(aliveItems)
                }, onlyWhen: state.isOn)

            case .toggleIsShieldApps(false):
                state.isShieldApps = false
                return .fireAndForget({
                    shieldAppsMonitor.stopMonitoringAll()
                }, onlyWhen: state.isOn)

            case .blockAppsSettings(.update):
                return .fireAndForget({ [state] in
                    modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
                }, onlyWhen: state.isOn && state.isBlockApps)

            case let .shieldAppsSettings(.updateItem(item)):
                return .fireAndForget({
                    shieldAppsMonitor.stopMonitoringItem(item)
                    try shieldAppsMonitor.startMonitoringItem(item)
                }, onlyWhen: state.isOn && state.isShieldApps)

            case let .shieldAppsSettings(.deleteItem(item)):
                return .fireAndForget({
                    shieldAppsMonitor.stopMonitoringItem(item)
                }, onlyWhen: state.isOn && state.isShieldApps)

            case let .shieldAppsSettings(.items(id: id, action: .toggleIsOn(isOn))):
                return .fireAndForget({ [state] in
                    if let item = state.shieldAppsSettings.items[id: id] {
                        if isOn {
                            try shieldAppsMonitor.startMonitoringItem(item)
                        } else {
                            shieldAppsMonitor.stopMonitoringItem(item)
                        }
                    }
                }, onlyWhen: state.isOn && state.isShieldApps)

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
    }
}
