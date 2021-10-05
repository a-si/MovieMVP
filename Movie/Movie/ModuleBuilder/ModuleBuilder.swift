// ModuleBuilder.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol Builder {
    static func createMainScreenModule() -> UIViewController
}

final class ModuleBuilder: Builder {
    static func createMainScreenModule() -> UIViewController {
        let view = MoviesViewController()
        let presenter = MainScreenPresenter(view: view)
        view.presenter = presenter
        return view
    }
}
