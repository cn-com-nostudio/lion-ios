// Caching.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2022/12/29.

import Foundation

protocol Caching<T> {
    associatedtype T
    func save(_ value: T) throws
    func load() throws -> T?
}
