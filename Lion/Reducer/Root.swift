// Root.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import Foundation
import ManagedSettings
extension Root.State {
    static let `default`: Self = .init(
        appInfo: .default,
        childMode: .child,
        loanMode: .loan,
        passwordLock: .default,
        products: .default
    )
}

struct Root: ReducerProtocol {
    struct AppInfo: Equatable, Codable {
        var name: String
        var version: String
        var buildVersion: String

        static let `default`: Self = .init(
            name: "",
            version: "",
            buildVersion: ""
        )
    }

    struct State: Equatable, Codable {
        var appInfo: AppInfo
        var childMode: ModeSettings.State
        var loanMode: ModeSettings.State
        var passwordLock: PasswordLock.State
        var products: Products.State

        @NotCoded var needRequestScreenTimeAccessPermission: Bool = false
        @NotCoded var isMorePageShow: Bool = false

        // 介绍页面是否已经读过，读过就不要show，没读过就show
        var isIntroduceRead: Bool = false
    }

    enum Action: Equatable {
        case appLaunched
//        case onAppActived
        case rateApp
        case childMode(ModeSettings.Action)
        case loanMode(ModeSettings.Action)
        case passwordLock(PasswordLock.Action)
        case products(Products.Action)
        case syncScreenTimeAuthorizationStatus
        case requestScreenTimeAccessPermission
        case updateIsScreenTimeAccessGranted(Bool)
        case toggleIsMorePageShow(Bool)
        case toggleIsIntroduceRead(Bool)

        case none
    }

    @Dependency(\.screenTimeAuth) var screenTimeAuth
    @Dependency(\.appInfo) var appInfo
    @Dependency(\.application) var application

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .appLaunched:
                // TODO: Effect should not call out of effect scope.
                state.appInfo.name = appInfo.name()
                state.appInfo.version = appInfo.version()
                state.appInfo.buildVersion = appInfo.buildVersion()
                return .run { [state] send in
                    if state.passwordLock.isOn {
                        await send(.passwordLock(.toggleIsPasswordUnlockPresented(true)))
                    }
                    await send(.syncScreenTimeAuthorizationStatus)
                }

            case .rateApp:
                return .fireAndForget {
                    // TODO: app review
//                    await application.rate()
                }

            case .syncScreenTimeAuthorizationStatus:
                return .task {
                    let isAccessGranted = await screenTimeAuth.isAccessGranted()
                    return .updateIsScreenTimeAccessGranted(isAccessGranted)
                }

            case .requestScreenTimeAccessPermission:
                return .task {
                    do {
                        try await screenTimeAuth.requestAuthorization()
                        return .updateIsScreenTimeAccessGranted(true)
                    } catch {
                        return .updateIsScreenTimeAccessGranted(false)
                    }
                }

            case let .updateIsScreenTimeAccessGranted(isGranted):
                state.needRequestScreenTimeAccessPermission = !isGranted
                return .none

            case let .toggleIsMorePageShow(isShow):
                state.isMorePageShow = isShow
                return .none

            case let .toggleIsIntroduceRead(isRead):
                state.isIntroduceRead = isRead
                return .none

            default:
                return .none
            }
        }

        Reduce { state, action in
            switch action {
            case let .childMode(.willToggleIsOn(isOn)) where state.products.isMember || state.childMode.turnOnTimes < 20:
                return .run { [state] send in
                    if isOn, state.loanMode.isOn {
                        await send(.loanMode(.toggleIsOn(false)))
                    }
                    await send(.childMode(.toggleIsOn(isOn)))
                }

            case .childMode(.willToggleIsOn) where !(state.products.isMember || state.childMode.turnOnTimes < 20):
                return .task {
                    .products(.toggleIsMemberPurchasePresented(true))
                }

            case let .loanMode(.willToggleIsOn(isOn)) where state.products.isMember:
                return .run { [state] send in
                    if isOn, state.childMode.isOn {
                        await send(.childMode(.toggleIsOn(false)))
                    }
                    await send(.loanMode(.toggleIsOn(isOn)))
                }

            case let .childMode(.toggleIsPresented(isOn)):
                return .task {
                    .childMode(.updateIsPresented(isOn))
                }

            case let .loanMode(.toggleIsPresented(isOn)) where state.products.isMember:
                return .task {
                    .loanMode(.updateIsPresented(isOn))
                }

            case let .childMode(.willToggleIsDenyAppInstallation(isOn)) where state.products.isMember:
                return .task {
                    .childMode(.toggleIsDenyAppInstallation(isOn))
                }

            case let .loanMode(.willToggleIsDenyAppInstallation(isOn)) where state.products.isMember:
                return .task {
                    .loanMode(.toggleIsDenyAppInstallation(isOn))
                }

            case let .passwordLock(.toggleIsPresented(isPresented)) where state.products.isMember:
                return .task {
                    .passwordLock(.updateIsPresented(isPresented))
                }

            case .loanMode(.willToggleIsOn),
                 .loanMode(.toggleIsPresented),
                 .passwordLock(.toggleIsPresented),
                 .childMode(.willToggleIsDenyAppInstallation),
                 .loanMode(.willToggleIsDenyAppInstallation)
                     where !state.products.isMember:
                return .task {
                    .products(.toggleIsMemberPurchasePresented(true))
                }

            default:
                return .none
            }
        }

        Scope(state: \.childMode, action: /Action.childMode) {
            ModeSettings()
        }

        Scope(state: \.loanMode, action: /Action.loanMode) {
            ModeSettings()
        }

        Scope(state: \.passwordLock, action: /Action.passwordLock) {
            PasswordLock()
        }

        Scope(state: \.products, action: /Action.products) {
            Products()
        }
    }
}
