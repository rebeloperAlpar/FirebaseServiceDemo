//
//  Comment.swift
//  FirebaseServiceDemo
//
//  Created by Alex Nagy on 21.03.2023.
//

import SwiftUI
import FirebaseService
import BetterCodable
import Firebase
import FirebaseFirestoreSwift

struct Comment: Codable, Identifiable, Firestorable, Hashable {
    
    @DocumentID var id: String?
    @DefaultEmptyString var uid: String
    @DefaultEmptyString var message: String
    @DefaultEmptyString var ownerUid: String
    
    init(uid: String? = nil,
         message: String? = nil,
         ownerUid: String? = nil) {
        self.uid = uid ?? ""
        self.message = message ?? ""
        self.ownerUid = ownerUid ?? ""
    }
    
}

struct DefaultCommentStrategy: DefaultCodableStrategy {
    static var defaultValue: Comment { return Comment() }
}

typealias DefaultEmptyComment = DefaultCodable<DefaultCommentStrategy>
