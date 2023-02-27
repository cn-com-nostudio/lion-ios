// ModePreview.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import SwiftUI

struct ModePreview: View {
    let store: StoreOf<ModeSettings>
    let header: ModeHeader
    var action: () -> Void

    let cornerRadius: CGFloat = 32.0

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: .four) {
                VStack(spacing: .one) {
                    ModeHeaderView(model: header)
                        .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])

                    VStack(alignment: .leading, spacing: .one) {
                        HStack {
                            Text(LocalizedStringKey(viewStore.modeName))
                                .font(.lion.title1)
                                .foregroundColor(header.primaryColor)
                            Spacer()
                            Image(.threeDots)
                                .resizable()
                                .frame(width: 28, height: 28)
                        }
                        CheckListView(store: store)
                    }
                    .padding(.leading, 24)
                    .padding(.trailing, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(cornerRadius, corners: [.bottomLeft, .bottomRight])
                    .padding(.bottom, 20)
                }
                .background {
                    Color.white
                        .cornerRadius(cornerRadius)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(.white, lineWidth: 5)
                        .shadow(radius: 15, x: 0, y: 5.0)
                )

                Button {
                    action()
                } label: {
                    Group {
                        if viewStore.isSetting {
                            ProgressView()
                        } else {
                            Text(viewStore.isOn ? .close : .open)
                                .font(.lion.title3)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .font(.lion.title3)
                    .foregroundColor(viewStore.isOn ? .white : .black)
                    .background(viewStore.isOn ? Color.lion.blue : Color.lion.yellow)
                    .cornerRadius(16)
                }
                .frame(width: 230)
                .disabled(viewStore.isSetting)
            }
            .fullScreenCover(
                isPresented: viewStore.binding(
                    get: \.isPresented,
                    send: ModeSettings.Action.toggleIsPresented
                ),
                content: {
                    ModeSettingsView(
                        store: store,
                        header: ModeHeaders[viewStore.state]
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
            header: ModeHeaders[.child],
            action: {}
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("ModePreview")
        .environment(\.locale, .init(identifier: "zh_CN"))
        .padding(50)
        .aspectRatio(0.65, contentMode: .fit)
    }
}
