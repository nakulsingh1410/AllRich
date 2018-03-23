//
//  PlanCell.swift
//  SkySell
//
//  Created by DW02 on 6/29/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class PlanCell: UICollectionViewCell {

    
    @IBOutlet weak var viContentBG: UIView!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var btUpgrade: UIButton!
    
    @IBOutlet weak var lbDetail: UILabel!
    
    
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbPlanName: UILabel!
    
    @IBOutlet weak var viImageBG: UIView!
    
    var lazyImage:PKImV3View! = nil
    
    
    var myTag:NSInteger = 0
    
    
    var callBackUpgrade:(NSInteger)->Void = {(tag) in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if(self.lazyImage == nil){
            self.lazyImage = PKImV3View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            self.viImageBG.addSubview(self.lazyImage)
        }
        self.lazyImage.imageView.contentMode = .scaleAspectFit
        
        self.viImageBG.clipsToBounds = true
    }

    func updateCellSize(size:CGSize) {
        
        let imH:CGFloat = size.height - (95 + 140 + 108)
        let imW:CGFloat = size.width - (20 + 60)
        
        self.lazyImage.updateFrame(newFrame: CGRect(x: 0, y: 0, width: imW, height: imH))
        
        
        
    }
    
    @IBAction func tapOnUpGrade(_ sender: UIButton) {
        self.callBackUpgrade(self.myTag)
    }
    
    
    
}
