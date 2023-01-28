// LocalizedStringKey.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/14.

import SwiftUI

extension LocalizedStringKey {
    static let childMode: Self = "child mode"
    static let loanMode: Self = "loan mode"
    static let childModeTip: Self = "child mode tip"
    static let loanModeTip: Self = "loan mode tip"
    static let denyAppRemoval: Self = "deny app removal"
    static let denyAppRemovalTip: Self = "deny app removal tip"
    static let denyAppInstallation: Self = "deny app installation"
    static let denyAppInstallationTip: Self = "deny app installation tip"
    static let blockApps: Self = "block apps"
    static let blockAppsTip: Self = "block apps tip"
    static let shieldApps: Self = "shield apps"
    static let shieldAppsTip: Self = "shield apps tip"
    static let blockWebs: Self = "block webs"
    static let blockWebsTip: Self = "block webs tip"

    static let blockAppsSettings: Self = "block apps settings"
    static let shiledAppsSettings: Self = "shiled apps settings"
    static let blockWebsSettings: Self = "block webs settings"

    static let start: Self = "start"
    static let stop: Self = "stop"
    static let settings: Self = "settings"
    static let suggesionModeSettings: Self = "suggesion mode settings"

    static let everyDay: Self = "every day"
    static let everyWorkday: Self = "every workday"
    static let everyWeekend: Self = "every weekend"

    static let limitAppsOpen: Self = "limit apps open"
    static let limitAppsOpenTip: Self = "limit apps open tip"
    static let timeIntervalToLimitAppsOpen: Self = "time interval to limit apps open"

    static let add: Self = "add"
    static let time: Self = "time"
    static let from: Self = "from"
    static let to: Self = "to"

    static let cancel: Self = "cancel"
    static let done: Self = "done"
    static let delete: Self = "delete"
    static let `repeat`: Self = "repeat"

    static let limitApps: Self = "limit apps"
    static let limitAppsTip: Self = "limit apps tip"
    static let selectApps: Self = "select apps"

    static let aboutChildMode: Self = "about child mode"
    static let aboutLoanMode: Self = "about loan mode"

    static func nOfApps(_ number: Int) -> Self {
        "\(number) apps"
    }

    static func nOfBlockedApps(_ number: Int) -> Self {
        "\(number) blocked apps"
    }

    static func nOfAppsSelected(_ number: Int) -> Self {
        "apps selected amount: \(number)"
    }

    static func nOfAppsSelected(_ number: Int, exceeds maxAmount: Int) -> Self {
        "apps selected amount: \(number) (exceeds max select amount \(maxAmount))"
    }
}
