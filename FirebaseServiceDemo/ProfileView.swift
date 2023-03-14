//
//  ProfileView.swift
//  FirebaseServiceDemo
//
//  Created by Alex Nagy on 14.03.2023.
//

import SwiftUI
import FirebaseService

struct ProfileView: View {
    
    @EnvironmentObject private var authenticator: FirebaseAuthenticator<Profile>
    
    @State private var isEditProfileViewPresented = false
    
    var body: some View {
        VStack {
            
            if let profilePictureUrl = URL(string: authenticator.profile?.profilePictureUrl ?? "") {
                AsyncImage(url: profilePictureUrl) { phase in
                    if let error = phase.error {
                        VStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text(error.localizedDescription)
                                .bold()
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    } else if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(width: 200, height: 200)
                .contentShape(Circle())
                .clipShape(Circle())
            }
            
            Text("Hello, \(authenticator.profile?.firstName ?? "there")!")
            
            Button("Log out") {
                logout()
            }
            
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isEditProfileViewPresented.toggle()
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .sheet(isPresented: $isEditProfileViewPresented) {
            EditProfileView()
        }
    }
    
    func logout() {
        do {
            try authenticator.signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
