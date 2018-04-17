//
//  MenuLabelCell.swift
//  SkySell
//
//  Created by DW02 on 6/2/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class MenuLabelCell: UITableViewCell {

    
    @IBOutlet weak var lbTitle: UILabel!
    
    
    @IBOutlet weak var imAccessory: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
