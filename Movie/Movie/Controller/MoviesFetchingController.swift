//
//  MoviesFetchingController.swift
//  Movie
//
//  Created by Артем on 29.07.2021.
//

import Foundation

final class MoviesFetchingController {
    func fetchMovies(withURLString urlString: String, completion: @escaping ([Movie]?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                print("Failed to receive data from the server")
                return
            }
            let jsonDecoder = JSONDecoder()
            guard let fetchedData = try? jsonDecoder.decode(Movies.self, from: data) else {
                print("Failed to decode data")
                completion(nil)
                return
            }
            completion(fetchedData.results)
        }
        task.resume()
    }
}
