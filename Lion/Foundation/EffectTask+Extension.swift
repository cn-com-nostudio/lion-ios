// EffectTask+Extension.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture

extension EffectTask {
    static func fireAndForget(_ work: @escaping () throws -> Void, onlyWhen condiction: @autoclosure () -> Bool) -> Self {
        if condiction() {
            return .fireAndForget {
                try work()
            }
        } else {
            return .none
        }
    }
}
