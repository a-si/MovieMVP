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
//    func showDetailMovieVC(withMovie movie: Movie?)
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

//    func showDetailMovieVC(withMovie movie: Movie?) {
//        router?.showDetailMovieController(withMovie: movie)
//    }
    func showDetailMovieVC(withMovie movie: Movie?, andCachedImage image: UIImage?) {
        router?.showDetailMovieController(withMovie: movie, andCachedImage: image)
    }

    func fetchFromRepository(byCategoryNumber categoryNumber: Int = 0) {
        let movies = coreDataPresenter.getMovies(forCategoryNumber: Int16(categoryNumber))
        self.movies = movies
        view?.successToFetchMovies()
    }

    //
//    func fetchFromRepo(byCategoryNumber categoryNumber: Int = 0, completion: @escaping ([Movie]?) -> Void) {
//        DispatchQueue.global().async {
//            let savedMovies = self.coreDataPresenter.getMovies(forCategoryNumber: Int16(categoryNumber))
//            if let savedMovies = savedMovies,
//               !savedMovies.isEmpty
//            {
//                //                self.movies = savedMovies
//                completion(savedMovies)
//            } else {
//                completion(nil)
//            }
//        }
//    }
//
//    func fetchMovies(byCategoryNumber categoryNumber: Int = 0) {
//        fetchFromRepo { movies in
//            if let movies = movies {
//                DispatchQueue.main.async {
//                    self.movies = movies
//                    self.view?.successToFetchMovies()
//                }
//            } else {
//                self.fetchFromNetwork(byCategoryNumber: categoryNumber)
//            }
//        }
//    }

//    func fetchMovies(byCategoryNumber categoryNumber: Int = 0) {
//        DispatchQueue.global().async {
//            let savedMovies = self.coreDataPresenter.getMovies(forCategoryNumber: Int16(categoryNumber))
//            if let savedMovies = savedMovies {
//                self.movies = savedMovies
//                DispatchQueue.main.async {
//                    self.view?.successToFetchMovies()
//                }
//                self.fetchFromNetwork(byCategoryNumber: categoryNumber)
//            } else {
//                self.fetchFromNetwork(byCategoryNumber: categoryNumber)
//            }
//        }
//    }

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
