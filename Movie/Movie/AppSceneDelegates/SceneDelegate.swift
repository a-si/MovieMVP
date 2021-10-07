// SceneDelegate.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene, willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController()
        let assemblyBuilder = AssemblyModule()
        let router = Router(navigationController: navigationController, assemblyBuilder: assemblyBuilder)
        router.setInitialViewController()
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
