// ModeItem.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ManagedSettings
import SwiftUI

struct ModeItem: Equatable {
    let icon: SystemIcon
    let name: LocalizedStringKey
    let tip: LocalizedStringKey
    let hasSubSettings: Bool
    let subSettingsName: LocalizedStringKey
    let subSettingsTip: LocalizedStringKey
    let gradient: Gradient

    init(icon: SystemIcon,
         title: LocalizedStringKey,
         tip: LocalizedStringKey,
         hasSubSettings: Bool,
         subSettingsName: LocalizedStringKey,
         subSettingsTip: @autoclosure () -> LocalizedStringKey,
         gradient: Gradient)
    {
        self.icon = icon
        name = title
        self.tip = tip
        self.hasSubSettings = hasSubSettings
        self.subSettingsName = subSettingsName
        self.subSettingsTip = subSettingsTip()
        self.gradient = gradient
    }
}

enum ModeItems {
    static let denyAppRemoval = ModeItem(
        icon: .eyeSlashFill,
        title: .denyAppRemoval,
        tip: .denyAppRemovalTip,
        hasSubSettings: false,
        subSettingsName: "",
        subSettingsTip: "",
        gradient: .pink
    )

    static let denyAppInstallation = ModeItem(
        icon: .eyeSlashFill,
        title: .denyAppInstallation,
        tip: .denyAppInstallationTip,
        hasSubSettings: false,
        subSettingsName: "",
        subSettingsTip: "",
        gradient: .blue
    )

    static func blockApps(subSettingsTip: @autoclosure () -> LocalizedStringKey) -> ModeItem {
        ModeItem(
            icon: .eyeSlashFill,
            title: .blockApps,
            tip: .blockAppsTip,
            hasSubSettings: true,
            subSettingsName: .blockAppsSettings,
            subSettingsTip: subSettingsTip(),
            gradient: .cyan
        )
    }

    static let shieldApps = ModeItem(
        icon: .gamecontrollerFill,
        title: .shieldApps,
        tip: .shieldAppsTip,
        hasSubSettings: true,
        subSettingsName: .shiledAppsSettings,
        subSettingsTip: "",
        gradient: .indigo
    )
}
