//
//  NewsViewModel.swift
//  Autodoc News
//
//  Created by Boris Kuznetsov on 18.02.2025.
//

import Combine
import Foundation

class NewsViewModel: ObservableObject {
    @Published var newsItems: [NewsData.NewsItem] = []
    @Published var hasMoreData = true

    private var currentPage = 1
    private let pageSize = 15
    private let newsService = NewsService()

    func fetchNews() async {
        guard hasMoreData else { return }

        do {
            let items = try await newsService.fetchNews(page: currentPage, pageSize: pageSize)
            DispatchQueue.main.async {
                self.newsItems.append(contentsOf: items.news)
                self.currentPage += 1
                self.hasMoreData = items.totalCount >= items.news.count
            }
        } catch {
            print("Error fetching news: \(error)")
        }

        
    }
}
