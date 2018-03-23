//
//  SerialNoCell.swift
//  SkySell
//
//  Created by DW02 on 21/11/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class SerialNoCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSerialNo: UILabel!
    
    @IBOutlet weak var lbAmount: UILabel!
    
    
    
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
