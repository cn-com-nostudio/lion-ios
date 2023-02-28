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
    let gradient: Gradient
    var maskGradient: Gradient
}

enum ModeHeaders {
    static let child = ModeHeader(
        modeName: .childMode,
        modeTip: .childModeTip,
        aboutTip: .aboutChildMode,
        headImage: Image(.child),
        primaryColor: Color(.darkIndigo),
        gradient: .init(colors: [Color(.darkIndigo), Color(.lightIndigo)]),
        maskGradient: .init(colors: [
            Color(hex: 0x6643F2).opacity(0),
            Color(hex: 0x6643F2)
        ])
    )

    static let loan = ModeHeader(
        modeName: .loanMode,
        modeTip: .loanModeTip,
        aboutTip: .aboutLoanMode,
        headImage: Image(.loan),
        primaryColor: Color(.darkBlue),
        gradient: .init(colors: [Color(.darkBlue), Color(.lightBlue)]),
        maskGradient: .init(colors: [
            Color(hex: 0x3871EA).opacity(0),
            Color(hex: 0x3871EA)
        ])
    )

    static subscript(mode: ModeSettings.State) -> ModeHeader {
        Self[LocalizedStringKey(mode.modeName)]
    }

    private static subscript(modeName: LocalizedStringKey) -> ModeHeader {
        [child, loan].first { $0.modeName == modeName } ?? child
    }
}
