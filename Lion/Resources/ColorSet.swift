// ColorSet.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/1.

import SwiftUI

enum ColorSet: String {
    case darkCyan
    case lightCyan
    case darkBlue
    case lightBlue
    case darkIndigo
    case lightIndigo
    case darkPink
    case lightPink
    case darkYellow
    case lightYellow
    case veryLightGreen
    case veryLightGray
}

extension Color {
    init(_ colorSet: ColorSet) {
        self = .init(colorSet.rawValue)
    }
}

extension Gradient {
    static let cyan = Self(
        colors: [
            Color(.darkCyan),
            Color(.lightCyan)
        ]
    )

    static let blue = Self(
        colors: [
            Color(.darkBlue),
            Color(.lightBlue)
        ]
    )

    static let indigo = Self(
        colors: [
            Color(.darkIndigo),
            Color(.lightIndigo)
        ]
    )

    static let pink = Self(
        colors: [
            Color(.darkPink),
            Color(.lightPink)
        ]
    )

    static let yellow = Self(
        colors: [
            Color(.darkYellow),
            Color(.lightYellow)
        ]
    )
}
