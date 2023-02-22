// InAppPurchaseProduct.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/1/31.

import ComposableArchitecture
import Foundation
import StoreKit
import SwiftUI

extension InAppPurchaseProduct.State {
    static let yearlyMember: Self = .init(
        productID: "cn.com.nostudio.lion_yearly",
        price: 0.0
    )
    static let lifetimeMember: Self = .init(
        productID: "cn.com.nostudio.lion_lifetime_member",
        price: 0.0
    )
}

struct InAppPurchaseProduct: ReducerProtocol {
    enum PurchaseFailedReason: Equatable, Codable {
        case unverified
        case unknown
    }

    enum PurchaseState: Equatable, Codable {
        case notPurchased
        case purchasing
        case pending
        case success
        case cancelled
        case failed(PurchaseFailedReason)
    }

    struct State: Equatable, Codable {
        let productID: String
//        let displayName: String
//        let description: String
        var price: Decimal
        var purchaseState: PurchaseState = .notPurchased
        var expiredDate: Date?
        @NotCoded var isLoading: Bool = false

        var displayPrice: String {
            "\(price)"
        }

        var isPurchasing: Bool {
            purchaseState == .purchasing
        }

        var isAvaliable: Bool {
            if purchaseState == .success {
                // 已购买但是有过期时间的，返回是否已经过期
                if let expiredDate {
                    return expiredDate > Date()
                } else {
                    // 已购买但是没有过期时间，则认为一直可以使用
                    return true
                }
            } else {
                return false
            }
        }
    }

    enum Action: Equatable {
        case purchase
        case purchaseSucceed(Date?)
        case purchasePending
        case purchaseCancel
        case purchaseFailed(PurchaseFailedReason)
        case update(Product)
        case loadProduct
        case syncPurchaseStateIfNeeded
        case none
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .purchase:
                state.purchaseState = .purchasing
                let productID = state.productID
                return .task {
                    do {
                        let products = try await Product.products(for: [productID])
                        let result = try await products[0].purchase()
                        switch result {
                        case let .success(.verified(transaction)):
                            await transaction.finish()
                            return .purchaseSucceed(transaction.expirationDate)

                        case .success(.unverified):
                            // Successful purchase but transaction/receipt can't be verified
                            // Could be a jailbroken phone
                            return .purchaseFailed(.unverified)

                        case .userCancelled:
                            return .purchaseCancel

                        case .pending:
                            // Transaction waiting on SCA (Strong Customer Authentication) or
                            // approval from Ask to Buy
                            return .purchasePending
                        @unknown default:
                            return .purchaseFailed(.unknown)
                        }
                    } catch {
                        return .purchaseFailed(.unknown)
                    }
                }

            case let .purchaseSucceed(expiredDate):
                state.purchaseState = .success
                state.expiredDate = expiredDate
                return .none

            case .purchasePending:
                state.purchaseState = .pending
                return .none

            case .purchaseCancel:
                state.purchaseState = .cancelled
                return .none

            case let .purchaseFailed(reason):
                state.purchaseState = .failed(reason)
                return .none

            case let .update(product):
                state.isLoading = false
                guard product.id == state.productID else { return .none }
                state.price = product.price
                return .none

            case .loadProduct:
                state.isLoading = true
                let productID = state.productID
                return .run { send in
                    let products = try await Product.products(for: [productID])
                    let product = products[0]
                    await send(.update(product))
                }

            case .syncPurchaseStateIfNeeded:
                guard state.purchaseState == .purchasing
                    || state.purchaseState == .pending
                else {
                    return .none
                }
                let productID = state.productID
                return .task {
                    if let verifyResult = await Transaction.currentEntitlement(for: productID) {
                        switch verifyResult {
                        case let .verified(transaction):
                            await transaction.finish()
                            return .purchaseSucceed(transaction.expirationDate)
                        case .unverified:
                            // Successful purchase but transaction/receipt can't be verified
                            // Could be a jailbroken phone
                            return .purchaseFailed(.unverified)
                        }
                    } else {
                        return .purchaseFailed(.unknown)
                    }
                }

            case .none:
                return .none
            }
        }
    }
}
