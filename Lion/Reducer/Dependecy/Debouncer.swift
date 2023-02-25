// Debouncer.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/25.

import ComposableArchitecture
import XCTestDynamicOverlay

extension DependencyValues {
    var debouncer: Debouncer { self[Debouncer.self] }
}

struct Debouncer {
    var submit: (@escaping () async throws -> Void) async -> Void
}

extension Debouncer: DependencyKey {
    static var debouncer = Limiter(policy: .debounce, duration: 1)

    static var liveValue: Self = .init(
        submit: {
            await debouncer.submit(operation: $0)
        }
    )

    static let testValue: Self = .init(
        submit: XCTUnimplemented("\(Self.self).submit")
    )
}
