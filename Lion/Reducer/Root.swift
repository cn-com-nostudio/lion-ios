// Root.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/28.

import ComposableArchitecture
import ManagedSettings

extension Root.State {
    static let `default`: Self = .init(childMode: .child, loanMode: .loan)
}

struct Root: ReducerProtocol {
    struct State: Equatable, Codable {
        var childMode: ModeSettings.State
        var loanMode: ModeSettings.State
    }

    enum Action: Equatable {
        case childMode(ModeSettings.Action)
        case loanMode(ModeSettings.Action)
    }

    var body: some ReducerProtocol<State, Action> {
//        Reduce { _, action in
//            switch action {
//            case .childMode, .loanMode:
//                return .none
//            }
//        }

        Scope(state: \.childMode, action: /Action.childMode) {
            ModeSettings()
        }

        Scope(state: \.loanMode, action: /Action.loanMode) {
            ModeSettings()
        }
    }
}
