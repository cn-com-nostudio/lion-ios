// DigitGroup.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/3.

import Foundation

public struct DigitGroup: Equatable, Hashable {
    public struct IndexedDigit: Equatable, Hashable {
        public let index: Int
        public let digit: Character?
    }

    public private(set) var indexed: [IndexedDigit]

    public var currentIndex: Int? {
        let firstBlank = indexed.first { $0.digit == nil }?.index
        if firstBlank == nil {
            if concat.isEmpty {
                return 0
            } else {
                return concat.count - 1
            }
        } else {
            return firstBlank
        }
    }

    public var concat: String {
        indexed.compactMap { $0.digit.map(String.init) }.reduce("", +)
    }

    public var isEmpty: Bool {
        concat.isEmpty
    }

    public init(digits: [Character?], upTo maxLength: Int) {
        let processed: [Character?]
        if digits.count <= maxLength {
            processed = digits + .init(repeating: nil, count: maxLength - digits.count)
        } else {
            processed = Array(digits.prefix(maxLength))
        }
        indexed = processed.enumerated().map(IndexedDigit.init)
    }

    public static func blank(upTo maxLength: Int) -> DigitGroup {
        .init(digits: .init(repeating: nil, count: maxLength), upTo: maxLength)
    }
}

extension DigitGroup.IndexedDigit: Identifiable {
    public var id: Int {
        index
    }
}
