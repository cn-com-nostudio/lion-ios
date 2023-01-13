// SortedDescriptor.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/6.

import Foundation

struct SortDescriptor<Value> {
    var comparator: (Value, Value) -> ComparisonResult
}

extension SortDescriptor {
    static func keyPath(
        _ keyPath: KeyPath<Value, some Comparable>
    ) -> Self {
        Self { rootA, rootB in
            let valueA = rootA[keyPath: keyPath]
            let valueB = rootB[keyPath: keyPath]

            if valueA < valueB {
                return .orderedAscending
            } else if valueA > valueB {
                return .orderedDescending
            } else {
                return .orderedSame
            }
        }
    }
}