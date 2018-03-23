//
//  FacebookGoogleCell.swift
//  SkySell
//
//  Created by DW02 on 5/2/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class FacebookGoogleCell: UITableViewCell {

    
    
    
    @IBOutlet weak var viFbBG: UIView!
    
    @IBOutlet weak var viGPBG: UIView!
    
    @IBOutlet weak var btFacebook: UIButton!
    
    @IBOutlet weak var btGoogle: UIButton!
    
    
    var handleCallBack:(NSInteger)->Void = {(tag) in }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viFbBG.clipsToBounds = true
        viGPBG.clipsToBounds = true
        
        
        viFbBG.layer.cornerRadius = 2
        viGPBG.layer.cornerRadius = 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func tapOnFacebook(_ sender: UIButton) {
        self.handleCallBack(0)
    }
    

    @IBAction func tapOnGoogle(_ sender: UIButton) {
        self.handleCallBack(1)
    }
    
    
}
