//
//  MainView.swift
//  FirebaseServiceDemo
//
//  Created by Alex Nagy on 07.03.2023.
//

import SwiftUI
import FirebaseService

struct MainView: View {
    
    @EnvironmentObject private var authenticator: FirebaseAuthenticator<Profile>
    
    var body: some View {
        Group {
            switch authenticator.value {
            case .undefined:
                ProgressView()
            case .authenticated:
                ContentView()
            case .notAuthenticated:
                AuthView()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
