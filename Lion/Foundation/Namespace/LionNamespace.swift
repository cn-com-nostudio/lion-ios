// LionNamespace.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import Foundation
import SwiftUI

struct Lion<Base> {
    let base: Base

    init(_ base: Base) {
        self.base = base
    }
}

protocol LionCompatible {
    associatedtype LionCompatibleType
    static var lion: LionCompatibleType.Type { get }
    var lion: LionCompatibleType { get }
}

extension LionCompatible {
    static var lion: Lion<Self>.Type {
        Lion<Self>.self
    }

    var lion: Lion<Self> {
        Lion(self)
    }
}
