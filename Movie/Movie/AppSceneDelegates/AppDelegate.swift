// AppDelegate.swift
// Copyright © Артём Сыряный. All rights reserved.

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
