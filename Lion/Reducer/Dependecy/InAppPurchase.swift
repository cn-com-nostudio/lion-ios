// InAppPurchase.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/5.

import ComposableArchitecture
import StoreKit
import XCTestDynamicOverlay

extension DependencyValues {
    var purchaser: InAppPurchase { self[InAppPurchase.self] }
}

enum InAppPurchaseError: Error {
    case succe
}

struct InAppPurchase {
    var product: (_ member: MemberType) async throws -> Product
    var purchase: (_ member: MemberType) async throws -> Bool
    var isMemberAvaliable: (_ member: MemberType) async -> Bool
//    var isMember: () async -> Bool
}

extension InAppPurchase: DependencyKey {
    static let purchaser = MemberPurchase()

    static var liveValue: Self = .init(
        product: { member in
            try await purchaser.product(for: member)
        },
        purchase: { member in
            try await purchaser.purchase(member: member)
        },
        isMemberAvaliable: { member in
            await purchaser.isMemberAvaliable(member)
        }
//        isMember: {
//            var isMember = await purchaser.isMemberAvaliable(.lifetime)
//            if !isMember {
//                isMember = await purchaser.isMemberAvaliable(.yearly)
//            }
//            return isMember
//        }
    )

    static let testValue: Self = .init(
        product: XCTUnimplemented("\(Self.self).product"),
        purchase: XCTUnimplemented("\(Self.self).purchase"),
        isMemberAvaliable: XCTUnimplemented("\(Self.self).isMemberAvaliable")
//        isMember: XCTUnimplemented("\(Self.self).isMember")
    )
}
