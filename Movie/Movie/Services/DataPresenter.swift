// DataPresenter.swift
// Copyright © Артём Сыряный. All rights reserved.

import CoreData
import Foundation

protocol DatabaseProtocol {
    associatedtype Entity

    func getMovies(forCategoryNumber categoryNumber: Int16) -> [Entity]?
    func saveMovies(movies: [Entity]?)
}

final class CoreDataRepository: DatabaseProtocol {
    typealias Entity = Movie

    let coreData = CoreDataService.shared
    var movieTitles: [String] = []

    func getMovies() -> [CoreDataMovie]? {
        let movies = try? coreData.context.fetch(CoreDataMovie.fetchRequest()) as? [CoreDataMovie]
        return movies
    }

    func getMovies(forCategoryNumber categoryNumber: Int16) -> [Movie]? {
        let coreDataMovies = try? coreData.context.fetch(CoreDataMovie.fetchRequest()) as? [CoreDataMovie]
        var movies: [Movie] = []
        if let coreDataMovies = coreDataMovies {
            for coreDataMovie in coreDataMovies where coreDataMovie.category == categoryNumber {
                let movie = Movie(
                    overview: coreDataMovie.overview,
                    releaseDate: coreDataMovie.releaseDate,
                    title: coreDataMovie.title,
                    posterPath: coreDataMovie.posterPath,
                    category: coreDataMovie.category
                )
                movies.append(movie)
            }
        }
        return movies
    }

    func saveMovies(movies: [Movie]?) {
        guard let movies = movies else { return }
        let savedMovies = getMovies()

        if let savedMovies = savedMovies {
            movieTitles = savedMovies.map { $0.title }
        }

        for movie in movies {
            guard !movieTitles.contains(movie.title) else { continue }
            let contextMovie = CoreDataMovie(context: coreData.context)
            contextMovie.overview = movie.overview
            contextMovie.releaseDate = movie.releaseDate
            contextMovie.title = movie.title
            contextMovie.posterPath = movie.posterPath
            contextMovie.category = movie.category
            coreData.saveContext()
        }
    }

    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        return paths[0]
    }
}

final class DataPresenter<DatabaseEntity: DatabaseProtocol> {
    var moviesDatabase: DatabaseEntity

    init(moviesDatabase: DatabaseEntity) {
        self.moviesDatabase = moviesDatabase
    }

    func getMovies(forCategoryNumber categoryNumber: Int16) -> [DatabaseEntity.Entity]? {
        return moviesDatabase.getMovies(forCategoryNumber: categoryNumber)
    }

    func saveMovies(movies: [DatabaseEntity.Entity]?) {
        moviesDatabase.saveMovies(movies: movies)
    }
}
