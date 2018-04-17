//
//  ReportChoiceDataModel.swift
//  SkySell
//
//  Created by DW02 on 6/27/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class ReportChoiceDataModel: NSObject {

    var isActive:Bool = false
    var position:NSInteger = 0
    var reason_id:String = ""
    var reason_title:String = ""
    
    
    
    
    override init() {
        super.init()
        
    

        
    }
    
    convenience init(dictionary:[String:Any]){
        
        self.init()
        
 
        
        self.readJson(dictionary: dictionary)
    }
    
    
    func readJson(dictionary:[String:Any]) {
        
        let isActive = dictionary["isActive"] as? Bool
        if let isActive = isActive{
            self.isActive = isActive
        }
        
        
        
        let position = dictionary["position"] as? NSInteger
        if let position = position{
            self.position = position
        }
        
        let reason_id = dictionary["reason_id"] as? String
        if let reason_id = reason_id{
            self.reason_id = reason_id
        }
        
        
        
        let reason_title = dictionary["reason_title"] as? String
        if let reason_title = reason_title{
            self.reason_title = reason_title
        }
        
        
        
    }
}
