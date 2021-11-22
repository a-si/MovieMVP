// MainScreenPresenter.swift
// Copyright © Артём Сыряный. All rights reserved.

import UIKit

private enum URLStrings: String {
    case popular =
        "https://api.themoviedb.org/3/movie/popular?api_key=ae7677e331c65fa9cf0fcbbe7e2a300d&language=ru&page=1"
    case topRated =
        "https://api.themoviedb.org/3/movie/top_rated?api_key=ae7677e331c65fa9cf0fcbbe7e2a300d&language=ru&page=1"
    case upComing =
        "https://api.themoviedb.org/3/movie/upcoming?api_key=ae7677e331c65fa9cf0fcbbe7e2a300d&language=ru&page=1"
}

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
    private var router: RouterProtocol
    private var movieAPIService: MovieAPIServiceProtocol
    private var coreDataPresenter: DataPresenter<CoreDataRepository>
    init(
        view: MainViewProtocol,
        movieAPIService: MovieAPIServiceProtocol,
        router: RouterProtocol,
        coreDataPresenter: DataPresenter<CoreDataRepository>
    ) {
        self.view = view
        self.movieAPIService = movieAPIService
        self.router = router
        self.coreDataPresenter = coreDataPresenter
        fetchMovies()
    }

    func showDetailMovieVC(withMovie movie: Movie?, andCachedImage image: UIImage?) {
        router.showDetailMovieController(withMovie: movie, andCachedImage: image)
    }

    func fetchFromRepository(byCategoryNumber categoryNumber: Int = 0) {
        let movies = coreDataPresenter.getMovies(forCategoryNumber: Int16(categoryNumber))
        self.movies = movies
        view?.successToFetchMovies()
        
        // сделал что-то неправильно
    }

    func fetchMovies(byCategoryNumber categoryNumber: Int = 0) {
        let savedMovies = coreDataPresenter.getMovies(forCategoryNumber: Int16(categoryNumber))
        if let savedMovies = savedMovies,
           !savedMovies.isEmpty
        {
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
