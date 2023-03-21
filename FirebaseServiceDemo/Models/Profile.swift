//
//  Profile.swift
//  FirebaseServiceDemo
//
//  Created by Alex Nagy on 07.03.2023.
//

import SwiftUI
import FirebaseService
import BetterCodable
import Firebase
import FirebaseFirestoreSwift

struct Profile: Codable, Identifiable, Firestorable, Nameable, Hashable {
    
    @DocumentID var id: String?
    @DefaultEmptyString var uid: String
    @DefaultEmptyString var firstName: String
    @DefaultEmptyString var middleName: String
    @DefaultEmptyString var lastName: String
    @DefaultEmptyString var profilePictureUrl: String
    
    init(uid: String? = nil,
         firstName: String? = nil,
         middleName: String? = nil,
         lastName: String? = nil,
         profilePictureUrl: String? = nil) {
        self.uid = uid ?? ""
        self.firstName = firstName ?? ""
        self.middleName = middleName ?? ""
        self.lastName = lastName ?? ""
        self.profilePictureUrl = profilePictureUrl ?? ""
    }
    
}

struct DefaultProfileStrategy: DefaultCodableStrategy {
    static var defaultValue: Profile { return Profile() }
}

typealias DefaultEmptyProfile = DefaultCodable<DefaultProfileStrategy>




