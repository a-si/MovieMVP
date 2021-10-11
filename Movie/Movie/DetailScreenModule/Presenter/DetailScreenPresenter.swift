// DetailScreenPresenter.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol DetailViewProtocol: AnyObject {
    func set(
        movie: Movie?,
        imageForMovie image: UIImage?
    )
}

protocol DetailViewPresenterProtocol: AnyObject {
    var movie: Movie? { get set }
    func setMovieAndImage()
    func returnToMainScreen()
}

final class DetailScreenPresenter: DetailViewPresenterProtocol {
    var movie: Movie?
    private weak var view: DetailViewProtocol?
    private var router: RouterProtocol?
    private var image: UIImage?

    init(
        view: DetailViewProtocol,
        movie: Movie?,
        image: UIImage?,
        movieAPIService _: MovieAPIServiceProtocol,
        router: RouterProtocol
    ) {
        self.view = view
        self.image = image
        self.movie = movie
        self.router = router
    }

    func returnToMainScreen() {
        router?.popToRoot()
    }

    func setMovieAndImage() {
        view?.set(movie: movie, imageForMovie: image)
    }
}
