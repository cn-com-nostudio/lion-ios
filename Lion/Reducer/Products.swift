// Products.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/14.

import ComposableArchitecture

extension Products.State {
    static let `default`: Self = .init(
        yearlyMember: .yearlyMember,
        lifetimeMember: .lifetimeMember
    )
}

struct Products: ReducerProtocol {
    struct State: Equatable, Codable {
        var yearlyMember: Member.State
        var lifetimeMember: Member.State

        @NotCoded var isMemberPurchasePresented: Bool = false

        var isMember: Bool {
            yearlyMember.isAvaliable || lifetimeMember.isAvaliable
        }

        var isLoading: Bool {
            isPurchasing || isSyncing
        }

        private var isPurchasing: Bool {
            yearlyMember.isPurchasing || lifetimeMember.isPurchasing
        }

        private var isSyncing: Bool {
            yearlyMember.isSyncing || lifetimeMember.isSyncing
        }
    }

    enum Action: Equatable {
        case yearlyMember(Member.Action)
        case lifetimeMember(Member.Action)
        case toggleIsMemberPurchasePresented(Bool)
        case syncMemberState
        case none
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .toggleIsMemberPurchasePresented(isOn):
                state.isMemberPurchasePresented = isOn
                return .none

            case .syncMemberState:
                return .run { send in
                    await send(.yearlyMember(.syncIsAvaliable))
                    await send(.lifetimeMember(.syncIsAvaliable))
                }

            default:
                return .none
            }
        }

        Scope(state: \.yearlyMember, action: /Action.yearlyMember) {
            Member()
        }

        Scope(state: \.lifetimeMember, action: /Action.lifetimeMember) {
            Member()
        }

        Reduce { _, action in
            switch action {
            case .lifetimeMember(.purchaseSucceed),
                 .yearlyMember(.purchaseSucceed):
                return .task {
                    .toggleIsMemberPurchasePresented(false)
                }

            default:
                return .none
            }
        }
    }
}
