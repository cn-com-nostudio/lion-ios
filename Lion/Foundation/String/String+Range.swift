// String+Range.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/3.

import Foundation

extension String {
    func safeRange(of range: Range<Int>) -> Range<Int> {
        max(range.lowerBound, 0) ..< min(range.upperBound, count)
    }

    func safeRange(of range: ClosedRange<Int>) -> ClosedRange<Int> {
        max(range.lowerBound, 0) ... min(range.upperBound, count)
    }

    subscript(_ indexs: ClosedRange<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[beginIndex ... endIndex])
    }

    subscript(_ range: Range<Int>) -> String {
        let safeRange = safeRange(of: range)
        let startIndex = index(startIndex, offsetBy: safeRange.lowerBound)
        let endIndex = index(startIndex, offsetBy: safeRange.upperBound)
        return String(self[startIndex ..< endIndex])
    }

    subscript(_ indexs: PartialRangeThrough<Int>) -> String {
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[startIndex ... endIndex])
    }

    subscript(_ indexs: PartialRangeFrom<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        return String(self[beginIndex ..< endIndex])
    }

    subscript(_ indexs: PartialRangeUpTo<Int>) -> String {
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[startIndex ..< endIndex])
    }
}

extension Safe where Base == String {
    func prefix(_ maxLength: Int) -> String {
        if maxLength < base.count {
            return String(base.prefix(maxLength))
        } else {
            return base
        }
    }
}

extension String: SafeCompatible {}
