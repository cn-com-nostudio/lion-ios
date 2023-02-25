// ScreenTimeAuth.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/8.

import Combine
import ComposableArchitecture
import FamilyControls
import Foundation
import XCTestDynamicOverlay

extension DependencyValues {
    var screenTimeAuth: ScreenTimeAuth { self[ScreenTimeAuth.self] }
}

struct ScreenTimeAuth {
    var requestAuthorization: () async -> Bool
    var isAccessGrantedSync: () -> Bool
    var isAccessGranted: () async -> Bool
}

extension ScreenTimeAuth: DependencyKey {
    static let center = AuthorizationCenter.shared
    static let mainQueue = DispatchQueue.main

    static var liveValue: Self = .init(
        requestAuthorization: {
            do {
                try await center.requestAuthorization(for: .individual)
                return true
            } catch {
                return false
            }
        },
        isAccessGrantedSync: {
            let status = center.authorizationStatus
            return status == .approved
        },
        isAccessGranted: {
            await withCheckedContinuation { continuation in
                _ = center.authorizationStatus
                // 授权状态需要延迟一点获取才准确。
                mainQueue.asyncAfter(deadline: .now() + 0.5) {
                    let isGranted = center.authorizationStatus == .approved
                    continuation.resume(returning: isGranted)
                }
            }
        }
    )

    static let testValue: Self = .init(
        requestAuthorization: XCTUnimplemented("\(Self.self).requestAuthorization"),
        isAccessGrantedSync: XCTUnimplemented("\(Self.self).isAccessGrantedSync"),
        isAccessGranted: XCTUnimplemented("\(Self.self).isAccessGranted")
    )
}
