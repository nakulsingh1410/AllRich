//
//  OwnerMessageCell.swift
//  SkySell
//
//  Created by supapon pucknavin on 6/8/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class OwnerOfferCell: UITableViewCell {

    
    
    
    enum State{
        case single
        case top
        case middle
        case bottom
    }
    
    @IBOutlet weak var viMessageBG: UIView!
    
    @IBOutlet weak var layout_Leading: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var viTL: UIView!
    @IBOutlet weak var viBL: UIView!
    
    @IBOutlet weak var viTR: UIView!
    
    @IBOutlet weak var viBR: UIView!
    
    
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    
    @IBOutlet weak var lbPrice: UILabel!
    
    @IBOutlet weak var layout_Top_Price: NSLayoutConstraint!
    
    
    var strTitle:String?{
        didSet{
            if let srr = strTitle{
                self.lbMessage.text = srr
                
                if(srr != ""){
                    self.layout_Top_Price.constant = 8
                }else{
                    self.layout_Top_Price.constant = 0
                }
                
            }
            
        }
    }
    
    
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
            break
        case .top:
            self.viTL.alpha = 0
            self.viBL.alpha = 0
            self.viTR.alpha = 0
            self.viBR.alpha = 1
            break
        case .middle:
            self.viTL.alpha = 0
            self.viBL.alpha = 0
            self.viTR.alpha = 1
            self.viBR.alpha = 1
            break
        case .bottom:
            self.viTL.alpha = 0
            self.viBL.alpha = 0
            self.viTR.alpha = 1
            self.viBR.alpha = 0
            break
        }
    }
}
