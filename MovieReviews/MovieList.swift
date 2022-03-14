//
//  Movie.swift
//  MovieReviews
//
//  Created by Rammel on 2022-03-14.
//

import Foundation

enum MovieResult {
    case success([MovieItem])
    case failure(Error)
}

struct MovieItem : Codable {
    let id: Int
    let title: String
    let genreIds: [Int]
    let voteAverage: Float
    let posterPath: String
}

struct MovieApiResult : Codable {
    let results: [MovieItem]
    let totalPages: Int
}

func fetchMovieList(endpoint: String, parameters: [String: String]?, callback: @escaping (MovieResult) -> Void){
    guard
        let url = APIHelper.buildURL(url: APIHelper.baseURL + endpoint, parameters: parameters)
    else{return}
    
    APIHelper.fetch(url: url) { fetchResult in
        switch fetchResult {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movieApiResult = try decoder.decode(MovieApiResult.self, from: data)
                callback(.success(movieApiResult.results))
                
            } catch let e {
                print("could not parse json data \(e)")
            }
        case .failure(let error):
            print("there was an error fetchin information \(error)")
        }
    }
}
