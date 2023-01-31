// PrimaryButton.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/29.

import SwiftUI

struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.lion.title3)
            .foregroundColor(.black)
            .background(Color(ColorSet.lightYellow))
            .cornerRadius(16)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        } label: {
            Text(.done)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
        }
        .buttonStyle(PrimaryButton())
        .frame(width: 160)
    }
}
