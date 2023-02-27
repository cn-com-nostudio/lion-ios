// LionApp.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/27.

import ComposableArchitecture
import SwiftUI

@main
struct LionApp: App {
    @Dependency(\.rootStoreInitial) var rootStoreInitial

    var body: some Scene {
        WindowGroup {
            RootView(
                store: rootStoreInitial.value()
            )
        }
    }
}
