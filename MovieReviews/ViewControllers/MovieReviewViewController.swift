//
//  MovieReviewViewController.swift
//  MovieReviews
//
//  Created by Rammel on 2022-04-06.
//

import UIKit
import CoreData

class MovieReviewViewController: UIViewController {
    
    var persistentContainer: NSPersistentContainer!
    var movie: Movie?
    var movieId: Int!

    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var markAsCompleteBtn: UIButton!
    
    @IBAction func saveAction(_ sender: Any) {
        movie!.review = reviewTextView.text
        updateMovie(movie: movie!)
        displayMessage(message: "Movie reviews has been saved")
    }
    
    @IBAction func markAsCompleteAction(_ sender: UIButton) {
        movie!.isCompleted = true
        updateMovie(movie: movie!)
        displayMessage(message: "Movie has been marked as completed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetch movie
        movie = fetchMovieFromDB(movieId: movieId)
        reviewTextView.text = movie!.review
        
        //add border to textview
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        reviewTextView.layer.borderWidth = 0.5
        reviewTextView.layer.borderColor = borderColor.cgColor
        reviewTextView.layer.cornerRadius = 5.0
    }
    
    private func fetchMovieFromDB(movieId: Int) -> Movie? {
        let request = Movie.fetchRequest() as NSFetchRequest<Movie>
        let id = Int32(truncatingIfNeeded: movieId)
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
    
    private func updateMovie(movie: Movie) {
        let moc = self.persistentContainer.viewContext
        moc.perform {
            do {
                try moc.save()
            } catch {
                moc.rollback()
            }
        }
    }
    
    private func displayMessage(message: String) {
        let alertController = UIAlertController(title: "", message: message , preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
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
