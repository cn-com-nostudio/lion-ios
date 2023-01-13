// RootStateInitial.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/13.

import ComposableArchitecture
import Foundation
import XCTestDynamicOverlay

extension DependencyValues {
    var rootStateInitial: RootStateInitial { self[RootStateInitial.self] }
}

struct RootStateInitial {
    var value: () -> Root.State
}

extension RootStateInitial: DependencyKey {
    static var liveValue: Self = .init(
        value: {
            if let url = Bundle.main.url(forResource: "rootStateInitialValue", withExtension: "json"),
               let model: Root.State = try? Resource(local: url).mode()
            {
                return model
            } else {
                return Root.State(childMode: .child, loanMode: .loan)
            }
        }
    )

    static let testValue: Self = .init(
        value: XCTUnimplemented("\(Self.self).value")
    )
}