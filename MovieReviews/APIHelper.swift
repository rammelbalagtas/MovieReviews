//
//  APIHelper.swift
//  MovieReviews
//
//  Created by Rammel on 2022-03-10.
//

import Foundation

struct APIHelper {
    
    private static let baseURL = "https://api.themoviedb.org/3"
    private static let apiKey = "f15b84be817740631eb028aeb8bb2754"
    
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    //prepare URL using API key and additional parameters
    private static func tmdbURL(url: String, parameters: [String: String]?) -> URL? {
        var components = URLComponents(string: url)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "api_key": apiKey,
            "language": "en-US"
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    static func fetch(endpoint: String, parameters: [String: String]?){
        guard
            let url = tmdbURL(url: baseURL + endpoint, parameters: parameters)
        else{return}
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            data, request, error in
            
            if let data = data {
                do{
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    guard
                        let jsonDictionary = jsonObject as? [AnyHashable: Any],
                        let results = jsonDictionary["results"] as? [[String:Any]]
                    else{preconditionFailure("was not able to parse JSON data")}
                    print(results)
                } catch let e {
                    print("could not serialize json data \(e)")
                }
            } else if let error = error {
                print("something went wrong when fetching. ERROR \(error)")
            } else {
                print("unknown error has occured")
            }
        }
        task.resume()
    }
}
