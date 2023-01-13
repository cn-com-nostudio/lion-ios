// FileManage.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2022/12/28.

import Foundation

extension Decodable {
    func readAsJSONString(from fileURL: URL,
                          using decoder: JSONDecoder = JSONDecoder(),
                          encoding: String.Encoding = .utf8)
        throws -> Self?
    {
        let string = try String(contentsOf: fileURL, encoding: .utf8)
        if let data = string.data(using: encoding) {
            let model = try decoder.decode(Self.self, from: data)
            return model
        } else {
            return nil
        }
    }
}

extension Encodable {
    func jsonString(using encoder: JSONEncoder = JSONEncoder(),
                    encoding: String.Encoding = .utf8)
        throws -> String?
    {
        let data = try encoder.encode(self)
        let string = String(data: data, encoding: encoding)
        return string
    }
}
