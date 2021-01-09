//
//  StorageManager.swift
//  TikTok
//
//  Created by Michael Kang on 1/7/21.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    public static let shared = StorageManager()
    private let storage = Storage.storage().reference() // reference to storage in firebase
    private init() {
            
    }
    
    // Public

    public func getVideoURL(with identifier: String, completion: (URL) -> Void) {}
    
    public func uploadVideoURL(from url: String) {}
    
}
