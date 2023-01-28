// MoreView.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/28.

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
        VStack {
            Image(.starts)
                .resizable()
                .frame(width: 134, height: 46)
//            Text(.becomeSeniorMember)
//                .font(.lion)
        }
        .background(Image(.blue))
    }
}
