// Zeroable.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2022/12/30.

import Foundation

protocol DefaultValuable {
    static var defaultValue: Self { get }
}

extension Int: DefaultValuable {
    static var defaultValue: Self { .zero }
}

extension Bool: DefaultValuable {
    static var defaultValue: Self { false }
}

extension String: DefaultValuable {
    static var defaultValue: Self { "" }
}

extension Optional: DefaultValuable {
    static var defaultValue: Self { .none }
}
