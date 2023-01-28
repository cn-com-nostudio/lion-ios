// ImageSet.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/28.

import SwiftUI

enum ImageSet: String {
    case child
    case loan
    case background
    case games
    case selector
    case starts
    case blue
}

extension Image {
    init(_ imageSet: ImageSet) {
        self = .init(imageSet.rawValue)
    }
}
