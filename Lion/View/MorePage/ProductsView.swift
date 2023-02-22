// ProductsView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/15.

import AlertToast
import ComposableArchitecture
import SwiftUI

struct ProductsView: View {
    enum SelectedProduct: Equatable {
        case yearlymember
        case lifetimeMember
    }

    let store: StoreOf<Member>

    @State private var selected: SelectedProduct = .lifetimeMember
    @State private var isProductPurchasePresented: Bool = false

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 20) {
                HStack(spacing: .half) {
                    InAppPurchaseProductView(
                        store: store.scope(
                            state: \.yearlyMember,
                            action: Member.Action.yearlyMember
                        ),
                        displayName: .twelveMonths,
                        description: .twoCupsOfCoffee,
                        isSelected: selected == .yearlymember,
                        action: {
                            selected = .yearlymember
                        }
                    )
                    ZStack(alignment: .top) {
                        InAppPurchaseProductView(
                            store: store.scope(
                                state: \.lifetimeMember,
                                action: Member.Action.lifetimeMember
                            ),
                            displayName: .lifetimeMember,
                            description: .payOnceAvailableForLife,
                            isSelected: selected == .lifetimeMember,
                            action: {
                                selected = .lifetimeMember
                            }
                        )
                        Image(.discount)
                            .resizable()
                            .frame(width: 92, height: 22)
                            .padding(.top, -11)
                    }
                }

                Button {
                    if selected == .lifetimeMember {
                        viewStore.send(.lifetimeMember(.purchase))
                    } else {
                        viewStore.send(.yearlyMember(.purchase))
                    }

                } label: {
                    if selected == .lifetimeMember {
                        Text(.unlockImmediately)
                            .frame(width: 352, height: 60)
                    } else {
                        Text(.subscribeImmediately)
                            .frame(width: 352, height: 60)
                    }
                }
                .buttonStyle(PrimaryButton())
                .opacity(viewStore.isPurchasing ? 0.3 : 1.0)
                .disabled(viewStore.isPurchasing)
            }
            .foregroundColor(.lion.white)
            .toast(isPresenting: viewStore.binding(
                get: \.isPurchasing,
                send: { _ in .none }
            ), alert: {
                AlertToast(type: .loading)
            })
        }
    }
}

struct InAppPurchaseProductView: View {
    let store: StoreOf<InAppPurchaseProduct>
    let displayName: LocalizedStringKey
    let description: LocalizedStringKey
    let isSelected: Bool
    var action: () -> Void

    var body: some View {
        WithViewStore(store) { viewStore in
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.lion.yellow : Color.lion.lightWhite, lineWidth: 3)
                .frame(width: 172, height: 100)
                .background {
                    if viewStore.isLoading {
                        ProgressView()
                    } else {
                        Button(action: action) {
                            VStack {
                                VStack(spacing: 0) {
                                    Text(displayName)
                                        .font(.lion.caption1Bold)
                                    HStack(alignment: .firstTextBaseline, spacing: .quarter) {
                                        Text(.currencySymbol)
                                            .font(.lion.title3)
                                        Text(viewStore.displayPrice)
                                            .font(.lion.largeTitle)
                                            .lineLimit(1)
                                    }
                                }
                                .foregroundColor(isSelected ? Color.lion.yellow : Color.lion.white)
                                Text(description)
                                    .font(.lion.caption2)
                            }
                        }
                    }
                }
//                .toast(isPresenting: viewStore.binding(
//                    get: \.isPurchasing,
//                    send: { _ in .none }
//                ), alert: {
//                    AlertToast(type: .loading)
//                })
                .onAppear {
                    viewStore.send(.loadProduct)
                    viewStore.send(.syncPurchaseStateIfNeeded)
                }
        }
    }
}
