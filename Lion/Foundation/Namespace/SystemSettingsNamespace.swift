// SystemSettingsNamespace.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/5.

import Foundation

struct SystemSettings<Base> {
    let base: Base

    init(_ base: Base) {
        self.base = base
    }
}

protocol SystemSettingsCompatible {
    associatedtype SystemSettingsCompatibleType
    static var systemSettings: SystemSettingsCompatibleType.Type { get }
    var systemSettings: SystemSettingsCompatibleType { get }
}

extension SystemSettingsCompatible {
    static var systemSettings: SystemSettings<Self>.Type {
        SystemSettings<Self>.self
    }

    var systemSettings: SystemSettings<Self> {
        SystemSettings(self)
    }
}
