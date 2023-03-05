// ProductPurchaseView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/14.

import ComposableArchitecture
import SwiftUI

struct ProductPurchaseView: View {
    let store: StoreOf<Products>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                ZStack(alignment: .topTrailing) {
                    VStack(spacing: 0) {
                        MemberIntorduceView()
                        footer.background {
                            LinearGradient(
                                gradient: Gradient.blue,
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .ignoresSafeArea()
                        }
                    }
                    closeButton {
                        viewStore.send(.toggleIsMemberPurchasePresented(false))
                    }
                    .padding(.trailing)
                }
            }
        }
    }

    private func closeButton(
        action: @escaping () -> Void) -> some View
    {
        Button(action: action) {
            Image(systemIcon: .xmarkCircleFill)
                .resizable()
                .foregroundColor(.lion.secondary)
                .frame(width: 40, height: 40)
                .opacity(0.2)
        }
    }

    private var footer: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 14) {
                ProductsView(store: store)

                HStack(spacing: 16) {
                    NavigationLink {
                        WebView(url: MoreItem.userLisence().link)
                            .navigationTitle(.userLisence)
                    } label: {
                        Text(.userLisence)
                    }

                    NavigationLink {
                        WebView(url: MoreItem.privacyPolicy().link)
                            .navigationTitle(.privacyPolicy)
                    } label: {
                        Text(.privacyPolicy)
                    }

                    Spacer()

                    Button {
                        viewStore.send(.syncMemberState)
                    } label: {
                        // TODO: Localized
                        Text("恢复购买")
                    }
                }
                .font(.lion.caption2)
                .foregroundColor(.lion.white)
                .padding(.horizontal, 20)
            }
            .padding(.top)
            .padding(.top)
        }
    }
}

struct ProductPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        ProductPurchaseView(
            store: Store(
                initialState: .default,
                reducer: Products()
            )
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}

struct MemberIntorduceView: View {
    func introduceItem() -> some View {
        VStack {
            Image(.childModeSwitch)
            Text(.childMode)
            Text(.childModeTip)
        }
    }

    private var checked: some View {
        Image(systemIcon: .checkmarkCircleFill)
            .resizable()
            .foregroundColor(.green)
            .frame(width: 16, height: 16)
    }

    var page1: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 20)

            VStack(alignment: .leading, spacing: 4) {
                Text(.becomeSeniorMember)
                Text(.fullProtectYourPrivacy)
                    .background(
                        Color.lion.yellow
                            .padding(.vertical, 4)
                            .padding(.horizontal, -8)
                            .offset(y: 5)
                    )
            }
            .padding(.leading)
            .font(.lion.largeTitle)

            Spacer()

            Grid(verticalSpacing: 25) {
                GridRow {
                    VStack {
                        Image(.childModeSwitch)
                            .resizable()
                            .frame(width: 90, height: 90)
                        Text(.childMode)
                        Text(.oneClickSwitch)
                    }
                    .frame(maxWidth: .infinity)
                    VStack {
                        Image(.loanModeSwitch)
                            .resizable()
                            .frame(width: 90, height: 90)
                        Text(.childMode)
                        Text(.oneClickSwitch)
                    }
                    .frame(maxWidth: .infinity)
                }
                GridRow {
                    VStack {
                        Image(.toggle)
                            .resizable()
                            .frame(width: 90, height: 90)
                        Text(.switchUlimitly)
                        Text(.hideAppsUnlimited)
                    }
                    .frame(maxWidth: .infinity)
                    VStack {
                        Image(.lock)
                            .resizable()
                            .frame(width: 90, height: 90)
                        Text(.passwordLock)
                        Text(.unlockUsingFaceID)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .foregroundColor(.lion.primary)
            .font(.lion.headline)

            Spacer()
        }
    }

    var page2: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 20)

            VStack(alignment: .leading, spacing: 4) {
                Text(.becomeSeniorMember)
                Text(.fullProtectYourPrivacy)
                    .background(
                        Color.lion.yellow
                            .padding(.vertical, 4)
                            .padding(.horizontal, -8)
                            .offset(y: 5)
                    )
            }
            .padding(.leading)
            .font(.lion.largeTitle)

            Spacer()

            Grid(alignment: .leading, verticalSpacing: 19) {
                GridRow {
                    Text("")
                    Text("基础版")
                        .font(.headline)
                        .gridColumnAlignment(.center)
                    Image(.pro)
                        .resizable()
                        .frame(width: 45, height: 20)
                        .gridColumnAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: 32)
                GridRow {
                    Text(.hideAppsUnlimited)
                        .foregroundColor(.lion.primary)
                    Text("限制 2 个")
                        .foregroundColor(.lion.secondary)
                    checked
                }
                GridRow {
                    Text(.switchUlimitly)
                        .foregroundColor(.lion.primary)
                    Text("限制 10 次")
                        .foregroundColor(.lion.secondary)
                    checked
                }
                GridRow {
                    Text(.denyAppInstallation)
                        .foregroundColor(.lion.primary)
                    Text("不支持")
                        .foregroundColor(.lion.secondary)
                    checked
                }
                GridRow {
                    Text(.denyAppRemoval)
                        .foregroundColor(.lion.primary)
                    checked
                    checked
                }
                GridRow {
                    Text(.shieldApps)
                        .foregroundColor(.lion.primary)
                    checked
                    checked
                }

                GridRow {
                    Text(.passwordLock)
                        .foregroundColor(.lion.primary)
                    Text("不支持")
                        .foregroundColor(.lion.secondary)
                    checked
                }
                GridRow {
                    Text(.childMode)
                        .foregroundColor(.lion.primary)
                    checked
                    checked
                }
                GridRow {
                    Text(.loanMode)
                        .foregroundColor(.lion.primary)
                    Text("不支持")
                        .foregroundColor(.lion.secondary)
                    checked
                }
            }
            .foregroundColor(.lion.primary)
            .font(.lion.caption2)
            .padding(.top, 16)
            .padding(.leading, 20)
            .padding(.bottom, 16)
            .background(Color.lion.white)
            .cornerRadius(16)

            Spacer()
        }
    }

    @State private var pageIndex: PagingView.PageIndex = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            PagingView(page: $pageIndex) {
                page1
                    .padding(.horizontal, 27)
                    .frame(maxHeight: .infinity)
                    .background(Color(hex: 0xF4EFDE))

                page2
                    .padding(.horizontal, 27)
                    .frame(maxHeight: .infinity)
                    .background(Color(hex: 0xCDE1EB))
            }
            .lineLimit(1)

            HStack {
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 50, height: 4)
                    .foregroundColor(.lion.white)
                    .opacity(pageIndex == 0 ? 1 : 0.5)
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 50, height: 4)
                    .foregroundColor(.lion.white)
                    .opacity(pageIndex == 1 ? 1 : 0.5)
            }
            .frame(height: 40)
        }
    }
}

struct MemberIntorduceView_Previews: PreviewProvider {
    static var previews: some View {
        MemberIntorduceView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewDisplayName("\(Self.self)")
            .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
