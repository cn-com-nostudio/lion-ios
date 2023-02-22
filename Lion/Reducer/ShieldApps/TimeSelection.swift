// TimeSelection.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import Foundation

struct TimeSelection: ReducerProtocol {
    struct State: Equatable, Codable {
        var time: HourMinute.State
        var min: HourMinute.State
        var max: HourMinute.State

        var selectRange: ClosedRange<Date> {
            min.date() ... max.date()
        }
    }

    enum Action: Equatable {
        case time(HourMinute.Action)
        case min(HourMinute.Action)
        case max(HourMinute.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.time, action: /Action.time) {
            HourMinute()
        }

        Scope(state: \.min, action: /Action.min) {
            HourMinute()
        }

        Scope(state: \.max, action: /Action.max) {
            HourMinute()
        }
    }
}
