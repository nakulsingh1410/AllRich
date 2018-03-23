//
//  MeetTheSellerCell.swift
//  SkySell
//
//  Created by DW02 on 5/26/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class MeetTheSellerCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    
    
    @IBOutlet weak var viUserImageBG: UIView!
    
    
    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbDetail: UILabel!
    
    
    @IBOutlet weak var viLine: UIView!
    
    
    @IBOutlet weak var viEmotionBG: UIView!
    
    @IBOutlet weak var lbSmile: UILabel!
    
    @IBOutlet weak var lbNormal: UILabel!
    
    @IBOutlet weak var lbSad: UILabel!
    
    
    var layzyImage:PKImV3View! = nil
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
        self.viUserImageBG.clipsToBounds = true
        self.viUserImageBG.layer.cornerRadius = 25
        
        
        if(self.layzyImage == nil){
            self.layzyImage = PKImV3View(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            self.viUserImageBG.addSubview(self.layzyImage)
          
        }
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
