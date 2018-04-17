//
//  AddViewCountOperation.swift
//  SkySell
//
//  Created by DW02 on 6/28/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase


class AddViewCountOperation: AsyncOperation {

    
   
    
    var productId:String = ""
    var userId:String = ""

    
    init(userID:String, productID:String){
        
        self.productId = productID
   
        
        self.userId = userID
        
        super.init()
    }
    
    
    
    override func main() {
        OperationQueue().addOperation {
            
            getProductDataWith(ProductID: self.productId, Finish: { (product) in
                
                let viewCount:NSInteger = product.viewCount
                
                let postRef1 = FIRDatabase.database().reference().child("products").child(self.productId).child("viewCount")
                
                let addValue:NSInteger = viewCount + 1
                postRef1.setValue(addValue)
                
            })
            
            
        }
    }
}
