// MainScreenPresenterTest.swift
// Copyright © RoadMap. All rights reserved.

@testable import Movie
import XCTest

class MockView: MainViewProtocol {
    func successToFetchMovies() {}
    func failToFetchMovies(withError error: Error) {}
}

class MockMovieAPIService: MovieAPIServiceProtocol {
    var movies: [Movie]!

    init() {}

    convenience init(movies: [Movie]?) {
        self.init()
        self.movies = movies
    }

    func fetchMovies(withURLString urlString: String, completion: @escaping (Result<[Movie]?, Error>) -> Void) {
        if let movies = movies {
            completion(.success(movies))
        } else {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }

    func fetchImage(forMovie movie: Movie?, completion: @escaping (UIImage) -> Void) {}
}

class MainScreenPresenterTest: XCTestCase {
    var view: MockView!
    var presenter: MainScreenPresenter!
    var movieAPIService: MovieAPIServiceProtocol!
    var router: RouterProtocol!
    var movies = [Movie]()

    override func setUpWithError() throws {
        let navigationController = UINavigationController()
        let assembly = AssemblyModuleBuilder()

        router = Router(navigationController: navigationController, assemblyBuilder: assembly)
    }

    override func tearDownWithError() throws {
        view = nil
        movieAPIService = nil
        presenter = nil
    }

    func testSuccessToGetMovies() {
        let movie = Movie(overview: "Foo", releaseDate: "Baz", title: "Bar", posterPath: "Bar")
        movies.append(movie)

        view = MockView()
        movieAPIService = MockMovieAPIService(movies: [movie])
        presenter = MainScreenPresenter(view: view, movieAPIService: movieAPIService, router: router)

        var catchedMovies: [Movie]?

        movieAPIService.fetchMovies(withURLString: "Test") { result in
            switch result {
            case let .success(movies):
                catchedMovies = movies
            case let .failure(error):
                print(error)
            }
        }
        XCTAssertNotEqual(catchedMovies?.count, 0)
        XCTAssertEqual(catchedMovies?.count, movies.count)
    }

    func testFailToGetMovies() {
        let movie = Movie(overview: "Foo", releaseDate: "Baz", title: "Bar", posterPath: "Bar")
        movies.append(movie)

        view = MockView()
        movieAPIService = MockMovieAPIService()
        presenter = MainScreenPresenter(view: view, movieAPIService: movieAPIService, router: router)

        var catchedError: Error?

        movieAPIService.fetchMovies(withURLString: "Test") { result in
            switch result {
            case .success:
                break
            case let .failure(error):
                catchedError = error
            }
        }
        XCTAssertNotNil(catchedError)
    }
}
