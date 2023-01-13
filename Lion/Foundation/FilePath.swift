// FilePath.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2022/12/29.

import Foundation

struct FilePath {
    let directory: Directory
    let fileName: String

    var url: URL {
        directory.appendingPathComponent(fileName)
    }
}
