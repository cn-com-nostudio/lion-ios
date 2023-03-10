// ModeItem.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ManagedSettings
import SwiftUI

struct ModeItem: Equatable {
    let icon: SystemIcon
    let iconSize: CGFloat
    let name: LocalizedStringKey
    let tip: LocalizedStringKey
    let hasToggle: Bool
    let hasSubSettings: Bool
    let subSettingsName: LocalizedStringKey
    let subSettingsTip: LocalizedStringKey
    let gradient: Gradient

    init(icon: SystemIcon,
         iconSize: CGFloat,
         title: LocalizedStringKey,
         tip: LocalizedStringKey,
         hasToggle: Bool,
         hasSubSettings: Bool,
         subSettingsName: LocalizedStringKey,
         subSettingsTip: @autoclosure () -> LocalizedStringKey,
         gradient: Gradient)
    {
        self.icon = icon
        self.iconSize = iconSize
        name = title
        self.tip = tip
        self.hasToggle = hasToggle
        self.hasSubSettings = hasSubSettings
        self.subSettingsName = subSettingsName
        self.subSettingsTip = subSettingsTip()
        self.gradient = gradient
    }
}

enum ModeItems {
    static let denyAppRemoval = ModeItem(
        icon: .trashSlashFill,
        iconSize: 18,
        title: .denyAppRemoval,
        tip: .denyAppRemovalTip,
        hasToggle: true,
        hasSubSettings: false,
        subSettingsName: "",
        subSettingsTip: "",
        gradient: .pink
    )

    static let denyAppInstallation = ModeItem(
        icon: .hourglass,
        iconSize: 22,
        title: .denyAppInstallation,
        tip: .denyAppInstallationTip,
        hasToggle: true,
        hasSubSettings: false,
        subSettingsName: "",
        subSettingsTip: "",
        gradient: .blue
    )

    static func blockApps(subSettingsTip: @autoclosure () -> LocalizedStringKey) -> ModeItem {
        ModeItem(
            icon: .eyeSlashFill,
            iconSize: 18,
            title: .blockApps,
            tip: .blockAppsTip,
            hasToggle: false,
            hasSubSettings: true,
            subSettingsName: .blockAppsSettings,
            subSettingsTip: subSettingsTip(),
            gradient: .cyan
        )
    }

    static let shieldApps = ModeItem(
        icon: .gamecontrollerFill,
        iconSize: 18,
        title: .shieldApps,
        tip: .shieldAppsTip,
        hasToggle: false,
        hasSubSettings: true,
        subSettingsName: .shiledAppsSettings,
        subSettingsTip: "",
        gradient: .indigo
    )
}
