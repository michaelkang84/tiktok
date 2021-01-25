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
    
    /// Storage bucket reference
    private let storage = Storage.storage().reference() // reference to storage in firebase
    private init() {
            
    }
    
    // Public

    public func uploadVideo(from url: URL, fileName: String, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        storage.child("/videos/\(username)/\(fileName)").putFile(from: url, metadata: nil) { (_, error) in
            completion(error == nil)
        }
    }
    
    public func generateVideoName() -> String {
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimestamp = Date().timeIntervalSince1970
        
        return uuidString + "_\(number)_" + "\(unixTimestamp)" + ".mov"
    }
    
    
}
