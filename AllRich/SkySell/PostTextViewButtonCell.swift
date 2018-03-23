//
//  PostTextViewButtonCell.swift
//  SkySell
//
//  Created by supapon pucknavin on 5/18/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class PostTextViewButtonCell: UITableViewCell {

    
    @IBOutlet weak var viTextBoxBG: UIView!
    
    
    @IBOutlet weak var myTextField: UITextField!
    
    @IBOutlet weak var myTextView: UITextView!
    
    @IBOutlet weak var imageAccessory: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.myTextField.isUserInteractionEnabled = false
        self.myTextView.isUserInteractionEnabled = false
        
        
        self.viTextBoxBG.clipsToBounds = true
        self.viTextBoxBG.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
