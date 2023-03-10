// DeleteButton.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import SwiftUI

struct DeleteButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.lion.title3)
            .foregroundColor(.red)
            .background(Color(.white))
            .cornerRadius(16)
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        } label: {
            Text(.delete)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
        }
        .buttonStyle(DeleteButton())
        .frame(width: 160)
    }
}
