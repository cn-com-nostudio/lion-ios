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

//        @NotCoded var isSetting: Bool = false
    }

    enum Action: Equatable {
        case toggleIsPresented(Bool)
        case toggleIsOn(Bool)
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

    struct CancelToken: Hashable {}

    func turnOn(_ state: State) async throws {
        Task {
            await modeManager.denyAppInstallation(state.isDenyAppInstallation)
        }

        Task {
            await modeManager.denyAppRemoval(state.isDenyAppRemoval)
        }

        Task {
            if state.isShieldApps {
                let aliveItems = state.shieldAppsSettings.items.elements // .filter(\.isOn)
                try await shieldAppsMonitor.startMonitoringItems(aliveItems)
            }
        }

        Task {
            if state.isBlockApps {
                await modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
            }
        }
    }

    func turnOff() async {
        Task {
            await modeManager.denyAppInstallation(false)
        }

        Task {
            await modeManager.denyAppRemoval(false)
        }

        Task {
            await shieldAppsMonitor.stopMonitoringAll()
        }
        Task {
            await modeManager.setBlockAppTokens([])
        }
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .toggleIsPresented(isPresented):
                state.isPresented = isPresented
                return .none

//            case .toggleIsOn(true):
//                guard state.isOn == false else { return .none }
//                state.isOn = true
//                state.isSetting = true
//                return .task { [state] in
//                    try await turnOn(state)
//                    return .settingDone
//                }
//
//            case .toggleIsOn(false):
//                guard state.isOn == true else { return .none }
//                state.isOn = false
//                state.isSetting = true
//                return .task {
//                    await turnOff()
//                    return .settingDone
//                }
//
//            case .settingDone:
//                state.isSetting = false
//                return .none

            case let .toggleIsOn(isOn):
                guard state.isOn != isOn else { return .none }
                state.isOn = isOn
//                state.isSetting = true
                return .fireAndForget { [state] in
                    if isOn {
                        try await turnOn(state)
                    } else {
                        await turnOff()
                    }
                }
//                .debounce(id: CancelToken(), for: .milliseconds(200), scheduler: DispatchQueue.global())
//                .receive(on: DispatchQueue.main)
//                .eraseToEffect()

//            case let .updateIsOn(isOn):
//                state.isOn = isOn
//                return .none

            case let .toggleIsDenyAppInstallation(isOn):
                state.isDenyAppInstallation = isOn
                return .fireAndForget({
                    await modeManager.denyAppInstallation(isOn)
                }, onlyWhen: state.isOn)

            case let .toggleIsDenyAppRemoval(isOn):
                state.isDenyAppRemoval = isOn
                return .fireAndForget({
                    await modeManager.denyAppRemoval(isOn)
                }, onlyWhen: state.isOn)

            case .toggleIsBlockApps(true):
                state.isBlockApps = true
                return .fireAndForget({ [state] in
                    await modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
                }, onlyWhen: state.isOn)

            case .toggleIsBlockApps(false):
                state.isBlockApps = false
                return .fireAndForget({
                    await modeManager.setBlockAppTokens([])
                }, onlyWhen: state.isOn)

            case .blockAppsSettings(.update):
                return .fireAndForget({ [state] in
                    await modeManager.setBlockAppTokens(state.blockAppsSettings.appTokens)
                }, onlyWhen: state.isOn && state.isBlockApps)

//            case .toggleIsShieldApps(true):
//                state.isShieldApps = true
//                return .fireAndForget({ [state] in
//                    let aliveItems = state.shieldAppsSettings.items.elements // .filter(\.isOn)
//                    try shieldAppsMonitor.startMonitoringItems(aliveItems)
//                }, onlyWhen: state.isOn)

            case let .toggleIsShieldApps(isOn):
                state.isShieldApps = isOn

                return .fireAndForget({ [state] in
                    if isOn {
                        let aliveItems = state.shieldAppsSettings.items.elements // .filter(\.isOn)
                        try await shieldAppsMonitor.startMonitoringItems(aliveItems)
                    } else {
                        await shieldAppsMonitor.stopMonitoringAll()
                    }
                }, onlyWhen: state.isOn)

            case let .shieldAppsSettings(.updateItem(item)),
                 let .shieldAppsSettings(.addItem(item)),
                 let .shieldAppsSettings(.deleteItem(item)):
                return .fireAndForget({ [state] in
                    Task {
                        await shieldAppsMonitor.stopMonitoringAll()
                        let aliveItems = state.shieldAppsSettings.items.elements // .filter(\.isOn)
                        try await shieldAppsMonitor.startMonitoringItems(aliveItems)
                    }
                }, onlyWhen: state.isOn && state.isShieldApps)
//                    .debounce(id: CancelToken(), for: .milliseconds(800), scheduler: DispatchQueue.global())
//                    .receive(on: DispatchQueue.main)
//                    .eraseToEffect()
//
//            case let .shieldAppsSettings(.deleteItem(item)):
//                return .fireAndForget({
//                    await shieldAppsMonitor.stopMonitoringItem(item)
//                }, onlyWhen: state.isOn && state.isShieldApps)
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
