// MoviesViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class MoviesViewController: UIViewController {
    // MARK: - Public Properties

    var presenter: MainViewPresenterProtocol!

    // MARK: - Private Variables

    private lazy var photoCacheService = PhotoCacheService(container: moviesTableView)

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

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addViewsToMainView()
        customizeUI()
        createConstraints()
        registerCell()
        setDelegateAndDataSurce()
    }

    // MARK: - Private Methods

    private func registerCell() {
        moviesTableView.register(
            MovieTableViewCell.self,
            forCellReuseIdentifier: MovieTableViewCell.identifier
        )
    }

    private func setDelegateAndDataSurce() {
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
    }

    private func customizeUI() {
        navigationItem.title = "Movies"
        view.backgroundColor = .black
        moviesTableView.backgroundColor = .black
        moviesTableView.separatorStyle = .none
    }

    @objc private func fetchMovies() {
        presenter.fetchMovies(
            byCategoryNumber:
            moviesSegmentedControl.selectedSegmentIndex
        )
    }

    private func addViewsToMainView() {
        view.addSubview(moviesSegmentedControl)
        view.addSubview(moviesTableView)
        view.addSubview(moviesSearchBar)
    }

    private func createConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        moviesSearchBar.topAnchor.constraint(
            equalTo: safeArea.topAnchor,
            constant: 10
        ).isActive = true
        moviesSearchBar.leftAnchor.constraint(
            equalTo: safeArea.leftAnchor,
            constant: 10
        ).isActive = true
        moviesSearchBar.rightAnchor.constraint(
            equalTo: safeArea.rightAnchor,
            constant: -10
        ).isActive = true
        moviesSearchBar.heightAnchor.constraint(equalToConstant: 35).isActive = true

        moviesSegmentedControl.topAnchor.constraint(
            equalTo: moviesSearchBar.bottomAnchor,
            constant: 10
        ).isActive = true
        moviesSegmentedControl.leftAnchor.constraint(
            equalTo: safeArea.leftAnchor,
            constant: 10
        ).isActive = true
        moviesSegmentedControl.rightAnchor.constraint(
            equalTo: safeArea.rightAnchor,
            constant: -10
        ).isActive = true
        moviesSegmentedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true

        moviesTableView.topAnchor.constraint(
            equalTo: moviesSegmentedControl.bottomAnchor,
            constant: 10
        ).isActive = true
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
        let selectedOptionalMovie = presenter.movies?[indexPath.row]
        guard let selectedMovie = selectedOptionalMovie else { return }
        let cachedImage = photoCacheService.photo(at: indexPath, url: selectedMovie.posterPath)
        presenter.showDetailMovieVC(withMovie: selectedMovie, andCachedImage: cachedImage)
    }
}

// MARK: - UITableViewDataSource

extension MoviesViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return presenter.movies?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.identifier,
            for: indexPath
        ) as? MovieTableViewCell else { return UITableViewCell() }
        let optionalMovie = presenter.movies?[indexPath.row]
        guard let movie = optionalMovie else { return UITableViewCell() }
        let cachedImage = photoCacheService.photo(at: indexPath, url: movie.posterPath)
        cell.accessibilityIdentifier = String(indexPath.row)
        cell.configure(withMovie: movie, andCachedImage: cachedImage)
        return cell
    }
}

// MARK: - MainViewProtocol

extension MoviesViewController: MainViewProtocol {
    func successToFetchMovies() {
        moviesTableView.reloadData()
    }

    func failToFetchMovies(withError error: Error) {
        print(error.localizedDescription)
    }
}
