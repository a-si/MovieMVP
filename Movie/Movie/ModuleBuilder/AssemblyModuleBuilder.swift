// AssemblyModuleBuilder.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol AssemblyBuilderProtocol {
    func createMainScreenModule(withRouter router: RouterProtocol) -> UIViewController
    func createDetailScreenModule(withMovie movie: Movie?, andRouter router: RouterProtocol) -> UIViewController
}

final class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    func createMainScreenModule(withRouter router: RouterProtocol) -> UIViewController {
        let view = MoviesViewController()
        let movieAPIService = MovieAPIService()
        let presenter = MainScreenPresenter(view: view, movieAPIService: movieAPIService, router: router)
        view.presenter = presenter
        return view
    }

    func createDetailScreenModule(withMovie movie: Movie?, andRouter router: RouterProtocol) -> UIViewController {
        let view = DetailMovieViewController()
        let movieAPIService = MovieAPIService()
        let presenter = DetailScreenPresenter(
            view: view,
            movie: movie,
            movieAPIService: movieAPIService,
            router: router
        )
        view.presenter = presenter
        return view
    }
}
