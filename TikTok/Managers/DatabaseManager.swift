//
//  DatabaseManager.swift
//  TikTok
//
//  Created by Michael Kang on 1/7/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    public static let shared = DatabaseManager()
    private let database = Database.database().reference() // reference to realtime database set up on firebase
    private init() {
            
    }
    
    // Public
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
    
}
