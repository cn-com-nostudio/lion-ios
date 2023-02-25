// EffectTask+Extension.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture

extension EffectTask {
    static func fireAndForget(_ work: @escaping () throws -> Void, onlyWhen condiction: @autoclosure () -> Bool) -> Self {
        if condiction() {
            return .fireAndForget {
                try work()
            }
        } else {
            return .none
        }
    }
}

extension EffectPublisher where Failure == Never {
    static func fireAndForget(
        priority _: TaskPriority? = nil,
        _ work: @escaping @Sendable () async throws -> Void,
        onlyWhen condiction: @autoclosure () -> Bool
    ) -> Self {
        if condiction() {
            return .fireAndForget {
                try await work()
            }
        } else {
            return .none
        }
    }
}
