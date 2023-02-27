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
        priority: TaskPriority? = nil,
        _ work: @escaping @Sendable () async throws -> Void,
        onlyWhen condiction: @autoclosure () -> Bool
    ) -> Self {
        if condiction() {
            return .fireAndForget(priority: priority) {
                try await work()
            }
        } else {
            return .none
        }
    }
}

extension EffectPublisher where Failure == Never {
    static func task(
        priority: TaskPriority? = nil,
        operation: @escaping @Sendable () async throws -> Action,
        catch handler: (@Sendable (Error) async -> Action)? = nil,
        onlyWhen condiction: @autoclosure () -> Bool,
        file: StaticString = #file,
        fileID: StaticString = #fileID,
        line: UInt = #line
    ) -> Self {
        if condiction() {
            return .task(
                priority: priority,
                operation: operation,
                catch: handler,
                file: file,
                fileID: fileID,
                line: line
            )
        } else {
            return .none
        }
    }
}

extension EffectPublisher where Failure == Never {
    static func run(
        priority: TaskPriority? = nil,
        operation: @escaping @Sendable (Send) async throws -> Void,
        catch handler: (@Sendable (Error, Send) async -> Void)? = nil,
        onlyWhen condiction: @autoclosure () -> Bool,
        file: StaticString = #file,
        fileID: StaticString = #fileID,
        line: UInt = #line
    ) -> Self {
        if condiction() {
            return .run(
                priority: priority,
                operation: operation,
                catch: handler,
                file: file,
                fileID: fileID,
                line: line
            )
        } else {
            return .none
        }
    }
}
