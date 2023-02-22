// MoreView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import SwiftUI

struct MoreView: View {
    var body: some View {
        VStack {
            MoreHeader()
        }
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewDisplayName("\(Self.self)")
            .environment(\.locale, .init(identifier: "zh_CN"))
    }
}

struct MoreHeader: View {
    var body: some View {
        VStack(spacing: .half) {
            Image(.starts)
                .resizable()
                .frame(width: 134, height: 46)
            Text(.becomeSeniorMember)
                .font(.lion.largeTitle)
            Text(.unlockAllFunctions)
                .font(.lion.headline)

            Button {} label: {
                VStack {
                    VStack(spacing: 0) {
                        Text(.twelveMonths)
                            .font(.lion.caption1)
                        HStack(alignment: .firstTextBaseline, spacing: .quarter) {
                            Text("¥")
                                .font(.lion.title3)
                            Text("38")
                                .font(.lion.largeTitle)
                        }
                    }
                    Text(.twoCupsOfCoffee)
                        .font(.lion.caption2)
                }
                .padding(.horizontal, .four)
                .padding(.vertical)
                .buttonBorderShape(
                    .roundedRectangle(radius: .one)
                )
            }
        }
        .foregroundColor(.lion.white)
        .background(Image(.blue))
    }
}
