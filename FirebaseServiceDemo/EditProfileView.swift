//
//  EditProfileView.swift
//  FirebaseServiceDemo
//
//  Created by Alex Nagy on 14.03.2023.
//

import SwiftUI
import FirebaseService
import PhotosUI

struct EditProfileView: View {
    
    @EnvironmentObject private var authenticator: FirebaseAuthenticator<Profile>
    
    @State private var profile = Profile()
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var profileImageSelection: PhotosPickerItem?
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        VStack {
            
            PhotosPicker(selection: $profileImageSelection) {
                Group {
                    if selectedImage == nil {
                        if profile.profilePictureUrl == "" {
                            Image(systemName: "camera")
                        } else {
                            AsyncImage(url: URL(string: profile.profilePictureUrl)) { phase in
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
                        }
                    } else {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(width: 200, height: 200)
                .contentShape(Circle())
                .clipShape(Circle())
            }
            .linkPhotosPicker(selection: $profileImageSelection, toSelectedUIImage: $selectedImage)
            
            TextField("First name", text: $profile.firstName)
                .textFieldStyle(.roundedBorder)
            
            TextField("Middle name", text: $profile.middleName)
                .textFieldStyle(.roundedBorder)
            
            TextField("Last name", text: $profile.lastName)
                .textFieldStyle(.roundedBorder)
            
            Button {
                save()
            } label: {
                HStack {
                    Spacer()
                    Text("Save").bold()
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
        .onAppear {
            if let profile = authenticator.profile {
                self.profile = profile
            }
        }
    }
    
    func save() {
        if selectedImage == nil {
            saveProfile()
        } else {
            saveImageAndProfile()
        }
    }
    
    func saveImageAndProfile() {
        Task {
            do {
                profile.profilePictureUrl = try await StorageContext.handleImageChange(newImage: selectedImage!, folderPath: profile.uid, oldImageUrl: profile.profilePictureUrl).absoluteString
                let profile = try FirestoreContext.update(profile, collectionPath: Path.Firestore.profiles)
                authenticator.profile = profile
                dismiss()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveProfile() {
        do {
            let profile = try FirestoreContext.update(profile, collectionPath: Path.Firestore.profiles)
            authenticator.profile = profile
            dismiss()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
