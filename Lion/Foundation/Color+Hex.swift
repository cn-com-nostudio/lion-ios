// Color+Hex.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/29.

import SwiftUI

extension Color {
    /**
     Creates a color from an hex integer (e.g. 0x3498db).
     - parameter hex: A hexa-decimal UInt64 that represents a color.
     - parameter opacityChannel: If true the given hex-decimal UInt64 includes the opacity channel (e.g. 0xFF0000FF).
     */
    init(hex: UInt64, hasOpacityChannel: Bool = false) {
        let mask = UInt64(0xFF)
        let cappedHex = !hasOpacityChannel && hex > 0xFFFFFF ? 0xFFFFFF : hex

        let red = cappedHex >> (hasOpacityChannel ? 24 : 16) & mask
        let green = cappedHex >> (hasOpacityChannel ? 16 : 8) & mask
        let blue = cappedHex >> (hasOpacityChannel ? 8 : 0) & mask
        let opacity = hasOpacityChannel ? cappedHex & mask : 255

        self.init(
            red: Double(red) / 255.0,
            green: Double(green) / 255.0,
            blue: Double(blue) / 255.0,
            opacity: Double(opacity) / 255.0
        )
    }
}
