//
//  SplitTotalTableViewCell.swift
//  tips
//
//  Created by John Spalluzzi on 12/28/15.
//  Copyright © 2015 johns. All rights reserved.
//

import UIKit

class SplitTotalTableViewCell: UITableViewCell {

    @IBOutlet weak var personCountLabel: UILabel!
    @IBOutlet weak var pricePerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
