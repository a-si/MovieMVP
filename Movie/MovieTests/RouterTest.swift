// RouterTest.swift
// Copyright © RoadMap. All rights reserved.

@testable import Movie
import XCTest

class MockNavigationController: UINavigationController {
    var presentedVC: UIViewController?

    override func pushViewController(_ viewController: UIViewController, animated _: Bool) {
        presentedVC = viewController
        super.pushViewController(viewController, animated: true)
    }
}

class RouterTest: XCTestCase {
    var router: RouterProtocol!
    var navigationController = MockNavigationController()
    let assembly = AssemblyModule()

    override func setUpWithError() throws {
        router = Router(navigationController: navigationController, assemblyBuilder: assembly)
    }

    override func tearDownWithError() throws {
        router = nil
    }

    func testRouter() {
        router.showDetailMovieController(withMovie: nil, andCachedImage: UIImage(named: "blackImage"))
        let detailViewController = navigationController.presentedVC
        XCTAssertTrue(detailViewController is DetailMovieViewController)
    }
}
