// MovieAPIService.swift
// Copyright © RoadMap. All rights reserved.

import Alamofire
import UIKit

protocol MovieAPIServiceProtocol {
    func fetchMovies(withURLString urlString: String, completion: @escaping (Result<[Movie]?, Error>) -> Void)

//    func fetchImage(forMovie movie: Movie?, completion: @escaping (UIImage) -> Void)
}

final class MovieAPIService: MovieAPIServiceProtocol {
    private var baseImageURLString = "https://image.tmdb.org/t/p/original"

    func fetchMovies(withURLString urlString: String, completion: @escaping (Result<[Movie]?, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        AF.request(url).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let moviesStructure = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(moviesStructure.results))
            } catch {
                completion(.failure(error))
            }
        }
    }

//    func fetchImage(forMovie movie: Movie?, completion: @escaping (UIImage) -> Void) {
//        guard let imagePath = movie?.posterPath else { return }
//        let fullImageURLString = baseImageURLString + imagePath
//        guard let imageURL = URL(string: fullImageURLString) else { return }
//        AF.request(imageURL, method: .get).validate().responseData { response in
//            guard let imageData = response.data,
//                  let movieImage = UIImage(data: imageData)
//            else {
//                completion(UIImage(named: "blackImage")!)
//                return
//            }
//            completion(movieImage)
//        }
//    }
}
