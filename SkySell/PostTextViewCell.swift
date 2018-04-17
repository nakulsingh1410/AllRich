//
//  PostTextViewCell.swift
//  SkySell
//
//  Created by DW02 on 5/18/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class PostTextViewCell: UITableViewCell {

    @IBOutlet weak var viTextBG: UIView!
    
    
    @IBOutlet weak var tfPlaceholder: UITextField!
    
    @IBOutlet weak var tvInput: UITextView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.viTextBG.clipsToBounds = true
        self.viTextBG.layer.cornerRadius = 4
        
        
        self.tfPlaceholder.isUserInteractionEnabled = false
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
