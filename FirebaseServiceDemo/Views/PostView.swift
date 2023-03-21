//
//  PostView.swift
//  FirebaseServiceDemo
//
//  Created by Alex Nagy on 21.03.2023.
//

import SwiftUI
import FirebaseService

struct PostView: View {
    
    let post: Post
    
    @EnvironmentObject private var authenticator: FirebaseAuthenticator<Profile>
    @EnvironmentObject private var appService: AppService
    
    @State private var randomInt = 0
    
    var body: some View {
        VStack {
            Text("\(post.message)")
            List {
                ForEach(appService.comments) { comment in
                    Text(comment.message)
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                editComment(comment)
                            } label: {
                                Image(systemName: "pencil")
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                delete(comment)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    randomInt = getRandomInt()
                    addNewComment(int: randomInt)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            fetchComments()
        }
        .onDisappear {
            appService.comments.removeAll()
        }
    }
    
    func getRandomInt() -> Int {
        Int.random(in: 0...100)
    }
    
    func addNewComment(int: Int) {
        Task {
            do {
                let comment = Comment(message: "Comment no. \(int)", ownerUid: post.uid)
                try await appService.addNewComment(comment)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchComments() {
        Task {
            do {
                try await appService.fetchPostComments(postUid: post.uid)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func editComment(_ comment: Comment) {
        do {
            var comment = comment
            comment.message = "Updated comment"
            try appService.updateComment(comment)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(_ comment: Comment) {
        do {
            try appService.deleteComment(comment)
        } catch {
            print(error.localizedDescription)
        }
    }
}

