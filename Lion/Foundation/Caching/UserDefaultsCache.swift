// UserDefaultsCache.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/29.

import Foundation

final class UserDefaultsCache<T>: Caching {
    private let userDefaults: UserDefaults
    private let cacheKey: String
    private let serializer: any PairedSerializer<T>

    init(userDefaults: UserDefaults = .standard,
         cacheKey: String,
         serializer: some PairedSerializer<T>)
    {
        self.userDefaults = userDefaults
        self.cacheKey = cacheKey
        self.serializer = serializer
    }

    func save(_ value: T) throws {
        let data = try serializer.serialize(value)
        userDefaults.set(data, forKey: cacheKey)
    }

    func load() throws -> T? {
        if let data = userDefaults.data(forKey: cacheKey) {
            let value = try serializer.deserialize(data)
            return value
        } else {
            return nil
        }
    }
}
