// StringSerializer.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import Foundation

extension String: Error {}

struct StringSerializer: Serializer {
    typealias Input = String
    private let encoding: String.Encoding

    init(encoding: String.Encoding = .utf8) {
        self.encoding = encoding
    }

    func serialize(_ input: Input) throws -> Data {
        if let output = input.data(using: encoding) {
            return output
        } else {
            throw ("Cannot deserialize string() to String using encoding(\(encoding).")
        }
    }
}

struct StringDeserializer: Deserializer {
    typealias Output = String
    private let encoding: String.Encoding

    init(encoding: String.Encoding = .utf8) {
        self.encoding = encoding
    }

    func deserialize(_ data: Data) throws -> Output {
        if let output = String(data: data, encoding: encoding) {
            return output
        } else {
            let bytes = ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .binary)
            throw ("Cannot serialize data(\(bytes)) to String using encoding(\(encoding).")
        }
    }
}
