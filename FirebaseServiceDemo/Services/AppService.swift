//
//  AppService.swift
//  FirebaseServiceDemo
//
//  Created by Alex Nagy on 21.03.2023.
//

import SwiftUI
import FirebaseService
import Firebase
import FirebaseFirestoreSwift

class AppService: ObservableObject {
    
    @Published var posts: [Post] = []
    @Published var comments: [Comment] = []
    
    @MainActor
    func addNewPost(_ post: Post) async throws {
        let newPost = try await FirestoreContext.create(post, collectionPath: Path.Firestore.posts)
        posts.append(newPost)
    }
    
    @MainActor
    func fetchMyPosts(_ uid: String) async throws {
        posts = try await FirestoreContext.query(collectionPath: Path.Firestore.posts, predicates: [
            .isEqualTo("ownerUid", uid)
        ])
    }
    
    @MainActor
    func addNewComment(_ comment: Comment) async throws {
        let newComment = try await FirestoreContext.create(comment, collectionPath: Path.Firestore.comments)
        comments.append(newComment)
    }
    
    @MainActor
    func fetchPostComments(postUid uid: String) async throws {
        comments = try await FirestoreContext.query(collectionPath: Path.Firestore.comments, predicates: [
            .isEqualTo("ownerUid", uid)
        ])
    }
    
    @MainActor
    func updateComment(_ comment: Comment) throws {
        let updatedComment = try FirestoreContext.update(comment, collectionPath: Path.Firestore.comments)
        let uid = updatedComment.uid
        for i in 0..<comments.count {
            let comment = comments[i]
            if comment.uid == uid {
                comments[i] = updatedComment
            }
        }
    }
    
    @MainActor
    func deleteComment(_ comment: Comment) throws {
        let deletedComment = try FirestoreContext.delete(comment, collectionPath: Path.Firestore.comments)
        let uid = deletedComment.uid
        for i in 0..<comments.count {
            let comment = comments[i]
            if comment.uid == uid {
                comments.remove(at: i)
                break
            }
        }
    }
    
    @MainActor
    func deletePost(_ post: Post) async throws {
        let comments: [Comment] = try await FirestoreContext.query(collectionPath: Path.Firestore.comments, predicates: [
            .isEqualTo("ownerUid", post.uid)
        ])
        
        try comments.forEach { comment in
            try deleteComment(comment)
        }
        
        let deletedPost = try FirestoreContext.delete(post, collectionPath: Path.Firestore.posts)
        
        let uid = deletedPost.uid
        for i in 0..<posts.count {
            let post = posts[i]
            if post.uid == uid {
                posts.remove(at: i)
                break
            }
        }
    }
}
