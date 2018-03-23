//
//  AnotherMessageCell.swift
//  SkySell
//
//  Created by DW02 on 6/8/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class AnotherImageCell: UITableViewCell {

    
    
    enum State{
        case single
        case top
        case middle
        case bottom
    }
    
    @IBOutlet weak var viMessageBG: UIView!
    
    @IBOutlet weak var layout_MessageBox_Width:NSLayoutConstraint!
    
    
    
    @IBOutlet weak var viTL: UIView!
    @IBOutlet weak var viBL: UIView!
    
    @IBOutlet weak var viTR: UIView!
    
    @IBOutlet weak var viBR: UIView!
    
    
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    
    @IBOutlet weak var viImageBG: UIView!
    
    var lazyImage:PKImV3View! = nil
    
    
    var imageSend:PKImV3View! = nil
    
    
    @IBOutlet weak var viUserImageBG: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.clipsToBounds = true
        self.viMessageBG.layer.cornerRadius = 8
        self.viMessageBG.clipsToBounds = true
        
        self.viTL.layer.cornerRadius = 2
        self.viBL.layer.cornerRadius = 2
        self.viTR.layer.cornerRadius = 2
        self.viBR.layer.cornerRadius = 2
        
        self.viTL.clipsToBounds = true
        self.viBL.clipsToBounds = true
        self.viTR.clipsToBounds = true
        self.viBR.clipsToBounds = true
        
        
        self.viTL.alpha = 0
        self.viBL.alpha = 0
        self.viTR.alpha = 0
        self.viBR.alpha = 0
        
        
        self.lazyImage = PKImV3View(frame: CGRect(x: 0, y: 0, width: 28, height: 28))

        self.viUserImageBG.addSubview(self.lazyImage)
        
        self.viUserImageBG.clipsToBounds = true
        self.viUserImageBG.layer.cornerRadius = 14
        
        
        
        
        self.imageSend = PKImV3View(frame: CGRect(x: 0, y: 0, width: 144, height: 144))
        self.viImageBG.clipsToBounds = true
        self.viImageBG.layer.cornerRadius = 2
        self.viImageBG.addSubview(self.imageSend)
        
        self.imageSend.imageView.contentMode = .scaleAspectFill
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setTextBoxState(state:State) {
        
        switch state {
        case .single:
            self.viTL.alpha = 0
            self.viBL.alpha = 0
            self.viTR.alpha = 0
            self.viBR.alpha = 0
            self.viUserImageBG.alpha = 1
            break
        case .top:
            self.viTL.alpha = 0
            self.viBL.alpha = 1
            self.viTR.alpha = 0
            self.viBR.alpha = 0
            self.viUserImageBG.alpha = 0
            break
        case .middle:
            self.viTL.alpha = 1
            self.viBL.alpha = 1
            self.viTR.alpha = 0
            self.viBR.alpha = 0
            self.viUserImageBG.alpha = 0
            break
        case .bottom:
            self.viTL.alpha = 1
            self.viBL.alpha = 0
            self.viTR.alpha = 0
            self.viBR.alpha = 0
            self.viUserImageBG.alpha = 1
            break
        }
    }
    
}
