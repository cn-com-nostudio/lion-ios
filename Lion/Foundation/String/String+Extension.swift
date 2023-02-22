// String+Extension.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/1/28.

//
// import Foundation
//
// extension String {
//    private var camelName: String {
//        var result = ""
//        var flag = false
////        forEach { c in
//            let s = String(c)
//            if s == "_" {
//                flag = true
//            } else {
//                if flag {
//                    result += s.uppercased()
//                    flag = false
//                } else {
//                    result += s
//                }
//            }
//        }
//        return result
//    }
//
//    private var underscoreName: String {
//        var result = ""
//        forEach { c in
//            let num = c.unicodeScalars.map(\.value).last!
//            let s = String(c)
//            if num > 64, num < 91 {
//                result += "_"
//                result += s.lowercased()
//            } else {
//                result += s
//            }
//        }
//        return result
//    }
// }
