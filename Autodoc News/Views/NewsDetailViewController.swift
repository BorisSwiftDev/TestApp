//
//  NewsDetailViewController.swift
//  Autodoc News
//
//  Created by Boris Kuznetsov on 18.02.2025.
//

import UIKit
import Combine

class NewsDetailViewController: UIViewController {
    private let viewModel: NewsDetailViewModel
    private var cancellables = Set<AnyCancellable>()

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    init(viewModel: NewsDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        bindViewModel()
    }

    private func setupViews() {
        self.navigationItem.title = viewModel.title
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? Const.fontSizeiPad : Const.fontSizeiPhone, weight: .bold)

        descriptionLabel.numberOfLines = .zero

        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: UIDevice.current.userInterfaceIdiom == .pad ? Const.multiplieriPad : Const.multiplieriPhone),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Const.regularSpace),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Const.regularSpace),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Const.regularSpace),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Const.spaceBetweenLabels),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Const.regularSpace),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Const.regularSpace),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Const.regularSpace)
        ])
    }

    private func bindViewModel() {
        // Привязываем данные из ViewModel к UI
        viewModel.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.imageView.image = image
            }
            .store(in: &cancellables)

        viewModel.$title
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.titleLabel.text = title
            }
            .store(in: &cancellables)

        viewModel.$description
            .receive(on: DispatchQueue.main)
            .sink { [weak self] description in
                self?.descriptionLabel.text = description
            }
            .store(in: &cancellables)
    }
}

private extension NewsDetailViewController {
    enum Const {
        static let regularSpace: CGFloat = 16
        static let spaceBetweenLabels: CGFloat = 8
        static let multiplieriPhone : CGFloat = 0.25
        static let multiplieriPad : CGFloat = 0.3
        
        static let fontSizeiPhone : CGFloat = 20
        static let fontSizeiPad : CGFloat = 24
        
    }
}
