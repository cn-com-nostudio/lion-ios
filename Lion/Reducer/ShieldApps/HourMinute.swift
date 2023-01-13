// HourMinute.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/10.

import ComposableArchitecture
import Foundation

extension HourMinute.State {
    static let min: Self = .init(hour: 0, minute: 0)
    static let max: Self = .init(hour: 23, minute: 59)
}

struct HourMinute: ReducerProtocol {
    struct State: Equatable, Codable {
        var hour: Int {
            didSet {
                guard hour >= 0, hour <= 23 else {
                    preconditionFailure("hour must greater or equal to 0 and less than or equal to 23")
                }
            }
        }

        var minute: Int {
            didSet {
                guard minute >= 0, minute <= 60 else {
                    preconditionFailure("minute must greater or equal to 0 and less than or equal to 60")
                }
            }
        }

        var next: Self {
            if hour == 23, minute == 59 {
                return .max
            } else if minute == 59 {
                return .init(hour: hour + 1, minute: 0)
            } else {
                return .init(hour: hour + 1, minute: minute + 1)
            }
        }

        var previous: Self {
            if hour == 0, minute == 0 {
                return .min
            } else if minute == 0 {
                return .init(hour: hour - 1, minute: 59)
            } else {
                return .init(hour: hour - 1, minute: minute - 1)
            }
        }

        var display: String {
            String(format: "%02d:%02d", hour, minute)
        }

        func date(_ calendar: Calendar = .current) -> Date {
            let components = DateComponents(hour: hour, minute: minute)
            let date = calendar.date(from: components)
            return date!
        }
    }

    enum Action: Equatable {
        case update(Date)
    }

    @Dependency(\.calendar) var calendar

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .update(date):
            let components = calendar.dateComponents([.hour, .minute], from: date)
            if let hour = components.hour, let minute = components.minute {
                state.hour = hour
                state.minute = minute
            }
            return .none
        }
    }
}
