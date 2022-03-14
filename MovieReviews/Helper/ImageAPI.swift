//
//  ImageAPI.swift
//  MovieReviews
//
//  Created by Rammel on 2022-03-14.
//

import Foundation
import UIKit

enum MovieImageResult{
    case success(UIImage)
    case failure(Error)
}

struct ImageAPI {
    
    public static let baseImageURL = "https://image.tmdb.org/t/p/"
    public static let backDropSize = "w300"

    // function to fetch actual image data based on image URL
    public static func fetchMovieImage(posterPath: String, callback: @escaping (MovieImageResult) -> Void){
        let url = "\(baseImageURL)\(backDropSize)\(posterPath)"
        APIHelper.fetch(url: URL(string: url)!) { fetchResult in
            switch fetchResult {
            case .success(let data):
                guard
                    let image = UIImage(data: data)
                else{return}
                callback(.success(image))
            case .failure(let error):
                print("there was an error fetchin information \(error)")
            }
        }
    }
}
