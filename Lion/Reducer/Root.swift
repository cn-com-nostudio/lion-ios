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
        member: .default
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
        var member: Member.State

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
        case member(Member.Action)
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

            case .member(.lifetimeMember(.purchaseSucceed)),
                 .member(.yearlyMember(.purchaseSucceed)):
                return .task {
                    .member(.toggleIsMemberPurchasePresented(false))
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

        Scope(state: \.member, action: /Action.member) {
            Member()
        }
    }
}
