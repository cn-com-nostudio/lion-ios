// ManagedSettingsStore.Name+Extension.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/1.

import DeviceActivity
import ManagedSettings

// 共享变量
public extension ManagedSettingsStore.Name {
    static let shared: Self = .init("cn.com.nostudio.lion")
}

extension ManagedSettingsStore.Name {
    static func store(of activity: DeviceActivityName) -> Self {
        .init("cn.com.nostudio.lion" + "." + activity.rawValue)
    }
}

public extension ManagedSettingsStore {
    static func store(of activity: DeviceActivityName) -> ManagedSettingsStore {
        ManagedSettingsStore(named: .store(of: activity))
    }
}
