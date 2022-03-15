//
//  MovieDetailViewCellTableViewCell.swift
//  MovieReviews
//
//  Created by Rammel on 2022-03-14.
//

import UIKit

class MovieDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var dataValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
