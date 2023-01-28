// ModeSettingsHeaderView.swift
// Copyright (c) 2023 Soda Studio
// Created by Jerry X T Wang on 2023/1/14.

import ComposableArchitecture
import SwiftUI

struct ModeSettingsHeaderView: View {
    let header: ModeHeader
    let store: StoreOf<ModeSettings>

    func closeButton(_ action: @escaping () -> Void) -> some View {
        Button(
            action: action,
            label: {
                Color.white
                    .opacity(0.08)
                    .blur(radius: 0.55)
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)
                    .overlay {
                        Image(systemIcon: .xmark)
                            .resizable()
                            .foregroundColor(.white.opacity(0.6))
                            .frame(width: 16, height: 16)
                    }
            }
        )
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack(alignment: .bottom) {
                ModeHeaderView(model: header)
                Color.clear.overlay(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 5) {
                        Spacer()
                        Text(header.modeTip)
                            .font(.lion.title3)
                            .foregroundColor(.white.opacity(0.5))
                        Text(header.modeName)
                            .font(.lion.largeTitle)
                            .foregroundColor(.white)
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                }.padding([.leading, .trailing], 32)
            }
            .overlay(alignment: .topTrailing) {
                closeButton {
                    viewStore.send(.toggleIsPresented(false))
                }
                .padding([.top, .trailing], 20)
            }
        }
    }
}

struct ModeSettingsHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ModeSettingsHeaderView(
                header: ModeHeaders[.child],
                store: Store(
                    initialState: .child,
                    reducer: ModeSettings()
                )
            )
            .aspectRatio(0.975, contentMode: .fit)
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
