// Bundle+Extension.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/4.

import Foundation

public extension Localized where Base == Bundle {
    var bundleDisplayName: String? {
        base.localizedInfoDictionary?["CFBundleDisplayName"] as? String
    }

    var bundleShortVersion: String? {
        base.localizedInfoDictionary?["CFBundleShortVersionString"] as? String
    }

    var bundleVersion: String? {
        base.localizedInfoDictionary?["CFBundleVersion"] as? String
    }
}

extension Bundle: LocalizedCompatible {}
