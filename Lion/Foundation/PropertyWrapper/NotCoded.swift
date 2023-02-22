// NotCoded.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import Foundation

@propertyWrapper
struct NotCoded<Value> where Value: DefaultValuable {
    private var value: Value

    public init(wrappedValue: Value) {
        value = wrappedValue
    }

    public var wrappedValue: Value {
        get { value }
        set { value = newValue }
    }
}

extension NotCoded: Codable {
    public func encode(to _: Encoder) throws {
        // Skip encoding the wrapped value.
    }

    public init(from _: Decoder) throws {
        // The wrapped value is simply initialised to zero when decoded.
        value = .defaultValue
    }
}

extension NotCoded: Equatable where Value: Equatable {}
