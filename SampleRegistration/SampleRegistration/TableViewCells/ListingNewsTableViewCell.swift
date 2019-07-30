//
//  ListingNewsTableViewCell.swift
//  SampleRegistration
//
//  Created by hassan on 29/07/19.
//  Copyright © 2019 hassan. All rights reserved.
//

import UIKit

class ListingNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageForListing: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
