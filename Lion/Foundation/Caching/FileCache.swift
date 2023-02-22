// FileCache.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import Foundation

final class FileCache<T>: Caching {
    private let url: URL
    private let serializer: any PairedSerializer<T>

    init(file url: URL,
         serializer: some PairedSerializer<T>)
    {
        self.url = url
        self.serializer = serializer
    }

    func save(_ value: T) throws {
        let data = try serializer.serialize(value)
        try data.write(to: url)
    }

    func load() throws -> T? {
        let data = try Data(contentsOf: url)
        let value = try serializer.deserialize(data)
        return value
    }
}
