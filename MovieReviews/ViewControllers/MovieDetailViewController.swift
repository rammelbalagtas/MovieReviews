//
//  MovieDetailViewController.swift
//  MovieReviews
//
//  Created by Rammel on 2022-03-14.
//

import UIKit

class MovieDetailViewController: UIViewController, UITableViewDelegate {
    
    var movieId: Int!
    var movie: MovieDetail?
    var movieCastList: [MovieCast]?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign controller as table view delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        registerNib() //register nib for table view cells
        
        //fetch movie data using movie id
        let movieEndpoint = "/movie/\(movieId!)"
        fetchMovie(endpoint: movieEndpoint, parameters: [:])
        { response in
            switch response {
            case .success(let data):
                self.movie = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        let castEndpoint = "/movie/\(movieId!)/credits"
        fetchCast(endpoint: castEndpoint, parameters: [:])
        { response in
            switch response {
            case .success(let data):
                self.movieCastList = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //Register nib for table view cells
    func registerNib() {
        //Register nib for movie detail table view cell
        let nibMovieHeader = UINib(nibName: Constants.NibName.movieHeaderTableViewCell, bundle: nil)
        tableView.register(nibMovieHeader, forCellReuseIdentifier: Constants.ReuseIdentifier.movieHeaderCell)
        let nibMovieDetail = UINib(nibName: Constants.NibName.movieDetailTableViewCell, bundle: nil)
        tableView.register(nibMovieDetail, forCellReuseIdentifier: Constants.ReuseIdentifier.movieDetailCell)
        let nibMovieCast = UINib(nibName: Constants.NibName.movieCastTableViewCell, bundle: nil)
        tableView.register(nibMovieCast, forCellReuseIdentifier: Constants.ReuseIdentifier.movieCastCell)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Detail"
        } else if section == 2 {
            return "Cast"
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 450
        }
        return tableView.rowHeight
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MovieDetailViewController: UITableViewDataSource {
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            if let movieCastList = movieCastList {
                return movieCastList.count
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let movie = movie
        else{return UITableViewCell()}
        
        switch indexPath.section {
        case 0: //Header image and description
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseIdentifier.movieHeaderCell, for: indexPath) as? MovieHeaderTableViewCell
            else{preconditionFailure("unable to dequeue cell")}
            ImageAPI.fetchMovieImage(posterPath: movie.posterPath) { response in
                switch response {
                case .success(let data):
                    DispatchQueue.main.async {
                        cell.movieImage.image = data
                        cell.movieDescriptionLabel.text = self.movie!.overview
                    }
                case .failure(let error):
                    print(error)
                }
            }
            return cell
        case 1: //Detail Table
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseIdentifier.movieDetailCell, for: indexPath) as? MovieDetailTableViewCell
            else{preconditionFailure("unable to dequeue cell")}
            switch indexPath.row {
            case 0:
                cell.dataLabel.text = "Release Date"
                cell.dataValue.text = movie.releaseDate
            case 1:
                cell.dataLabel.text = "Runtime"
                cell.dataValue.text = String(movie.runtime) + " mins"
            case 2:
                cell.dataLabel.text = "Genre"
                var genre = [String]()
                for movieGenre in movie.genres {
                    genre.append(movieGenre.name)
                }
                let formattedGenre = (genre.map{String($0)}).joined(separator: ", ")
                cell.dataValue.text = formattedGenre
            default:
                cell.dataLabel.text = ""
                cell.dataValue.text = ""
            }
            return cell
        case 2: //Cast
            
            guard
                let movieCastList = movieCastList
            else{return UITableViewCell()}
            
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseIdentifier.movieCastCell, for: indexPath) as? MovieCastTableViewCell
            else{preconditionFailure("unable to dequeue cell")}
            let movieCast = movieCastList[indexPath.row]
            cell.actorNameLabel.text = movieCast.name
            cell.characterNameLabel.text = movieCast.character
            if let profilePath = movieCast.profilePath {
                ImageAPI.fetchMovieImage(posterPath: profilePath) { response in
                    switch response {
                    case .success(let data):
                        DispatchQueue.main.async {
                            cell.castImage.image = data
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}