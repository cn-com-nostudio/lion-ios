// ColorSet.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import SwiftUI

extension Lion where Base == Color {
    static let primary = Color(hex: 0x191A1C)
    static let secondary = Color(hex: 0x191A1C).opacity(0.5)
    static let white = Color.white
    static let lightWhite = white.opacity(0.3)
    static let error = Color.red.opacity(0.7)

    static let gray: Color = .init(hex: 0xD9D9D9)
    static let yellow: Base = .init(hex: 0xFFD836)
    static let blue: Base = .init(hex: 0x3775F6)
}

extension Color: LionCompatible {}

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
