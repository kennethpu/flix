//
//  MoviesTableViewCell.swift
//  flix
//
//  Created by Kenneth Pu on 9/20/15.
//  Copyright © 2015 Kenneth Pu. All rights reserved.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var criticsIcon: UIImageView!
    @IBOutlet weak var criticsScoreLabel: UILabel!
    @IBOutlet weak var audienceIcon: UIImageView!
    @IBOutlet weak var audienceScoreLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.posterImageView.image = nil
    }

}
