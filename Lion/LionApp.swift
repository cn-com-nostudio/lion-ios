// LionApp.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/29.

import ComposableArchitecture
import FamilyControls
import SwiftUI

@main
struct LionApp: App {
    @Dependency(\.rootStateCahce) var rootStateCache
    @Dependency(\.rootStateInitial) var rootStateInitial

    var body: some Scene {
        WindowGroup {
            RootView(
                store: createStore()
            )
            .onAppear {
                Task {
                    do {
                        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                    } catch {
                        print("Failed to enroll Aniyah with error: \(error)")
                    }
                }
            }
        }
    }

    func createStore() -> Store<Root.State, Root.Action> {
        let state = (try? rootStateCache.load()) ?? rootStateInitial.value()

        return .init(
            initialState: state,
            reducer: Root()
                .caching(using: rootStateCache)
                .signpost()
                ._printChanges()
        )
    }
}
