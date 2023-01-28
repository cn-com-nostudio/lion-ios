// Sequence+Sorted.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/28.

import Foundation

extension Sequence {
    func sorted<T>(
        by keyPath: KeyPath<Element, T>,
        using comparator: (T, T) -> Bool = (<)
    ) -> [Element] where T: Comparable {
        sorted { element1, element2 in
            comparator(element1[keyPath: keyPath], element2[keyPath: keyPath])
        }
    }
}

extension Sequence {
    func sorted(
        using descriptors: [SortDescriptor<Element>],
        sortOrder: SortOrder
    ) -> [Element] {
        sorted { element1, element2 in
            for descriptor in descriptors {
                let result = descriptor.comparator(element1, element2)

                switch result {
                case .orderedSame:
                    break
                case .orderedAscending:
                    return sortOrder == .forward
                case .orderedDescending:
                    return sortOrder == .reverse
                }
            }

            // If no descriptor was able to determine the sort
            // order, we'll default to false (similar to when
            // using the '<' operator with the built-in API):
            return false
        }
    }
}

extension Sequence {
    func sorted(
        using descriptors: SortDescriptor<Element>...,
        sortOrder _: SortOrder
    ) -> [Element] {
        sorted(using: descriptors, sortOrder: .forward)
    }
}
