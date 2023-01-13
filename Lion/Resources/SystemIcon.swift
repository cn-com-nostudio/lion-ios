// SystemIcon.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/2.

import SwiftUI

extension Image {
    init(systemIcon: SystemIcon) {
        self.init(systemName: systemIcon.name)
    }
}

enum SystemIcon: String, Codable {
    case checkmarkCircleFill
    case xmarkCircleFill
    case xmark

    case eyeSlashFill
    case trashSlashFill
    case hourglass
    case gamecontrollerFill
    case handRaisedFill
    case chevronForward

    var name: String {
        var result = ""
        rawValue.forEach { char in
            let num = char.unicodeScalars.map(\.value).last!
            let string = String(char)
            if num > 64, num < 91 {
                result += "."
                result += string.lowercased()
            } else {
                result += string
            }
        }
        return result
    }
}
