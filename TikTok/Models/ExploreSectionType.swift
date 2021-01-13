//
//  ExploreSectionType.swift
//  TikTok
//
//  Created by Michael Kang on 1/13/21.
//

import Foundation

enum ExploreSectionType: CaseIterable {
    case banners
    case trendingPosts
    case trendingHastags
    case users
    case recommended
    case popular
    case new
    
    var title: String {
        switch self {
        
        case .banners:
            return "Featured"
        case .trendingPosts:
            return "Trending Videos"
        case .users:
            return "Popular Creators"
        case .trendingHastags:
            return "Hastags"
        case .recommended:
            return "Recomended"
        case .popular:
            return "Popular"
        case .new:
            return "Recently Posted"
        }
    }
}
