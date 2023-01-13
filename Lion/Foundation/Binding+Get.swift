// Binding+Get.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/8.

import SwiftUI

extension Binding {
    static func get(_ get: @escaping @autoclosure () -> Value) -> Binding<Value> {
        Binding(
            get: get,
            set: { _ in }
        )
    }
}

// extension Optional {
//    static func
// }
// extension Binding {
//    static func selected<T: Optional>() -> Binding<Value>
// }

// extension Binding {
//    static func toggle<T>(_ value: inout Optional<T>) -> Binding<Bool> {
//        Binding<Bool>(
//            get: { value != nil },
//            set: { isOn in
//                if isOn {
//                    value = nil
//                }
//            }
//        )
//    }
// }

// extension Optional {
//    mutating func toggle() -> Binding<Bool> {
//        Binding(get: { [self] in
//            self != nil
//        }, set: { [self] isOn in
//            if !isOn {
//                self = nil
//            }
//        })
//    }
// }
