//
//  CategoriesTextLabelCell.swift
//  SkySell
//
//  Created by DW02 on 5/22/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class CategoriesTextLabelCell: UICollectionViewCell {

    
    @IBOutlet weak var viBG: UIView!
    
    
    @IBOutlet weak var lbTitle: UILabel!
    
    
    let pinkColor:UIColor = UIColor(red: (3.0/255.0), green: (210.0/255.0), blue: (99.0/255.0), alpha: 1.0)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.clipsToBounds = true
        self.viBG.clipsToBounds = true
        self.viBG.layer.cornerRadius = 15
        self.viBG.backgroundColor = UIColor.white
        
        self.viBG.layer.borderWidth = 1.0
        
        self.viBG.layer.borderColor = pinkColor.cgColor
        
        self.lbTitle.textColor = pinkColor
        self.lbTitle.backgroundColor = UIColor.clear
        
        
    }
    
    
    func setToSelect(select:Bool){
        
        if(select == true){
            self.viBG.backgroundColor = pinkColor
            self.lbTitle.textColor = UIColor.white
        }else{
            self.viBG.backgroundColor = UIColor.white
            self.lbTitle.textColor = pinkColor
        }
        
        
    }

    
    
    
}
