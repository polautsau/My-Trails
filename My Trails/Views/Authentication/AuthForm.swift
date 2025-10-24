//
//  AuthForm.swift
//  My Trails
//
//  Captures email/password credentials with biometric toggle.
//

import SwiftUI

struct AuthForm: View {
    @ObservedObject var viewModel: AuthenticationViewModel

    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            SecureField("Password", text: $viewModel.password)
                .textContentType(.password)
            Toggle("Enable biometric login", isOn: $viewModel.enableBiometrics)
                .toggleStyle(.switch)
        }
        .padding()
    }
}
