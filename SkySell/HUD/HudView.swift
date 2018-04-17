//
//  HudView.swift
//  MedStaff
//
//  Created by ds on 06/10/17.
//  Copyright © 2017 Dotsquares. All rights reserved.
//


import UIKit

class HudView: UIView {
    
    @IBOutlet var loaderImageView: UIActivityIndicatorView!
    @IBOutlet var hudTitle: UILabel!
    var title: String?
    fileprivate static var instance: HudView!
    
    internal static var sharedInstance: HudView {
        if(instance == nil){
            instance = (Bundle.main.loadNibNamed("HudView", owner: self, options: nil)?[0] as? HudView)
        }
        return instance;
    }
    
    override func draw(_ rect: CGRect) {
        if let loaderTitle = title {
            //hudTitle.text = loaderTitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
         loaderImageView.stopAnimating()
    }
   

}
