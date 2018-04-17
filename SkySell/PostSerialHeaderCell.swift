//
//  PostSerialHeaderCell.swift
//  SkySell
//
//  Created by DW02 on 20/11/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class PostSerialHeaderCell: UITableViewCell {

    @IBOutlet weak var viSerialBG: UIView!
    
    @IBOutlet weak var viAmountBG: UIView!
    
    @IBOutlet weak var btDelete: UIButton!
    
    
    @IBOutlet weak var tfSeial: UITextField!
    @IBOutlet weak var tfAmount: UITextField!
    
    
    var myTag:NSInteger = 0
    
    
    var callBackDelete:(NSInteger)->Void = {(tag) in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.viSerialBG.clipsToBounds = true
        self.viSerialBG.layer.cornerRadius = 4
        
        
        self.viAmountBG.clipsToBounds = true
        self.viAmountBG.layer.cornerRadius = 4
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tapOnDelete(_ sender: Any) {
        self.callBackDelete(self.myTag)
    }
}
