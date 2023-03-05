// MemberPurchase.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/5.

import StoreKit

enum MemberType: CaseIterable, Codable, Equatable {
    case yearly
    case lifetime

    var productID: String {
        switch self {
        case .yearly:
            return "cn.com.nostudio.lion_yearly"
        case .lifetime:
            return "cn.com.nostudio.lion_lifetime_member"
        }
    }
}

struct MemberPurchase {
    func product(for member: MemberType) async throws -> Product {
        let products = try await Product.products(for: [member.productID])
        let product = products[0]
        return product
    }

    func purchase(member: MemberType) async throws -> Bool {
        let product = try await product(for: member)
        let result = try await product.purchase()
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            return true

        case .success(.unverified):
            // Successful purchase but transaction/receipt can't be verified
            // Could be a jailbroken phone
            return false

        case .userCancelled:
            return false

        case .pending:
            // Transaction waiting on SCA (Strong Customer Authentication) or
            // approval from Ask to Buy
            return false

        @unknown default:
            return false
        }
    }

    func isMemberAvaliable(_ member: MemberType) async -> Bool {
        guard let transation = await Transaction.latest(for: member.productID) else { return false }
        switch transation {
        case let .verified(transation):
            switch transation.productType {
            case .consumable:
                // Member 没有这种类型，这个分支永远不会执行到，所以直接返回false。
                return false
            case .nonConsumable:
                return true
            case .autoRenewable, .nonRenewable:
                if let expirationDate = transation.expirationDate {
                    return expirationDate > Date()
                } else {
                    return false
                }
            default:
                return false
            }
        case .unverified:
            return false
        }
    }
}
