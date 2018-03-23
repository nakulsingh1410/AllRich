//
//  ProductSubCategoryCell.swift
//  SkySell
//
//  Created by DW02 on 4/19/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class ProductSubCategoryCell: UICollectionViewCell {

    
    @IBOutlet weak var viBG: UIView!
    
    
    var cellHeight:CGFloat = 118.0
    var cellWidth:CGFloat = 98.0
    
    var viContent:UIView! = nil
    
    var lazyImage:PKImV3View! = nil
    
    var lbTitle: UILabel!
    
    
    var viOverlay:UIView! = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        if(self.viContent == nil){
            self.viContent = UIView(frame: CGRect(x: 5, y: 15, width: 88, height: 88))
            self.viBG.addSubview(self.viContent)
            self.viContent.backgroundColor = UIColor.black
            self.viContent.clipsToBounds = true
            self.viContent.layer.cornerRadius = 4
            
        }
        
        
        if(self.lazyImage == nil){
            self.lazyImage = PKImV3View(frame: CGRect(x: 0, y: 0, width: 88, height: 88))
            self.viContent.addSubview(self.lazyImage)
            //self.lazyImage.updateFrame(newFrame: CGRect(x: 0, y: 0, width: 88, height: 88))
            self.lazyImage.imageView.contentMode = .scaleAspectFill
        }
        
        
        if(self.viOverlay == nil){
            self.viOverlay = UIView(frame:CGRect(x: 0, y: 0, width: 88, height: 88))
            self.viOverlay.isUserInteractionEnabled = false
            self.viOverlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            self.viContent.addSubview(self.viOverlay)
        }
        
        
        
        
        if(self.lbTitle == nil){
            self.lbTitle = UILabel(frame: CGRect(x: 4, y: 20, width: 80, height: 48))
            self.lbTitle.font = UIFont(name: "Avenir-Medium", size: 14)
            self.lbTitle.textColor = UIColor.white
            self.lbTitle.textAlignment = .center
            self.lbTitle.numberOfLines = 0
            self.viContent.addSubview(self.lbTitle)
        }
        
        
        self.lbTitle.layer.shadowColor = UIColor(red: (39.0/255.0), green: (47.0/255.0), blue: (85.0/255.0), alpha: 1.0).cgColor
        
        self.lbTitle.layer.shadowOpacity = 0.95
        self.lbTitle.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.lbTitle.layer.shadowRadius = 1
        
        
        
        
        self.viBG.clipsToBounds = true
        self.viBG.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.viBG.layer.shadowRadius = 3
        self.viBG.layer.shadowColor = UIColor.black.cgColor
        self.viBG.layer.shadowOpacity = 0
        
        //self.setStatusToHighlight(highlight: true)
    }
    
    func setStatusToHighlight(highlight:Bool, Animation animation:Bool) {
        
        if(animation == false){
            if(highlight == true){
                self.viContent.frame = CGRect(x: 5, y: 5, width: 88, height: 88)
                self.viBG.layer.shadowOpacity = 0.75
            }else{
                self.viContent.frame = CGRect(x: 5, y: 15, width: 88, height: 88)
                self.viBG.layer.shadowOpacity = 0
            }
        }else{
            
            UIView.animate(withDuration: 0.25, animations: { 
                if(highlight == true){
                    self.viContent.frame = CGRect(x: 5, y: 5, width: 88, height: 88)
                    self.viBG.layer.shadowOpacity = 0.75
                }else{
                    self.viContent.frame = CGRect(x: 5, y: 15, width: 88, height: 88)
                    self.viBG.layer.shadowOpacity = 0
                }
            })
        }
        
    }

}
