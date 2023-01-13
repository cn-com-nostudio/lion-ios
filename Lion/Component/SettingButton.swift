// SettingButton.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/1.

import SwiftUI

struct SettingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.callout.weight(.bold))
            .foregroundColor(.white)
            .background(.black.opacity(0.2))
            .cornerRadius(12)
    }
}

struct SettingButton_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        } label: {
            Text(.settings)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .buttonStyle(SettingButton())
        .frame(width: 160)
    }
}
