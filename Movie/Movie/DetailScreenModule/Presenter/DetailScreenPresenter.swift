// DetailScreenPresenter.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol DetailViewProtocol: AnyObject {
    func set(
        descriptionForMovie movie: Movie?,
        imageForMovie image: UIImage?
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
    private var image: UIImage?
    private var movieAPIService: MovieAPIServiceProtocol

    init(
        view: DetailViewProtocol,
        movie: Movie?,
        image: UIImage?,
        movieAPIService: MovieAPIServiceProtocol,
        router: RouterProtocol
    ) {
        self.view = view
        self.image = image
        self.movie = movie
        self.movieAPIService = movieAPIService
        self.router = router
    }

    func returnToMainScreen() {
        router?.popToRoot()
    }

    func fetchImageForMovie() {
        view?.set(descriptionForMovie: movie, imageForMovie: image)
    }
}
