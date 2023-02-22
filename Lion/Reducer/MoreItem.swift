// MoreItem.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/2.

import SwiftUI

enum MoreItem {
    case quickHelp
    case feedbacksAndSuggestions
    case passwordLock
    case userLisence
    case privacyPolicy
    case shareToFriends
    case specialThanks

    struct Value {
        let icon: ImageSet
        let title: LocalizedStringKey
        let isMemberItem: Bool
        let link: String

        static let quickHelp: Self = .init(
            icon: .quickHelp,
            title: .quickHelp,
            isMemberItem: false,
            link: "https://hidingcat.super.site/get-started"
        )

        static let feedbacksAndSuggesstions: Self = .init(
            icon: .feedbacksAndSuggestions,
            title: .feedbacksAndSuggestions,
            isMemberItem: false,
            link: "leohuang.ux@gmail.com"
        )

        static let passwordLock: Self = .init(
            icon: .passwordLock,
            title: .passwordLock,
            isMemberItem: true,
            link: ""
        )

        static let userLisence: Self = .init(
            icon: .userLisence,
            title: .userLisence,
            isMemberItem: false,
            link: "https://hidingcat.super.site/terms"
        )

        static let privacyPolicy: Self = .init(
            icon: .privacyPolicy,
            title: .privacyPolicy,
            isMemberItem: false,
            link: "https://hidingcat.super.site/privacy-policy"
        )

        static let shareToFriends: Self = .init(
            icon: .shareToFriends,
            title: .shareToFriends,
            isMemberItem: false,
            link: "https://itunes.apple.com/app/id1564858029"
        )

        static let specialThanks: Self = .init(
            icon: .specialThanks,
            title: .specialThanks,
            isMemberItem: false,
            link: "https://hidingcat.super.site/thanks"
        )
    }

    func callAsFunction() -> Value {
        switch self {
        case .quickHelp: return .quickHelp
        case .feedbacksAndSuggestions: return .feedbacksAndSuggesstions
        case .passwordLock: return .passwordLock
        case .userLisence: return .userLisence
        case .privacyPolicy: return .privacyPolicy
        case .shareToFriends: return .shareToFriends
        case .specialThanks: return .specialThanks
        }
    }
}
