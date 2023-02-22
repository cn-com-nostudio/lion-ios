// KeychainConfiguration.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/4.

import Foundation

struct KeychainConfiguration {
    let serviceName: String

    /*
         Specifying an access group to use with `KeychainPasswordItem` instances
         will create items shared accross both apps.

         For information on App ID prefixes, see:
             https://developer.apple.com/library/ios/documentation/General/Conceptual/DevPedia-CocoaCore/AppID.html
         and:
             https://developer.apple.com/library/ios/technotes/tn2311/_index.html
     */
//    static let accessGroup = "[YOUR APP ID PREFIX].com.example.apple-samplecode.GenericKeychainShared"

    /*
         Not specifying an access group to use with `KeychainPasswordItem` instances
         will create items specific to each app.
     */
    let accessGroup: String?

    init(serviceName: String, accessGroup: String? = nil) {
        self.serviceName = serviceName
        self.accessGroup = accessGroup
    }
}
