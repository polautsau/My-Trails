//
//  AnalyticsService.swift
//  My Trails
//
//  Basic analytics abstraction capturing app level events.
//

import Foundation

protocol AnalyticsService {
    func track(event: AnalyticsEvent)
    func track(error: Error)
}

enum AnalyticsEvent {
    case appLaunched
    case authenticationCompleted(provider: AuthProvider)
    case deepLinkOpened(String)
    case trailSelected(UUID)
    case recordingStateChanged(TrailRecording.State)
    case subscriptionPurchased(SubscriptionPlan.PlanType)
    case offlinePackageStatusChanged(String)
}

struct ConsoleAnalyticsService: AnalyticsService {
    func track(event: AnalyticsEvent) {
        print("[Analytics] Event: \(event)")
    }

    func track(error: Error) {
        print("[Analytics] Error: \(error.localizedDescription)")
    }
}
