// StringAndDataTests.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2022/12/29.

import Foundation

import XCTest

final class StringAndDataTests: XCTestCase {
    func test1() {
        let string = String(data: Data(), encoding: .utf8)
        XCTAssertEqual(string, "")
    }
}
