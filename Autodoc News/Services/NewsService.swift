//
//  NewsService.swift
//  Autodoc News
//
//  Created by Boris Kuznetsov on 18.02.2025.
//

import Foundation

class NewsService {
    func fetchNews(page: Int, pageSize: Int) async throws -> NewsData {
        let urlString = "https://webapi.autodoc.ru/api/news/\(page)/\(pageSize)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let newsItems = try JSONDecoder().decode(NewsData.self, from: data)
        return newsItems
    }
}
