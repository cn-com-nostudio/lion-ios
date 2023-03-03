// Date+Weekday.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/1.

import Foundation

public extension Date {
    func weekday(calendar: Calendar = .current) -> Weekday {
        let number = calendar.component(.weekday, from: self)
        let weekday = Weekday(rawValue: number)!
        return weekday
    }
}
