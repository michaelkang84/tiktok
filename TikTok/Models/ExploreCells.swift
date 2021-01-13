//
//  ExploreCells.swift
//  TikTok
//
//  Created by Michael Kang on 1/13/21.
//

import Foundation
import UIKit

enum ExploreCells {
    case banner(viewModel: ExploreBannerViewModel)
    case post(viewModel: ExplorePostViewModel)
    case hashtag(viewModel: ExploreHashtagViewModel)
    case user(viewModel: ExploreUserViewModel)
}


