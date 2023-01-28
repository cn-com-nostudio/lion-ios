// TimeInterval.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/14.

import ComposableArchitecture
import Foundation

extension TimeInterval.State {
    static let `default`: Self = .init(
        start: .init(
            time: .init(hour: 9, minute: 0),
            min: .min,
            max: .init(hour: 18, minute: 0)
        ),
        end: .init(
            time: .init(hour: 18, minute: 0),
            min: .init(hour: 9, minute: 0),
            max: .max
        )
    )
}

struct TimeInterval: ReducerProtocol {
    struct State: Equatable, Codable {
        var start: TimeSelection.State
        var end: TimeSelection.State
    }

    enum Action: Equatable {
        case start(TimeSelection.Action)
        case end(TimeSelection.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.start, action: /Action.start) {
            TimeSelection()
        }

        Scope(state: \.end, action: /Action.end) {
            TimeSelection()
        }

        Reduce { state, action in
            switch action {
            case .start(.time):
                state.end.min = state.start.time.next
                print(state.start.time)
                return .none
            case .end(.time):
                print(state.end.time)
                state.start.max = state.end.time.previous
                return .none
            default:
                return .none
            }
        }
    }
}
