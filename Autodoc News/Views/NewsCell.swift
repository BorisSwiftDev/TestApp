//
//  NewsCell.swift
//  Autodoc News
//
//  Created by Boris Kuznetsov on 18.02.2025.
//

import UIKit

class NewsCell: UICollectionViewCell {
    static let reuseIdentifier = "NewsCell"

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private var imageTask: URLSessionDataTask?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // Отменяем текущую задачу загрузки изображения
        imageTask?.cancel()
        imageView.image = nil
    }

    private func setupViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Const.radius
        

        titleLabel.numberOfLines = 3
        titleLabel.font = UIFont.systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? Const.titleFontSizeiPad : Const.titleFontSizeiPhone, weight: .bold)

        dateLabel.numberOfLines = 1
        dateLabel.font = UIFont.systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? Const.dateFontSizeiPad : Const.dateFontSizeiPhone, weight: .regular)
        dateLabel.textColor = .gray

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Const.regularSpace),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Const.regularSpace),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Const.regularSpace),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Const.regularSpace),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Const.regularSpace),
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor),

            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Const.dateSpace),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: imageView.bottomAnchor)
        ])
    }

    func configure(with newsItem: NewsData.NewsItem) {
        titleLabel.text = newsItem.title
        dateLabel.text = formatDate(newsItem.publishedDate)

        // Проверяем кеш
        if let cachedImage = ImageCache.shared.image(forKey: newsItem.titleImageUrl) {
            imageView.image = cachedImage
        } else {
            // Загружаем изображение, если его нет в кеше
            loadImage(from: newsItem.titleImageUrl)
        }
    }

    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        // Отменяем предыдущую задачу, если она есть
        imageTask?.cancel()

        // Начинаем новую задачу загрузки
        imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    // Устанавливаем изображение только если ячейка все еще отображает этот URL
                    if self.imageTask?.originalRequest?.url == url {
                        self.imageView.image = image
                        ImageCache.shared.setImage(image, forKey: urlString)
                    }
                }
            }
        }
        imageTask?.resume()
    }

        private func formatDate(_ dateString: String) -> String {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = Const.format
    
            if let date = inputFormatter.date(from: dateString) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateStyle = .medium
                outputFormatter.locale = Locale(identifier: "ru_RU")
                outputFormatter.timeStyle = .none
                return outputFormatter.string(from: date)
            }
            return Const.unknownDate
        }
}

private extension NewsCell {
    enum Const {
        static let unknownDate: String = "Дата публикации неизвестна"
        static let format: String = "yyyy-MM-dd'T'HH:mm:ss"
        
        static let regularSpace: CGFloat = 8
        static let dateSpace: CGFloat = 4
        
        static let titleFontSizeiPad: CGFloat = 20
        static let titleFontSizeiPhone: CGFloat = 16
        static let dateFontSizeiPad: CGFloat = 15
        static let dateFontSizeiPhone: CGFloat = 11
        
        static let radius: CGFloat = 8
    }
}
