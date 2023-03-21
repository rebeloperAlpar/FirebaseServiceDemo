//
//  FirebaseServiceDemoApp.swift
//  FirebaseServiceDemo
//
//  Created by Alex Nagy on 07.03.2023.
//

import SwiftUI
import FirebaseService
import FirebaseCore

@main
struct FirebaseServiceDemoApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    @StateObject private var appService = AppService()
    
    var body: some Scene {
        WindowGroup {
            FirebaseAuthenticatorView<MainView, Profile>(Path.Firestore.profiles) {
                MainView()
            }
            .environmentObject(appService)
        }
    }
}
