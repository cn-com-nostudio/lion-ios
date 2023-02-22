// PrimaryButton.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/1/28.

import SwiftUI

struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.lion.title3)
            .foregroundColor(.black)
            .background(Color.lion.yellow)
            .cornerRadius(16)
    }
}

struct PrimarySelectedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.lion.title3)
            .foregroundColor(.white)
            .background(Color.lion.blue)
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
        .buttonStyle(PrimarySelectedButton())
        .frame(width: 160)
    }
}
