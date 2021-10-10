// MovieTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class MovieTableViewCell: UITableViewCell {
    // MARK: Static Constants

    static let identifier = "MovieTableViewCell"

    // MARK: Private Variables

    private let movieBackgroundView: UIView = {
        let movieBackgroundView = UIView()
        movieBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        movieBackgroundView.layer.cornerRadius = 15
        movieBackgroundView.layer.masksToBounds = true
        movieBackgroundView.layer.borderWidth = 3
        movieBackgroundView.layer.borderColor = UIColor.darkGray.cgColor
        return movieBackgroundView
    }()

    private var posterImageView: UIImageView = {
        let posterImageView = UIImageView()
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.layer.masksToBounds = true
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 15
        return posterImageView
    }()

    private var movieNameLabel: UILabel = {
        let movieNameLabel = UILabel()
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        movieNameLabel.font = .boldSystemFont(ofSize: 18)
        movieNameLabel.adjustsFontSizeToFitWidth = true
        movieNameLabel.textColor = .white
        movieNameLabel.numberOfLines = 0
        movieNameLabel.textAlignment = .center
        return movieNameLabel
    }()

    private var movieDescriptionLabel: UILabel = {
        let movieDescriptionLabel = UILabel()
        movieDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        movieDescriptionLabel.font = .systemFont(ofSize: 15)
        movieDescriptionLabel.textAlignment = .center
        movieDescriptionLabel.numberOfLines = 0
        movieDescriptionLabel.textColor = .white
        movieDescriptionLabel.contentMode = .right
        return movieDescriptionLabel
    }()

    private var movieReleaseDateLabel: UILabel = {
        let movieReleaseDateLabel = UILabel()
        movieReleaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        movieReleaseDateLabel.font = .boldSystemFont(ofSize: 14)
        movieReleaseDateLabel.textAlignment = .center
        movieReleaseDateLabel.textColor = .white
        movieReleaseDateLabel.textAlignment = .right
        return movieReleaseDateLabel
    }()

    private var movieRateLabel: UILabel = {
        let movieReleaseDateLabel = UILabel()
        movieReleaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        movieReleaseDateLabel.font = .boldSystemFont(ofSize: 23)
        movieReleaseDateLabel.tintColor = .lightGray
        movieReleaseDateLabel.layer.borderWidth = 1
        movieReleaseDateLabel.layer.borderColor = UIColor.yellow.cgColor
        movieReleaseDateLabel.contentMode = .center
        return movieReleaseDateLabel
    }()

    // MARK: Private Methods

    private func addBackgroundViewConstraints() {
        movieBackgroundView.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: 5
        ).isActive = true
        movieBackgroundView.leftAnchor.constraint(
            equalTo: contentView.leftAnchor,
            constant: 10
        ).isActive = true
        movieBackgroundView.rightAnchor.constraint(
            equalTo: contentView.rightAnchor,
            constant: -10
        ).isActive = true
        movieBackgroundView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -5
        ).isActive = true
    }

    private func addPosterImageViewConstraints() {
        posterImageView.topAnchor.constraint(equalTo: movieBackgroundView.topAnchor).isActive = true
        posterImageView.leftAnchor.constraint(equalTo: movieBackgroundView.leftAnchor).isActive = true
        posterImageView.bottomAnchor.constraint(equalTo: movieBackgroundView.bottomAnchor).isActive = true
        posterImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }

    private func addMovieNameLabelConstraints() {
        movieNameLabel.topAnchor.constraint(
            equalTo: movieBackgroundView.topAnchor,
            constant: 5
        ).isActive = true
        movieNameLabel.leftAnchor.constraint(
            equalTo: posterImageView.rightAnchor,
            constant: 20
        ).isActive = true
        movieNameLabel.rightAnchor.constraint(
            equalTo: movieBackgroundView.rightAnchor,
            constant: -20
        ).isActive = true
        movieNameLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }

    private func addMovieDescriptionLabelConstraints() {
        movieDescriptionLabel.topAnchor.constraint(
            equalTo: movieNameLabel.bottomAnchor,
            constant: 5
        ).isActive = true
        movieDescriptionLabel.leftAnchor.constraint(
            equalTo: posterImageView.rightAnchor,
            constant: 10
        ).isActive = true
        movieDescriptionLabel.rightAnchor.constraint(
            equalTo: movieBackgroundView.rightAnchor,
            constant: -10
        ).isActive = true
        movieDescriptionLabel.bottomAnchor.constraint(
            equalTo: movieBackgroundView.bottomAnchor,
            constant: -30
        ).isActive = true
    }

    private func addMovieReleaseDateLabelConstraints() {
        movieReleaseDateLabel.topAnchor.constraint(
            equalTo: movieDescriptionLabel.bottomAnchor,
            constant: 5
        ).isActive = true
        movieReleaseDateLabel.rightAnchor.constraint(
            equalTo: movieBackgroundView.rightAnchor,
            constant: -10
        ).isActive = true
        movieReleaseDateLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }

    private func addMovieRateLabelConstraints() {
        movieBackgroundView.rightAnchor.constraint(
            equalTo: posterImageView.rightAnchor,
            constant: -40
        ).isActive = true
        movieBackgroundView.bottomAnchor.constraint(
            equalTo: posterImageView.bottomAnchor,
            constant: -40
        ).isActive = true
        movieBackgroundView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        movieBackgroundView.widthAnchor.constraint(equalToConstant: 15).isActive = true
    }

    private func addSubViewsToBackgroundView() {
        movieBackgroundView.addSubview(posterImageView)
        movieBackgroundView.addSubview(movieNameLabel)
        movieBackgroundView.addSubview(movieDescriptionLabel)
        movieBackgroundView.addSubview(movieReleaseDateLabel)
    }

    func configure(withMovie movie: Movie, andCachedImage image: UIImage?) {
        movieNameLabel.text = movie.title
        movieDescriptionLabel.text = movie.overview
        posterImageView.image = image
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .black
        selectionStyle = .none
        contentView.addSubview(movieBackgroundView)
        addSubViewsToBackgroundView()
        addBackgroundViewConstraints()
        addPosterImageViewConstraints()
        addMovieNameLabelConstraints()
        addMovieDescriptionLabelConstraints()
        addMovieReleaseDateLabelConstraints()
    }
}
