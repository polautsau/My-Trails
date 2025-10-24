//
//  AuthenticationViewModel.swift
//  My Trails
//
//  Handles email-first authentication flows.
//

import Foundation
import Combine

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var email: String = "" {
        didSet { updateValidation() }
    }
    @Published var password: String = "" {
        didSet { updateValidation() }
    }
    @Published var enableBiometrics: Bool = false
    @Published var error: String?
    @Published private(set) var mode: Mode = .signIn
    @Published private(set) var isValid: Bool = false

    private var service: (any AuthenticationService)?
    private(set) var lastProvider: AuthProvider?

    enum Mode {
        case signIn
        case register
    }

    var primaryActionTitle: String {
        mode == .signIn ? "Sign In" : "Create Account"
    }

    func bind(service: any AuthenticationService) {
        self.service = service
        updateValidation()
    }

    func toggleMode() {
        mode = mode == .signIn ? .register : .signIn
    }

    func primaryAction() async throws {
        guard let service else { throw AuthError.userMissing }
        switch mode {
        case .signIn:
            _ = try await service.signIn(email: email, password: password)
        case .register:
            _ = try await service.register(email: email, password: password)
        }
        if enableBiometrics {
            UserDefaults.standard.set(email, forKey: "biometric.email")
        }
        lastProvider = .email
        error = nil
    }

    func link(provider: AuthProvider) async throws {
        guard let service else { throw AuthError.userMissing }
        _ = try await service.linkOAuth(provider: provider)
        lastProvider = provider
    }

    private func updateValidation() {
        isValid = email.contains("@") && password.count >= 6
    }
}
