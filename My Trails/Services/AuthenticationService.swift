//
//  AuthenticationService.swift
//  My Trails
//
//  Unified sign-in flow prioritizing email/phone per TRD.
//

import Foundation

protocol AuthenticationService: AnyObject {
    var isAuthenticated: Bool { get }
    var currentUser: UserProfile? { get }
    func prepare() async throws
    func register(email: String, password: String) async throws -> UserProfile
    func signIn(email: String, password: String) async throws -> UserProfile
    func linkOAuth(provider: AuthProvider) async throws -> UserProfile
    func signOut() async throws
}
