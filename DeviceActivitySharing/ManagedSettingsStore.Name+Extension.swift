// ManagedSettingsStore.Name+Extension.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/1.

import ManagedSettings

// 共享变量
public extension ManagedSettingsStore.Name {
    static let shared: Self = .init("cn.com.nostudio.lion")
}

extension UserDefaults {
    static let shared: UserDefaults = .init(suiteName: "group.cn.com.nostudio.lion")!
}
