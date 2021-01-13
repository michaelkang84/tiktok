//
//  ExploreUserViewModel.swift
//  TikTok
//
//  Created by Michael Kang on 1/13/21.
//

import Foundation

struct ExploreUserViewModel {
    let profilePicture: URL?
    let username: String
    let followerCount: Int
    let handler: (() -> Void)
}
