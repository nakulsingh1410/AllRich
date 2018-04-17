//
//  PostTextFieldCell.swift
//  SkySell
//
//  Created by supapon pucknavin on 5/17/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class PostTextFieldCell: UITableViewCell {

    
    @IBOutlet weak var viTextBG: UIView!
    
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var button: UIButton!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viTextBG.clipsToBounds = true
        self.viTextBG.layer.cornerRadius = 4
        button.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
