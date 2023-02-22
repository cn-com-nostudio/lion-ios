// ModeHeaderView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import SwiftUI

struct ModeHeaderView: View {
    @State var model: ModeHeader

    var body: some View {
        ZStack(alignment: .bottom) {
            model.primaryColor
                .padding(.top, -500)

            LinearGradient(
                gradient: model.gradient,
                startPoint: .top,
                endPoint: .bottom
            )

            model.headImage
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct ModeHeader_Previews: PreviewProvider {
    static var previews: some View {
        ModeHeaderView(
            model: ModeHeaders[.child]
        )
        .cornerRadius(16, corners: [.topLeft, .topRight])
        .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
        .previewDisplayName("ModeHeader")
        .environment(\.locale, .init(identifier: "zh_CN"))
        .padding(70)
        .aspectRatio(0.85, contentMode: .fit)
    }
}
