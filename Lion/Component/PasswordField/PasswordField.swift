// PasswordField.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/3.

import SwiftUI

enum PostAction {
    case reset(delay: Double)
    case shake(delay: Double)
    case unfocus(delay: Double)
}

struct PasscodeField<Label>: View, KeyboardNotifiable where Label: View {
    private let maxDigits: Int
    private let submit: (DigitGroup) -> [PostAction]
    private let label: () -> Label

    init(
        input: Binding<String> = .constant(""),
        maxDigits: Int = 4,
        submit: @escaping (DigitGroup) -> [PostAction],
        @ViewBuilder label: @escaping () -> Label
    ) {
        _input = input
        self.maxDigits = maxDigits
        self.submit = submit

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
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
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

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let postActions = submit(pin)
            executePostActions(postActions)
        }
    }

    private func executePostActions(_ postActions: [PostAction]) {
        postActions.forEach { action in
            switch action {
            case let .reset(delay):
                let deadline: DispatchTime = .now() + delay
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    reset()
                }
            case let .shake(delay):
                let deadline: DispatchTime = .now() + delay
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    shake()
                }
            case let .unfocus(delay):
                let deadline: DispatchTime = .now() + delay
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    unfocus()
                }
            }
        }
    }

    private func reset() {
        pin = .blank(upTo: maxDigits)
    }

    private func shake() {
        attempts += 1
    }

    private func unfocus() {
        isFocused = false
    }
}

extension PasscodeField where Label == Text {
    init(
        _ title: some StringProtocol,
        maxDigits: Int = 4,
        action: @escaping (DigitGroup) -> [PostAction]
    ) {
        self.init(maxDigits: maxDigits, submit: action) {
            Text(title)
                .font(.title)
        }
    }
}

struct PasscodeField_Previews: PreviewProvider {
    static var previews: some View {
        PasscodeField("Please Enter Passcode") { digits in
            if digits.concat == "1234" {
                return [.shake(delay: 0)]
            } else {
                return [.reset(delay: 0)]
            }
        }
    }
}
