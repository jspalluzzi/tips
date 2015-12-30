//
//  SwitchCellTableViewCell.swift
//  tips
//
//  Created by John Spalluzzi on 12/29/15.
//  Copyright © 2015 johns. All rights reserved.
//

import UIKit

class SwitchCellTableViewCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    
    @IBOutlet weak var settingsSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
