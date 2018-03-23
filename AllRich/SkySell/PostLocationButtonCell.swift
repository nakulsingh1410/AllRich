//
//  PostLocationButtonCell.swift
//  SkySell
//
//  Created by DW02 on 5/18/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class PostLocationButtonCell: UITableViewCell {

    @IBOutlet weak var viTextBoxBG: UIView!
    
    
    @IBOutlet weak var myTextField: UITextField!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.viTextBoxBG.clipsToBounds = true
        self.viTextBoxBG.layer.cornerRadius = 4
        
        self.myTextField.isUserInteractionEnabled = false
        
        
    }
    
    
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
