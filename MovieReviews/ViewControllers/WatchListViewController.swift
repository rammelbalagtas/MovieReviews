//
//  WatchListViewController.swift
//  MovieReviews
//
//  Created by Rammel on 2022-03-10.
//

import UIKit

class WatchListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        registerNib() //register nib for table view cells

        // Do any additional setup after loading the view.
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WatchListViewController: UITableViewDataSource {
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ReuseIdentifier.watchListCell, for: indexPath) as? WatchListTableViewCell
        else{preconditionFailure("unable to dequeue cell")}
        
        cell.titleLabel.text = "This is the movie title"
        cell.yearLabel.text = "2021"
        
        return cell
        
    }
    
}
