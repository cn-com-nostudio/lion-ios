// FontSet.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/29.

import SwiftUI

extension LionNamespacing where Base == Font {
    static let largeTitle: Font = .system(size: 32).weight(.semibold)
    static let title1: Font = .system(size: 28).weight(.semibold)
    static let title2: Font = .system(size: 24).weight(.semibold)
    static let title3: Font = .system(size: 20).weight(.semibold)
    static let headline: Font = .system(size: 16).weight(.semibold)

    static let body: Font = .system(size: 16).weight(.regular)
    static let caption1: Font = .system(size: 14).weight(.regular)
    static let caption1Bold: Font = .system(size: 14).weight(.semibold)
    static let caption2: Font = .system(size: 12).weight(.regular)
    static let caption2Bold: Font = .system(size: 12).weight(.semibold)
    static let caption3: Font = .system(size: 10).weight(.regular)
}

extension Font: LionNamespacingCompatible {}
//
// extension LionNamespacing where Base == Font {}
