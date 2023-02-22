// AppsSelection.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import FamilyControls
import ManagedSettings

extension AppsSelection.State {
    static let none: Self = .init(
        isPresented: false,
        appTokens: [],
        categoryTokens: []
    )
}

struct AppsSelection: ReducerProtocol {
    struct State: Equatable, Codable {
        @NotCoded var isPresented: Bool
        var appTokens: Set<ApplicationToken>
        var categoryTokens: Set<ActivityCategoryToken>

        var maxSelectAmount: Int { 50 }
    }

    enum Action: Equatable {
        case toggleIsPresented(Bool)
        case update(FamilyActivitySelection)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .toggleIsPresented(isPresented):
                state.isPresented = isPresented
                return .none

            case let .update(selection):
                state.categoryTokens = selection.categoryTokens
                state.appTokens = selection.applicationTokens
                return .none
            }
        }
    }
}
