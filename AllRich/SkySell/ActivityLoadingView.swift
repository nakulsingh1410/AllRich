//
//  ActivityLoadingView.swift
//  SkySell
//
//  Created by DW02 on 4/20/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class ActivityLoadingView: UIView {

    var activity:UIActivityIndicatorView! = nil
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
      
        
        let gradient:RadialGradientView = RadialGradientView(frame: CGRect(x: frame.width * -1, y: frame.height * -1, width: frame.width * 3, height: frame.height * 3))
        gradient.OutsideColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.9)
        gradient.InsideColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0.5)
        gradient.backgroundColor = UIColor.clear


        self.addSubview(gradient)
        
        
        self.activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        self.addSubview(self.activity)
        self.activity.center = CGPoint(x: frame.width/2.0, y: frame.height/2.0)
        
        self.activity.startAnimating()
        
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
   

}



class RadialGradientView: UIView {
    
    @IBInspectable var InsideColor: UIColor = UIColor.clear
    @IBInspectable var OutsideColor: UIColor = UIColor.clear
    
    
    override func draw(_ rect: CGRect) {
        let colors = [InsideColor.cgColor, OutsideColor.cgColor] as CFArray
        let endRadius = min(frame.width, frame.height) / 2
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        UIGraphicsGetCurrentContext()!.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: endRadius, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
    }
    
}



