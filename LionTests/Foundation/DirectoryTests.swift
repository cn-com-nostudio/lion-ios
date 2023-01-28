// DirectoryTests.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/14.

@testable import Lion
import XCTest

final class DirectoryTests: XCTestCase {
    func testDirectoryIsExist() {
        XCTAssertTrue(DocumentDirectory().isExist)
    }

    func testDirectoryIsNotExist() {
        XCTAssertFalse(DocumentDirectory(subFolder: "notExistFile.txt").isExist)
    }

    func testcreateDirectory() throws {
        let directory = DocumentDirectory(subFolder: "subFolder")
        try directory.create()
        XCTAssertTrue(directory.isExist)
    }
}
