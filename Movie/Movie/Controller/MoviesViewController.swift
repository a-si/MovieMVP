//
//  ViewController.swift
//  Movie
//
//  Created by Артем on 28.07.2021.
//

import UIKit

final class MoviesViewController: UIViewController {
    // MARK: - Private Variables

    private var moviesArray = [Movie]()

    // MARK: - Private Contstants

    private let urlStringsArray: [URLStrings] = [.popular, .topRated, .upComing]

    private let moviesFetchingController = MoviesFetchingController()

    private let moviesSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Shows, Movies and More"
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .black
        searchBar.searchTextField.textColor = .white

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let moviesSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Popular", "Top Rated", "Up Coming"])
        segmentedControl.selectedSegmentTintColor = .darkGray
        segmentedControl.tintColor = .black
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .black
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(fetchMovies), for: .valueChanged)
        return segmentedControl
    }()

    private let moviesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Movies"
        view.backgroundColor = .black
        moviesTableView.backgroundColor = .black
        moviesTableView.separatorStyle = .none
        fetchMovies()
        addViewsToMainView()
        createConstraints()
        moviesTableView.register(MovieTableViewCell.self,
                                 forCellReuseIdentifier: MovieTableViewCell.identifier)
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
    }

    // MARK: - Private Methods

    @objc private func fetchMovies() {
        let currentURLString = urlStringsArray[moviesSegmentedControl.selectedSegmentIndex]
        print(currentURLString.rawValue)
        moviesFetchingController.fetchMovies(withURLString: currentURLString.rawValue) { fetchedMovies in
            guard let fetchedMovies = fetchedMovies else {
                print("Completion Error. Can not fetch the data")
                return
            }
            DispatchQueue.main.async {
                self.moviesArray = fetchedMovies
                self.moviesTableView.reloadData()
            }
        }
    }

    private func addViewsToMainView() {
        view.addSubview(moviesSegmentedControl)
        view.addSubview(moviesTableView)
        view.addSubview(moviesSearchBar)
    }

    private func createConstraints() {
        let safeArera = view.safeAreaLayoutGuide
        moviesSearchBar.topAnchor.constraint(equalTo: safeArera.topAnchor,
                                             constant: 10).isActive = true
        moviesSearchBar.leftAnchor.constraint(equalTo: safeArera.leftAnchor,
                                              constant: 10).isActive = true
        moviesSearchBar.rightAnchor.constraint(equalTo: safeArera.rightAnchor,
                                               constant: -10).isActive = true
        moviesSearchBar.heightAnchor.constraint(equalToConstant: 35).isActive = true

        moviesSegmentedControl.topAnchor.constraint(equalTo: moviesSearchBar.bottomAnchor,
                                                    constant: 10).isActive = true
        moviesSegmentedControl.leftAnchor.constraint(equalTo: safeArera.leftAnchor,
                                                     constant: 10).isActive = true
        moviesSegmentedControl.rightAnchor.constraint(equalTo: safeArera.rightAnchor,
                                                      constant: -10).isActive = true
        moviesSegmentedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true

        moviesTableView.topAnchor.constraint(equalTo: moviesSegmentedControl.bottomAnchor,
                                             constant: 10).isActive = true
        moviesTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        moviesTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        moviesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: - UITableViewDelegate

extension MoviesViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 250
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailMovieViewController = DetailMovieViewController()
        detailMovieViewController.movie = moviesArray[indexPath.row]
        navigationController?.pushViewController(detailMovieViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension MoviesViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return moviesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.identifier,
            for: indexPath
        ) as? MovieTableViewCell else { return UITableViewCell() }
        cell.movie = moviesArray[indexPath.row]
        cell.configure()
        return cell
    }
}
