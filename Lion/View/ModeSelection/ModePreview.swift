// ModePreview.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/22.

import ComposableArchitecture
import SwiftUI

struct ModePreview: View {
    let root: StoreOf<Root>
    let store: StoreOf<ModeSettings>
    let header: ModeHeader

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .hAlignment)) {
                ModePreviewWithoutImage(
                    store: store,
                    header: header
                )
                .frame(height: 375)

                header.headImage
                    .resizable()
                    .frame(width: 292, height: 246)
            }
            .onTapGesture {
                viewStore.send(.toggleIsPresented(true))
            }
            .fullScreenCover(
                isPresented: viewStore.binding(
                    get: \.isPresented,
                    send: ModeSettings.Action.toggleIsPresented
                ),
                content: {
                    WithViewStore(root) { rootStore in
                        ModeSettingsView(
                            store: store,
                            header: ModeHeaders[viewStore.state]
                        )
                        .fullScreenCover(
                            isPresented: rootStore.binding(
                                get: \.products.isMemberPurchasePresented,
                                send: { .products(.toggleIsMemberPurchasePresented($0)) }
                            )
                        ) {
                            ProductPurchaseView(
                                store: root.scope(
                                    state: \.products,
                                    action: Root.Action.products
                                )
                            )
                        }
                    }
                }
            )
        }
    }
}

struct ModePreviewWithoutImage: View {
    let store: StoreOf<ModeSettings>
    let header: ModeHeader

    private let cornerRadius: CGFloat = 32.0

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                LinearGradient(
                    stops: header.gradient,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .alignmentGuide(.hAlignment) { dim in
                    dim[.bottom]
                }

                VStack(alignment: .leading, spacing: .one) {
                    HStack {
                        Text(LocalizedStringKey(viewStore.mode.name))
                            .font(.lion.title1)
                            .foregroundColor(header.primaryColor)
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
                                        .font(.lion.title3)
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
                    CheckListView(store: store)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Color.lion.white)
            .cornerRadius(cornerRadius)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.white, lineWidth: 5)
                    .shadow(radius: 15, x: 0, y: 5.0)
            )
        }
    }
}

struct ModePreview_Previews: PreviewProvider {
    static var previews: some View {
        ModePreview(
            root: Store(
                initialState: .default,
                reducer: Root()
            ),
            store: Store(
                initialState: ModeSettings.State.child,
                reducer: ModeSettings()
            ),
            header: ModeHeaders[.child]
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("ModePreview")
        .environment(\.locale, .init(identifier: "zh_CN"))
        .padding(.horizontal, 50)
        .frame(height: 500)
    }
}
