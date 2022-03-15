//
//  Constants.swift
//  MovieReviews
//
//  Created by Rammel on 2022-03-10.
//

import Foundation

struct Constants {
    
    //reuse identifier for custom nibs
    struct ReuseIdentifier {
        static let movieCollectionCell = "MovieCollectionCellReuseIdentifier"
        static let movieHeaderCell = "movieheader"
        static let movieDetailCell = "moviedetail"
        static let movieCastCell = "moviecast"
    }
    
    //custom nib for table view/collection view cells
    struct NibName {
        static let movieCollectionViewCell = "MovieCollectionViewCell"
        static let movieHeaderTableViewCell = "MovieHeaderTableViewCell"
        static let movieDetailTableViewCell = "MovieDetailTableViewCell"
        static let movieCastTableViewCell = "MovieCastTableViewCell"
    }
}
