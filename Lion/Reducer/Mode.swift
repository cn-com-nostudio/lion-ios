// Mode.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/29.

import ComposableArchitecture
import Foundation
import ManagedSettings

protocol Mode: Codable, Equatable {
    var modeName: String { get }
    var isOn: Bool { get }

    var isDenyAppRemoval: Bool { get }
    var isDenyAppInstallation: Bool { get }

    var isBlockApps: Bool { get }
    var blockAppsSettings: AppsSelection.State { get }

    var isShieldApps: Bool { get }
    var shieldAppsSettings: ShieldAppsSettings.State { get }
}
