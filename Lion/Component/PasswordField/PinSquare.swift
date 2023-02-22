// PinSquare.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/3.

import SwiftUI

public struct PinSquare: View {
    private let digit: Character?
    private let isHidden: Bool
    private let isHighlighted: Bool
    private let style: SquareStyle

    public init(
        digit: Character?,
        isHidden: Bool,
        isHighlighted: Bool,
        style: SquareStyle
    ) {
        self.digit = digit
        self.isHidden = isHidden
        self.isHighlighted = isHighlighted
        self.style = style
    }

    public var body: some View {
        Text(isHidden ? "" : (digit.flatMap(String.init) ?? ""))
            .font(.title)
            .frame(width: style.width, height: style.width, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .stroke(isHighlighted ? style.highlightedColor : style.borderColor, lineWidth: style.borderWidth)
                    .background((digit == nil || !isHidden) ? Color(.clear) : style.backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
            )
    }
}

public struct SquareStyle: Equatable, Hashable {
    public var width: CGFloat = 48
    public var cornerRadius: CGFloat = 6
    public var borderWidth: CGFloat = 2
    public var borderColor: Color = .init(.systemGray2)
    public var backgroundColor: Color = .init(.systemGray2)
    public var highlightedColor: Color = .accentColor
}

public extension SquareStyle {
    static let pin: Self = .init()
}
