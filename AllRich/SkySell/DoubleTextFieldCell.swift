//
//  DoubleTextFieldCell.swift
//  SkySell
//
//  Created by DW02 on 5/4/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class DoubleTextFieldCell: UITableViewCell {

    
    @IBOutlet weak var imageIcon: UIImageView!
    
    
    @IBOutlet weak var tfFirstName: UITextField!
    
    @IBOutlet weak var tfLastName: UITextField!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
