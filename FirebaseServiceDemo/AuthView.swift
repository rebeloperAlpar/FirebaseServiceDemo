//
//  AuthView.swift
//  FirebaseServiceDemo
//
//  Created by Alex Nagy on 07.03.2023.
//

import SwiftUI
import FirebaseService

struct AuthView: View {
    
//    @State private var firstName = ""
//    @State private var lastName = ""
    @State private var profile = Profile()
    
    @EnvironmentObject private var authenticator: FirebaseAuthenticator<Profile>
    
    @State private var isLogin = true
    
    @State private var isSignInWithApple = true
    
    var body: some View {
        VStack {
            Spacer()
            if isSignInWithApple {
//                FirebaseSignInWithAppleButton(label: .continueWithApple, profile: profile) { result in
//                    switch result {
//                    case .success(let profile):
//                        print("Successfully signed in with Apple: \(profile.uid)")
//                    case .failure(let failure):
//                        print(failure.localizedDescription)
//                    }
//                }
                Button("Sign in with Apple") {
                    signInWithApple()
                }
                .buttonStyle(.bordered)
            } else {
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
                    TextField("First name", text: $profile.firstName)
                        .textFieldStyle(.roundedBorder)
                    TextField("Last name", text: $profile.lastName)
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
        }
        .padding()
    }
    
    func signUp() {
        Task {
//            let profile = Profile(firstName: firstName, lastName: lastName)
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
    
    func signInWithApple() {
        Task {
            do {
                try await authenticator.continueWithApple(profile: profile)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
