// CachingReducer.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2022/12/29.

import ComposableArchitecture

extension ReducerProtocol where State: Codable {
    func caching(
        using cache: some Caching<State>,
        ignoreCachingDuplicates isDuplicate: ((State, State) -> Bool)? = nil
    ) -> some ReducerProtocol<State, Action> {
        Reduce.init { state, action in
            let previousState = state
            let effects = reduce(into: &state, action: action)
            let nextState = state

            if isDuplicate?(previousState, nextState) == true {
                return effects
            }

            return .merge(
                .fireAndForget {
                    try cache.save(nextState)
                },
                effects
            )
        }
    }
}

extension ReducerProtocol where State: Codable & Equatable {
    func caching(
        using cache: some Caching<State>
    ) -> some ReducerProtocol<State, Action> {
        caching(using: cache, ignoreCachingDuplicates: ==)
    }
}
