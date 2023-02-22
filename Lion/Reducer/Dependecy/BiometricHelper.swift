// BiometricHelper.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/3.

import ComposableArchitecture
import Foundation
import XCTestDynamicOverlay

extension DependencyValues {
    var biometricHelper: BiometricHelper { self[BiometricHelper.self] }
}

struct BiometricHelper {
    var isFaceIDSupported: () -> Bool
    var evaluatePolicy: () async -> BiometricEvaluateResult
    var savePassword: (Password, Account) async throws -> Void
    var readPassword: (Account) throws -> String
}

extension KeychainConfiguration {
    static let app: Self = .init(serviceName: Bundle.main.bundleIdentifier ?? "cn.com.nostudio.lion")
}

extension BiometricHelper: DependencyKey {
    static let auth = BiometricIDAuth.shared
    static let keychainStore = KeychainStore(configuration: .app)

    static var liveValue: Self = .init(
        isFaceIDSupported: {
            auth.biometricType() == .faceID
        },
        evaluatePolicy: {
            await auth.evaluatePolicy()
        },
        savePassword: { password, account in
            try keychainStore.savePassword(
                password,
                forAccount: account
            )
        },
        readPassword: { account in
            try keychainStore.readPassword(forAccount: account)
        }
    )

    static let testValue: Self = .init(
        isFaceIDSupported: XCTUnimplemented("\(Self.self).isFaceIDSupported"),
        evaluatePolicy: XCTUnimplemented("\(Self.self).evaluatePolicy"),
        savePassword: XCTUnimplemented("\(Self.self).savePassword"),
        readPassword: XCTUnimplemented("\(Self.self).readPassword")
    )
}
