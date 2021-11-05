// AssemblyModule.swift
// Copyright © Артём Сыряный. All rights reserved.

import UIKit

protocol AssemblyProtocol {
    func createMainScreenModule(withRouter router: RouterProtocol) -> UIViewController
    func createDetailScreenModule(withMovie movie: Movie?, image: UIImage?, andRouter router: RouterProtocol)
        -> UIViewController
}

final class AssemblyModule: AssemblyProtocol {
    func createMainScreenModule(withRouter router: RouterProtocol) -> UIViewController {
        let view = MoviesViewController()
        let movieAPIService = MovieAPIService()
        let presenter = MainScreenPresenter(view: view, movieAPIService: movieAPIService, router: router)
        view.presenter = presenter
        return view
    }

    func createDetailScreenModule(
        withMovie movie: Movie?,
        image: UIImage?,
        andRouter router: RouterProtocol
    ) -> UIViewController {
        let view = DetailMovieViewController()
        let movieAPIService = MovieAPIService()
        let presenter = DetailScreenPresenter(
            view: view,
            movie: movie,
            image: image,
            movieAPIService: movieAPIService,
            router: router
        )
        view.presenter = presenter
        return view
    }
}
