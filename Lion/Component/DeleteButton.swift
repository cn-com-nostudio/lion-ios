// DeleteButton.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/7.

import SwiftUI

struct DeleteButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.body.weight(.bold))
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
            Text("删除")
                .frame(maxWidth: .infinity)
                .padding(.vertical)
        }
        .buttonStyle(DeleteButton())
        .frame(width: 160)
    }
}
