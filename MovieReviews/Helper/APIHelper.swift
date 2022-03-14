//
//  APIHelper.swift
//  MovieReviews
//
//  Created by Rammel on 2022-03-10.
//

import Foundation

enum FetchResult {
    case success(Data)
    case failure(Error)
}

struct APIHelper {
    
    public static let baseURL = "https://api.themoviedb.org/3"
    private static let apiKey = "f15b84be817740631eb028aeb8bb2754"
    
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    //prepare URL using API key and additional parameters
    public static func buildURL(url: String, parameters: [String: String]?) -> URL? {
        var components = URLComponents(string: url)!
        var queryItems = [URLQueryItem]()
        
        //always add API key to query items
        let item = URLQueryItem(name: "api_key", value: apiKey)
        queryItems.append(item)
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    //generic fetch method
    public static func fetch(url: URL, callback: @escaping (FetchResult) -> Void){
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            data, request, error in
            
            if let data = data {
                callback(.success(data))
            } else if let error = error{
                callback(.failure(error))
            }
        }
        task.resume()
    }
}
