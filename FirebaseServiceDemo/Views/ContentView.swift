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
    @EnvironmentObject private var appService: AppService
    
    @State private var randomInt = 0
    
    var body: some View {
        List {
            ForEach(appService.posts) { post in
                NavigationLink {
                    PostView(post: post)
                } label: {
                    Text(post.message)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button {
                        delete(post)
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                NavigationLink {
                    ProfileView()
                } label: {
                    Image(systemName: "person")
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button {
                    randomInt = getRandomInt()
                    addNewPost(int: randomInt)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onReceive(authenticator.$profile) { _ in
            fetchMyPosts()
        }
    }
    
    func getRandomInt() -> Int {
        Int.random(in: 0...100)
    }
    
    func addNewPost(int: Int) {
        Task {
            do {
                guard let ownerUid = authenticator.profile?.uid else { return }
                let post = Post(message: "Hello there \(int)", ownerUid: ownerUid)
                try await appService.addNewPost(post)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchMyPosts() {
        Task {
            do {
                guard let ownerUid = authenticator.profile?.uid else { return }
                try await appService.fetchMyPosts(ownerUid)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func delete(_ post: Post) {
        Task {
            do {
                try await appService.deletePost(post)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
