// RootStateCache.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/1/28.

import ComposableArchitecture
import Foundation
import XCTestDynamicOverlay

extension DependencyValues {
    var rootStateCahce: RootStateCache { self[RootStateCache.self] }
}

struct RootStateCache: Caching {
    typealias T = Root.State

    func save(_ value: Root.State) throws {
        try _save(value)
    }

    func load() throws -> Root.State? {
        try _load()
    }

    var _save: (Root.State) throws -> Void
    var _load: () throws -> Root.State?
}

extension RootStateCache: DependencyKey {
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
        _save: cache.save(_:),
        _load: cache.load
    )

    static let testValue: Self = .init(
        _save: XCTUnimplemented("\(Self.self)._save"),
        _load: XCTUnimplemented("\(Self.self)._load")
    )
}
