//
//  Subscription.swift
//  My Trails
//
//  Describes premium access plans and entitlements.
//

import Foundation

struct SubscriptionPlan: Identifiable, Codable, Hashable {
    enum PlanType: String, Codable {
        case monthly
        case yearly
    }

    let id: UUID
    var type: PlanType
    var price: Decimal
    var currencyCode: String
    var features: [SubscriptionFeature]
}

enum SubscriptionFeature: String, Codable, CaseIterable {
    case offlineDownloadsUnlimited
    case 3dMaps
    case hdTerrain
    case analytics
    case weatherForecasts48h
    case weatherForecasts7d
    case liveSharing
    case customMapStyles
    case adsFree
}
