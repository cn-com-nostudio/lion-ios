// ShieldAppsItem.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import DeviceActivitySharing
import MobileCore

extension ShieldAppsItem.State {
    static var new: Self {
        let selectedApps: AppsSelection.State = .init(isPresented: true)
        return .init(selectedApps: selectedApps)
    }
}

struct ShieldAppsItem: ReducerProtocol {
    struct State: Equatable, Codable, Identifiable {
        let id: UUID
        var isOn: Bool
        var timeDuration: TimeDuration.State
        var weekdays: SortedSet<Weekday>

        let selectedAppsGroupID: UUID
        var selectedApps: AppsSelection.State

        var isNew: Bool

        @Dependency(\.uuid) static var uuid

        init(
            id: UUID = uuid(),
            isOn: Bool = true,
            timeDuration: TimeDuration.State = .default,
            weekdays: SortedSet<Weekday> = .everyDay,
            selectedAppsGroupID: UUID = uuid(),
            selectedApps: AppsSelection.State = .init(isPresented: true)
        ) {
            self.id = id
            self.isOn = isOn
            self.timeDuration = timeDuration
            self.weekdays = weekdays
            self.selectedAppsGroupID = selectedAppsGroupID
            self.selectedApps = selectedApps
            isNew = true
        }
    }

    enum Action: Equatable {
        case toggleIsOn(Bool)
        case timeDuration(TimeDuration.Action)
        case weekday(WeekdayAction)
        case selectedApps(AppsSelection.Action)

        case deselect
        case editDone
        case delete
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
                return .none

            case .editDone:
                state.isNew = false
                /* 由于TimeIntervalPikcer和AppsPikcerButton，点击之后弹出框均为sheet方式，
                 当你正在TimeIntervalPikcer选择时间时，此时不小心点击AppsPikcerButton区域，
                 AppsPikcerButton的onTapGuesture会调用，selectedApps.isPresented就会变成true，
                 此时时间显示器会dismiss，但是AppsPikcer并不会present（因为此时时间选择器还是没有完全dismiss掉）
                 */
                state.selectedApps.isPresented = false
                return .none

            default:
                return .none
            }
        }

        Scope(state: \.timeDuration, action: /Action.timeDuration) {
            TimeDuration()
        }

        Scope(state: \.selectedApps, action: /Action.selectedApps) {
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
