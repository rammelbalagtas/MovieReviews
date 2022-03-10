//
//  ViewController.swift
//  MovieReviews
//
//  Created by Rammel on 2022-03-10.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBAction func switchMovieCategory(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            APIHelper.fetch(endpoint: "/movie/popular", parameters: ["page": "1"])
        case 1:
            APIHelper.fetch(endpoint: "/movie/now_playing", parameters: ["page": "1"])
        case 2:
            APIHelper.fetch(endpoint: "/movie/top_rated", parameters: ["page": "1"])
        case 3:
            APIHelper.fetch(endpoint: "/movie/upcoming", parameters: ["page": "1"])
        default:
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Default selection
        APIHelper.fetch(endpoint: "/movie/popular", parameters: ["page": "1"])
    }

}

