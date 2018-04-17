//
//  ConditionCell.swift
//  SkySell
//
//  Created by DW02 on 5/18/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class ConditionCell: UITableViewCell {

    
    
    enum ActionOn{
        case left
        case right
    }
    
    
    @IBOutlet weak var btLeft: UIButton!
    
    @IBOutlet weak var btRight: UIButton!
    
    var callBack:(_ tapOn:ActionOn)->Void = {(tapOn) in }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.clipsToBounds = true
        self.btLeft.clipsToBounds = true
        self.btRight.clipsToBounds = true
        
        
        self.btLeft.layer.cornerRadius = 4
        self.btLeft.layer.borderColor = UIColor(red: (3/255), green: (210/255), blue: (99/255), alpha: 1.0).cgColor
        self.btLeft.layer.borderWidth = 1
        
        
        
        self.btRight.layer.cornerRadius = 4
        self.btRight.layer.borderColor = UIColor(red: (3/255), green: (210/255), blue: (99/255), alpha: 1.0).cgColor
        self.btRight.layer.borderWidth = 1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    
    @IBAction func tapOnLeft(_ sender: UIButton) {
        
        self.callBack(ConditionCell.ActionOn.left)
    }
    
    @IBAction func tapOnRight(_ sender: UIButton) {
        
        self.callBack(ConditionCell.ActionOn.right)
    }
    
    
    func setButtonHighlightTo(status:ActionOn) {
        if(status == .left){
            self.btLeft.backgroundColor = UIColor(red: (3/255), green: (210/255), blue: (99/255), alpha: 1.0)
            self.btLeft.setTitleColor(UIColor.white, for: UIControlState.normal)
            
            
            self.btRight.backgroundColor = UIColor.clear
            self.btRight.setTitleColor(UIColor(red: (3/255), green: (210/255), blue: (99/255), alpha: 1.0), for: UIControlState.normal)
            
        }else{
            self.btRight.backgroundColor = UIColor(red: (3/255), green: (210/255), blue: (99/255), alpha: 1.0)
            self.btRight.setTitleColor(UIColor.white, for: UIControlState.normal)
            
            
            self.btLeft.backgroundColor = UIColor.clear
            self.btLeft.setTitleColor(UIColor(red: (3/255), green: (210/255), blue: (99/255), alpha: 1.0), for: UIControlState.normal)
            
        }
        
    }
    
    
}
