// PasswordUnlockView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/4.

import ComposableArchitecture
import SwiftUI

struct PasswordUnlockView: View {
    let store: StoreOf<PasswordLock>
    @State private var isPasswordWrong: Bool = false

    @Dependency(\.biometricHelper) var biometricHelper

    private func head() -> some View {
        VStack {
            Image(.passwordLogo)
                .resizable()
                .frame(width: 120, height: 120)
            Spacer()
                .frame(height: .two)
            Text(isPasswordWrong ? .wrongPassword : .inputPasswordToUnlock)
                .font(.lion.body)
                .foregroundColor(isPasswordWrong ? .lion.error : .lion.secondary)
        }
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                Color(.veryLightGreen)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    PasscodeField(
                        input: viewStore.binding(
                            get: \.biometricPassword,
                            send: { _ in .none }
                        ),
                        maxDigits: viewStore.password.passwordLength,
                        submit: { digits in
                            if digits.concat == viewStore.password() {
                                viewStore.send(.toggleIsPasswordUnlockPresented(false))
                                return []
                            } else {
                                isPasswordWrong = true
                                return [.shake(delay: 0), .reset(delay: 0.3)]
                            }
                        },
                        label: { head() }
                    )
                    Spacer()

                    if biometricHelper.isFaceIDSupported(), viewStore.useFaceID, !isPasswordWrong {
                        Button {
                            viewStore.send(.readBiometricPassword)
                        } label: {
                            Image(systemIcon: .faceid)
                                .resizable()
                                .foregroundColor(.lion.secondary)
                                .frame(width: .two, height: .two)
                        }
                        Spacer()
                            .frame(height: .four)
                    }
                }
            }
            .alert(
                store.scope(state: \.alert),
                dismiss: PasswordLock.Action.dismissAlert
            )
            .onAppear {
                if viewStore.useFaceID {
                    viewStore.send(.readBiometricPassword)
                }
            }
        }
    }
}

struct PasswordUnlockView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordUnlockView(
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
