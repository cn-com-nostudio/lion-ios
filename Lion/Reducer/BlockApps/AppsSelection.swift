// AppsSelection.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import FamilyControls
import ManagedSettings

struct AppsSelection: ReducerProtocol {
    struct State: Equatable, Codable {
        @NotCoded var isPresented: Bool
        var appTokens: Set<ApplicationToken>
        var categoryTokens: Set<ActivityCategoryToken>

        var maxSelectAmount: Int { 50 }

        init(isPresented: Bool,
             appTokens: Set<ApplicationToken> = [],
             categoryTokens: Set<ActivityCategoryToken> = [])
        {
            self.isPresented = isPresented
            self.appTokens = appTokens
            self.categoryTokens = categoryTokens
        }
    }

    enum Action: Equatable {
        case toggleIsPresented(Bool)
        case updateIsPresented(Bool)
        case update(FamilyActivitySelection)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .updateIsPresented(isPresented):
                state.isPresented = isPresented
                return .none

            case let .update(selection):
                state.categoryTokens = selection.categoryTokens
                state.appTokens = selection.applicationTokens
                return .none

            default:
                return .none
            }
        }
    }
}
