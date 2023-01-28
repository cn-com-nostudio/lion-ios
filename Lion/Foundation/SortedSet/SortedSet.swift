// SortedSet.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/14.

import Foundation

struct SortedSet<Element: Hashable & Comparable>: ExpressibleByArrayLiteral {
    private var array: [Element] = []
    private var sortOrder: SortOrder = .forward

    init<S: Sequence>(_ sequence: S) where S.Iterator.Element == Element {
        array = Set(sequence).sorted(by: compare)
    }

    init(arrayLiteral elements: Element...) {
        self = .init(elements)
    }

    private var compare: (Element, Element) -> Bool {
        switch sortOrder {
        case .forward: return (<)
        case .reverse: return (>)
        }
    }

    mutating func insert(_ newElement: Element) {
        guard !contains(newElement) else { return }

        if let index = array.firstIndex(where: { compare(newElement, $0) }) {
            array.insert(newElement, at: index)
        } else {
            array.append(newElement)
        }
    }

    mutating func remove(_ element: Element) {
        if let index = index(of: element) {
            array.remove(at: index)
        }
    }

    func contains(_ element: Element) -> Bool {
        array.contains { $0 == element }
    }

    func contains(allIn set: Self) -> Bool {
        for element in set where !contains(element) {
            return false
        }
        return true
    }
}

extension SortedSet: RandomAccessCollection {
    var startIndex: Int {
        array.startIndex
    }

    var endIndex: Int {
        array.endIndex
    }

    func index(after i: Int) -> Int {
        array.index(after: i)
    }

    func index(before i: Int) -> Int {
        array.index(before: i)
    }

    subscript(position: Int) -> Element {
        array[position]
    }
}

extension SortedSet {
    @inlinable func index(of element: Element) -> Int? {
        array.firstIndex(of: element)
    }

    @inlinable func firstIndex(where predicate: (Element) throws -> Bool) rethrows -> Int? {
        try array.firstIndex(where: predicate)
    }
}

extension SortedSet: Hashable where Element: Hashable {}
extension SortedSet: Codable where Element: Codable {}
extension SortedSet: Equatable where Element: Equatable {}
