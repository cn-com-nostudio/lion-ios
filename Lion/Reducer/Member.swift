// Member.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/1/31.

import ComposableArchitecture
import Foundation
import StoreKit
import SwiftUI

extension Member.State {
    static let yearlyMember: Self = .init(
        memberType: .yearly,
        price: 0.0
    )
    static let lifetimeMember: Self = .init(
        memberType: .lifetime,
        price: 0.0
    )
}

struct Member: ReducerProtocol {
    struct State: Equatable, Codable {
        let memberType: MemberType
        var price: Decimal

        @NotCoded var isAvaliable: Bool = false
        @NotCoded var isLoading: Bool = false
        @NotCoded var isPurchasing: Bool = false
        @NotCoded var isSyncing: Bool = false

        var displayPrice: String {
            "\(price)"
        }
    }

    enum Action: Equatable {
        case loadProduct
        case loadProductSucceed(Product)
        case loadProductFailed

        case purchase
        case purchaseSucceed
        case purchaseFailed

        case syncIsAvaliable
        case syncIsAvaliableSucceed(Bool)
        case syncIsAvaliableFailed

        case updateIsAvaliable(Bool)
    }

    @Dependency(\.purchaser) var purchaser
    @Dependency(\.memberState) var memberState

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadProduct:
                state.isLoading = true
                return .task { [state] in
                    do {
                        let product = try await purchaser.product(state.memberType)
                        return .loadProductSucceed(product)
                    } catch {
                        return .loadProductFailed
                    }
                }

            case let .loadProductSucceed(product):
                state.isLoading = false
                state.price = product.price
                return .none

            case .loadProductFailed:
                state.isLoading = false
                return .none

            case .purchase:
                state.isPurchasing = true
                return .task { [state] in
                    do {
                        let isSuccess = try await purchaser.purchase(state.memberType)
                        return isSuccess ? .purchaseSucceed : .purchaseFailed
                    } catch {
                        return .purchaseFailed
                    }
                }

            case .purchaseSucceed:
                state.isPurchasing = false
                return .task {
                    .updateIsAvaliable(true)
                }

            case .purchaseFailed:
                state.isPurchasing = false
                return .none

            case .syncIsAvaliable:
                state.isSyncing = true
                return .task { [state] in
                    let isAvalibale = await purchaser.isMemberAvaliable(state.memberType)
                    return .syncIsAvaliableSucceed(isAvalibale)
                }

            case let .syncIsAvaliableSucceed(isAvaliable):
                state.isSyncing = false
                return .task {
                    .updateIsAvaliable(isAvaliable)
                }

            case .syncIsAvaliableFailed:
                state.isSyncing = false
                return .none

            case let .updateIsAvaliable(isAvaliable):
                state.isAvaliable = isAvaliable
                return .fireAndForget { [state] in
                    memberState.updateMember(state.memberType, isAvaliable)
                }
            }
        }
    }
}
