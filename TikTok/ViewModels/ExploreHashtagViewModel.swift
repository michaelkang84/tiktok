//
//  ExploreHashtagViewModel.swift
//  TikTok
//
//  Created by Michael Kang on 1/13/21.
//

import Foundation
import UIKit


struct ExploreHashtagViewModel {
    let text: String
    let icon: UIImage?
    let count: Int // number of posts associated with hashtag
    let handler: (() -> Void)
}
