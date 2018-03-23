//
//  ButtonCell.swift
//  SkySell
//
//  Created by DW02 on 5/11/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {

    @IBOutlet weak var myButton: UIButton!
    
    
    
    var callBack:()->Void = {() in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.myButton.clipsToBounds = true
        self.myButton.layer.cornerRadius = 2
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tapOnButton(_ sender: UIButton) {
        
        self.callBack()
    }
}
