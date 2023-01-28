// LionNamespace.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/28.

import Foundation
import SwiftUI

struct LionNamespacing<Base> {
    let base: Base

    init(_ base: Base) {
        self.base = base
    }
}

protocol LionNamespacingCompatible {
    associatedtype LionNamespacingCompatibleType
    static var lion: LionNamespacingCompatibleType.Type { get }
    var lion: LionNamespacingCompatibleType { get }
}

extension LionNamespacingCompatible {
    static var lion: LionNamespacing<Self>.Type {
        LionNamespacing<Self>.self
    }

    var lion: LionNamespacing<Self> {
        LionNamespacing(self)
    }
}
