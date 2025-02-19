//
//  NewsDetailViewModel.swift
//  Autodoc News
//
//  Created by Boris Kuznetsov on 18.02.2025.
//

// ViewModels/NewsDetailViewModel.swift
import UIKit
import Combine

class NewsDetailViewModel {
    @Published var image: UIImage?
    @Published var title: String
    @Published var description: String

    private let newsItem: NewsData.NewsItem
    private let imageUrl: String
    private var cancellables = Set<AnyCancellable>()

    init(newsItem: NewsData.NewsItem, imageUrl: String) {
        self.newsItem = newsItem
        self.imageUrl = imageUrl
        self.title = newsItem.title
        self.description = newsItem.description

        // Загружаем изображение, если оно есть в кеше
        if let cachedImage = ImageCache.shared.image(forKey: imageUrl) {
            self.image = cachedImage
        } else {
            loadImage()
        }
    }

    private func loadImage() {
        self.image = ImageCache.shared.image(forKey: imageUrl)
    }
}
