// TestView.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/28.

import DeviceActivity
import FamilyControls
import SwiftUI

func startMonitoringSchedule(for id: Int) throws {
    let intervalStart = DateComponents(hour: 11, minute: 51)
    let intervalEnd = DateComponents(hour: 11, minute: 52)
    let schedule = DeviceActivitySchedule(intervalStart: intervalStart, intervalEnd: intervalEnd, repeats: true)
    let center = DeviceActivityCenter()
    let activity = DeviceActivityName(String(id))
    try center.startMonitoring(activity, during: schedule)
}

func stopMonitoringSchedule(for id: Int) throws {
    let center = DeviceActivityCenter()
    let activity = DeviceActivityName(String(id))
    center.stopMonitoring([activity])
}

struct ToggleView: View {
    @State var isOn: Bool = false
    var body: some View {
        VStack {
            Text("Hello world")
            Toggle("HI", isOn: $isOn)
                .onChange(of: isOn) { newValue in
                    if newValue {
                        try? startMonitoringSchedule(for: 123)
                    } else {
                        try? stopMonitoringSchedule(for: 123)
                    }
                }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewDisplayName("\(Self.self)")
            .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
