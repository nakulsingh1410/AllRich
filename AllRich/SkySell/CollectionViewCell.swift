//
//  CollectionViewCell.swift
//  SkySell
//
//  Created by supapon pucknavin on 4/16/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viImageBG: UIView!
    @IBOutlet weak var lazyImage: PKImV3View!
    
    @IBOutlet weak var layout_TextHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var btFollow: UIButton!
    
    let gradientView = GradientView(frame: .zero)
    
    
    var isFollow:Bool = false
    
    let imageNotFollow:UIImage = UIImage(named: "FollowCenterBT-01.png")!
    let imageFollow:UIImage = UIImage(named: "FollowCenterBT-01.png")!
    
    let imageFollowing:UIImage = UIImage(named: "FollowCenterBT-03.png")!
    
    var myTag:NSInteger = 0
    
    var callBackTapOnFollow:(_ tag:NSInteger)->Void = {(NSInteger) in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
        self.viImageBG.clipsToBounds = true
        
        
        self.lbTitle.layer.shadowColor = UIColor(red: (39.0/255.0), green: (47.0/255.0), blue: (85.0/255.0), alpha: 1.0).cgColor
        
        self.lbTitle.layer.shadowOpacity = 0.95
        self.lbTitle.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.lbTitle.layer.shadowRadius = 1
        
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        viImageBG.addSubview(gradientView)
        
        let top = gradientView.topAnchor.constraint(equalTo: topAnchor)
        let bottom = gradientView.bottomAnchor.constraint(equalTo: bottomAnchor)
        let leading = gradientView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let trailing = gradientView.trailingAnchor.constraint(equalTo: trailingAnchor)
        
        gradientView.backgroundColor = UIColor.clear
        
        
        let color1:CGColor = UIColor(red: (39.0/255.0), green: (47.0/255.0), blue: (85.0/255.0), alpha: 0.30).cgColor
        
        
        let color2:CGColor = UIColor(red: (39.0/255.0), green: (47.0/255.0), blue: (85.0/255.0), alpha: 0.0).cgColor
        
        
        gradientView.gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientView.gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        
        gradientView.gradientLayer.colors = [color1, color2]
        
       
        
        NSLayoutConstraint.activate([top, bottom, leading, trailing])
        
        
        viImageBG.bringSubview(toFront: lbTitle)
        viImageBG.bringSubview(toFront: btFollow)
        
        
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
        
    }

    func setIsFollow(follow:Bool) {
        if(isFollow != follow){
            isFollow = follow
            
            if(isFollow == true){
                self.btFollow.setImage(imageFollowing, for: UIControlState.normal)
            }else{
                self.btFollow.setImage(imageNotFollow, for: UIControlState.normal)
            }
            
            
        }
    }
    
    func setTomodeGroup() {
        self.btFollow.setImage(imageFollowing, for: UIControlState.normal)
        
    }
    @IBAction func tapOnFollow(_ sender: UIButton) {
        self.callBackTapOnFollow(self.myTag)
    }
}



