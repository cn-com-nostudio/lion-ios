// FilePath.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import Foundation

struct FilePath {
    let directory: Directory
    let fileName: String

    var url: URL {
        directory.appendingPathComponent(fileName)
    }
}
