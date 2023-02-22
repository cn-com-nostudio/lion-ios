// MoreView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/1/28.

import ComposableArchitecture
import SwiftUI

struct MoreView: View {
    let store: StoreOf<Root>

    private var footer: some View {
        HStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(.appStoreReviews)
                        .font(.lion.headline)
                    Text(.giveUsAFiveStarComment)
                        .font(.lion.caption2)
                }
                .foregroundColor(.lion.white)

                Image(.fiveStar)
                    .resizable()
                    .frame(width: 105, height: 21)
            }
            Spacer()
            Image(.cat)
                .resizable()
                .frame(width: 126, height: 126)
        }
        .padding(.leading, 20)
        .padding(.trailing)
        .background(Color.lion.blue)
    }

    private func version(_ version: String, buildVersion: String) -> some View {
        VStack {
            Image(.hiddingCatEnglish)
                .resizable()
                .frame(width: 96, height: 17)
            Text(.version(version, buildVersion: buildVersion))
                .font(.lion.caption2)
                .foregroundColor(Color(hex: 0x9FADC9))
        }
    }

    private func headView(store: StoreOf<Member>) -> some View {
        WithViewStore(store) { viewStore in
            if viewStore.isMember {
                memberView()
            } else {
                toBeAMemberView(
                    store: store
                )
            }
        }
    }

    private func toBeAMemberView(store: StoreOf<Member>) -> some View {
        VStack(spacing: 36) {
            VStack(spacing: .half) {
                Image(.starts)
                    .resizable()
                    .frame(width: 134, height: 46)
                Text(.becomeSeniorMember)
                    .font(.lion.largeTitle)
                Text(.unlockAllFunctions)
                    .font(.lion.headline)
            }
            .foregroundColor(.lion.white)

            ProductsView(
                store: store
            )
        }
        .padding(.top, 20)
        .padding(.bottom, 36)
    }

    private func memberView() -> some View {
        ZStack(alignment: .bottom) {
            Image(.bigStar)
                .resizable()
                .frame(width: 184, height: 176)
            HStack {
                Image(systemIcon: .laurelLeading)
                    .resizable()
                    .frame(width: 25, height: 43)
                    .foregroundColor(.lion.yellow)
                Spacer()
                VStack(spacing: 4) {
                    Text(.lifetimeMember)
                        .font(.lion.title3)
                    Text(.thanksForYourSupport)
                        .font(.lion.caption2)
                }
                .foregroundColor(.lion.white)
                Spacer()
                Image(systemIcon: .laurelTrailing)
                    .resizable()
                    .frame(width: 25, height: 43)
                    .foregroundColor(.lion.yellow)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
            .background {
                Color.lion.white
                    .opacity(0.1)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.3), lineWidth: 2)
                            .shadow(radius: 12, x: 0, y: 4.0)
                    }
            }
            .cornerRadius(16)
            .padding(.bottom, -10)
        }
        .padding(.horizontal)
        .padding(.bottom, 36)
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack {
                ZStack(alignment: .topTrailing) {
                    ScrollView {
                        VStack(spacing: 20) {
                            headView(
                                store: store.scope(
                                    state: \.member,
                                    action: Root.Action.member
                                )
                            )
                            .padding(.top)
                            .frame(maxWidth: .infinity)
                            .background {
                                ZStack {
                                    Color(.darkBlue)
                                        .padding(.top, -500)

                                    LinearGradient(
                                        gradient: Gradient.blue,
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                }
                            }

                            MoreItemsView(
                                store: store.scope(
                                    state: \.passwordLock,
                                    action: Root.Action.passwordLock
                                )
                            )
                            .padding(.horizontal)

                            VStack(spacing: 45) {
                                footer
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        viewStore.send(.rateApp)
                                    }

                                version(
                                    viewStore.appInfo.version,
                                    buildVersion: viewStore.appInfo.buildVersion
                                )
                            }
                        }
                    }
                    .background(Color(.veryLightGreen))

                    CloseButton {
                        viewStore.send(.toggleIsMorePageShow(false))
                    }
                    .padding()
                }
            }
        }
    }
}

struct MoreItemsView: View {
    let store: StoreOf<PasswordLock>

    @State var showWebView = false

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: .one) {
                VStack(spacing: 0) {
                    NavigationLink {
                        WebView(url: MoreItem.quickHelp().link)
                            .navigationTitle(.quickHelp)
                    } label: {
                        MoreItemView(item: .quickHelp)
                    }

                    NavigationLink {
                        WebView(url: MoreItem.feedbacksAndSuggestions().link)
                            .navigationTitle(.feedbacksAndSuggestions)
                    } label: {
                        MoreItemView(item: .feedbacksAndSuggestions)
                    }
                }
                .cornerRadius(16)

                VStack(spacing: 0) {
                    NavigationLink {
                        PasswordLockView(
                            store: store
                        )
                    } label: {
                        MoreItemView(
                            item: .passwordLock,
                            subTitle: viewStore.isOn ? .alreadyTurnOn : .notTurnOnYet
                        )
                    }

                    NavigationLink {
                        WebView(url: MoreItem.userLisence().link)
                            .navigationTitle(.userLisence)
                    } label: {
                        MoreItemView(item: .userLisence)
                    }

                    NavigationLink {
                        WebView(url: MoreItem.privacyPolicy().link)
                            .navigationTitle(.privacyPolicy)
                    } label: {
                        MoreItemView(item: .privacyPolicy)
                    }
                }
                .cornerRadius(16)

                VStack(spacing: 0) {
                    NavigationLink {
                        WebView(url: MoreItem.shareToFriends().link)
                            .navigationTitle(.shareToFriends)
                    } label: {
                        MoreItemView(item: .shareToFriends)
                    }

                    NavigationLink {
                        WebView(url: MoreItem.specialThanks().link)
                            .navigationTitle(.specialThanks)
                    } label: {
                        MoreItemView(item: .specialThanks)
                    }
                }
                .cornerRadius(16)
            }
        }
    }
}

struct MoreItemView: View {
    let item: MoreItem
    let subTitle: LocalizedStringKey?

    init(item: MoreItem, subTitle: LocalizedStringKey? = nil) {
        self.item = item
        self.subTitle = subTitle
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Image(item().icon)
                    .resizable()
                    .frame(width: 28, height: 28)

                Text(item().title)
                    .font(.lion.headline)
                    .foregroundColor(.lion.primary)

                if item().isMemberItem {
                    Image(.pro)
                        .resizable()
                        .frame(width: 37, height: 16)
                }
                Spacer()
                if let subTitle {
                    Text(subTitle)
                        .font(.lion.caption1)
                        .foregroundColor(.secondary)
                }

                Image(systemIcon: .chevronForward)
                    .foregroundColor(.secondary)
            }
            .padding()

            Divider()
                .opacity(0.5)
                .padding(.horizontal)
        }
        .background(Color.white)
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView(
            store: Store(
                initialState: .default,
                reducer: Root()
            )
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
