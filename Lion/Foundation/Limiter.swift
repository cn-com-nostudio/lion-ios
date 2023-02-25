// Limiter.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/25.

import Foundation

actor Limiter {
    private let policy: Policy
    private let duration: TimeInterval
    private var task: Task<Void, Error>?

    init(policy: Policy, duration: TimeInterval) {
        self.policy = policy
        self.duration = duration
    }

    func submit(operation: @escaping () async throws -> Void) {
        switch policy {
        case .throttle: throttle(operation: operation)
        case .debounce: debounce(operation: operation)
        }
    }
}

// MARK: - Limiter.Policy

extension Limiter {
    enum Policy {
        case throttle
        case debounce
    }
}

// MARK: - Private utility methods

private extension Limiter {
    func throttle(operation: @escaping () async throws -> Void) {
        guard task == nil else { return }

        task = Task {
            try await sleep()
            task = nil
        }

        Task {
            try await operation()
        }
    }

    func debounce(operation: @escaping () async throws -> Void) {
        task?.cancel()

        task = Task {
            try await sleep()
            try await operation()
            task = nil
        }
    }

    func sleep() async throws {
        try await Task.sleep(nanoseconds: UInt64(duration * .nanosecondsPerSecond))
    }
}

// MARK: - TimeInterval

extension TimeInterval {
    static let nanosecondsPerSecond = TimeInterval(NSEC_PER_SEC)
}

// MARK: - How to use it:

// var throttler = Limiter(policy: .throttle, duration: 1)
// throttler.submit { ... }
