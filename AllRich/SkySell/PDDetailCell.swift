//
//  PDDetailCell.swift
//  SkySell
//
//  Created by DW02 on 5/26/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class PDDetailCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDetail: UILabel!
    
    
    
    
    /*
 
     |-22-[lbTitle]-8-[lbDetail]-22|
     |-------  157  --
 
 
 */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
