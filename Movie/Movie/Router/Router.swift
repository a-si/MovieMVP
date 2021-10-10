// Router.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol BaseRouterProtocol {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyProtocol? { get set }
}

protocol RouterProtocol: BaseRouterProtocol {
    func setInitialViewController()
    func showDetailMovieController(withMovie movie: Movie?, andCachedImage: UIImage?)
    func popToRoot()
}

final class Router: RouterProtocol {
    var navigationController: UINavigationController?

    var assemblyBuilder: AssemblyProtocol?

    init(navigationController: UINavigationController, assemblyBuilder: AssemblyProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }

    func setInitialViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblyBuilder?.createMainScreenModule(withRouter: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }

    func showDetailMovieController(withMovie movie: Movie?, andCachedImage image: UIImage?) {
        if let navigationController = navigationController {
            guard let detailViewController = assemblyBuilder?
                .createDetailScreenModule(withMovie: movie, image: image, andRouter: self) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }

    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
