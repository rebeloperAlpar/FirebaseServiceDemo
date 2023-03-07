//
//  ContentView.swift
//  FirebaseServiceDemo
//
//  Created by Alex Nagy on 07.03.2023.
//

import SwiftUI
import FirebaseService

struct ContentView: View {
    
    @EnvironmentObject private var authenticator: FirebaseAuthenticator<Profile>
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, \(authenticator.profile?.firstName ?? "there")!")
            
            Button("Log out") {
                logout()
            }
        }
        .padding()
    }
    
    func logout() {
        do {
            try authenticator.signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
