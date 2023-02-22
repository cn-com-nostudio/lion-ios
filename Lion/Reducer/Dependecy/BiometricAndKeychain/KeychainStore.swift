// KeychainStore.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/4.

import Foundation

typealias Password = String
typealias Account = String

struct KeychainStore {
    let configuration: KeychainConfiguration

    func savePassword(_ password: Password, forAccount account: Account) throws {
        print("savePassword Once")
        let passwordItem = KeychainPasswordItem(
            service: configuration.serviceName,
            account: account,
            accessGroup: configuration.accessGroup
        )
        try passwordItem.savePassword(password)
    }

    func readPassword(forAccount account: Account) throws -> Password {
        print("readPassword Once")
        let passwordItem = KeychainPasswordItem(
            service: configuration.serviceName,
            account: account,
            accessGroup: configuration.accessGroup
        )
        return try passwordItem.readPassword()
    }

    func removeAccount(_ account: Account) throws {
        let passwordItem = KeychainPasswordItem(
            service: configuration.serviceName,
            account: account,
            accessGroup: configuration.accessGroup
        )
        try passwordItem.deleteItem()
    }
}
