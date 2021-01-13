//
//  ExploreBannerViewModel.swift
//  TikTok
//
//  Created by Michael Kang on 1/13/21.
//

import Foundation
import UIKit

struct ExploreBannerViewModel {
    let imageView: UIImage?
    let title: String
    let handler: (() -> Void)
}
