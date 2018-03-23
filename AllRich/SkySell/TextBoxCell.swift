//
//  TextBoxCell.swift
//  SkySell
//
//  Created by DW02 on 5/4/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class TextBoxCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    
    
    @IBOutlet weak var viTextFrameBG: UIView!
    
    @IBOutlet weak var myTextview: UITextView!
    
    
    @IBOutlet weak var lbTextCount: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
        self.viTextFrameBG.clipsToBounds = true
        self.viTextFrameBG.layer.borderWidth = 1
        self.viTextFrameBG.layer.cornerRadius = 2
        self.viTextFrameBG.layer.borderColor = UIColor(red: (39.0/255.0), green: (47.0/255.0), blue: (85.0/255.0), alpha: 1.0).cgColor
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
}
