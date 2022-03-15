//
//  Movie.swift
//  MovieReviews
//
//  Created by Rammel on 2022-03-14.
//

import Foundation

enum MovieListResult {
    case success([MovieListItem])
    case failure(Error)
}

struct MovieListApiResult : Codable {
    let results: [MovieListItem]
    let totalPages: Int
}

struct MovieListItem : Codable {
    let id: Int
    let title: String
    let voteAverage: Float
    let posterPath: String
}

enum MovieDetailResult {
    case success(MovieDetail)
    case failure(Error)
}

struct MovieDetail : Codable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let runtime: Int
    let posterPath: String
    let genres: [Genre]
}

struct Genre : Codable {
    let id: Int
    let name: String
}

// Fetch list of movies
func fetchMovieList(endpoint: String, parameters: [String: String]?, callback: @escaping (MovieListResult) -> Void){
    guard
        let url = APIHelper.buildURL(url: APIHelper.baseURL + endpoint, parameters: parameters)
    else{return}
    
    APIHelper.fetch(url: url) { fetchResult in
        switch fetchResult {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movieApiResult = try decoder.decode(MovieListApiResult.self, from: data)
                callback(.success(movieApiResult.results))
            } catch let e {
                print("could not parse json data \(e)")
            }
        case .failure(let error):
            print("there was an error fetchin information \(error)")
        }
    }
}

//Fetch details of movie
func fetchMovie(endpoint: String, parameters: [String: String]?, callback: @escaping (MovieDetailResult) -> Void){
    guard
        let url = APIHelper.buildURL(url: APIHelper.baseURL + endpoint, parameters: parameters)
    else{return}
    
    APIHelper.fetch(url: url) { fetchResult in
        switch fetchResult {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                callback(.success(movieDetail))
            } catch let e {
                print("could not parse json data \(e)")
            }
        case .failure(let error):
            print("there was an error fetchin information \(error)")
        }
    }
}
