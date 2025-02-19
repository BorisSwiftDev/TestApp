//
//  NewsViewController.swift
//  Autodoc News
//
//  Created by Boris Kuznetsov on 18.02.2025.
//

import UIKit
import Combine

class NewsViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var viewModel = NewsViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindViewModel()
        Task {
            await viewModel.fetchNews()
        }
        
        self.navigationItem.title = Const.navigationTitle
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            // Определяем количество колонок в зависимости от ориентации и типа устройства
            let isiPad = UIDevice.current.userInterfaceIdiom == .pad
            let isLandscape = layoutEnvironment.container.effectiveContentSize.width > layoutEnvironment.container.effectiveContentSize.height
            let columns: Int

            if isiPad {
                columns = isLandscape ? 3 : 2 // 3 колонки в ландшафтной ориентации, 2 — в портретной
            } else {
                columns = 1 // На iPhone всегда 1 колонка
            }

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            group.interItemSpacing = .fixed(Const.regularSpace)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = Const.regularSpace
            section.contentInsets = NSDirectionalEdgeInsets(top: Const.regularSpace, leading: Const.regularSpace, bottom: Const.regularSpace, trailing: Const.regularSpace)

            return section
        }
        return layout
    }

    private func bindViewModel() {
        viewModel.$newsItems
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.collectionView.collectionViewLayout = self.createLayout()
        }
    }
}

extension NewsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.reuseIdentifier, for: indexPath) as! NewsCell
        let newsItem = viewModel.newsItems[indexPath.row]
        cell.configure(with: newsItem)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.newsItems.count
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.newsItems.count - 1, viewModel.hasMoreData {
            Task {
                await viewModel.fetchNews()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newsItem = viewModel.newsItems[indexPath.row]
        let imageUrl = newsItem.titleImageUrl

        // Создаем ViewModel и передаем ее в детальный экран
        let detailViewModel = NewsDetailViewModel(newsItem: newsItem, imageUrl: imageUrl)
        let detailViewController = NewsDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

private extension NewsViewController {
    enum Const {
        static let regularSpace: CGFloat = 16
        static let navigationTitle: String = "Autodoc news"
    }
}
