//
//  DashboardMadeOfferOperation.swift
//  SkySell
//
//  Created by DW02 on 6/28/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase


class DashboardMadeOfferOperation: AsyncOperation {

    var made_offer_count:NSInteger = 0
    
    override func main() {
        OperationQueue().addOperation {
            
            
            let postRef = FIRDatabase.database().reference().child("dashboard")
            
            postRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                
    
                if let value = snapshot.value as? NSDictionary{
                    
               
                    
                    if let made_offer_count = value.object(forKey: "made_offer_count") as? NSInteger{
                        self.made_offer_count = made_offer_count
                    }
                    
                }
                
                
                let postRef2 = FIRDatabase.database().reference().child("dashboard").child("made_offer_count")
                
                let newMade:NSInteger = self.made_offer_count + 1
                postRef2.setValue(newMade)
                
                
                
              
            })
            
            
        }
    }
    
    
}
