//
//  ReportsDataModel.swift
//  SkySell
//
//  Created by DW02 on 6/27/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class ReportsDataModel: NSObject {

    var dateFormatFull:DateFormatter = DateFormatter()
    
    
    var report_id:String = ""
    var user_id:String = ""
    var product_id:String = ""
    var owner_product_id:String = ""
    var reporter_id:String = ""
    var status:String = ""
    var created_at:NSInteger = 0
    var created_at_Date:Date = Date()
    var created_at_server_timestamp:NSInteger = 0
    
    
    
    var updated_at:NSInteger = 0
    var updated_at_Date:Date = Date()
    var updated_at_server_timestamp:NSInteger = 0
    
    
    var reason_id:String = String()
    var reason_title:String = String()
    
    
    override init() {
        super.init()
        
        dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        
        
    }
    
    convenience init(dictionary:[String:Any]){
        
        self.init()
        
        dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        self.readJson(dictionary: dictionary)
    }
    
    
    func readJson(dictionary:[String:Any]) {
        
        let report_id = dictionary["report_id"] as? String
        if let report_id = report_id{
            self.report_id = report_id
        }
        
        
        let user_id = dictionary["user_id"] as? String
        if let user_id = user_id{
            self.user_id = user_id
        }
        
        let owner_product_id = dictionary["owner_product_id"] as? String
        if let owner_product_id = owner_product_id{
            self.owner_product_id = owner_product_id
        }
        
        
        
        let status = dictionary["status"] as? String
        if let status = status{
            self.status = status
        }
        
        
        let product_id = dictionary["product_id"] as? String
        if let product_id = product_id{
            self.product_id = product_id
        }
        
        
        let created_at = dictionary["created_at"] as? NSInteger
        if let created_at = created_at{
            self.created_at = created_at
            
            self.created_at_Date = Date(timeIntervalSince1970: TimeInterval(self.created_at/1000))
        
        }
        
        if let created_at_server_timestamp = dictionary["created_at_server_timestamp"] as? NSInteger{
            self.created_at_server_timestamp = created_at_server_timestamp
            
            
        }
        
        
        
        let updated_at = dictionary["updated_at"] as? NSInteger
        if let updated_at = updated_at{
            self.updated_at = updated_at
        
            
            self.updated_at_Date = Date(timeIntervalSince1970: TimeInterval(self.updated_at/1000))
            
           
            
        }
        
        
        if let updated_at_server_timestamp = dictionary["updated_at_server_timestamp"] as? NSInteger{
            self.updated_at_server_timestamp = updated_at_server_timestamp
            
            
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














