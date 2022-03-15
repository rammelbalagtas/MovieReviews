//
//  CastList.swift
//  MovieReviews
//
//  Created by Rammel on 2022-03-14.
//

import Foundation

enum MovieCastResult {
    case success([MovieCast])
    case failure(Error)
}

struct MovieCastApiResult : Codable {
    let cast: [MovieCast]
}

struct MovieCast : Codable {
    let name: String
    let character: String
    let profilePath: String?
}

//Fetch list of casts
func fetchCast(endpoint: String, parameters: [String: String]?, callback: @escaping (MovieCastResult) -> Void){
    guard
        let url = APIHelper.buildURL(url: APIHelper.baseURL + endpoint, parameters: parameters)
    else{return}
    
    APIHelper.fetch(url: url) { fetchResult in
        switch fetchResult {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movieCastApiResult = try decoder.decode(MovieCastApiResult.self, from: data)
                callback(.success(movieCastApiResult.cast))
            } catch let e {
                print("could not parse json data \(e)")
            }
        case .failure(let error):
            print("there was an error fetchin information \(error)")
        }
    }
}

