// MemberShareState.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/5.

import ComposableArchitecture
import StoreKit
import XCTestDynamicOverlay

class MemberShareState {
    static let shared = MemberShareState()

    private init() {}

    var memberState: [MemberType: Bool] = [:]

    var isMember: Bool {
        memberState.values.contains(true)
    }
}

extension DependencyValues {
    var memberState: MemberState { self[MemberState.self] }
}

struct MemberState {
    var updateMember: (_ member: MemberType, _ isAvaliable: Bool) -> Void
    var isMember: () -> Bool
}

extension MemberState: DependencyKey {
    static let sharedState = MemberShareState.shared

    static var liveValue: Self = .init(
        updateMember: { member, isAvaliable in
            sharedState.memberState[member] = isAvaliable
        },
        isMember: {
            sharedState.isMember
        }
    )

    static let testValue: Self = .init(
        updateMember: XCTUnimplemented("\(Self.self).updateMember"),
        isMember: XCTUnimplemented("\(Self.self).isMember")
    )
}
