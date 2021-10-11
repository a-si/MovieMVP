// UnitTests.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
@testable import Movie
import XCTest

class MockView: MainViewProtocol {
    func successToFetchMovies() {}
    func failToFetchMovies(withError _: Error) {}
}

@objc(CoreDataMovie)
final class MockCoreDataMovie: NSManagedObject {
    @NSManaged var overview: String
    @NSManaged var releaseDate: String
    @NSManaged var title: String
    @NSManaged var posterPath: String
    @NSManaged var category: Int16
}

class MockMovieAPIService: MovieAPIServiceProtocol {
    var movies: [Movie]!

    init() {}

    convenience init(movies: [Movie]?) {
        self.init()
        self.movies = movies
    }

    func fetchMovies(withURLString _: String, completion: @escaping (Result<[Movie]?, Error>) -> Void) {
        if let movies = movies {
            completion(.success(movies))
        } else {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }
}

class UnitTests: XCTestCase {
    var view: MockView!
    var presenter: MainScreenPresenter!
    var movieAPIService: MovieAPIServiceProtocol!
    var router: RouterProtocol!
    var movies = [Movie]()
    var coreDataPresenter: DataPresenter<CoreDataRepository>!
    let coreData = CoreDataService.shared
    
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try coreData.context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                coreData.context.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }

    override func setUpWithError() throws {
        let navigationController = UINavigationController()
        let assembly = AssemblyModule()
        router = Router(navigationController: navigationController, assemblyBuilder: assembly)
    }

    override func tearDownWithError() throws {
        view = nil
        movieAPIService = nil
        presenter = nil
        coreDataPresenter = nil
        deleteAllData("CoreDataMovie")
    }

    func testSuccessNetworkGettingMovies() {
        let movie = Movie(overview: "Foo", releaseDate: "Baz", title: "Bar", posterPath: "Bar", category: 0)
        movies.append(movie)

        view = MockView()
        movieAPIService = MockMovieAPIService(movies: movies)
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

    func testFailNetworkGettingMovies() {
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

    func testSuccessRepositorySavingMovies() {
        deleteAllData("CoreDataMovie")
        let movie = Movie(overview: "Foo", releaseDate: "Baz", title: "Bar", posterPath: "Bar", category: 0)

        let testMovies = [Movie(overview: "Foo", releaseDate: "Baz", title: "Bar", posterPath: "Bar", category: 0)]

        coreDataPresenter = DataPresenter(moviesDatabase: CoreDataRepository())
        coreDataPresenter.saveMovies(movies: [movie])
        let savedMovies = coreDataPresenter.getMovies(forCategoryNumber: 0)
        XCTAssertEqual(savedMovies?.first?.title, testMovies.first?.title)
        XCTAssertNotNil(savedMovies)
    }

    func testFailRepositorySavingMovies() {
        deleteAllData("CoreDataMovie")
        let movie = Movie(overview: "Bar", releaseDate: "Baz", title: "Baz", posterPath: "Foo", category: 0)

        let testMovies = [Movie(overview: "Foo", releaseDate: "Baz", title: "Foo", posterPath: "Bar", category: 0)]

        coreDataPresenter = DataPresenter(moviesDatabase: CoreDataRepository())
        coreDataPresenter.saveMovies(movies: [movie])
        let savedMovies = coreDataPresenter.getMovies(forCategoryNumber: 0)
        XCTAssertNotEqual(savedMovies?.first?.title, testMovies.first?.title)
    }
}
