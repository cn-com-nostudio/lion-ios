// ShieldAppsItem.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import Foundation
import SwiftUI

extension ShieldAppsItem.State {
    @Dependency(\.uuid) static var uuid

    static let `default`: Self = .init(id: uuid())
}

struct ShieldAppsItem: ReducerProtocol {
    struct State: Equatable, Codable, Identifiable {
        let id: UUID
//        var isOn: Bool
        var timeDuration: TimeDuration.State
        var weekdays: SortedSet<Weekday>
        var selectedApps: AppsSelection.State

        @NotCoded var isNew: Bool

        init(
            id: UUID,
//            isOn: Bool = false,
            timeDuration: TimeDuration.State = .default,
            weekdays: SortedSet<Weekday> = .everyDay,
            selectedApps: AppsSelection.State = .none
        ) {
            self.id = id
//            self.isOn = isOn
            self.timeDuration = timeDuration
            self.weekdays = weekdays
            self.selectedApps = selectedApps
            isNew = true
        }
    }

    enum Action: Equatable {
//        case toggleIsOn(Bool)
        case timeDuration(TimeDuration.Action)
        case weekday(WeekdayAction)
        case selectApps(AppsSelection.Action)
        case editDone
    }

    enum WeekdayAction: Equatable {
        case addWeekday(Weekday)
        case removeWeekday(Weekday)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { _, action in
            switch action {
//            case let .toggleIsOn(isOn):
//                state.isOn = isOn
//                return .none

            default:
                return .none
            }
        }

        Scope(state: \.timeDuration, action: /Action.timeDuration) {
            TimeDuration()
        }

        Scope(state: \.selectedApps, action: /Action.selectApps) {
            AppsSelection()
        }

        Reduce { state, action in
            switch action {
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
    }
}
