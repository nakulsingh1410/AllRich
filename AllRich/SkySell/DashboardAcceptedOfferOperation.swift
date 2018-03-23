//
//  DashboardAcceptedOfferOperation.swift
//  SkySell
//
//  Created by DW02 on 6/28/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase


class DashboardAcceptedOfferOperation: AsyncOperation {

    
    
    
    var accepted_offer_count:NSInteger = 0
    var accepted_offer_total_price:Double = 0
    var made_offer_count:NSInteger = 0
    
    
    
    
    var dateFormatFull:DateFormatter = DateFormatter()
    
    
    var addPrice:Double = 0
    
    init(price:Double){
        
        self.addPrice = price
        
       
        
        super.init()
    }
    
    override func main() {
        OperationQueue().addOperation {
            
            self.dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            self.dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            
            
            
            let postRef = FIRDatabase.database().reference().child("dashboard")
            
            postRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                
                if let value = snapshot.value as? NSDictionary{
                    
                    
                    
                    if let made_offer_count = value.object(forKey: "made_offer_count") as? NSInteger{
                        self.made_offer_count = made_offer_count
                    }
                    
                    
                    if let accepted_offer_count = value.object(forKey: "accepted_offer_count") as? NSInteger{
                        self.accepted_offer_count = accepted_offer_count
                    }
                    
                    
                    if let accepted_offer_total_price = value.object(forKey: "accepted_offer_total_price") as? Double{
                        self.accepted_offer_total_price = accepted_offer_total_price
                    }
                    
                    
                    
                    
                }
                
                
                
                
                ///////
                let update:String = self.dateFormatFull.string(from: Date())
                let postRefUpdate = FIRDatabase.database().reference().child("dashboard").child("accepted_last_updated")
                
                postRefUpdate.setValue(update)
                
                ////
                let postRef_accepted_offer_count = FIRDatabase.database().reference().child("dashboard").child("accepted_offer_count")
                
                postRef_accepted_offer_count.setValue((self.accepted_offer_count + 1))
                
                ////
                let postRef_accepted_offer_total_price = FIRDatabase.database().reference().child("dashboard").child("accepted_offer_total_price")
                
                postRef_accepted_offer_total_price.setValue((self.accepted_offer_total_price + self.addPrice))
                
                
                
                
                
                
            })
            
            
        }
    }
    
}
