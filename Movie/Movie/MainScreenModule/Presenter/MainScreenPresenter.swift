// MainScreenPresenter.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

protocol MainViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol MainViewPresenterProtocol: AnyObject {
    var movies: [Movie]? { get set }
    func fetchMovies(byCategoryNumber categoryNumber: Int)
}

final class MainScreenPresenter: MainViewPresenterProtocol {
    private var urlStrings: [URLStrings] = [.popular, .topRated, .upComing]
    private weak var view: MainViewProtocol?
    var movies: [Movie]?

    init(view: MainViewProtocol) {
        self.view = view
    }

    func fetchMovies(byCategoryNumber categoryNumber: Int) {
        let currentURLString = urlStrings[categoryNumber]
        MovieAPIService().fetchMovies(withURLString: currentURLString.rawValue) { [weak self] result in
            switch result {
            case let .success(fetchedMovies):
                self?.movies = fetchedMovies
                self?.view?.success()
            case let .failure(error):
                self?.view?.failure(error: error)
            }
        }
    }
}
