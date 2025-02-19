//
//  Autodoc_NewsTests.swift
//  Autodoc NewsTests
//
//  Created by Boris Kuznetsov on 18.02.2025.
//

import XCTest
import Foundation
@testable import Autodoc_News

class Autodoc_NewsTests: XCTestCase {
    func testNewsItemDecoding() throws {
        let json = """
        {
            "news": [
                {
                  "id": 8404,
                  "title": "Представлен компактный кроссовер Acura ADX",
                  "description": "В линейке моделей Acura уже много лет существует дыра",
                  "publishedDate": "2025-02-17T00:00:00",
                  "url": "avto-novosti/acura_adx",
                  "fullUrl": "https://www.autodoc.ru/avto-novosti/acura_adx",
                  "titleImageUrl": "https://file.autodoc.ru/news/avto-novosti/1554386130_1.jpg",
                  "categoryType": "Автомобильные новости"
                },
                {
                  "id": 8402,
                  "title": "Volvo EX30 Cross Country: яркий электромобиль",
                  "description": "Более четверти века назад появление версии Cross Country помогло Volvo увеличить продажи автомобилей",
                  "publishedDate": "2025-02-14T00:00:00",
                  "url": "avto-novosti/volvo_cross_country",
                  "fullUrl": "https://www.autodoc.ru/avto-novosti/volvo_cross_country",
                  "titleImageUrl": "https://file.autodoc.ru/news/avto-novosti/1297950220_1.jpg",
                  "categoryType": "Автомобильные новости"
                }
            ],
        "totalCount": 2
        }
        """.data(using: .utf8)!

        let newsItem = try JSONDecoder().decode(NewsData.self, from: json)

        XCTAssertEqual(newsItem.totalCount, 2)
        XCTAssertEqual(newsItem.news.first?.id, 8404)
        XCTAssertEqual(newsItem.news.first?.description, "В линейке моделей Acura уже много лет существует дыра")
        XCTAssertEqual(newsItem.news.first?.titleImageUrl, "https://file.autodoc.ru/news/avto-novosti/1554386130_1.jpg")
        XCTAssertEqual(newsItem.news.first?.publishedDate, "2025-02-17T00:00:00")
    }
    
    func testFetchNews() async {
        let mockService = MockNewsService()
        let newsItems = try? await mockService.fetchNews(page: 1, pageSize: 15)

        XCTAssertNotNil(newsItems)
        XCTAssertEqual(newsItems?.totalCount, 2)
        XCTAssertEqual(newsItems?.news.first?.title, "Test Title 1")
        XCTAssertEqual(newsItems?.news.last?.title, "Test Title 2")
    }

}

class MockNewsService: NewsService {
    override func fetchNews(page: Int, pageSize: Int) async throws -> NewsData {
        return NewsData (
                news: [
                    NewsData.NewsItem(
                        id: 1,
                        title: "Test Title 1",
                        description: "Test Description 1",
                        publishedDate: "2025-02-17T00:00:00",
                        url: "example.com",
                        fullUrl: "https://example.com",
                        titleImageUrl: "https://example.com/image1.jpg",
                        categoryType: "none"
                    ),
                    NewsData.NewsItem(
                        id: 2,
                        title: "Test Title 2",
                        description: "Test Description 2",
                        publishedDate: "2025-02-18T00:00:00",
                        url: "example.com",
                        fullUrl: "https://example.com",
                        titleImageUrl: "https://example.com/image1.jpg",
                        categoryType: "none"
                    )
                ],
                totalCount: 2
            )
    }
}
