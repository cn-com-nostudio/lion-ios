// Caching.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import Foundation

protocol Caching<T> {
    associatedtype T
    func save(_ value: T) throws
    func load() throws -> T?
}
