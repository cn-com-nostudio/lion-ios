// withCheckedContinuationOnMain.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/4.

import Combine

@MainActor
func withCheckedContinuationOnMain<T>(
    function _: String = #function,
    _ body: @escaping @MainActor (CheckedContinuation<T, Never>) -> Void
) async -> T {
    await withCheckedContinuation { continuation in
        Task { @MainActor in
            body(continuation)
        }
    }
}

@MainActor
func withCheckedThrowingContinuationOnMain<T>(
    function _: String = #function,
    _ body: @escaping @MainActor (CheckedContinuation<T, Error>) -> Void
) async throws -> T {
    try await withCheckedThrowingContinuation { continuation in
        Task { @MainActor in
            body(continuation)
        }
    }
}
