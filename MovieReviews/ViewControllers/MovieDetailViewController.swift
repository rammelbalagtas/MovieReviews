//
//  MovieDetailViewController.swift
//  MovieReviews
//
//  Created by Rammel on 2022-03-14.
//

import UIKit
import CoreData

class MovieDetailViewController: UIViewController, UITableViewDelegate {
    
    var movieId: Int!
    var movie: MovieDetail?
    var movieCastList: [MovieCast]?
    var persistentContainer: NSPersistentContainer!
    var movieImage: UIImage?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign controller as table view delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        registerNib() //register nib for table view cells
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
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
    
    //to make the rows not selected
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //handler method for the double tap
    @objc func imageDoubleTapped() {
        
        var message = ""
        let movieExist = updateWatchList()
        if movieExist {
            message = "Movie removed watchlist/favorites"
        } else {
            message = "Movie added to watchlist/favorites"
        }
        
        let alertController = UIAlertController(title: "", message: message , preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    private func fetchMovieFromDB() -> Movie? {
        let request = Movie.fetchRequest() as NSFetchRequest<Movie>
        let id = Int32(truncatingIfNeeded: movie!.id)
        let predicate = NSPredicate(format: "abs(id) == %d", id)
        
        request.predicate = predicate
        let moc = persistentContainer.viewContext
        guard
            let results = try? moc.fetch(request)
        else {return nil}
        if results.isEmpty {
            return nil
        } else {
            return results[0]
        }
    }
    
    //add or remove from watchlist
    private func updateWatchList() -> Bool {
        
        var movieExist = true
        
        let moc = self.persistentContainer.viewContext
        if let movie = fetchMovieFromDB() {
            //remove from watchlist
            moc.delete(movie)
        } else {
            //add to watchlist
            let movie = Movie(context: moc)
            movie.id = Int32(truncatingIfNeeded: self.movie!.id)
            movie.title = self.movie?.title
            movie.image = self.movieImage?.jpegData(compressionQuality: 1.0)
            movie.year = String(self.movie!.releaseDate.prefix(4))
            movieExist = false
        }
        
        moc.perform {
            do {
                try moc.save()
            } catch {
                moc.rollback()
            }
        }
        return movieExist
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let dst = segue.destination as? MovieReviewViewController {
             dst.persistentContainer = persistentContainer
             dst.movieId = movieId
         }
     }
     
    
}

extension MovieDetailViewController: UITableViewDataSource, MovieHeaderTableCellDelegate {
    
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
            cell.movieDescriptionLabel.text = self.movie!.overview
            cell.movieImage.image = nil
            if let posterPath = movie.posterPath {
                ImageAPI.fetchMovieImage(posterPath: posterPath) { response in
                    switch response {
                    case .success(let data):
                        DispatchQueue.main.async {
                            cell.movieImage.image = data
                            self.movieImage = data
                            let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageDoubleTapped))
                            tap.numberOfTapsRequired = 2
                            cell.movieImage.addGestureRecognizer(tap)
                            cell.delegate = self
                            //hide the button if movie is not added to watchlist
                            if let _ = self.fetchMovieFromDB() {
                                cell.addReviewsButton.alpha = 1
                            } else {
                                cell.addReviewsButton.alpha = 0
                            }
                            
                        }
                    case .failure(let error):
                        print(error)
                    }
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
    
    func displayReviewScreen() {
        performSegue(withIdentifier: "showMovieReview", sender: self)
    }
    
    
}
