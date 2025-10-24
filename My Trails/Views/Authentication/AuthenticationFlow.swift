//
//  AuthenticationFlow.swift
//  My Trails
//
//  Email-first authentication UI with optional OAuth linking.
//

import SwiftUI

struct AuthenticationFlow: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = AuthenticationViewModel()

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            VStack(spacing: 12) {
                Image(systemName: "mountain.2.fill")
                    .font(.system(size: 72))
                Text("Sign in to My Trails")
                    .font(.title.bold())
            }

            AuthForm(viewModel: viewModel)
                .liquidGlassCard()

            VStack(spacing: 12) {
                Text("or continue with")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                HStack(spacing: 12) {
                    OAuthButton(icon: "apple.logo", provider: .apple)
                    OAuthButton(icon: "globe", provider: .google)
                    OAuthButton(icon: "f.square", provider: .facebook)
                }
            }
            .padding(.horizontal)

            Spacer()
            MyTrailsUI.PrimaryButton(title: viewModel.primaryActionTitle, icon: "arrow.right") {
                Task {
                    do {
                        try await viewModel.primaryAction()
                        withAnimation {
                            appState.route = .main
                        }
                        appState.analytics.track(event: .authenticationCompleted(provider: viewModel.lastProvider ?? .email))
                    } catch {
                        viewModel.error = error.localizedDescription
                    }
                }
            }
            .disabled(!viewModel.isValid)

            if let error = viewModel.error {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
        }
        .padding()
        .task {
            viewModel.bind(service: appState.services.authService)
        }
    }

    @ViewBuilder
    private func OAuthButton(icon: String, provider: AuthProvider) -> some View {
        Button {
            Task {
                do {
                    try await viewModel.link(provider: provider)
                    appState.analytics.track(event: .authenticationCompleted(provider: provider))
                } catch {
                    viewModel.error = error.localizedDescription
                }
            }
        } label: {
            Image(systemName: icon)
                .frame(width: 56, height: 56)
                .background(.ultraThinMaterial, in: Circle())
        }
        .buttonStyle(.plain)
    }
}
