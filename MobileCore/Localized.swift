// Localized.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/4.

public struct Localized<Base> {
    let base: Base

    init(_ base: Base) {
        self.base = base
    }
}

public protocol LocalizedCompatible {
    associatedtype LocalizedCompatibleType
    static var localized: LocalizedCompatibleType.Type { get }
    var localized: LocalizedCompatibleType { get }
}

public extension LocalizedCompatible {
    static var localized: Localized<Self>.Type {
        Localized<Self>.self
    }

    var localized: Localized<Self> {
        Localized(self)
    }
}
