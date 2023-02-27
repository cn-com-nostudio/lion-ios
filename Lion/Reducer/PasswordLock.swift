// PasswordLock.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/2.

import ComposableArchitecture
import Foundation
import UIKit

extension PasswordLock.State {
    static let `default`: Self = .init(isOn: false, useFaceID: false, password: .default)
}

extension PasswordSetup.State {
    static let `default`: Self = .init(password: "")
}

struct PasswordSetup: ReducerProtocol {
    struct State: Equatable, Codable {
        var passwordLength = 4
        var password: String

        func callAsFunction() -> String {
            password
        }
    }

    enum Action: Equatable {
        case updatePassword(String)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .updatePassword(password):
                let newPassword = password.safe.prefix(state.passwordLength)
                state.password = newPassword
                return .none
            }
        }
    }
}

struct PasswordLock: ReducerProtocol {
    struct State: Equatable, Codable {
        var isOn: Bool
        var useFaceID: Bool
        var password: PasswordSetup.State

        @NotCoded var isFaceIDSupported: Bool = false

        @NotCoded var isPasswordSetupPresented: Bool = false
        @NotCoded var isPasswordUnlockPresented: Bool = false

        @NotCoded var biometricPassword: String = ""

        @NotCoded var alert: AlertState<Action>?
    }

    enum Action: Equatable {
        case toggleIsOn(Bool)

        case toggleUseFaceID(Bool)
        case updateUseFaceID(Bool)

        case password(PasswordSetup.Action)

        case toggleIsPasswordSetupPresented(Bool)
        case toggleIsPasswordUnlockPresented(Bool)

        case showAlert(AlertState<Action>)
        case dismissAlert
        case gotoAppSettings
        case gotoPasscode

        case readBiometricPassword
        case updateBiometricPassword(String)

        case onAppear
        case updateIsFaceIDSupported(Bool)

        case none
    }

    @Dependency(\.biometricHelper) var biometricHelper
    @Dependency(\.application) var application
    @Dependency(\.mainQueue) var mainQueue
    let account: Account = "appLaunch"

    func savePassword(_ password: Password) async throws {
        try await biometricHelper.savePassword(password, account)
    }

    func readPassword() -> String {
        (try? biometricHelper.readPassword(account)) ?? ""
    }

    func evaluatePolicy(success: @escaping () async throws -> PasswordLock.Action) async throws -> Action {
        let evaluateResult = await biometricHelper.evaluatePolicy()
        switch evaluateResult {
        case .success:
            return try await success()
        case .biometryNotAvailable:
            let alert = AlertState(
                title: TextState(.faceIDAccessNotGranted),
                message: TextState(.grantFaceIDAccessToUseFaceIDToUnlock),
                primaryButton: .cancel(TextState(.cancel)),
                secondaryButton: .default(TextState(.grantFaceIDAccess), action: .send(Action.gotoAppSettings))
            )
            return .showAlert(alert)

        case .passcodeNotSet:
            let alert = AlertState(
                title: TextState(.devicePasscodeNotSet),
                message: TextState(.setDevicePasscodeToUseFaceIDToUnlock),
                primaryButton: .cancel(TextState(.cancel)),
                secondaryButton: .default(TextState(.setDevicePasscode), action: .send(Action.gotoPasscode))
            )
            return .showAlert(alert)

        case .biometryNotEnrolled:
            let alert = AlertState(
                title: TextState(.devicePasscodeNotSet),
                message: TextState(.setDevicePasscodeToUseFaceIDToUnlock),
                primaryButton: .cancel(TextState(.cancel)),
                secondaryButton: .default(TextState(.setDevicePasscode), action: .send(Action.gotoPasscode))
            )
            return .showAlert(alert)

        case .other:
            return .none
        }
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .toggleIsOn(isOn):
                if isOn {
                    state.isPasswordSetupPresented = true
                } else {
                    state.isOn = false
                    state.useFaceID = false
                    state.password = .default
                }
                return .none

            case let .toggleUseFaceID(isOn):
                return .task { [state] in
                    try await evaluatePolicy {
                        if isOn {
                            try await savePassword(state.password())
                            return .updateUseFaceID(true)
                        } else {
                            return .updateUseFaceID(false)
                        }
                    }
                }

            case let .updateUseFaceID(isOn):
                state.useFaceID = isOn
                return .none

            case let .toggleIsPasswordSetupPresented(isOn):
                state.isPasswordSetupPresented = isOn
                return .none

            case let .toggleIsPasswordUnlockPresented(isOn):
                state.isPasswordUnlockPresented = isOn
                return .none

            case let .showAlert(alert):
                state.alert = alert
                return .none

            case .dismissAlert:
                state.alert = nil
                return .none

            case .gotoAppSettings:
                return .fireAndForget {
                    // TODO: go to app settings
//                    _ = await application.rate()
                }

            case .gotoPasscode:
                return .fireAndForget {
                    // TO DO: Tell user how to set device password and how to enroll faceID.
                }

            case .readBiometricPassword:
                return .task {
                    try await evaluatePolicy {
                        .updateBiometricPassword(readPassword())
                    }
                }

            case let .updateBiometricPassword(password):
                state.biometricPassword = password
                return .none

            case .onAppear:
                return .task {
                    .updateIsFaceIDSupported(biometricHelper.isFaceIDSupported())
                }

            case let .updateIsFaceIDSupported(isSupported):
                state.isFaceIDSupported = isSupported
                return .none

            default:
                return .none
            }
        }

        Scope(state: \.password, action: /Action.password) {
            PasswordSetup()
        }

        Reduce { state, action in
            switch action {
            case .password(.updatePassword):
                state.isOn = true
                return .run { [state] send in
                    if state.useFaceID {
                        try await savePassword(state.password())
                        await send(.toggleUseFaceID(false))
                        await send(.toggleUseFaceID(true))
                    }
                    await send(.toggleIsPasswordSetupPresented(false))
                }
            default:
                return .none
            }
        }
    }
}
