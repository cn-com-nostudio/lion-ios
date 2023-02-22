// Member.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/14.

import ComposableArchitecture

extension Member.State {
    static let `default`: Self = .init(
        yearlyMember: .yearlyMember,
        lifetimeMember: .lifetimeMember
    )
}

struct Member: ReducerProtocol {
    struct State: Equatable, Codable {
        var yearlyMember: InAppPurchaseProduct.State
        var lifetimeMember: InAppPurchaseProduct.State

        @NotCoded var isMemberPurchasePresented: Bool = false

        var isMember: Bool {
            yearlyMember.isAvaliable
                || lifetimeMember.isAvaliable
        }

        var isPurchasing: Bool {
            yearlyMember.isPurchasing || lifetimeMember.isPurchasing
        }
    }

    enum Action: Equatable {
        case yearlyMember(InAppPurchaseProduct.Action)
        case lifetimeMember(InAppPurchaseProduct.Action)
        case toggleIsMemberPurchasePresented(Bool)
        case none
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .toggleIsMemberPurchasePresented(isOn):
                state.isMemberPurchasePresented = isOn
                return .none

            default:
                return .none
            }
        }

        Scope(state: \.yearlyMember, action: /Action.yearlyMember) {
            InAppPurchaseProduct()
        }

        Scope(state: \.lifetimeMember, action: /Action.lifetimeMember) {
            InAppPurchaseProduct()
        }
    }
}
