// Movies.swift
// Copyright © Артём Сыряный. All rights reserved.

import CoreData
import Foundation

final class Movies: Decodable {
    var results: [Movie]
}

final class Movie: Decodable {
    var overview: String
    var releaseDate: String
    var title: String
    var posterPath: String
    var category: Int16 = 0

    enum MovieCodingKeys: String, CodingKey {
        case overview
        case releaseDate = "release_date"
        case title
        case posterPath = "poster_path"
    }

    init(
        overview: String,
        releaseDate: String,
        title: String,
        posterPath: String,
        category: Int16
    ) {
        self.overview = overview
        self.releaseDate = releaseDate
        self.title = title
        self.posterPath = posterPath
        self.category = category
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: MovieCodingKeys.self)
        overview = try values.decode(String.self, forKey: MovieCodingKeys.overview)
        releaseDate = try values.decode(String.self, forKey: MovieCodingKeys.releaseDate)
        title = try values.decode(String.self, forKey: MovieCodingKeys.title)
        posterPath = try values.decode(String.self, forKey: MovieCodingKeys.posterPath)
    }
}

@objc(CoreDataMovie)
final class CoreDataMovie: NSManagedObject {
    @NSManaged var overview: String
    @NSManaged var releaseDate: String
    @NSManaged var title: String
    @NSManaged var posterPath: String
    @NSManaged var category: Int16
}
