// WeekDay.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/29.

import Foundation

@frozen enum Weekday: Int, Equatable, Hashable, Comparable, Codable, CaseIterable, Identifiable {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday

    var id: Int {
        rawValue
    }

    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    func shortWeekdaySymbols(
        dateFormatter: DateFormatter = .init()
    ) -> String {
        dateFormatter.shortWeekdaySymbols[rawValue - 1]
    }

    func veryShortWeekdaySymbols(
        dateFormatter: DateFormatter = .init()
    ) -> String {
        dateFormatter.veryShortWeekdaySymbols[rawValue - 1]
    }
}

extension SortedSet where Element == Weekday {
    static var workdays: SortedSet<Weekday> = [.monday, .tuesday, .wednesday, .thursday, .friday]
    static let weekend: SortedSet<Weekday> = [.saturday, .sunday]
}
