//
//  ExploreUserViewModel.swift
//  TikTok
//
//  Created by Michael Kang on 1/13/21.
//

import Foundation
import UIKit

struct ExploreUserViewModel {
    let profilePicture: UIImage?
    let username: String
    let followerCount: Int
    let handler: (() -> Void)
}
