// ModeSettingsHeaderView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import SwiftUI

struct CloseButton: View {
    let action: () -> Void

    var body: some View {
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
}

struct ModeSettingsHeaderView: View {
    let header: ModeHeader
    let store: StoreOf<ModeSettings>
    var action: () -> Void

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack(alignment: .bottom) {
                ModeHeaderView(model: header)

                VStack(alignment: .leading, spacing: 0) {
                    Text(header.modeTip)
                        .font(.lion.title3)
                        .foregroundColor(.white.opacity(0.5))

                    HStack {
                        Text(header.modeName)
                            .font(.lion.largeTitle)
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            action()
                        } label: {
                            Group {
                                if viewStore.isSetting {
                                    ProgressView()
                                } else {
                                    Text(viewStore.isOn ? .close : .open)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .font(.lion.title3)
                            .foregroundColor(viewStore.isOn ? .white : .black)
                            .background(viewStore.isOn ? Color.lion.blue : Color.lion.yellow)
                            .cornerRadius(16)
                        }
                        .frame(width: 126)
                        .disabled(viewStore.isSetting)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.top, 56)
                .padding(.bottom, 30)
                .background {
                    LinearGradient(
                        gradient: header.maskGradient,
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
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
                ),
                action: {}
            )
            .aspectRatio(0.975, contentMode: .fit)
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
