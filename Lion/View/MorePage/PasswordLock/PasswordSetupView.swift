// PasswordSetupView.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/3.

import Combine
import ComposableArchitecture
import SwiftUI

struct PasswordSetupView: View {
    let store: StoreOf<PasswordSetup>

    @State private var newPassword: String = ""

    private func head(
        passwordLength: Int
    ) -> some View {
        VStack {
            Image(.passwordLogo)
                .resizable()
                .frame(width: 120, height: 120)
            Text(hasNewPasswordInputDone(passwordLength: passwordLength) ? .inputNewPasswordOnceAgain : .inputNewPassword)
                .font(.lion.body)
                .foregroundColor(.lion.secondary)
        }
    }

    func hasNewPasswordInputDone(passwordLength: Int) -> Bool {
        newPassword.count == passwordLength
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                Color(.veryLightGreen)
                    .ignoresSafeArea()

                PasscodeField(
                    maxDigits: viewStore.passwordLength,
                    action: { digits in
                        if hasNewPasswordInputDone(passwordLength: viewStore.passwordLength) {
                            let confirmNewPassword = digits.concat
                            if confirmNewPassword == newPassword {
                                viewStore.send(.updatePassword(newPassword))
                                return []
                            } else {
                                return [.reset, .shake]
                            }
                        } else {
                            newPassword = digits.concat
                            return .reset
                        }
                    },
                    label: { head(passwordLength: viewStore.passwordLength) }
                )
            }
        }
    }
}

struct PasswordSetupView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordSetupView(
            store: .init(
                initialState: .default,
                reducer: PasswordSetup()
            )
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        .previewDisplayName("\(Self.self)")
        .environment(\.locale, .init(identifier: "zh_CN"))
    }
}
