// KeyboardNotifiable.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/9.

import Combine
import UIKit

protocol KeyboardNotifiable {
    var keyboardPublisher: AnyPublisher<KeyboardNotification, Never> { get }
}

enum KeyboardNotification {
    case willShow
    case willHide
    case didShow
    case didHide
}

extension KeyboardNotifiable {
    var keyboardPublisher: AnyPublisher<KeyboardNotification, Never> {
        Publishers.MergeMany(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in .willShow },

            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in .willHide },

            NotificationCenter.default
                .publisher(for: UIResponder.keyboardDidShowNotification)
                .map { _ in .didShow },

            NotificationCenter.default
                .publisher(for: UIResponder.keyboardDidHideNotification)
                .map { _ in .didHide }
        )
        .eraseToAnyPublisher()
    }
}
