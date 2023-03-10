// TimeDuration.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import Foundation

extension TimeDuration.State {
    static let `default`: Self = .init(
        start: .init(
            time: .init(hour: 9, minute: 0)
        ),
        end: .init(
            time: .init(hour: 18, minute: 0)
        )
    )
}

struct TimeDuration: ReducerProtocol {
    struct State: Equatable, Codable {
        var start: TimeSelection.State
        var end: TimeSelection.State

        var startRange: ClosedRange<Date> {
            .from(.min, to: end.time.previous)
        }

        var endRange: ClosedRange<Date> {
            .from(start.time.next, to: .max)
        }
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
    }
}

extension ClosedRange<Date> {
    static func from(_ start: Date, to end: Date) -> Self {
        start ... end
    }

    static func from(_ start: HourMinute.State, to end: HourMinute.State) -> Self {
        start.date() ... end.date()
    }

    static let allDay = from(.min, to: .max)
}
