// PasswordLockView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/2.

import ComposableArchitecture
import SwiftUI

struct PasswordLockView: View {
    let store: StoreOf<PasswordLock>

    @Environment(\.presentationMode) var presentation

    private var header: some View {
        VStack {
            Image(.password)
                .resizable()
                .frame(width: 230, height: 230)
            Text(.passwordLock)
                .font(.lion.title2)
        }
    }

    private func passwordLockToggle(isOn: Binding<Bool>) -> some View {
        HStack {
            Text(.passwordLock)
                .font(.lion.headline)
            Toggle(
                "",
                isOn: isOn
            )
            .hapticFeedback(style: .light)
        }
    }

    private func faceIDToggle(isOn: Binding<Bool>) -> some View {
        HStack {
            Text(.useFaceIDToUnlock)
                .font(.lion.headline)
            Toggle(
                "",
                isOn: isOn
            )
            .hapticFeedback(style: .light)
        }
    }

    func resetPasswordRow(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(.resetPassword)
                    .font(.lion.headline)
                Spacer()
                Image(systemIcon: .chevronForward)
                    .foregroundColor(.lion.secondary)
            }
        }
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                Color(.veryLightGreen)
                    .ignoresSafeArea()
                VStack(spacing: 50) {
                    header
                    VStack(spacing: .one) {
                        VStack(spacing: .one) {
                            passwordLockToggle(
                                isOn: viewStore.binding(
                                    get: \.isOn,
                                    send: PasswordLock.Action.toggleIsOn
                                )
                            )
                            .padding(.horizontal)
                        }
                        .padding(.vertical, .one)
                        .background(Color.white)
                        .cornerRadius(.one)

                        VStack {
                            if viewStore.isFaceIDSupported {
                                faceIDToggle(
                                    isOn: viewStore.binding(
                                        get: \.useFaceID,
                                        send: PasswordLock.Action.toggleUseFaceID
                                    )
                                )
                                Divider()
                                    .opacity(0.5)
                            }
                            resetPasswordRow(action: {
                                viewStore.send(.toggleIsPasswordSetupPresented(true))
                            })
                            .padding(.vertical, 5)
                        }
                        .padding()
                        .opacity(viewStore.isOn ? 1 : 0.3)
                        .background(Color.white)
                        .cornerRadius(.one)
                        .disabled(!viewStore.isOn)
                    }
                    Spacer()
                }
                .foregroundColor(.lion.primary)
                .padding()
                .animation(.easeInOut, value: viewStore.state)
                .fullScreenCover(
                    isPresented:
                    viewStore.binding(
                        get: \.isPasswordSetupPresented,
                        send: PasswordLock.Action.toggleIsPasswordSetupPresented
                    )
                ) {
                    PasswordSetupView(
                        store: store.scope(
                            state: \.password,
                            action: PasswordLock.Action.password
                        )
                    )
                }
                .alert(
                    store.scope(state: \.alert),
                    dismiss: PasswordLock.Action.dismissAlert
                )
            }
//            .navigationBarBackButtonHidden(true)
//            .navigationBarItems(leading:
//                Button(action: {
//                    presentation.wrappedValue.dismiss()
//                }) {
//                    Image(systemName: "arrow.left")
//                        .imageScale(.large)
//                        .foregroundColor(.lion.secondary)
//                }
//            )
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

struct PasswordLockView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordLockView(
            store: .init(
                initialState: .default,
                reducer: PasswordLock()
            )
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
