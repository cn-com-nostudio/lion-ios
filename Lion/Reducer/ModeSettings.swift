// ModeSettings.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

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

    struct CancelToken: Hashable {}

    func turnOn(_ state: State) async throws {
        await modeManager.denyAppInstallation(state.isDenyAppInstallation)
        await modeManager.denyAppRemoval(state.isDenyAppRemoval)
        if state.isBlockApps {
            await modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
        }
        if state.isShieldApps {
            let aliveItems = state.shieldAppsSettings.items.elements // .filter(\.isOn)
            try shieldAppsMonitor.startMonitoringItems(aliveItems)
        }
    }

    func turnOff() async {
        await modeManager.clearAllSettings()
        shieldAppsMonitor.stopMonitoringAll()
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .toggleIsPresented(isPresented):
                state.isPresented = isPresented
                return .none

            case .toggleIsOn(true):
                guard state.isOn == false else { return .none }
                state.isOn = true
                return .fireAndForget { [state] in
                    try await turnOn(state)
                }
                .debounce(id: CancelToken(), for: .milliseconds(800), scheduler: DispatchQueue.main)
                .eraseToEffect()

            case .toggleIsOn(false):
                guard state.isOn == true else { return .none }
                state.isOn = false
                return .fireAndForget {
                    await turnOff()
                }
                .debounce(id: CancelToken(), for: .milliseconds(800), scheduler: DispatchQueue.main)
                .eraseToEffect()

            case let .toggleIsDenyAppInstallation(isOn):
                state.isDenyAppInstallation = isOn
                return .fireAndForget({
                    await modeManager.denyAppInstallation(isOn)
                }, onlyWhen: state.isOn)
                    .debounce(id: CancelToken(), for: .milliseconds(800), scheduler: DispatchQueue.main)
                    .eraseToEffect()

            case let .toggleIsDenyAppRemoval(isOn):
                state.isDenyAppRemoval = isOn
                return .fireAndForget({
                    await modeManager.denyAppRemoval(isOn)
                }, onlyWhen: state.isOn)
                    .debounce(id: CancelToken(), for: .milliseconds(800), scheduler: DispatchQueue.main)
                    .eraseToEffect()

            case .toggleIsBlockApps(true):
                state.isBlockApps = true
                return .fireAndForget({ [state] in
                    await modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
                }, onlyWhen: state.isOn)
                    .debounce(id: CancelToken(), for: .milliseconds(800), scheduler: DispatchQueue.main)
                    .eraseToEffect()

            case .toggleIsBlockApps(false):
                state.isBlockApps = false
                return .fireAndForget({
                    await modeManager.setBlockAppTokens(nil)
                }, onlyWhen: state.isOn)
                    .debounce(id: CancelToken(), for: .milliseconds(800), scheduler: DispatchQueue.main)
                    .eraseToEffect()

            case .blockAppsSettings(.update):
                return .fireAndForget({ [state] in
                    await modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
                }, onlyWhen: state.isOn && state.isBlockApps)
//                    .debounce(id: CancelToken(), for: .milliseconds(800), scheduler: DispatchQueue.global())
//                    .receive(on: DispatchQueue.main)
//                    .eraseToEffect()

//            case .toggleIsShieldApps(true):
//                state.isShieldApps = true
//                return .fireAndForget({ [state] in
//                    let aliveItems = state.shieldAppsSettings.items.elements // .filter(\.isOn)
//                    try shieldAppsMonitor.startMonitoringItems(aliveItems)
//                }, onlyWhen: state.isOn)
//                    .debounce(id: CancelToken(), for: .milliseconds(800), scheduler: DispatchQueue.global())
//                    .receive(on: DispatchQueue.main)
//                    .eraseToEffect()

            case let .toggleIsShieldApps(isOn):
                state.isShieldApps = isOn
                return .fireAndForget({ [state] in
                    if isOn {
                        let aliveItems = state.shieldAppsSettings.items.elements // .filter(\.isOn)
                        try shieldAppsMonitor.startMonitoringItems(aliveItems)
                    } else {
                        shieldAppsMonitor.stopMonitoringAll()
                    }
                }, onlyWhen: state.isOn)
                    .debounce(id: CancelToken(), for: .milliseconds(800), scheduler: DispatchQueue.main)
                    .eraseToEffect()

            case let .shieldAppsSettings(.updateItem(item)),
                 let .shieldAppsSettings(.addItem(item)):
                return .fireAndForget({
                    shieldAppsMonitor.stopMonitoringItem(item)
                    try shieldAppsMonitor.startMonitoringItem(item)
                }, onlyWhen: state.isOn && state.isShieldApps)
//                    .debounce(id: CancelToken(), for: .milliseconds(800), scheduler: DispatchQueue.global())
//                    .receive(on: DispatchQueue.main)
//                    .eraseToEffect()

            case let .shieldAppsSettings(.deleteItem(item)):
                return .fireAndForget({
                    shieldAppsMonitor.stopMonitoringItem(item)
                }, onlyWhen: state.isOn && state.isShieldApps)
//                    .debounce(id: CancelToken(), for: .milliseconds(800), scheduler: DispatchQueue.global())
//                    .receive(on: DispatchQueue.main)
//                    .eraseToEffect()

//            case let .shieldAppsSettings(.items(id: id, action: .toggleIsOn(isOn))):
//                return .fireAndForget({ [state] in
//                    if let item = state.shieldAppsSettings.items[id: id] {
//                        if isOn {
//                            try shieldAppsMonitor.startMonitoringItem(item)
//                        } else {
//                            shieldAppsMonitor.stopMonitoringItem(item)
//                        }
//                    }
//                }, onlyWhen: state.isOn && state.isShieldApps)
//                    .debounce(id: CancelToken(), for: .milliseconds(800), scheduler: DispatchQueue.global())
//                    .receive(on: DispatchQueue.main)
//                    .eraseToEffect()

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
