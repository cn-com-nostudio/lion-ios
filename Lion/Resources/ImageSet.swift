// ImageSet.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import SwiftUI

enum ImageSet: String {
    case child
    case loan
    case background
    case games
    case webs
    case selector
    case starts
    case blue

    case fiveStar
    case bigStar
    case pro

    case password
    case passwordLogo
    case cat

    case quickHelp
    case feedbacksAndSuggestions
    case passwordLock
    case userLisence
    case privacyPolicy
    case shareToFriends
    case specialThanks

    case childModeSwitch
    case loanModeSwitch
    case toggle
    case lock

    case boat
    case settings

    case beAMember
    case discount

    case threeDots
    case hiddingCatEnglish

    case loading
    case introduce1
    case introduce2
    case introduce3
    case hiddingCatYellow

    case checkYellow

    case appStore
    case blankApp
    case placeholderApp
}

extension Image {
    init(_ imageSet: ImageSet) {
        self = .init(imageSet.rawValue)
    }
}
