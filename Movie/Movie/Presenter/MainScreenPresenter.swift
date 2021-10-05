// MainScreenPresenter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol MainViewProtocol: class {
    func setMovies(movies: [Movie])
}

protocol MainViewPresenterProtocol: class {
    var movies: [Movie] { get set }
    func fetchMovies(byCategoryNumber categoryNumber: Int)
    init(view: MainViewProtocol)
}

final class MainScreenPresenter: MainViewPresenterProtocol {
    var urlStringsArray: [URLStrings] = [.popular, .topRated, .upComing]
    var moviesFetchingController = MoviesFetchingController()
    weak var view: MainViewProtocol?
    var movies: [Movie] = []

    required init(view: MainViewProtocol) {
        self.view = view
    }

    func fetchMovies(byCategoryNumber categoryNumber: Int) {
        let currentURLString = urlStringsArray[categoryNumber]
        moviesFetchingController.fetchMovies(withURLString: currentURLString.rawValue) { fetchedMovies in
            guard let fetchedMovies = fetchedMovies else {
                print("Completion Error. Can not fetch the data")
                return
            }
            DispatchQueue.main.async {
                self.movies = fetchedMovies
                self.view?.setMovies(movies: fetchedMovies)
            }
        }
    }
}
