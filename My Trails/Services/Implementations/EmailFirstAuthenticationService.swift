//
//  EmailFirstAuthenticationService.swift
//  My Trails
//
//  Email-first authentication with optional OAuth provider linking.
//

import Foundation

@MainActor final class EmailFirstAuthenticationService: AuthenticationService {
    private var user: UserProfile?

    var isAuthenticated: Bool { user != nil }
    var currentUser: UserProfile? { user }

    func prepare() async throws { }

    func register(email: String, password: String) async throws -> UserProfile {
        let profile = UserProfile(
            id: UUID(),
            email: email,
            displayName: email.components(separatedBy: "@").first ?? "Hiker",
            avatarURL: nil,
            tier: .free,
            achievements: [],
            preferences: UserPreferences(
                measurementSystem: .metric,
                trackingAutoPause: true,
                navigationUnits: .kilometers,
                isBiometricEnabled: false,
                pushNotificationsEnabled: true,
                preferredLanguageCode: Locale.current.identifier
            ),
            linkedProviders: [.email],
            totalDistance: .init(value: 0, unit: .kilometers),
            totalElevation: .init(value: 0, unit: .meters),
            totalTime: 0
        )
        user = profile
        return profile
    }

    func signIn(email: String, password: String) async throws -> UserProfile {
        if let existing = user, existing.email == email {
            return existing
        }
        return try await register(email: email, password: password)
    }

    func linkOAuth(provider: AuthProvider) async throws -> UserProfile {
        guard provider != .email else { return try await ensureUser() }
        var profile = try await ensureUser()
        profile.linkedProviders.insert(provider)
        user = profile
        return profile
    }

    func signOut() async throws {
        user = nil
    }

    private func ensureUser() async throws -> UserProfile {
        guard let user else { throw AuthError.userMissing }
        return user
    }
}

enum AuthError: Error {
    case userMissing
}
