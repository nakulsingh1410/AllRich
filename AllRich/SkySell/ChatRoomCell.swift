//
//  ChatRoomCell.swift
//  SkySell
//
//  Created by DW02 on 6/6/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class ChatRoomCell: UITableViewCell {

    
    
    @IBOutlet weak var viContainBG: UIView!
    @IBOutlet weak var layout_Leading_ContainBG: NSLayoutConstraint!
    
    @IBOutlet weak var btDelete: UIButton!
    
    
    @IBOutlet weak var viProductImageBG: UIView!
    
    
    var callDelete:(NSInteger)->Void = {(NSInteger) in }
    var callAccepted:(NSInteger)->Void = {(NSInteger) in }
    
    
    var myTag:NSInteger = 0
    
    @IBOutlet weak var viUserImageBG: UIView!
    
    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbProductName: UILabel!
    
    
    @IBOutlet weak var viStatusBG: UIView!
    @IBOutlet weak var lbStatus: UILabel!
    
    
    @IBOutlet weak var lbPrice: UILabel!
    
    @IBOutlet weak var btAccepted: UIButton!
    
    
    @IBOutlet weak var viUnreadBG: UIView!
    
    @IBOutlet weak var layoutUnreadWidth: NSLayoutConstraint!
    
    
    
    var lazyImageUser:PKImV3View! = nil
    var lazyImageProduct:PKImV3View! = nil
    
    
    var isShowDelete:Bool = false
    
    var status:RoomMessagesDataModel.SellStatus = .non
    
    @IBOutlet weak var lbCount: UILabel!
    
    
    let fontCount:UIFont = UIFont(name: "Avenir-Medium", size: 14)!
    var unreadCount:NSInteger?{
        
        
        didSet{
            
            if let count = unreadCount{
                let strC:String = String(format: "%d", count)
                self.lbCount.text = strC
                
                var w = widthForView(text: strC, Font: fontCount, Height: 19.5)
                
                w = w + 20
                if(w < 30){
                    w = 30
                }
                self.layoutUnreadWidth.constant = w
                self.layoutIfNeeded()
                self.updateConstraints()
                
            }
            
            
            
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.clipsToBounds = true
        self.viUserImageBG.clipsToBounds = true
        self.viUserImageBG.layer.cornerRadius = 20
        
        self.lazyImageUser = PKImV3View(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.viUserImageBG.addSubview(self.lazyImageUser)
        
        
        
        
        self.viProductImageBG.clipsToBounds = true
        self.viProductImageBG.layer.cornerRadius = 2
        self.lazyImageProduct = PKImV3View(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.viProductImageBG.addSubview(self.lazyImageProduct)
        self.lazyImageProduct.imageView.contentMode = .scaleAspectFill
        
        
        
        
        self.viProductImageBG.bringSubview(toFront: self.viStatusBG)
        
        
        self.btAccepted.clipsToBounds = true
        self.btAccepted.layer.cornerRadius = 2
        
        self.btDelete.alpha = 0
        self.btDelete.isEnabled = false
        
        self.layout_Leading_ContainBG.constant = 0
        
        self.updateConstraints()
        self.layoutIfNeeded()
        
        self.btAccepted.isUserInteractionEnabled = false
        
        self.btAccepted.alpha = 0
        
        self.viUnreadBG.clipsToBounds = true
        self.viUnreadBG.layer.cornerRadius = 15
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setStatusTo(st:RoomMessagesDataModel.SellStatus, ChatAsSelling isSelling:Bool) {
        if(st != self.status){
            self.status = st
            switch self.status {
            case .non:
                
                self.btAccepted.alpha = 0
                
                break
            case .accepted:
                
                self.btAccepted.backgroundColor = UIColor(red: (48/255), green: (170/255), blue: (49/255), alpha: 1.0)
                self.btAccepted.setTitle("Accepted", for: UIControlState.normal)
                self.btAccepted.alpha = 1
                break
            case .declined:
                
                self.btAccepted.backgroundColor = UIColor(red: (208/255), green: (2/255), blue: (27/255), alpha: 1.0)
                self.btAccepted.setTitle("Declined", for: UIControlState.normal)
                self.btAccepted.alpha = 1
                break
            case .cancel:
                
                self.btAccepted.backgroundColor = UIColor(red: (208/255), green: (2/255), blue: (27/255), alpha: 1.0)
                self.btAccepted.setTitle("Cancelled", for: UIControlState.normal)
                self.btAccepted.alpha = 1
                break
            case .offer:
               
                self.btAccepted.backgroundColor = UIColor(red: (48/255), green: (170/255), blue: (49/255), alpha: 1.0)
                self.btAccepted.setTitle("Offered", for: UIControlState.normal)
                if(isSelling == true){
                    self.btAccepted.alpha = 1
                }else{
                    self.btAccepted.alpha = 1
                }
                
                break
        
            }
        }
    }
    
    
    
    @IBAction func tapOnDelete(_ sender: UIButton) {
        
        self.callDelete(self.myTag)
    }
    
    
    
    @IBAction func tapOnAccepted(_ sender: UIButton) {
        
        self.callAccepted(self.myTag)
    }
    
    
    func showDeleteButtm(show:Bool) {
        if(show != self.isShowDelete){
            
            self.isShowDelete = show
            
            if(show){
                self.layout_Leading_ContainBG.constant = 60
            }else{
                self.layout_Leading_ContainBG.constant = 0
            }
            
            UIView.animate(withDuration: 0.25, animations: { 
                
                
                if(self.isShowDelete){
                    self.btDelete.alpha = 1
                    self.btDelete.isEnabled = true
                }else{
                    self.btDelete.alpha = 0
                    self.btDelete.isEnabled = false
                }
                
                self.updateConstraints()
                self.layoutIfNeeded()
                
            })
            
        }
    }
    
    
    
}







