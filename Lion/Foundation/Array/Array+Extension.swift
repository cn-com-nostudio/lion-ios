// Array+Extension.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/14.

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> Self {
        var temp = Self()
        var set = Set<Element>()
        for element in self where !set.contains(element) {
            temp.append(element)
            set.insert(element)
        }
        return temp
    }
}

extension Array {
    @inlinable mutating func removeOnce<S>(in elements: S) where Element == S.Element, S: Sequence, Element: Equatable {
        let indexes = elements.map(firstIndex(of:)).compactMap { $0 }
        remove(atOffsets: IndexSet(indexes))
    }

    @inlinable mutating func removeAll<S>(in elements: S) where Element == S.Element, S: Sequence, Element: Equatable {
        removeAll(where: elements.contains(_:))
    }
}
