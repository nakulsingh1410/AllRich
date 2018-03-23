//
//  DeletePlanCell.swift
//  SkySell
//
//  Created by DW02 on 6/30/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class DeletePlanCell: UITableViewCell {

    
    @IBOutlet weak var viImageBG: UIView!
    
    @IBOutlet weak var btDelete: UIButton!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbDetail: UILabel!
    
    
    var myTag:NSInteger = 0
    
    
    
    
    
    var lazyImage:PKImV3View! = nil
    
    
    var callBackDelete:(NSInteger)->Void = {(tag) in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lazyImage = PKImV3View(frame: CGRect(x: 0, y: 0, width: 86, height: 80))
        self.viImageBG.addSubview(self.lazyImage)
        
        
        
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func tapOnDelete(_ sender: UIButton) {
        
        self.callBackDelete(self.myTag)
    }
    
    
}
