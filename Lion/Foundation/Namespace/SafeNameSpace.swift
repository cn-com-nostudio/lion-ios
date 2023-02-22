// SafeNamespace.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/3.

import Foundation
import SwiftUI

struct Safe<Base> {
    let base: Base

    init(_ base: Base) {
        self.base = base
    }
}

protocol SafeCompatible {
    associatedtype SafeCompatibleType
    static var safe: SafeCompatibleType.Type { get }
    var safe: SafeCompatibleType { get }
}

extension SafeCompatible {
    static var safe: Safe<Self>.Type {
        Safe<Self>.self
    }

    var safe: Safe<Self> {
        Safe(self)
    }
}
