// MainScreenPresenter.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol MainViewProtocol: AnyObject {
    func successToFetchMovies()
    func failToFetchMovies(withError error: Error)
}

protocol MainViewPresenterProtocol: AnyObject {
    var movies: [Movie]? { get set }
    func fetchMovies(byCategoryNumber categoryNumber: Int)
    func showDetailMovieVC(withMovie: Movie?, andCachedImage image: UIImage?)
}

final class MainScreenPresenter: MainViewPresenterProtocol {
    var movies: [Movie]?
    private var urlStrings: [URLStrings] = [.popular, .topRated, .upComing]
    private weak var view: MainViewProtocol?
    private var router: RouterProtocol?
    private var movieAPIService: MovieAPIServiceProtocol
    private var coreDataPresenter = DataPresenter(moviesDatabase: CoreDataRepository())
    
    init(view: MainViewProtocol, movieAPIService: MovieAPIServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.movieAPIService = movieAPIService
        self.router = router
        fetchMovies()
    }
    
    func showDetailMovieVC(withMovie movie: Movie?, andCachedImage image: UIImage?) {
        router?.showDetailMovieController(withMovie: movie, andCachedImage: image)
    }
    
    func fetchFromRepository(byCategoryNumber categoryNumber: Int = 0) {
        let movies = coreDataPresenter.getMovies(forCategoryNumber: Int16(categoryNumber))
        self.movies = movies
        view?.successToFetchMovies()
    }
    
    func fetchMovies(byCategoryNumber categoryNumber: Int = 0) {
        let savedMovies = coreDataPresenter.getMovies(forCategoryNumber: Int16(categoryNumber))
        if let savedMovies = savedMovies,
           !savedMovies.isEmpty {
            fetchFromRepository(byCategoryNumber: categoryNumber)
        }
        fetchMoviesFromNetwork(byCategoryNumber: categoryNumber)
    }
    
    func fetchMoviesFromNetwork(byCategoryNumber categoryNumber: Int = 0) {
        let currentURLString = urlStrings[categoryNumber]
        movieAPIService.fetchMovies(withURLString: currentURLString.rawValue) { [weak self] result in
            switch result {
            case let .success(fetchedMovies):
                if let fetchedMovies = fetchedMovies {
                    fetchedMovies.forEach { $0.category = Int16(categoryNumber) }
                }
                self?.movies = fetchedMovies
                self?.coreDataPresenter.saveMovies(movies: fetchedMovies)
                self?.view?.successToFetchMovies()
            case let .failure(error):
                self?.view?.failToFetchMovies(withError: error)
            }
        }
    }
}
