// DenyAppRemovalTipView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/4.

import SwiftUI

struct DenyAppRemovalTipView: View {
    var action: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(.placeholderApp)
                    .resizable()
                    .frame(width: 88, height: 88)
                Spacer()
                Image(.blankApp)
                    .resizable()
                    .frame(width: 88, height: 88)
                Spacer()
                Image(.placeholderApp)
                    .resizable()
                    .frame(width: 88, height: 88)
            }
            .padding(.horizontal, 40)

            VStack(spacing: 42) {
                VStack(spacing: 8) {
                    Text(.afterCancelDenyAppRemovalAppMayNotBackToTheOriginalPosition)
                        .foregroundColor(.lion.primary)
                        .font(.lion.title2)
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)

                    Text(.likeInstallingNewAppItWillAppearInBlankAreaOnScreen)
                        .foregroundColor(.lion.secondary)
                        .font(.lion.caption1)
                }

                Button {
                    action()
                } label: {
                    Text(.iGetIt)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                }
                .buttonStyle(PrimaryButton())
                .padding(.horizontal, 20)
            }
        }
    }
}

struct DenyAppRemovalTipView_Previews: PreviewProvider {
    static var previews: some View {
        DenyAppRemovalTipView(action: {})
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewDisplayName("\(Self.self)")
            .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
