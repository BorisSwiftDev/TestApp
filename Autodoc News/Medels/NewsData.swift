//
//  NewsData.swift
//  Autodoc News
//
//  Created by Boris Kuznetsov on 18.02.2025.
//

import Foundation

struct NewsData: Codable {
    let news: [NewsItem]
    let totalCount: Int
    
    struct NewsItem: Codable {
        let id: Int
        let title: String
        let description: String
        let publishedDate: String
        let url: String
        let fullUrl: String
        let titleImageUrl: String
        let categoryType: String
    }
}
