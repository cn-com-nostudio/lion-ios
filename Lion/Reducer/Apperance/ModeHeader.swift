// ModeHeader.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/28.

import SwiftUI

struct ModeHeader: Equatable {
    let modeName: LocalizedStringKey
    let modeTip: LocalizedStringKey
    let aboutTip: LocalizedStringKey
    let headImage: Image
    let colors: [Color]
}

extension ModeHeader {
    var gradient: Gradient {
        .init(colors: colors)
    }

    var primaryColor: Color {
        colors.first!
    }
}

enum ModeHeaders {
    static let child = ModeHeader(
        modeName: .childMode,
        modeTip: .childModeTip,
        aboutTip: .aboutChildMode,
        headImage: Image(.child),
        colors: [Color(.darkIndigo), Color(.lightIndigo)]
    )

    static let loan = ModeHeader(
        modeName: .loanMode,
        modeTip: .loanModeTip,
        aboutTip: .aboutLoanMode,
        headImage: Image(.loan),
        colors: [Color(.darkBlue), Color(.lightBlue)]
    )

    static subscript(mode: ModeSettings.State) -> ModeHeader {
        Self[LocalizedStringKey(mode.modeName)]
    }

    private static subscript(modeName: LocalizedStringKey) -> ModeHeader {
        [child, loan].first { $0.modeName == modeName } ?? child
    }
}
