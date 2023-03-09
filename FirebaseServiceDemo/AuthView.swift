//
//  AuthView.swift
//  FirebaseServiceDemo
//
//  Created by Alex Nagy on 07.03.2023.
//

import SwiftUI
import FirebaseService

struct AuthView: View {
    
    @State private var firstName = ""
    @State private var lastName = ""
    
    @EnvironmentObject private var authenticator: FirebaseAuthenticator<Profile>
    
    @State private var isLogin = true
    
    var body: some View {
        VStack {
            Spacer()
            if isLogin {
                TextField("Email", text: $authenticator.credentials.email)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $authenticator.credentials.password)
                    .textFieldStyle(.roundedBorder)
                Button("Sign in") {
                    signIn()
                }
                .buttonStyle(.borderedProminent)
                Button("I don't have an account") {
                    isLogin.toggle()
                }
            } else {
                TextField("First name", text: $firstName)
                    .textFieldStyle(.roundedBorder)
                TextField("Last name", text: $lastName)
                    .textFieldStyle(.roundedBorder)
                TextField("Email", text: $authenticator.credentials.email)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $authenticator.credentials.password)
                    .textFieldStyle(.roundedBorder)
                Button("Sign up") {
                    signUp()
                }
                .buttonStyle(.borderedProminent)
                Button("I already have an account") {
                    isLogin.toggle()
                }
            }
        }
        .padding()
    }
    
    func signUp() {
        Task {
            let profile = Profile(firstName: firstName, lastName: lastName)
            do {
                try await authenticator.signUp(profile: profile)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func signIn() {
        Task {
            do {
                try await authenticator.signIn()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
