//
//  WatchListViewController.swift
//  MovieReviews
//
//  Created by Rammel on 2022-03-10.
//

import UIKit
import CoreData

class WatchListViewController: UIViewController, UITableViewDelegate {
    
    var persistentContainer: NSPersistentContainer!
    var watchList = [Movie]()
    var inProgressMovies = [Movie]()
    var completedMovies = [Movie]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        registerNib() //register nib for table view cells

//        // Do any additional setup after loading the view
//        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    //Register nib for table view cells
    func registerNib() {
        //Register nib for movie detail table view cell
        let nibWatchList = UINib(nibName: Constants.NibName.watchListTableViewCell, bundle: nil)
        tableView.register(nibWatchList, forCellReuseIdentifier: Constants.ReuseIdentifier.watchListCell)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "In Progress"
        } else if section == 1 {
            return "Completed"
        } else {
            return nil
        }
    }
    
    private func fetchData() {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        let moc = persistentContainer.viewContext
        guard
            let results = try? moc.fetch(request)
        else {return}
        watchList = results
        inProgressMovies = results.filter{ $0.isCompleted == false}
        completedMovies = results.filter{ $0.isCompleted == true}
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dst = segue.destination as? MovieDetailViewController {
            dst.movieId = Int(watchList[(tableView.indexPathForSelectedRow?.row)!].id)
            dst.persistentContainer = persistentContainer
        }
    }

}

extension WatchListViewController: UITableViewDataSource {
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return inProgressMovies.count
        } else {
            return completedMovies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseIdentifier.watchListCell, for: indexPath) as? WatchListTableViewCell
        else{preconditionFailure("unable to dequeue cell")}
        
        var movie: Movie!
        if indexPath.section == 0 {
            movie = inProgressMovies[indexPath.row]
        } else {
            movie = completedMovies[indexPath.row]
        }
        cell.titleLabel.text = movie.title
        cell.yearLabel.text = movie.year
        cell.movieImageView.image = UIImage(data: movie.image!)
        return cell
        
    }
    
}
