//
//  Post.swift
//  FirebaseServiceDemo
//
//  Created by Alex Nagy on 21.03.2023.
//

import SwiftUI
import FirebaseService
import BetterCodable
import Firebase
import FirebaseFirestoreSwift

struct Post: Codable, Identifiable, Firestorable, Hashable {
    
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

struct DefaultPostStrategy: DefaultCodableStrategy {
    static var defaultValue: Post { return Post() }
}

typealias DefaultEmptyPost = DefaultCodable<DefaultPostStrategy>





