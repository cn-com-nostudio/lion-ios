// ShieldConfigurationExtension.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/28.

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
//        ShieldConfiguration()
        ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.systemThickMaterial,
            backgroundColor: UIColor.orange,

            icon: nil,

            title: ShieldConfiguration.Label(
                text: "Chores",
                color: UIColor.orange
            ),

            subtitle: .init(
                text: "Sorry, you can't use \(application.localizedDisplayName ?? "this app") because you haven't finished all of your chores.",
                color: UIColor.label
            ),

            primaryButtonLabel: .init(
                text: "Leave App",
                color: UIColor.white
            ),
            primaryButtonBackgroundColor: .orange
        )
    }

    override func configuration(shielding application: Application, in _: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.systemThickMaterial,
            backgroundColor: UIColor.orange,

            icon: nil,

            title: ShieldConfiguration.Label(
                text: "Chores",
                color: UIColor.orange
            ),

            subtitle: .init(
                text: "Sorry, you can't use \(application.localizedDisplayName ?? "this app") because you haven't finished all of your chores.",
                color: UIColor.label
            ),

            primaryButtonLabel: .init(
                text: "Leave App",
                color: UIColor.white
            ),
            primaryButtonBackgroundColor: .orange
        )
    }

    override func configuration(shielding _: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        ShieldConfiguration()
    }

    override func configuration(shielding _: WebDomain, in _: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        ShieldConfiguration()
    }
}
