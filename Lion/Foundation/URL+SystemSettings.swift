// URL+SystemSettings.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/5.

import Foundation
import UIKit

extension URL {
    static func appStorePage(appID: String) -> Self {
        .init(string: "https://itunes.apple.com/app/id\(appID)")!
    }

    static func appStoreReviewPage(appID: String) -> Self {
        .init(string: "https://itunes.apple.com/app/id\(appID)?action=write-review")!
    }
}

extension SystemSettings where Base == URL {
    static let app: Base = .init(string: UIApplication.openSettingsURLString)!
}

extension URL: SystemSettingsCompatible {}
