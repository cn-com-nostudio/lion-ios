// GrantAccessView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/21.

import ComposableArchitecture
import SwiftUI

struct GrantAccessView: View {
    let store: StoreOf<Root>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 50) {
                VStack(spacing: 60) {
                    VStack(spacing: 40) {
                        Image(.loading)
                            .resizable()
                            .frame(width: 148, height: 148)
                        Text(.allowAppToManageAccessLimit(appName: viewStore.appInfo.name))
                            .foregroundColor(.lion.primary)
                            .font(.lion.title1)
                            .multilineTextAlignment(.center)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(.checkYellow)
                                .resizable()
                                .frame(width: 21, height: 22)
                            Text(.useScreenTimeLimitToManageAccessLimit(appName: viewStore.appInfo.name))
                        }
                        HStack {
                            Image(.checkYellow)
                                .resizable()
                                .frame(width: 21, height: 22)
                            Text(.weRespectYourDataPrivacyAndSecurity)
                        }
                        HStack {
                            Image(.checkYellow)
                                .resizable()
                                .frame(width: 21, height: 22)
                            Text(.youCanCancelThisAuthorizationAtAnyTime)
                        }
                    }
                    .foregroundColor(.lion.secondary)
                    .font(.lion.caption2)
                    .padding()
                    .background(Color.lion.white)
                    .cornerRadius(12)
                }

                Button {
                    viewStore.send(.requestScreenTimeAccessPermission)
                } label: {
                    Text(.allowAccess)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                }
                .buttonStyle(PrimaryButton())
            }
            .padding(.horizontal, 20)
            .frame(maxHeight: .infinity)
            .background(Image(.background))
        }
    }
}

struct GrantAccessView_Previews: PreviewProvider {
    static var previews: some View {
        GrantAccessView(
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
