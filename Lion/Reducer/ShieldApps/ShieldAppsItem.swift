// ShieldAppsItem.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/9.

import ComposableArchitecture
import Foundation
import SwiftUI

struct ShieldAppsItem: ReducerProtocol {
    struct State: Equatable, Codable, Identifiable {
        let id: UUID
        var isOn: Bool
        var timeInterval: TimeInterval.State
        var weekdays: SortedSet<Weekday>
        var selectedApps: AppsSelection.State

        init(
            id: UUID,
            isOn: Bool = false,
            timeInterval: TimeInterval.State = .default,
            weekdays: SortedSet<Weekday> = .init(),
            selectedApps: AppsSelection.State = .none
        ) {
            self.id = id
            self.isOn = isOn
            self.timeInterval = timeInterval
            self.weekdays = weekdays
            self.selectedApps = selectedApps
        }
    }

    enum Action: Equatable {
        case toggleIsOn(Bool)
        case timeInterval(TimeInterval.Action)
        case weekday(WeekdayAction)
        case selectApps(AppsSelection.Action)
    }

    enum WeekdayAction: Equatable {
        case addWeekday(Weekday)
        case removeWeekday(Weekday)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .toggleIsOn(isOn):
                state.isOn = isOn
                print(LocalizedStringKey.nOfApps(3))

                return .none

            case let .weekday(.addWeekday(weekday)):
                state.weekdays.insert(weekday)
                return .none

            case let .weekday(.removeWeekday(weekday)):
                state.weekdays.remove(weekday)
                return .none

            default:
                return .none
            }
        }

        Scope(state: \.timeInterval, action: /Action.timeInterval) {
            TimeInterval()
        }

        Scope(state: \.selectedApps, action: /Action.selectApps) {
            AppsSelection()
        }
    }
}
