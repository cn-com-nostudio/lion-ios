// TimeSelection.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import Foundation

struct TimeSelection: ReducerProtocol {
    struct State: Equatable, Codable {
        var time: HourMinute.State
    }

    enum Action: Equatable {
        case time(HourMinute.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.time, action: /Action.time) {
            HourMinute()
        }
    }
}
