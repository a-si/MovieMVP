// AppDelegate.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _:
        [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupURLCache()
        customizeAppAppearance()
        print("APP. COUNT OF CORE DATA MOVIES = ", CoreDataRepository().getMovies()?.count ?? "nil")
        var movieTitles: [String] = []
        let savedMovies = CoreDataRepository().getMovies()
        if let savedMovies = savedMovies {
            movieTitles = savedMovies.map { $0.title }
        }
        print("APP. COUNT OF MOVIE TITLES!!! = \(movieTitles.count)")
        print(movieTitles)
        return true
    }

    private func setupURLCache() {
        let temporaryDirectory = NSTemporaryDirectory()
        let urlCache = URLCache(
            memoryCapacity: 75_000_000,
            diskCapacity: 100_000_000,
            diskPath: temporaryDirectory
        )
        URLCache.shared = urlCache
    }

    private func customizeAppAppearance() {
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false

        UISegmentedControl.appearance()
            .setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
