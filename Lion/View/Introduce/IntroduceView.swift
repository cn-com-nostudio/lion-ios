// IntroduceView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/20.

import ComposableArchitecture
import SwiftUI

struct Introduce: Identifiable {
    var id: String {
        backgroundColor.description
    }

    let image: Image
    let title1: LocalizedStringKey
    let title2: LocalizedStringKey
    let desc: LocalizedStringKey
    let backgroundColor: Color

    static let page1: Self = .init(
        image: Image(.introduce1),
        title1: .temporaryLoanOfMobilePhoneToOthers,
        title2: .preventPeepingPrivacy,
        desc: .turnOnTheHiddenApp,
        backgroundColor: Color(hex: 0xCDE1EB)
    )

    static let page2: Self = .init(
        image: Image(.introduce2),
        title1: .deleteTheAppByMistake,
        title2: .preventLossOfImportantData,
        desc: .turnOnTheProhibitionOfDeletingApps,
        backgroundColor: Color(hex: 0xD1EADE)
    )

    static let page3: Self = .init(
        image: Image(.introduce3),
        title1: .temporaryLoanOfMobilePhoneToChildren,
        title2: .preventGameAddiction,
        desc: .limitTheDurationOfGamesAndWatchingVideos,
        backgroundColor: Color(hex: 0xDBD5F4)
    )
}

struct IntroduceView: View {
    let store: StoreOf<Root>
    @State private var pageIndex: PagingView.PageIndex = 0
    @State private var isStartPageShow: Bool = true
    let introduces: [Introduce] = [
        .page1, .page2, .page3
    ]

    var indexIndicator: some View {
        HStack {
            ForEach(0 ..< 3) { index in
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundColor(pageIndex == index ? .lion.yellow : .lion.white)
            }
        }
    }

    var isLastPage: Bool {
        pageIndex == introduces.count - 1
    }

    func nextPage() {
        pageIndex += 1
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            if isStartPageShow == true {
                StartPage {
                    isStartPageShow = false
                }
            } else {
                ZStack(alignment: .bottom) {
                    PagingView(
                        page: $pageIndex
                    ) {
                        ForEach(introduces) { introduce in
                            IntroducePage(introduce: introduce)
                        }
                    }

                    HStack {
                        indexIndicator
                        Spacer()
                        Button {
                            if isLastPage {
                                viewStore.send(.toggleIsIntroduceRead(true))
                            } else {
                                nextPage()
                            }
                        } label: {
                            Text(isLastPage ? .start : .nextPage)
                                .frame(width: 126, height: 60)
                        }
                        .buttonStyle(PrimaryButton())
                    }
                    .padding(40)
                }
                .background(Color(.veryLightGreen))
            }
        }
    }
}

struct IntroduceView_Previews: PreviewProvider {
    static var previews: some View {
        IntroduceView(
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

struct IntroducePage: View {
    let introduce: Introduce

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            introduce.image
                .resizable()
                .frame(width: 390, height: 322)

            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading) {
                    Text(introduce.title1)
                    Text(introduce.title2)
                        .background(
                            Color.lion.yellow
                                .padding(.vertical, 4)
                                .padding(.horizontal, -4)
                                .offset(y: 5)
                        )
                }
                .foregroundColor(.lion.primary)
                .font(.lion.largeTitle)
                .lineLimit(1)

                Text(introduce.desc)
                    .foregroundColor(.lion.secondary)
                    .font(.lion.title3)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 40)

            Spacer()
        }
        .padding(.bottom, 60)
        .background {
            introduce.backgroundColor.ignoresSafeArea()
        }
    }
}

struct IntroducePage_Previews: PreviewProvider {
    static var previews: some View {
        IntroducePage(introduce: .page1)
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewDisplayName("\(Self.self)")
            .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
