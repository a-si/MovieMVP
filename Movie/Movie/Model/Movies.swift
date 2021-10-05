// Movies.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

enum URLStrings: String {
    case popular =
        "https://api.themoviedb.org/3/movie/popular?api_key=ae7677e331c65fa9cf0fcbbe7e2a300d&language=ru&page=1"
    case topRated =
        "https://api.themoviedb.org/3/movie/top_rated?api_key=ae7677e331c65fa9cf0fcbbe7e2a300d&language=ru&page=1"
    case upComing =
        "https://api.themoviedb.org/3/movie/upcoming?api_key=ae7677e331c65fa9cf0fcbbe7e2a300d&language=ru&page=1"
}

struct Movies: Decodable {
    var results: [Movie]
}

struct Movie: Decodable {
    var overview: String
    var releaseDate: String
    var title: String
    var posterPath: String

    enum MovieCodingKeys: String, CodingKey {
        case overview
        case releaseDate = "release_date"
        case title
        case posterPath = "poster_path"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: MovieCodingKeys.self)
        overview = try values.decode(String.self, forKey: MovieCodingKeys.overview)
        releaseDate = try values.decode(String.self, forKey: MovieCodingKeys.releaseDate)
        title = try values.decode(String.self, forKey: MovieCodingKeys.title)
        posterPath = try values.decode(String.self, forKey: MovieCodingKeys.posterPath)
    }
}
