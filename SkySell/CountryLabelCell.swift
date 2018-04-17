//
//  CountryLabelCell.swift
//  SkySell
//
//  Created by DW02 on 5/23/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class CountryLabelCell: UITableViewCell {

    
    
    @IBOutlet weak var lbTitle: UILabel!
    
    
    @IBOutlet weak var imageFlag: UIImageView!
    
    @IBOutlet weak var viLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
