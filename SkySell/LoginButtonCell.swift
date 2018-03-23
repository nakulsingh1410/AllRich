//
//  LoginButtonCell.swift
//  SkySell
//
//  Created by DW02 on 5/2/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class LoginButtonCell: UITableViewCell {

    
    
    @IBOutlet weak var btLogin: UIButton!
    
    
    var handleCallBack:(NSInteger)->Void = {(tag) in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btLogin.clipsToBounds = true
        btLogin.layer.cornerRadius = 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func tapOnLogin(_ sender: UIButton) {
        
        self.handleCallBack(self.tag)
    }
}
