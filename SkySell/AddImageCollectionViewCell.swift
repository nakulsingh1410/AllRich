//
//  AddImageCollectionViewCell.swift
//  SkySell
//
//  Created by DW02 on 5/17/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import QuartzCore

class AddImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viBackgroud: UIView!
    
    @IBOutlet weak var imageBG: UIImageView!
   
    //var tapGesture:UILongPressGestureRecognizer! = nil
    
    var lazyImage:PKImV3View! = nil
    
    var border:CAShapeLayer! = nil
    
    
    var cellTag:NSInteger = -1
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if(self.border == nil){
            border = CAShapeLayer()
            border.strokeColor = UIColor(red: (39/255), green: (47/255), blue: (85/255), alpha: 1.0).cgColor
            border.fillColor = UIColor.clear.cgColor
            
          
            border.lineDashPattern = [NSNumber(value: 2), NSNumber(value: 1)]
            
            
            self.viBackgroud.layer.addSublayer(border)
            
            border.path = UIBezierPath(rect: self.viBackgroud.bounds).cgPath
            border.frame = self.viBackgroud.bounds
        }
        
        
        
        
        if(self.lazyImage == nil){
            self.lazyImage = PKImV3View(frame: CGRect(x: 0, y: 0, width: 90, height: 99))
            self.viBackgroud.addSubview(self.lazyImage)
            self.lazyImage.backgroundColor = UIColor.clear
            //self.lazyImage.updateFrame(newFrame: CGRect(x: 0, y: 0, width: 88, height: 88))
        }
        
        viBackgroud.clipsToBounds = true
        viBackgroud.layer.cornerRadius = 2
        
        
        
        //self.tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(AddImageCollectionViewCell.doubleTapGesture(sender:)))
        //self.tapGesture.numberOfTapsRequired = 2
    
        //self.viBackgroud.addGestureRecognizer(tapGesture)
        
        
        

    }
    
    
    
    func updateCellSize(size:CGSize) {
        
        
        self.lazyImage.updateFrame(newFrame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.border.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height)).cgPath
        self.border.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
       
        
    }
    
    func doubleTapGesture(sender:UILongPressGestureRecognizer) {
        
        let object:[String:NSInteger] = ["CellTag": cellTag]
        
        print("UILongPressGestureRecognizer \(cellTag) ")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tapOpenImageWithIndex"), object: nil, userInfo: object)
    }
    
    

}
