//
//  DatabaseManager.swift
//  MessengerApp
//
//  Created by Diego Belusky on 27.08.21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager { // final means that this class can not be subclassed
    static let shared = DatabaseManager() // This is a singleton
    private let database = Database.database().reference()
    
}

// MARK: - Account Management

extension DatabaseManager {
    
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "_")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { dataSnapshot in
            guard dataSnapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    
    // with 3 slashes you can add a description(documentation string) to the method, like so..
    /// Inserts new user to database.
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
}

struct ChatAppUser {
    let firstName: String?
    let lastName: String?
    let emailAdress: String
    
    var safeEmail: String {
        var safeEmail = emailAdress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "_")
        return safeEmail
    }
}



