// BiometricIDAuth.swift
// Copyright (c) 2023 Nostudio
// Created by Jerry X T Wang on 2023/2/4.

import Combine
import LocalAuthentication

enum BiometricType {
    case touchID
    case faceID
    case none
}

enum BiometricEvaluateResult {
    case success
    case passcodeNotSet
    case biometryNotEnrolled
    case biometryNotAvailable
    case other(Error)
}

class BiometricIDAuth {
    let context = LAContext()

    static let shared: BiometricIDAuth = .init()

    private init() {
//        context.touchIDAuthenticationAllowableReuseDuration = 5 * 60
    }

    @discardableResult
    func canEvaluatePolicy() -> Bool {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }

    func evaluatePolicy() async -> BiometricEvaluateResult {
        do {
            try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Use FaceID")
            return .success
        } catch LAError.biometryNotAvailable {
            return .biometryNotAvailable
        } catch LAError.passcodeNotSet {
            return .passcodeNotSet
        } catch LAError.biometryNotEnrolled {
            return .biometryNotEnrolled
        } catch {
            return .other(error)
        }
    }

    func biometricType() -> BiometricType {
        canEvaluatePolicy()
        switch context.biometryType {
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        case .none:
            return .none
        @unknown default:
            return .none
        }
    }
}
