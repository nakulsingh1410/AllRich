//
//  LikeDataObjec.swift
//  SkySell
//
//  Created by DW02 on 9/12/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class LikeDataObjec: NSObject {

    var favoriteID:String = ""
    var created_at:NSInteger = 0
    var product_id:String = ""
    var uid:String = ""
    
    
    convenience init(dictionary:[String:Any]){
        
        self.init()
        
        
        
        self.readJsonObject(dictionary: dictionary)
    }
    
    func readJsonObject(dictionary:[String:Any]) {
        
        
        let created_at = dictionary["created_at"] as? NSInteger
        if let created_at = created_at{
            self.created_at = created_at
        }
 
        
        let product_id = dictionary["product_id"] as? String
        if let product_id = product_id{
            self.product_id = product_id
        }
        
        
        let uid = dictionary["uid"] as? String
        if let uid = uid{
            self.uid = uid
        }
        
    }
    
}
