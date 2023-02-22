// Resource.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import Foundation

final class Resource<T> where T: Codable {
    let deserializer: any Deserializer<T>
    let resource: URL

    func mode() throws -> T {
        let data = try Data(contentsOf: resource)
        return try deserializer.deserialize(data)
    }

    init(
        local resource: URL,
        deserializer: any Deserializer<T> = decodableDeserializer()
    ) {
        self.resource = resource
        self.deserializer = deserializer
    }
}
