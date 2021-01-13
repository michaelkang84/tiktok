//
//  ExplorePostViewModel.swift
//  TikTok
//
//  Created by Michael Kang on 1/13/21.
//

import Foundation
import UIKit


struct ExplorePostViewModel {
    let thumbnail: UIImage?
    let caption: String
    let handler: (() -> Void)
}
