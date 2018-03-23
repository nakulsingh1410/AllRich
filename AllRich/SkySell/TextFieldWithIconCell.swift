//
//  TextFieldWithIconCell.swift
//  SkySell
//
//  Created by DW02 on 5/4/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class TextFieldWithIconCell: UITableViewCell {

    
    @IBOutlet weak var imageIcon: UIImageView!
    
    @IBOutlet weak var tfInput: UITextField!
    @IBOutlet weak var button: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
        button.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
