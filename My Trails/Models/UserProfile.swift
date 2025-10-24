//
//  UserProfile.swift
//  My Trails
//
//  Represents the authenticated user and subscription state.
//

import Foundation

struct UserProfile: Identifiable, Codable, Hashable {
    enum Tier: String, Codable {
        case free
        case premium
    }

    let id: UUID
    var email: String
    var displayName: String
    var avatarURL: URL?
    var tier: Tier
    var achievements: [UserAchievement]
    var preferences: UserPreferences
    var linkedProviders: Set<AuthProvider>
    var totalDistance: Measurement<UnitLength>
    var totalElevation: Measurement<UnitLength>
    var totalTime: TimeInterval
}

struct UserPreferences: Codable, Hashable {
    var measurementSystem: MeasurementSystem
    var trackingAutoPause: Bool
    var navigationUnits: NavigationUnits
    var isBiometricEnabled: Bool
    var pushNotificationsEnabled: Bool
    var preferredLanguageCode: String
}

enum MeasurementSystem: String, Codable {
    case metric
    case imperial
}

enum NavigationUnits: String, Codable {
    case kilometers
    case miles
}

struct UserAchievement: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var description: String
    var iconName: String
    var earnedAt: Date
}
