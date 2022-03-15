//
//  MovieCastTableViewCell.swift
//  MovieReviews
//
//  Created by Rammel on 2022-03-14.
//

import UIKit

class MovieCastTableViewCell: UITableViewCell {

    @IBOutlet weak var castImage: UIImageView!
    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var characterNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
