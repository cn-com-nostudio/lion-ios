// RootStoreInitial.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/1/28.

import ComposableArchitecture
import Foundation
import XCTestDynamicOverlay

extension DependencyValues {
    var rootStoreInitial: RootStoreInitial { self[RootStoreInitial.self] }
}

struct RootStoreInitial {
    var value: () -> Store<Root.State, Root.Action>
}

extension RootStoreInitial: DependencyKey {
    static let cache: some Caching<Root.State> = {
        let directory = DocumentDirectory()
        let filePath = FilePath(directory: directory, fileName: "rootState")
        let serializer: AnyPairedSerializer<Root.State> = .init(
            serializer: encodableSerializer(),
            deserializer: decodableDeserializer()
        )
        let cache = FileCache(file: filePath.url, serializer: serializer)
        return cache
    }()

    static var liveValue: Self = .init(
        value: {
            let state: Root.State
            do {
                if let cachedState = try cache.load() {
                    state = cachedState
                } else {
                    state = .default
                }
            } catch {
                state = .default
                print("fuck data lost: \(error)")
            }

            return .init(
                initialState: state,
                reducer: Root()
                    .caching(using: cache)
                    .signpost()
                    ._printChanges()
            )
        }
    )

    static let testValue: Self = .init(
        value: XCTUnimplemented("\(Self.self).value")
    )
}
