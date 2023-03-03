// ShieldAppsItem.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import DeviceActivitySharing
import MobileCore

extension ShieldAppsItem.State {
    static var new: Self { .init() }
}

struct ShieldAppsItem: ReducerProtocol {
    struct State: Equatable, Codable, Identifiable {
        let id: UUID
        var timeDuration: TimeDuration.State
        var weekdays: SortedSet<Weekday>

        let selectedAppsGroupID: UUID
        var selectedApps: AppsSelection.State

        var isNew: Bool
        @NotCoded var isUpdating: Bool = false
        @NotCoded var isDeleting: Bool = false

        @Dependency(\.uuid) static var uuid

        init(
            id: UUID = uuid(),
            timeDuration: TimeDuration.State = .default,
            weekdays: SortedSet<Weekday> = .everyDay,
            selectedAppsGroupID: UUID = uuid(),
            selectedApps: AppsSelection.State = .none
        ) {
            self.id = id
            self.timeDuration = timeDuration
            self.weekdays = weekdays
            self.selectedAppsGroupID = selectedAppsGroupID
            self.selectedApps = selectedApps
            isNew = true
        }
    }

    enum Action: Equatable {
        case timeDuration(TimeDuration.Action)
        case weekday(WeekdayAction)
        case selectApps(AppsSelection.Action)

        case updateIsNew(Bool)
        case updateIsUpdating(Bool)
        case updateIsDeleting(Bool)
    }

    enum WeekdayAction: Equatable {
        case addWeekday(Weekday)
        case removeWeekday(Weekday)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .updateIsUpdating(isOn):
                state.isUpdating = isOn
                return .none

            case let .updateIsDeleting(isOn):
                state.isDeleting = isOn
                return .none

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
