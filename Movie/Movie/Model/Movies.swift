// Movies.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

// enum URLStrings: String {
//    case popular =
//        "https://api.themoviedb.org/3/movie/popular?api_key=ae7677e331c65fa9cf0fcbbe7e2a300d&language=ru&page=1"
//    case topRated =
//        "https://api.themoviedb.org/3/movie/top_rated?api_key=ae7677e331c65fa9cf0fcbbe7e2a300d&language=ru&page=1"
//    case upComing =
//        "https://api.themoviedb.org/3/movie/upcoming?api_key=ae7677e331c65fa9cf0fcbbe7e2a300d&language=ru&page=1"
// }
//
// struct Movies: Decodable {
//    var results: [Movie]
// }
//
//
// struct Movie: Decodable {
//    var overview: String
//    var releaseDate: String
//    var title: String
//    var posterPath: String
//
//    enum MovieCodingKeys: String, CodingKey {
//        case overview
//        case releaseDate = "release_date"
//        case title
//        case posterPath = "poster_path"
//    }
//
//    init(
//        overview: String,
//        releaseDate: String,
//        title: String,
//        posterPath: String
//    ) {
//        self.overview = overview
//        self.releaseDate = releaseDate
//        self.title = title
//        self.posterPath = posterPath
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: MovieCodingKeys.self)
//        overview = try values.decode(String.self, forKey: MovieCodingKeys.overview)
//        releaseDate = try values.decode(String.self, forKey: MovieCodingKeys.releaseDate)
//        title = try values.decode(String.self, forKey: MovieCodingKeys.title)
//        posterPath = try values.decode(String.self, forKey: MovieCodingKeys.posterPath)
//    }
// }

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

    //    convenience init(overview: String, releaseDate: String, title: String, posterPath: String)  {
    ////        self.init(overview: overview, releaseDate: releaseDate, title: title, posterPath: posterPath)
    //        self.init()
    //        self.overview = overview
    //        self.releaseDate = releaseDate
    //        self.title = title
    //        self.posterPath = posterPath
    //    }
}

// @objc(Movie)
// final class Movie: NSManagedObject, Decodable {
//    @NSManaged var overview: String
//    @NSManaged var releaseDate: String
//    @NSManaged var title: String
//    @NSManaged var posterPath: String
////    @NSManaged var category: String?
//
//    enum MovieCodingKeys: String, CodingKey {
//        case overview
//        case releaseDate = "release_date"
//        case title
//        case posterPath = "poster_path"
//    }
//
////    required convenience init(
////        overview: String,
////        releaseDate: String,
////        title: String,
////        posterPath: String
////    ) {
////        self.init(context: CoreDataService.shared.context)
////        self.overview = overview
////        self.releaseDate = releaseDate
////        self.title = title
////        self.posterPath = posterPath
////    }
//
//     init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: MovieCodingKeys.self)
//        overview = try values.decode(String.self, forKey: MovieCodingKeys.overview)
//        releaseDate = try values.decode(String.self, forKey: MovieCodingKeys.releaseDate)
//        title = try values.decode(String.self, forKey: MovieCodingKeys.title)
//        posterPath = try values.decode(String.self, forKey: MovieCodingKeys.posterPath)
//    }
// }
