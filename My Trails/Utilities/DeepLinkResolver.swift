//
//  DeepLinkResolver.swift
//  My Trails
//
//  Maps universal links to application routes.
//

import Foundation
import Combine

enum DeepLinkResolver {
    static func resolve(url: URL) -> DeepLinkDestination? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        if let host = components.host, host.contains("trails"), let path = components.path.split(separator: "/").first {
            return DeepLinkDestination(rawValue: String(path))
        }
        if let fragment = components.fragment {
            return DeepLinkDestination(rawValue: fragment)
        }
        return nil
    }
}
