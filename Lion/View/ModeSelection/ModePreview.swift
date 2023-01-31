// ModePreview.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/29.

import ComposableArchitecture
import SwiftUI

struct ModePreview: View {
    let store: StoreOf<ModeSettings>
    let header: ModeHeader

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    ModeHeaderView(model: header)
                        .cornerRadius(16, corners: [.topLeft, .topRight])
                        .frame(height: proxy.frame(in: .global).height / 362 * 220)

                    VStack(alignment: .leading) {
                        Spacer()
                        Text(LocalizedStringKey(viewStore.modeName))
                            .font(.lion.title1)
                            .foregroundColor(header.primaryColor)
                        Spacer()
                        CheckListView(store: store)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white, lineWidth: 5)
                    .shadow(radius: 5, x: 0, y: 3.0)
            )
            .fullScreenCover(
                isPresented: viewStore.binding(
                    get: \.isPresented,
                    send: ModeSettings.Action.toggleIsPresented
                ),
                content: {
                    ModeSettingsView(
                        store: store,
                        header: ModeHeaders[.child]
                    )
                }
            )
            .onTapGesture {
                viewStore.send(.toggleIsPresented(true))
            }
        }
    }
}

struct ModePreview_Previews: PreviewProvider {
    static var previews: some View {
        ModePreview(
            store: Store(
                initialState: ModeSettings.State.child,
                reducer: ModeSettings()
            ),
            header: ModeHeaders[.child]
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("ModePreview")
        .environment(\.locale, .init(identifier: "zh_CN"))
        .padding(50)
        .aspectRatio(0.8, contentMode: .fit)
    }
}
