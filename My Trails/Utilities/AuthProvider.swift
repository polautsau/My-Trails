//
//  AuthProvider.swift
//  My Trails
//
//  Supported authentication providers.
//

import Foundation
import Combine

enum AuthProvider: String, Codable, CaseIterable, Hashable {
    case email
    case apple
    case google
    case facebook
}
