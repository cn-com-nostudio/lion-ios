// StartPage.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/27.

import ComposableArchitecture
import SwiftUI

struct StartPage: View {
    var action: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 45) {
                Spacer()
                Image(.cat)
                    .resizable()
                    .frame(width: 178, height: 178)
                Spacer()
                VStack {
                    Image(.hiddingCatYellow)
                        .resizable()
                        .frame(width: 110, height: 37)
                    Text(.protectYourPrivacyAndData)
                        .foregroundColor(.lion.white)
                        .font(.lion.title3)
                }

                VStack(spacing: 20) {
                    Button {
                        action()
                    } label: {
                        Text(.startNow)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                    }
                    .buttonStyle(PrimaryButton())

                    HStack {
                        Text(.clickToIndicateYourConsent)
                            .foregroundColor(.lion.white.opacity(0.5))
                        NavigationLink {
                            WebView(url: MoreItem.userLisence().link)
                                .navigationTitle(.userLisence)
                        } label: {
                            Text(.userLisence)
                                .foregroundColor(.lion.yellow)
                        }
                        Text(.and)
                            .foregroundColor(.lion.white.opacity(0.5))
                        NavigationLink {
                            WebView(url: MoreItem.privacyPolicy().link)
                                .navigationTitle(.privacyPolicy)
                        } label: {
                            Text(.privacyPolicy)
                                .foregroundColor(.lion.yellow)
                        }
                    }
                    .font(.caption2)
                }
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: 0x3775F6))
        }
    }
}

struct StartPage_Previews: PreviewProvider {
    static var previews: some View {
        StartPage(
            action: {}
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
