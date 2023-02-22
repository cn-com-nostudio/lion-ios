// PasswordField.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/3.

import SwiftUI

struct PostActions: OptionSet {
    let rawValue: Int
}

extension PostActions {
    static let reset: Self = .init(rawValue: 1 << 0)
    static let shake: Self = .init(rawValue: 1 << 1)
}

struct PasscodeField<Label>: View, KeyboardNotifiable where Label: View {
    private let maxDigits: Int
    private let action: (DigitGroup) -> PostActions
    private let label: () -> Label

    init(
        input: Binding<String> = .constant(""),
        maxDigits: Int = 4,
        action: @escaping (DigitGroup) -> PostActions,
        @ViewBuilder label: @escaping () -> Label
    ) {
        _input = input
        self.maxDigits = maxDigits
        self.action = action

        self.label = label
        pin = .blank(upTo: maxDigits)
    }

    @Binding private var input: String
    @State private var pin: DigitGroup
    @State private var hidesPin: Bool = true
    @State private var disableHighlight: Bool = true
    @FocusState private var isFocused: Bool
    @State private var attempts: Int = 0
    @State private var isAttemptsAnimating: Bool = false

    public var body: some View {
        VStack(spacing: 20) {
            label()
            ZStack {
                pinDots
                    .modifier(Shake(animatableData: CGFloat(attempts)))
                    .animationObserver(
                        for: CGFloat(attempts),
                        onChanged: { _ in isAttemptsAnimating = true },
                        onCompleted: { isAttemptsAnimating = false }
                    )
                    .animation(.easeInOut, value: attempts)
                backgroundField
                    .focused($isFocused)
            }
            .fixedSize(horizontal: true, vertical: true)
        }
        .onChange(of: input, perform: { newValue in
            pin = .init(digits: Array(newValue), upTo: maxDigits)
            if newValue.count == maxDigits {
                submitPin()
            }
        })
        .onReceive(keyboardPublisher, perform: { notification in
            if notification == .didHide {
                submitPin()
            }
        })
        .onAppear {
            isFocused = true
        }
    }

    private var pinDots: some View {
        PinGroup(digitGroup: $pin, isHidden: $hidesPin, disableHighlight: $disableHighlight, style: .pin)
    }

    private var backgroundField: some View {
        let boundPin = Binding<String>(
            get: { pin.concat },
            set: { newValue in
                guard newValue != pin.concat else { return }
                guard !isAttemptsAnimating else { return }
                pin = .init(digits: newValue.map { $0 }, upTo: maxDigits)

                if newValue.count == maxDigits {
                    submitPin()
                }
            }
        )

        return TextField("", text: boundPin, onCommit: submitPin)
            .accentColor(.clear)
            .foregroundColor(.clear)
            .keyboardType(.numberPad)
            .textFieldStyle(.plain)
            .disableAutocorrection(true)
            .onTapGesture {
                disableHighlight = false
            }
    }

    private var showPinStack: some View {
        HStack {
            Spacer()
            if !pin.isEmpty {
                showPinButton
            }
        }
        .frame(height: 20)
        .padding(.trailing)
    }

    private var showPinButton: some View {
        Button {
            hidesPin.toggle()
        } label: {
            hidesPin ? Image(systemName: "eye.slash.fill") : Image(systemName: "eye.fill")
        }
    }

    private func submitPin() {
        guard !pin.isEmpty else {
            hidesPin = true
            return
        }
        let deadline: DispatchTime = .now() + 0.4
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            let postActions = action(pin)
            excutePostActions(postActions)
        }
    }

    private func excutePostActions(_ actions: PostActions) {
        if actions.contains(.shake) {
            shake()
        }

        let deadline: DispatchTime = .now() + (actions.contains(.shake) ? 0.4 : 0)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            if actions.contains(.reset) {
                reset()
            }
        }
    }

    private func reset() {
        pin = .blank(upTo: maxDigits)
    }

    private func shake() {
        attempts += 1
    }
}

extension PasscodeField where Label == Text {
    init(
        _ title: some StringProtocol,
        maxDigits: Int = 4,
        action: @escaping (DigitGroup) -> PostActions
    ) {
        self.init(maxDigits: maxDigits, action: action) {
            Text(title)
                .font(.title)
        }
    }
}

struct PasscodeField_Previews: PreviewProvider {
    static var previews: some View {
        PasscodeField("Please Enter Passcode") { digits in
            if digits.concat == "1234" {
                return .shake
            } else {
                return .reset
            }
        }
    }
}
