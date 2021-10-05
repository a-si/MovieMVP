// MainScreenPresenter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol MainViewProtocol: class {
    func setMovies(movies: [Movie])
}

protocol MainViewPresenterProtocol: class {
    var movies: [Movie] { get set }
    func fetchMovies(byCategoryNumber categoryNumber: Int)
}

final class MainScreenPresenter: MainViewPresenterProtocol {
    private var urlStringsArray: [URLStrings] = [.popular, .topRated, .upComing]
    private weak var view: MainViewProtocol?
    var movies: [Movie] = []

    init(view: MainViewProtocol) {
        self.view = view
    }

    func fetchMovies(byCategoryNumber categoryNumber: Int) {
        let currentURLString = urlStringsArray[categoryNumber]
        MoviesFetchingController().fetchMovies(withURLString: currentURLString.rawValue) { [weak self] fetchedMovies in
            guard let fetchedMovies = fetchedMovies else {
                print("Completion Error. Can not fetch the data")
                return
            }
            DispatchQueue.main.async {
                self?.movies = fetchedMovies
                self?.view?.setMovies(movies: fetchedMovies)
            }
        }
    }
}
