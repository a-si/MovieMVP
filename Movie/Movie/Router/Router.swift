// Router.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol BaseRouterProtocol {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: BaseRouterProtocol {
    func setInitialViewController()
    func showDetailMovieController(withMovie movie: Movie?)
    func popToRoot()
}

final class Router: RouterProtocol {
    var navigationController: UINavigationController?

    var assemblyBuilder: AssemblyBuilderProtocol?

    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }

    func setInitialViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblyBuilder?.createMainScreenModule(withRouter: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }

    func showDetailMovieController(withMovie movie: Movie?) {
        if let navigationController = navigationController {
            guard let detailViewController = assemblyBuilder?
                .createDetailScreenModule(withMovie: movie, andRouter: self) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }

    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
