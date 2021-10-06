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
}

final class DetailScreenPresenter: DetailViewPresenterProtocol {
    var movie: Movie?

    private weak var view: DetailViewProtocol?

    init(view: DetailViewProtocol, movie: Movie?) {
        self.view = view
        self.movie = movie
    }

    func fetchImageForMovie() {
        MovieAPIService().fetchImage(forMovie: movie) { [weak self] image in
            self?.view?.set(
                descriptionForMovie: self?.movie,
                imageForMovie: image
            )
        }
    }
}
