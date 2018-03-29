//
//  DataServices.swift
//  SocialApp
//
//  Created by A K M Saleh Sultan on 3/29/18.
//  Copyright © 2018 A K M Saleh Sultan. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

let DB_BASE =  Database.database().reference()

class DataServices{
    
    static let ds = DataServices()
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE : DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        print(uid)
        print(userData)
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
