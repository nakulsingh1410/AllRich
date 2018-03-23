//
//  PlansDataModel.swift
//  SkySell
//
//  Created by DW02 on 6/29/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class PlansDataModel {

    var amount:NSInteger = 0
    var description:String = ""
    var image_name:String = ""
    var image_path:String = ""
    var image_src:String = ""
    
    
    var isActive:Bool = false
    var listings:NSInteger = 0
    var order:NSInteger = 0
    var plan_id:String = ""
    var plan_name:String = ""
    
    var itunes_id:String = ""
    
    
    convenience init(dictionary:[String:Any]){
        
        self.init()
        
        
        
        self.readJsonObject(dictionary: dictionary)
    }
    
    func readJsonObject(dictionary:[String:Any]) {
        
        let amount = dictionary["amount"] as? NSInteger
        if let amount = amount{
            self.amount = amount
        }else{
            let samount = dictionary["amount"] as? String
            if let samount = samount{
                if let iamount = NSInteger(samount){
                    self.amount = iamount
                }
            }
        }
        
        
        let description = dictionary["description"] as? String
        if let description = description{
            self.description = description
        }
        
        
        let image = dictionary["image"] as? [String:String]
        if let image = image{
            
            if let name = image["name"]{
                self.image_name = name
            }
            
            
            if let path = image["path"]{
                self.image_path = path
            }
            
            
            if let src = image["src"]{
                self.image_src = src
            }
            
        }
        
        
        let isActive = dictionary["isActive"] as? Bool
        if let isActive = isActive{
            self.isActive = isActive
        }
        
        
        
        let listings = dictionary["listings"] as? NSInteger
        if let listings = listings{
            self.listings = listings
        }
        
        
        
        let order = dictionary["order"] as? NSInteger
        if let order = order{
            self.order = order
        }
        
        
        let plan_id = dictionary["plan_id"] as? String
        if let plan_id = plan_id{
            self.plan_id = plan_id
        }
        
        let plan_name = dictionary["plan_name"] as? String
        if let plan_name = plan_name{
            self.plan_name = plan_name
        }
        
        
        let itunes_id = dictionary["itunes_id"] as? String
        if let itunes_id = itunes_id{
            self.itunes_id = itunes_id
        }
        
        
        
    }
}
