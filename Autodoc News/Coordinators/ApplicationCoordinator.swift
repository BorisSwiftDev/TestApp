//
//  ApplicationCoordinator.swift
//  Autodoc News
//
//  Created by Boris Kuznetsov on 18.02.2025.
//

import UIKit

class ApplicationCoordinator {
    private let window: UIWindow

    init(window: UIWindow = UIWindow()) {
        self.window = window
    }

    func start() {
        self.window.rootViewController?.navigationController?.setNavigationBarHidden(false, animated: false)
        runNewsFlow()
    }
}

extension ApplicationCoordinator {
    func runNewsFlow() {
        let newsViewController = NewsViewController()
        let navigationController = UINavigationController(rootViewController: newsViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
