// ModeHeader.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import SwiftUI

struct ModeHeader: Equatable {
    let modeName: LocalizedStringKey
    let modeTip: LocalizedStringKey
    let aboutTip: LocalizedStringKey
    let headImage: Image
    let primaryColor: Color
    let gradient: [Gradient.Stop]
    var maskGradient: [Gradient.Stop]
}

enum ModeHeaders {
    static let child = ModeHeader(
        modeName: .childMode,
        modeTip: .childModeTip,
        aboutTip: .aboutChildMode,
        headImage: Image(.child),
        primaryColor: Color(.darkIndigo),
        gradient: [
            .init(color: Color(.darkIndigo), location: 0.0),
            .init(color: Color(.lightIndigo), location: 1.0)
        ],
        maskGradient: [
            .init(color: Color(.darkIndigo).opacity(0), location: 0.0),
            .init(color: Color(.darkIndigo), location: 0.57)
        ]
    )

    static let loan = ModeHeader(
        modeName: .loanMode,
        modeTip: .loanModeTip,
        aboutTip: .aboutLoanMode,
        headImage: Image(.loan),
        primaryColor: Color(.darkBlue),
        gradient: [
            .init(color: Color(.darkBlue), location: 0.0),
            .init(color: Color(.lightBlue), location: 1.0)
        ],
        maskGradient: [
            .init(color: Color(.darkBlue).opacity(0), location: 0.0),
            .init(color: Color(.darkBlue), location: 0.57)
        ]
    )

    static subscript(mode: ModeSettings.State) -> ModeHeader {
        Self[LocalizedStringKey(mode.modeName)]
    }

    private static subscript(modeName: LocalizedStringKey) -> ModeHeader {
        [child, loan].first { $0.modeName == modeName } ?? child
    }
}
