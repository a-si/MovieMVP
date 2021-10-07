// DetailScreenPresenter.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol DetailViewProtocol: AnyObject {
    func set(
        descriptionForMovie movie: Movie?,
        imageForMovie image: UIImage
    )
}

protocol DetailViewPresenterProtocol: AnyObject {
    var movie: Movie? { get set }
    func fetchImageForMovie()
    func returnToMainScreen()
}

final class DetailScreenPresenter: DetailViewPresenterProtocol {
    var movie: Movie?
    private weak var view: DetailViewProtocol?
    private var router: RouterProtocol?
    private var movieAPIService: MovieAPIServiceProtocol

    init(view: DetailViewProtocol, movie: Movie?, movieAPIService: MovieAPIServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.movie = movie
        self.movieAPIService = movieAPIService
        self.router = router
    }

    func returnToMainScreen() {
        router?.popToRoot()
    }

    func fetchImageForMovie() {
        movieAPIService.fetchImage(forMovie: movie) { [weak self] image in
            self?.view?.set(
                descriptionForMovie: self?.movie,
                imageForMovie: image
            )
        }
    }
}
