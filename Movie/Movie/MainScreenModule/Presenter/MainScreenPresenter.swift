// MainScreenPresenter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol MainViewProtocol: AnyObject {
    func successToFetchMovies()
    func failToFetchMovies(withError error: Error)
}

protocol MainViewPresenterProtocol: AnyObject {
    var movies: [Movie]? { get set }
    func fetchMovies(byCategoryNumber categoryNumber: Int)
    func showDetailMovieVC(withMovie movie: Movie?)
}

final class MainScreenPresenter: MainViewPresenterProtocol {
    var movies: [Movie]?
    private var urlStrings: [URLStrings] = [.popular, .topRated, .upComing]
    private weak var view: MainViewProtocol?
    private var router: RouterProtocol?
    private var movieAPIService: MovieAPIServiceProtocol

    init(view: MainViewProtocol, movieAPIService: MovieAPIServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.movieAPIService = movieAPIService
        self.router = router
        fetchMovies()
    }

    func showDetailMovieVC(withMovie movie: Movie?) {
        router?.showDetailMovieController(withMovie: movie)
    }

    func fetchMovies(byCategoryNumber categoryNumber: Int = 0) {
        let currentURLString = urlStrings[categoryNumber]
        movieAPIService.fetchMovies(withURLString: currentURLString.rawValue) { [weak self] result in
            switch result {
            case let .success(fetchedMovies):
                self?.movies = fetchedMovies
                self?.view?.successToFetchMovies()
            case let .failure(error):
                self?.view?.failToFetchMovies(withError: error)
            }
        }
    }
}
