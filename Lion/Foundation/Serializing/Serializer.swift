// Serializer.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import Foundation

protocol Serializer<Input> {
    associatedtype Input
    func serialize(_ input: Input) throws -> Data
}

protocol Deserializer<Output> {
    associatedtype Output
    func deserialize(_ data: Data) throws -> Output
}

protocol PairedSerializer<Value>: Serializer, Deserializer where Input == Value, Output == Value {
    associatedtype Value
}

final class AnyPairedSerializer<Value>: PairedSerializer {
    private let serializer: any Serializer<Value>
    private let deserializer: any Deserializer<Value>

    init(
        serializer: some Serializer<Value>,
        deserializer: some Deserializer<Value>
    ) {
        self.serializer = serializer
        self.deserializer = deserializer
    }

    func serialize(_ input: Value) throws -> Data {
        try serializer.serialize(input)
    }

    func deserialize(_ data: Data) throws -> Value {
        try deserializer.deserialize(data)
    }
}
