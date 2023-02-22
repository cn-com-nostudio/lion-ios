// KeychainPasswordItem.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/4.

import Foundation
import LocalAuthentication

struct LocalAuthStrategy {
    let accessControl: SecAccessControl?
    let authContext: LAContext?

    init(
        accessControl: SecAccessControl? = .biometryAny,
        authContext: LAContext? = nil
    ) {
        self.accessControl = accessControl
        self.authContext = authContext
    }
}

extension LocalAuthStrategy {
    static let `default`: Self = .init(authContext: BiometricIDAuth.shared.context)
}

struct KeychainPasswordItem {
    // MARK: Types

    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError(status: OSStatus)
    }

    // MARK: Properties

    let service: String

    private(set) var account: String

    let accessGroup: String?

    // MARK: Intialization

    init(service: String, account: String, accessGroup: String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }

    // MARK: Keychain access

    func readPassword() throws -> String {
        /*
             Build a query to find the item that matches the service, account and
             access group.
         */
        var query = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue

        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }

        // Parse the password string from the query result.
        guard let existingItem = queryResult as? [String: Any],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: String.Encoding.utf8)
        else {
            throw KeychainError.unexpectedPasswordData
        }

        return password
    }

    func savePassword(_ password: String) throws {
        // Encode the password into an Data object.
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        try addOrUpdateData(encodedPassword)
    }

    private func addData(_ data: Data) throws {
        var newItem = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        newItem[kSecValueData as String] = data

        // Add a the new item to the keychain.
        let status = SecItemAdd(newItem as CFDictionary, nil)

        // Throw an error if an unexpected status was returned.
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
    }

    private func addOrUpdateData(_ data: Data) throws {
        // Update the existing item with the new password.
        var attributesToUpdate = [String: Any]()
        attributesToUpdate[kSecValueData as String] = data

        let query = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

        if status == errSecItemNotFound {
            return try addData(data)
        }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
    }

    mutating func renameAccount(_ newAccountName: String) throws {
        // Try to update an existing item with the new account name.
        var attributesToUpdate = [String: Any]()
        attributesToUpdate[kSecAttrAccount as String] = newAccountName

        let query = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }

        account = newAccountName
    }

    func deleteItem() throws {
        // Delete the existing item from the keychain.
        let query = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)

        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }

    static func passwordItems(forService service: String, accessGroup: String? = nil) throws -> [KeychainPasswordItem] {
        // Build a query for all items that match the service and access group.
        var query = KeychainPasswordItem.keychainQuery(withService: service, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanFalse

        // Fetch matching items from the keychain.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        // If no items were found, return an empty array.
        guard status != errSecItemNotFound else { return [] }

        // Throw an error if an unexpected status was returned.
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }

        // Cast the query result to an array of dictionaries.
        guard let resultData = queryResult as? [[String: Any]] else { throw KeychainError.unexpectedItemData }

        // Create a `KeychainPasswordItem` for each dictionary in the query result.
        var passwordItems = [KeychainPasswordItem]()
        for result in resultData {
            guard let account = result[kSecAttrAccount as String] as? String else { throw KeychainError.unexpectedItemData }

            let passwordItem = KeychainPasswordItem(service: service, account: account, accessGroup: accessGroup)
            passwordItems.append(passwordItem)
        }

        return passwordItems
    }

    // MARK: Convenience

    private static func keychainQuery(
        withService service: String,
        account: String? = nil,
        accessGroup: String? = nil,
        authStategy: LocalAuthStrategy? = authStrategy
    ) -> [String: Any] {
        var query = [String: Any]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service

        if let account {
            query[kSecAttrAccount as String] = account
        }

        if let accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }

        if let accessControl = authStrategy.accessControl {
            query[kSecAttrAccessControl as String] = accessControl
        }

        if let authContext = authStategy?.authContext {
            query[kSecUseAuthenticationContext as String] = authContext
        }

        return query
    }

    static var authStrategy: LocalAuthStrategy = .default
}

extension SecAccessControl {
    static let biometryAny = SecAccessControlCreateWithFlags(
        nil,
        kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
        .biometryAny,
        nil
    )
}
