// PinCircle.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/3.

import SwiftUI

public struct PinCircle: View {
    private let digit: Character?
    private let isHidden: Bool
    private let isHighlighted: Bool
    private let style: CircleStyle

    public init(
        digit: Character?,
        isHidden: Bool,
        isHighlighted: Bool,
        style: CircleStyle
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
                Circle()
                    .stroke(.clear, lineWidth: 0)
                    .background((digit == nil || !isHidden) ? style.normalColor : style.highlightedColor)
                    .clipShape(Circle())
            )
    }
}

public struct CircleStyle: Equatable, Hashable {
    public var width: CGFloat = 20
    public var normalColor: Color = .lion.gray
    public var highlightedColor: Color = .lion.blue
}

public extension CircleStyle {
    static let pin: Self = .init()
}
