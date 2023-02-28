// UserDefaultCache.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

//// UserDefaultCache.swift
//// Copyright (c) 2023 Nostudio
//// Created by Jerry X T Wang on 2023/2/22.
//
// import Foundation
//
// typealias Encode<T: Encodable> = (T) throws -> Data
// typealias Decode<T: Decodable> = (Data) throws -> T
//
// struct CacheKey<Value> {
//    let key: String
//
//    init(_ key: String) {
//        self.key = key
//    }
//
//    func callAsFunction() -> String {
//        key
//    }
// }
//
// struct UserDefaultCache<T: Codable> {
//    let userDefaults: UserDefaults
//    let encoder: Encode<T>
//    let decoder: Decode<T>
//
//    init(userDefaults: UserDefaults = .standard,
//         encoder: @escaping Encode<T> = JSONEncoder().encode,
//         decoder: @escaping Decode<T> = { try JSONDecoder().decode(T.self, from: $0) })
//    {
//        self.userDefaults = userDefaults
//        self.encoder = encoder
//        self.decoder = decoder
//    }
//
//    func save(_ value: T, for key: CacheKey<T>) throws {
//        let data = try encoder(value)
//        userDefaults.set(data, forKey: key())
//        userDefaults.synchronize()
//    }
//
//    func load(from key: CacheKey<T>) throws -> T? {
//        if let data = userDefaults.data(forKey: key()) {
//            let model = try decoder(data)
//            return model
//        } else {
//            return nil
//        }
//    }
// }
