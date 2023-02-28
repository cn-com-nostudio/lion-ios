// ShieldConfigurationExtension.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/24.

import ManagedSettings
import ManagedSettingsUI
import SwiftUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding _: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
//        ShieldConfiguration()
        ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.systemMaterialDark,
            backgroundColor: .clear, // UIColor(Color(hex: 0xEFF4F9)),

            icon: UIImage(named: "cat"),

            title: ShieldConfiguration.Label(
                text: "放下手机 \n 自己才是生活的主角",
                color: UIColor.black
            ),

            subtitle: .init(
                text: "今天玩手机的时间到啦",
                color: UIColor(Color(hex: 0x191A1C))
            ),

            primaryButtonLabel: .init(
                text: "好的",
                color: .black
            ),
            primaryButtonBackgroundColor: UIColor(Color(hex: 0xFFD836))
        )
    }

    override func configuration(shielding _: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        ShieldConfiguration()
    }
}
