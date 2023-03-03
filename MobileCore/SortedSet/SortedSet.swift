// SortedSet.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import Foundation

public struct SortedSet<Element: Hashable & Comparable>: ExpressibleByArrayLiteral {
    private var array: [Element] = []
    private var sortOrder: SortOrder = .forward

    public init<S: Sequence>(_ sequence: S) where S.Iterator.Element == Element {
        array = Set(sequence).sorted(by: compare)
    }

    public init(arrayLiteral elements: Element...) {
        self = .init(elements)
    }

    private var compare: (Element, Element) -> Bool {
        switch sortOrder {
        case .forward: return (<)
        case .reverse: return (>)
        }
    }

    public mutating func insert(_ newElement: Element) {
        guard !contains(newElement) else { return }

        if let index = array.firstIndex(where: { compare(newElement, $0) }) {
            array.insert(newElement, at: index)
        } else {
            array.append(newElement)
        }
    }

    public mutating func remove(_ element: Element) {
        if let index = index(of: element) {
            array.remove(at: index)
        }
    }

    public func contains(_ element: Element) -> Bool {
        array.contains { $0 == element }
    }

    public func contains(allIn set: Self) -> Bool {
        for element in set where !contains(element) {
            return false
        }
        return true
    }
}

extension SortedSet: RandomAccessCollection {
    public var startIndex: Int {
        array.startIndex
    }

    public var endIndex: Int {
        array.endIndex
    }

    public func index(after i: Int) -> Int {
        array.index(after: i)
    }

    public func index(before i: Int) -> Int {
        array.index(before: i)
    }

    public subscript(position: Int) -> Element {
        array[position]
    }
}

extension SortedSet {
    func index(of element: Element) -> Int? {
        array.firstIndex(of: element)
    }

    func firstIndex(where predicate: (Element) throws -> Bool) rethrows -> Int? {
        try array.firstIndex(where: predicate)
    }
}

extension SortedSet: Hashable where Element: Hashable {}
extension SortedSet: Codable where Element: Codable {}
extension SortedSet: Equatable where Element: Equatable {}
