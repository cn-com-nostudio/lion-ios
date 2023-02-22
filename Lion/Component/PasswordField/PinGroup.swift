// PinGroup.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/3.

import SwiftUI

public struct PinGroup: View {
    @Binding public var digitGroup: DigitGroup
    @Binding public var isHidden: Bool
    @Binding public var disableHighlight: Bool
    public let style: PinGroupStyle

    public var body: some View {
        HStack(alignment: .center, spacing: style.spacing) {
            ForEach(digitGroup.indexed) { indexedDigit in
                PinCircle(
                    digit: indexedDigit.digit,
                    isHidden: isHidden,
                    isHighlighted: disableHighlight ? false : digitGroup.currentIndex == indexedDigit.index,
                    style: .pin
                )
            }
        }
    }
}

public struct PinGroupStyle: Equatable, Hashable {
    public var spacing: CGFloat = 24
}

public extension PinGroupStyle {
    static let pin: Self = .init()
}
