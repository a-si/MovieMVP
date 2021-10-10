// DetailMovieViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class DetailMovieViewController: UIViewController {
    // MARK: - Public Properties

    var presenter: DetailViewPresenterProtocol!

    // MARK: - Private Properties

    private var detailPosterImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var movieNameLabel: UILabel = {
        let movieNameLabel = UILabel()
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        movieNameLabel.font = .boldSystemFont(ofSize: 17)
        movieNameLabel.textColor = .white
        movieNameLabel.layer.masksToBounds = true
        movieNameLabel.numberOfLines = 0
        movieNameLabel.textAlignment = .center
        return movieNameLabel
    }()

    private var movieDescriptionLabel: UILabel = {
        let movieDescriptionLabel = UILabel()
        movieDescriptionLabel.adjustsFontSizeToFitWidth = true
        movieDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        movieDescriptionLabel.font = .systemFont(ofSize: 17)
        movieDescriptionLabel.layer.masksToBounds = true
        movieDescriptionLabel.textAlignment = .center
        movieDescriptionLabel.numberOfLines = 0
        movieDescriptionLabel.textColor = .white
        return movieDescriptionLabel
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addViewsToMainView()
        addConstraints()
        setupUI()
        fetchImageForMovie()
    }

    // MARK: Private Methods

    private func setupUI() {
        view.backgroundColor = .black
    }

    private func addViewsToMainView() {
        view.addSubview(detailPosterImageView)
        view.addSubview(movieNameLabel)
        view.addSubview(movieDescriptionLabel)
    }

    private func addConstraints() {
        addPosterImageViewConstraints()
        addMovieNameLabelConstraints()
        addMovieDescriptionLabelConstraints()
    }

    private func fetchImageForMovie() {
        presenter.fetchImageForMovie()
    }

    private func addPosterImageViewConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        detailPosterImageView.topAnchor.constraint(
            equalTo: safeArea.topAnchor,
            constant: 20
        ).isActive = true
        detailPosterImageView.leftAnchor.constraint(
            equalTo: view.leftAnchor,
            constant: 80
        ).isActive = true
        detailPosterImageView.rightAnchor.constraint(
            equalTo: view.rightAnchor,
            constant: -80
        ).isActive = true
        detailPosterImageView.heightAnchor.constraint(
            equalToConstant: view.bounds.height / 2 - 100
        ).isActive = true
    }

    private func addMovieNameLabelConstraints() {
        movieNameLabel.topAnchor.constraint(
            equalTo: detailPosterImageView.bottomAnchor,
            constant: 15
        ).isActive = true
        movieNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        movieNameLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        movieNameLabel.leftAnchor.constraint(
            equalTo: view.leftAnchor,
            constant: 30
        ).isActive = true
        movieNameLabel.rightAnchor.constraint(
            equalTo: view.rightAnchor,
            constant: -30
        ).isActive = true
    }

    private func addMovieDescriptionLabelConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        movieDescriptionLabel.topAnchor.constraint(
            equalTo: movieNameLabel.bottomAnchor,
            constant: 5
        ).isActive = true
        movieDescriptionLabel.leftAnchor.constraint(
            equalTo: safeArea.leftAnchor,
            constant: 30
        ).isActive = true
        movieDescriptionLabel.rightAnchor.constraint(
            equalTo: safeArea.rightAnchor,
            constant: -30
        ).isActive = true
        movieDescriptionLabel.bottomAnchor.constraint(
            equalTo: safeArea.bottomAnchor,
            constant: 1
        ).isActive = true
    }
}

// MARK: - DetailViewProtocol

extension DetailMovieViewController: DetailViewProtocol {
    func set(descriptionForMovie movie: Movie?, imageForMovie image: UIImage?) {
        detailPosterImageView.image = image
        movieNameLabel.text = movie?.title
        movieDescriptionLabel.text = movie?.overview
    }
}
