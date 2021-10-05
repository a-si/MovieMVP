// DetailMovieViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class DetailMovieViewController: UIViewController {
    // MARK: - Private Properties

    private var baseStringOfImageURL = "https://image.tmdb.org/t/p/original"

    // MARK: - Public Properties

    var movie: Movie?

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

    // MARK: Private Methods

    private func fetchTheImage() {
        guard let imagePath = movie?.posterPath else { return }
        let fullStringOfImageURL = baseStringOfImageURL + imagePath
        guard let imageURL = URL(string: fullStringOfImageURL) else { return }
        let fetchImageTask = URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            guard let imageData = data else { return }
            guard let movieImage = UIImage(data: imageData) else { return }
            DispatchQueue.main.async {
                self.detailPosterImageView.image = movieImage
            }
        }
        fetchImageTask.resume()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTheImage()
        view.backgroundColor = .black
        view.addSubview(detailPosterImageView)
        view.addSubview(movieNameLabel)
        view.addSubview(movieDescriptionLabel)
        addPosterImageViewConstraints()
        addMovieNameLabelConstraints()
        addMovieDescriptionLabelConstraints()
        movieNameLabel.text = movie?.title
        movieDescriptionLabel.text = movie?.overview
    }
}
