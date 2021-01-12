//
//  CommentModel.swift
//  TikTok
//
//  Created by Michael Kang on 1/12/21.
//

import Foundation

struct CommentModel {
    let text: String
    let user: User
    let date: Date
    
    static func mockComments() -> [CommentModel] {
        let user = User(username: "kanye west", profilePictureUrl: nil, identifier: UUID().uuidString)
        
        var comments = [CommentModel]()
        
        let text = [
            "this is cool",
            "this is rad",
            "im learning so much"
        ]
        
        for comment in text {
            comments.append(
                CommentModel(text: comment, user: user, date: Date())
            )
        }
        
        return comments
    }
}
