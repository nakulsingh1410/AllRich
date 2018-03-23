//
//  MapPopUpView.swift
//  SkySell
//
//  Created by supapon pucknavin on 6/3/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class MapPopUpView: UIView {

    

    var viImageUserBG:UIView! = nil
    var userD:UIImageView! = nil
    var userImage:PKImV3View! = nil
    
    var lbName:UILabel! = nil
    var lbProductName:UILabel! = nil
    var lbPrice:UILabel! = nil
    
    var viImProductBG:UIView! = nil
    var productImage:PKImV3View! = nil
    var productD:UIImageView! = nil
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpView(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpView(frame:CGRect) {
        
        viImageUserBG = UIView(frame: CGRect(x: 14, y: 14, width: 50, height: 50))
        self.addSubview(viImageUserBG)
        viImageUserBG.clipsToBounds = true
        viImageUserBG.layer.cornerRadius = 25
        
        userD = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        viImageUserBG.addSubview(userD)
        userD.image = UIImage(named: "iconProfileEmptyState.png")
        userD.contentMode = .center
        
        
        userImage = PKImV3View(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        viImageUserBG.addSubview(userImage)
        
     
        let labelW:CGFloat = frame.width - (70 + 14 + 56 + 6)
        
        lbName = UILabel(frame: CGRect(x: 70, y: 14, width:labelW, height: 20))
        lbName.font = UIFont(name: "Avenir-Medium", size: 12)
        lbName.textColor = UIColor(red: (88/255), green: (116/255), blue: (234/255), alpha: 1.0)
        self.addSubview(lbName)
        
        
        lbProductName = UILabel(frame: CGRect(x: 70, y: 40, width:labelW, height: 24))
        lbProductName.font = UIFont(name: "Avenir-Medium", size: 14)
        lbProductName.textColor = UIColor(red: (39/255), green: (47/255), blue: (85/255), alpha: 1.0)
        self.addSubview(lbProductName)
        
        
        lbPrice = UILabel(frame: CGRect(x: 70, y: 70, width:labelW, height: 20))
        lbPrice.font = UIFont(name: "Avenir-Medium", size: 12)
        lbPrice.textColor = UIColor(red: (3/255), green: (210/255), blue: (99/255), alpha: 1.0)
        self.addSubview(lbPrice)
        
        
        viImProductBG = UIView(frame: CGRect(x: frame.width - (14 + 56 + 6), y: 14, width: 56, height: 56))
        self.addSubview(viImProductBG)
        viImProductBG.clipsToBounds = true
        viImProductBG.layer.cornerRadius = 2
        
        
        productD = UIImageView(frame: CGRect(x: 0, y: 0, width: 56, height: 56))
        viImProductBG.addSubview(productD)
        productD.image = UIImage(named: "imgDefault.png")
        productD.contentMode = .center
        
        
        productImage = PKImV3View(frame: CGRect(x: 0, y: 0, width: 56, height: 56))
        viImProductBG.addSubview(productImage)
    }
}
