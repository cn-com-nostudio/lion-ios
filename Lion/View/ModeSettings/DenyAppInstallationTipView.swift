// DenyAppInstallationTipView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/3/4.

import SwiftUI

struct DenyAppInstallationTipView: View {
    var action: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Image(.appStore)
                .resizable()
                .frame(width: 88, height: 88)

            Spacer().frame(height: 24)

            Text(.afterTrunOnDenyAppInstallationAppstoreWillHide)
                .multilineTextAlignment(.center)
                .foregroundColor(.lion.primary)
                .font(.lion.title2)
                .lineSpacing(5)

            Spacer().frame(height: 42)

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

struct DenyAppInstallationTipView_Previews: PreviewProvider {
    static var previews: some View {
        DenyAppInstallationTipView(action: {})
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewDisplayName("\(Self.self)")
            .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
