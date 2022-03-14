//
//  ViewController.swift
//  MovieReviews
//
//  Created by Rammel on 2022-03-10.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate {
    
    var movieList = [MovieItem]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func switchMovieCategory(_ sender: UISegmentedControl) {
        var endpoint: String
        switch sender.selectedSegmentIndex {
        case 0:
            endpoint = "/movie/popular"
        case 1:
            endpoint = "/movie/now_playing"
        case 2:
            endpoint = "/movie/top_rated"
        case 3:
            endpoint = "/movie/upcoming"
        default:
            endpoint = "/movie/popular"
        }
        fetchMovieList(endpoint: endpoint, parameters: ["page": "1"])
        { response in
            switch response {
            case .success(let data):
                self.movieList = data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Default selection
        fetchMovieList(endpoint: "/movie/popular", parameters: ["page": "1"])
        { response in
            switch response {
            case .success(let data):
                self.movieList = data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
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
        movieList.count
    }
    
    //data per collection view cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ReuseIdentifier.movieCollectionCell, for: indexPath) as? MovieCollectionViewCell {
            
            let movie = movieList[indexPath.row]
            ImageAPI.fetchMovieImage(posterPath: movie.posterPath) { response in
                switch response {
                case .success(let data):
                    DispatchQueue.main.async {
                        cell.movieImage.image = data
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
}

