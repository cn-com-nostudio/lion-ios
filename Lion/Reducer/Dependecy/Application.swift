// Application.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/5.

import ComposableArchitecture
import Foundation
import UIKit
import XCTestDynamicOverlay

// extension DependencyValues {
//    var application: ApplicationOpener { self[ApplicationOpener.self] }
// }
//
// struct ApplicationOpener {
//    var rate: () async -> Void
// }
//
// extension ApplicationOpener: DependencyKey {
//    static let app = UIApplication.shared
//    static let appID = "1661287418"
//
//    static var liveValue: Self = .init(
//        rate: {
//            Task { @MainActor in
//                await app.open(.appStoreReviewPage(appID: appID))
//            }
//        }
//    )
//
//    static let testValue: Self = .init(
//        rate: XCTUnimplemented("\(Self.self).rate")
//    )
// }
