// LocalizedStringKey.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/29.

import SwiftUI

extension LocalizedStringKey {
    static let childMode: Self = "child mode"
    static let loanMode: Self = "loan mode"
    static let childModeTip: Self = "child mode tip"
    static let loanModeTip: Self = "loan mode tip"
    static let aboutChildMode: Self = "about child mode"
    static let aboutLoanMode: Self = "about loan mode"
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

    static let open: Self = "open"
    static let close: Self = "close"
    static let settings: Self = "settings"
    static let suggesionModeSettings: Self = "suggesion mode settings"

    static let everyDay: Self = "every day"
    static let everyWorkday: Self = "every workday"
    static let everyWeekend: Self = "every weekend"

    static let limitAppsOpen: Self = "limit apps open"
    static let limitAppsOpenTip: Self = "limit apps open tip"
    static let timeIntervalToLimitAppsOpen: Self = "time interval to limit apps open"

    static let add: Self = "add"
    static let startSetting: Self = "start setting"
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

    static let becomeSeniorMember: Self = "become senior member"
    static let unlockAllFunctions: Self = "unlock all functions, protect your privacy"
    static let protectYourPrivacy: Self = "protect your privacy"
    static let unlockImmediately: Self = "unlock immediately"
    static let subscribeImmediately: Self = "subscribe immediately"

    static let quickHelp: Self = "quick help"
    static let feedbacksAndSuggestions: Self = "feedbacks and suggesctions"
    static let passwordLock: Self = "password lock"
    static let userLisence: Self = "user lisence"
    static let privacyPolicy: Self = "privacy policy"
    static let shareToFriends: Self = "share to friends"
    static let specialThanks: Self = "special thanks"
    static let appStoreReviews: Self = "app store reviews"
    static let giveUsAFiveStarComment: Self = "give us a five-star comment on appstore"

    static let resetPassword: Self = "reset password"
    static let useFaceIDToUnlock: Self = "use faceID to unlock"

    static let inputNewPassword: Self = "input new password"
    static let inputNewPasswordOnceAgain: Self = "input new password once again"
    static let inputPasswordToUnlock: Self = "input password to unlock"
    static let faceID: Self = "faceID"
    static let wrongPassword: Self = "wrong password"

    static let faceIDAccessNotGranted: Self = "faceID access not granted"
    static let grantFaceIDAccessToUseFaceIDToUnlock: Self = "grant faceID access to use faceID to unlock"
    static let grantFaceIDAccess: Self = "grant faceID access"

    static let faceIDNotEnrolled: Self = "faceID not enrolled"
    static let enrollFaceIDToUseFaceIDToUnlock: Self = "enroll faceID to use faceID to unlock"
    static let enrollFaceID: Self = "enroll faceID"

    static let devicePasscodeNotSet: Self = "device passcode not set"
    static let setDevicePasscodeToUseFaceIDToUnlock: Self = "set device passcode to use faceID to unlock"
    static let setDevicePasscode: Self = "set device passcode"

    static let twelveMonths: Self = "12 months"
    static let twoCupsOfCoffee: Self = "2 cups of coffee"
    static let lifetimeMember: Self = "lifetime member"
    static let payOnceAvailableForLife: Self = "pay once, available for life"

    static let currencySymbol: Self = "currency symbol"

    static let oneClickSwitch: Self = "one-click to switch"
    static let switchUlimitly: Self = "switch unlimitly"
    static let hideAppsUnlimited: Self = "hide apps unlimitly"
    static let unlockUsingFaceID: Self = "unlock using faceID"

    static let alreadyTurnOn: Self = "already turn on"
    static let notTurnOnYet: Self = "not turn on yet"

    static let thanksForYourSupport: Self = "thanks for your support"

    static let temporaryLoanOfMobilePhoneToOthers: Self = "temporary loan of mobile phone to others"
    static let preventPeepingPrivacy: Self = "prevent peeping privacy"
    static let turnOnTheHiddenApp: Self = "turn on the hidden app, so you don't panic when you check your phone"

    static let deleteTheAppByMistake: Self = "delete the app by mistake"
    static let preventLossOfImportantData: Self = "prevent loss of important data"
    static let turnOnTheProhibitionOfDeletingApps: Self = "turn on the prohibition of deleting apps to avoid losing important data that cannot be retrieved"

    static let temporaryLoanOfMobilePhoneToChildren: Self = "bring baby mobile phone for children to play"
    static let preventGameAddiction: Self = "prevent game addiction"
    static let limitTheDurationOfGamesAndWatchingVideos: Self = "limit the duration of games and watching videos to prevent children from having too much fun"

    static let nextPage: Self = "next page"

    static let start: Self = "start"
    static let stop: Self = "stop"

    static let weRespectYourDataPrivacyAndSecurity: Self = "we respect your data privacy and security, and this feature will work entirely locally and offline."
    static let youCanCancelThisAuthorizationAtAnyTime: Self = "you can cancel this authorization at any time in the system's \"Settings\" > \"Screen Time\"."

    static let allowAccess: Self = "allow access"

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

    static func limitTimeOffer(_ percentage: Int) -> Self {
        "limit time offer \(percentage)%"
    }

    static func version(_ version: String, buildVersion: String) -> Self {
        "version \(version)(\(buildVersion))"
    }

    static func yearlyMember(purchaseDate: Date, expiredDate _: Date) -> Self {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return "yearly member(\(dateFormatter.string(from: purchaseDate)) - \(dateFormatter.string(from: purchaseDate))"
    }

    static func allowAppToManageAccessLimit(appName: String) -> Self {
        "allow \(appName) to manage access limit of this device"
    }

    static func useScreenTimeLimitToManageAccessLimit(appName: String) -> Self {
        "\(appName) use screen time limit to manage access limit of the device."
    }
}
