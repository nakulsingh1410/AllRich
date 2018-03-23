//
//  FeedbackChoiceCell.swift
//  SkySell
//
//  Created by DW02 on 6/23/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class FeedbackChoiceCell: UITableViewCell {

    enum SelectOn{
        case non
        case positive
        case neutral
        case negative
    }
    
    @IBOutlet weak var imagePositive: UIImageView!
    @IBOutlet weak var viTextBoxPositive: UIView!
    @IBOutlet weak var lbPositive: UILabel!
    @IBOutlet weak var btPositive: UIButton!
    
    
    
    
    @IBOutlet weak var imageNeutral: UIImageView!
    @IBOutlet weak var viTextBoxNeutral: UIView!
    @IBOutlet weak var lbNeutral: UILabel!
    @IBOutlet weak var btNeutral: UIButton!
    
    
    
    
    
    @IBOutlet weak var imageNegative: UIImageView!
    @IBOutlet weak var viTextBoxNegative: UIView!
    @IBOutlet weak var lbNegative: UILabel!
    @IBOutlet weak var btNegative: UIButton!
    
    
    var myPinkColor:UIColor = UIColor(red: (3/255), green: (210/255), blue: (99/255), alpha: 1.0)
    
    
    var callBackSelect:(SelectOn)->Void = {(select) in }
    
    
    
    var selectOn:SelectOn?{
        didSet{
            if let select = selectOn{
                switch select {
                case .non:
                    
                    //---
                    self.imagePositive.image = UIImage(named: "iconSmile.png")!
                    self.viTextBoxPositive.backgroundColor = UIColor.white
                    self.lbPositive.textColor = myPinkColor
                    //---
                    self.imageNeutral.image = UIImage(named: "iconNormal.png")!
                    self.viTextBoxNeutral.backgroundColor = UIColor.white
                    self.lbNeutral.textColor = myPinkColor
                    //---
                    self.imageNegative.image = UIImage(named: "iconSad.png")!
                    self.viTextBoxNegative.backgroundColor = UIColor.white
                    self.lbNegative.textColor = myPinkColor
                    //---
                    
                    
                    
                    
                    break
                case .positive:
                    
                    //---
                    self.imagePositive.image = UIImage(named: "iconSmile1.png")!
                    self.viTextBoxPositive.backgroundColor = myPinkColor
                    self.lbPositive.textColor = UIColor.white
                    //---
                    self.imageNeutral.image = UIImage(named: "iconNormal.png")!
                    self.viTextBoxNeutral.backgroundColor = UIColor.white
                    self.lbNeutral.textColor = myPinkColor
                    //---
                    self.imageNegative.image = UIImage(named: "iconSad.png")!
                    self.viTextBoxNegative.backgroundColor = UIColor.white
                    self.lbNegative.textColor = myPinkColor
                    //---
                    
                    
                    break
                case .neutral:
                    
                    //---
                    self.imagePositive.image = UIImage(named: "iconSmile.png")!
                    self.viTextBoxPositive.backgroundColor = UIColor.white
                    self.lbPositive.textColor = myPinkColor
                    //---
                    self.imageNeutral.image = UIImage(named: "iconNormal1.png")!
                    self.viTextBoxNeutral.backgroundColor = myPinkColor
                    self.lbNeutral.textColor = UIColor.white
                    //---
                    self.imageNegative.image = UIImage(named: "iconSad.png")!
                    self.viTextBoxNegative.backgroundColor = UIColor.white
                    self.lbNegative.textColor = myPinkColor
                    //---
                    
                    
                    break
                case .negative:
                    
                    //---
                    self.imagePositive.image = UIImage(named: "iconSmile.png")!
                    self.viTextBoxPositive.backgroundColor = UIColor.white
                    self.lbPositive.textColor = myPinkColor
                    //---
                    self.imageNeutral.image = UIImage(named: "iconNormal.png")!
                    self.viTextBoxNeutral.backgroundColor = UIColor.white
                    self.lbNeutral.textColor = myPinkColor
                    //---
                    self.imageNegative.image = UIImage(named: "iconSad1.png")!
                    self.viTextBoxNegative.backgroundColor = myPinkColor
                    self.lbNegative.textColor = UIColor.white
                    //---
                    
                    break
               
                }
                
            }else{
                
                //---
                self.imagePositive.image = UIImage(named: "iconSmile.png")!
                self.viTextBoxPositive.backgroundColor = UIColor.white
                self.lbPositive.textColor = myPinkColor
                //---
                self.imageNeutral.image = UIImage(named: "iconNormal.png")!
                self.viTextBoxNeutral.backgroundColor = UIColor.white
                self.lbNeutral.textColor = myPinkColor
                //---
                self.imageNegative.image = UIImage(named: "iconSad.png")!
                self.viTextBoxNegative.backgroundColor = UIColor.white
                self.lbNegative.textColor = myPinkColor
                //---
            }
            
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.viTextBoxPositive.clipsToBounds = true
        self.viTextBoxPositive.layer.cornerRadius = 2
        self.viTextBoxPositive.layer.borderColor = myPinkColor.cgColor
        self.viTextBoxPositive.layer.borderWidth = 1
        
        
        self.viTextBoxNeutral.clipsToBounds = true
        self.viTextBoxNeutral.layer.cornerRadius = 2
        self.viTextBoxNeutral.layer.borderColor = myPinkColor.cgColor
        self.viTextBoxNeutral.layer.borderWidth = 1
        
        
        
        
        self.viTextBoxNegative.clipsToBounds = true
        self.viTextBoxNegative.layer.cornerRadius = 2
        self.viTextBoxNegative.layer.borderColor = myPinkColor.cgColor
        self.viTextBoxNegative.layer.borderWidth = 1
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func tapOnPositive(_ sender: UIButton) {
        self.selectOn = .positive
        self.callBackSelect(self.selectOn!)
    }
    
    
    @IBAction func tapOnNeutral(_ sender: UIButton) {
        self.selectOn = .neutral
        self.callBackSelect(self.selectOn!)
    }
    
    @IBAction func tapOnNegative(_ sender: UIButton) {
        self.selectOn = .negative
        self.callBackSelect(self.selectOn!)
    }
    
    
    
    
    
    
    
}
