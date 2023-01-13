// ManagedSettingsStoreTests.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2022/12/29.

//// ManagedSettingsStoreTests.swift
//// Copyright (c) 2022 Soda Studio
//// Created by Jerry X T Wang on 2022/12/29.
//
// import ManagedSettings
// import XCTest
//
// final class ManagedSettingsStoreTests: XCTestCase {
//    func test1() {
//        let childStore = ManagedSettingsStore(named: ManagedSettingsStore.Name(rawValue: "child"))
//        childStore.application.denyAppInstallation = true
//        childStore.application.denyAppRemoval = false
//
//
////        let loanStore = ManagedSettingsStore(named: ManagedSettingsStore.Name(rawValue: "loan"))
////        loanStore.application.denyAppInstallation = false
////        loanStore.application.denyAppRemoval = true
////
////        XCTAssertEqual(loanStore.application.denyAppInstallation, false)
////        XCTAssertEqual(loanStore.application.denyAppRemoval, true)
//
//        XCTAssertEqual(childStore.application.denyAppInstallation, true)
//        XCTAssertEqual(childStore.application.denyAppRemoval, false)
//    }
//
////    func test2() {
////        let childStore = ManagedSettingsStore(named: ManagedSettingsStore.Name(rawValue: "child"))
////        childStore.application.denyAppInstallation = true
////        childStore.application.denyAppRemoval = false
////
////        let loanStore = ManagedSettingsStore(named: ManagedSettingsStore.Name(rawValue: "loan"))
////        loanStore.application.denyAppInstallation = false
////        loanStore.application.denyAppRemoval = true
////
////        loanStore.clearAllSettings()
////
////        XCTAssertNil(loanStore.application.denyAppInstallation)
////        XCTAssertNil(loanStore.application.denyAppRemoval)
////
////        XCTAssertEqual(childStore.application.denyAppInstallation, true)
////        XCTAssertEqual(childStore.application.denyAppRemoval, false)
////    }
// }
