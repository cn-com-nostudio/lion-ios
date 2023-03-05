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
                Color.black
                    .opacity(0.2)
                    .blur(radius: 0.55)
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)
                    .overlay {
                        Image(systemIcon: .xmark)
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 16, height: 16)
                            .font(.lion.largeTitle)
                    }
            }
        )
    }
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CloseButton(action: {})
                .aspectRatio(0.975, contentMode: .fit)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue)
        .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}

struct ModeSettingsHeaderView: View {
    let header: ModeHeader
    let store: StoreOf<ModeSettings>

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack(alignment: .bottom) {
                Group {
                    header.primaryColor
                        .padding(.top, -500)
                    LinearGradient(
                        stops: header.gradient,
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    header.headImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, 58)
                }

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
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            viewStore.send(.willToggleIsOn(!viewStore.isOn))
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
                        stops: header.maskGradient,
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
                )
            )
            .aspectRatio(0.975, contentMode: .fit)
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
