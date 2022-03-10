//
//  ViewController.swift
//  MovieReviews
//
//  Created by Rammel on 2022-03-10.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        
        // Register nib for the UI of the collection view cell
        registerNib()
        
        //assign view controller as delegate for the collection view
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //Register nib for collection view and table view cells
    func registerNib() {
        
        //Register nib for collection view
        let nib = UINib(nibName: Constants.NibName.movieCollectionViewCell, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: Constants.ReuseIdentifier.movieCollectionCell)
        if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 90, height: 120)
        }
        
    }

}

extension HomeViewController: UICollectionViewDataSource{
    
    //collection view cells count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000 //dummy count
    }
    
    //data per collection view cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ReuseIdentifier.movieCollectionCell, for: indexPath) as? MovieCollectionViewCell {
            return cell
        }
        return UICollectionViewCell()
    }
    
}

