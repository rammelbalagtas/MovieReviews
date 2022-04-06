//
//  MovieHeaderTableViewCell.swift
//  MovieReviews
//
//  Created by Rammel on 2022-03-14.
//

import UIKit

protocol MovieHeaderTableCellDelegate {
    func displayReviewScreen()
}

class MovieHeaderTableViewCell: UITableViewCell {
    
    var delegate: MovieHeaderTableCellDelegate?

    @IBOutlet weak var tapInstructionLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var addReviewsButton: UIButton!
    
    @IBAction func addReviewsAction(_ sender: UIButton) {
        delegate?.displayReviewScreen()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
