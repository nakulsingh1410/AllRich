//
//  RoomMessagesDataModel.swift
//  SkySell
//
//  Created by DW02 on 6/6/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase


class RoomMessagesDataModel: NSObject {

    enum SellStatus{
        case non
        case accepted
        case declined
        case cancel
        case offer
    }
    
    
    var createdAt:NSInteger = 0
    var createdAt_Date:Date = Date()
    var createdByUserId:String = ""
    
    var isAccepted:[String:Bool] = [String:Bool]()
    var last_message:String = ""
    var offer_price:String = ""
    var product_id:String = ""
    var receivedByUserId:String = ""
    var room_id:String = ""
    var updatedAt:NSInteger = 0
    var updatedAt_Date:Date = Date()
    
    
    
    
    var isDeleteUser:[String] = [String]()
    
    
    
    
    
    var dateFormatFull:DateFormatter = DateFormatter()
    
    
    
    

    var product:RealmProductDataModel! = nil
    
    
    var createBy:RealmUserDataObject! = nil
    var reciveBy:RealmUserDataObject! = nil
    
    
    
    var unreadCount:[String:NSInteger] = [String:NSInteger]()
    
    
    var last_status:String = ""
    
    
    
    var status:SellStatus = .non
    
    override init() {
        super.init()
        
        dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        
        
    }
    
    convenience init(dictionary:NSDictionary){
        
        self.init()
        
        dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        self.readJson(dictionary: dictionary)
    }
    
    
    func readJson(dictionary:NSDictionary) {
        
        let str_createdAt = dictionary.object(forKey: "createdAt") as? NSInteger
        if let str_createdAt = str_createdAt{
            self.createdAt = str_createdAt
            
            self.createdAt_Date = Date(timeIntervalSince1970: TimeInterval(self.createdAt/1000))
            
        }
        
        
        let createBy = dictionary.object(forKey: "createdByUserId") as? String
        if let createBy = createBy{
            self.createdByUserId = createBy
        }
        
        let sreceivedByUserId = dictionary.object(forKey: "receivedByUserId") as? String
        if let sreceivedByUserId = sreceivedByUserId{
            self.receivedByUserId = sreceivedByUserId
        }
        
        
      
        
        
        
        
        
        let strLast_message = dictionary.object(forKey: "last_message") as? String
        if let strLast_message = strLast_message{
            self.last_message = strLast_message
        }
        
        
        let strOfferPrice = dictionary.object(forKey: "offer_price") as? String
        if let strOfferPrice = strOfferPrice{
            self.offer_price = strOfferPrice
        }
        
        
        let strproduct_id = dictionary.object(forKey: "product_id") as? String
        if let strproduct_id = strproduct_id{
            self.product_id = strproduct_id
        }
        
        
        
        let last_status = dictionary["last_status"] as? String
        if let last_status = last_status{
            self.last_status = last_status
        }
        
        
        
        let sroom_id = dictionary.object(forKey: "room_id") as? String
        if let sroom_id = sroom_id{
            self.room_id = sroom_id
        }
        
        
        
        
        let str_updatedAt = dictionary.object(forKey: "updatedAt") as? NSInteger
        if let str_updatedAt = str_updatedAt{
            self.updatedAt = str_updatedAt
            
            
            self.updatedAt_Date = Date(timeIntervalSince1970: TimeInterval(str_updatedAt/1000))
            
          
            
        }
        
        
        
        
        let unread = dictionary.object(forKey: "unread_count") as? [String:NSInteger]
        if let unread = unread{
            
            self.unreadCount = unread
            
            
        }
        
        
        let isDeleteUser = dictionary["isDeleteUser"] as? [String:Bool]
        if let isDeleteUser = isDeleteUser{
            
            for obj in isDeleteUser{
                
                if(obj.value == true){
                    self.isDeleteUser.append(obj.key)
                }
            }
        }
        
        
        /*
        let dicAccepted = dictionary["isAccepted"] as? [String:Bool]
        if let dicAccepted = dicAccepted{
            
            
            self.updateStatus(accepted: dicAccepted)
    
            
        }*/
        
        self.updateStatus()
        
    }
    
    
    
    
    func readJsonObject(dictionary:[String:Any]) {
        
        let str_createdAt = dictionary["createdAt"] as? NSInteger
        if let str_createdAt = str_createdAt{
            self.createdAt = str_createdAt
            
            
            self.createdAt_Date = Date(timeIntervalSince1970: TimeInterval(str_createdAt/1000))
            
            
           
            
        }
        
        
        let createBy = dictionary["createdByUserId"] as? String
        if let createBy = createBy{
            self.createdByUserId = createBy
        }
        
        let sreceivedByUserId = dictionary["receivedByUserId"] as? String
        if let sreceivedByUserId = sreceivedByUserId{
            self.receivedByUserId = sreceivedByUserId
        }
        
        
        
        
        
        
        let strLast_message = dictionary["last_message"] as? String
        if let strLast_message = strLast_message{
            self.last_message = strLast_message
        }
        
        
        let strOfferPrice = dictionary["offer_price"] as? String
        if let strOfferPrice = strOfferPrice{
            self.offer_price = strOfferPrice
        }
        
        
        let strproduct_id = dictionary["product_id"] as? String
        if let strproduct_id = strproduct_id{
            self.product_id = strproduct_id
        }
        
        
        
        
        
        
        
        let sroom_id = dictionary["room_id"] as? String
        if let sroom_id = sroom_id{
            self.room_id = sroom_id
        }
        
        
        
        let last_status = dictionary["last_status"] as? String
        if let last_status = last_status{
            self.last_status = last_status
        }
        
        
        
        
        
        
        let str_updatedAt = dictionary["updatedAt"] as? NSInteger
        if let str_updatedAt = str_updatedAt{
            self.updatedAt = str_updatedAt
            
            self.updatedAt_Date = Date(timeIntervalSince1970: TimeInterval(str_updatedAt/1000))
            
            
            
         
            
        }
        
        
        
        
        let unread = dictionary["unread_count"] as? [String:NSInteger]
        if let unread = unread{
            
            self.unreadCount = unread
            
            
        }
        
        
        
        
        let isDeleteUser = dictionary["isDeleteUser"] as? [String:Bool]
        if let isDeleteUser = isDeleteUser{
            
            for obj in isDeleteUser{
                
                if(obj.value == true){
                    self.isDeleteUser.append(obj.key)
                }
            }
        }
        
        
        
        
        /*
        let dicAccepted = dictionary["isAccepted"] as? [String:Bool]
        if let dicAccepted = dicAccepted{
            
            
            self.updateStatus(accepted: dicAccepted)
            
            
        }*/
        
        self.updateStatus()
        
    }
    
    
    func updateStatus(){
        
        /*
        var createrAccep:Bool = false
        var reciveAccep:Bool = false
        
     
        
        
        
        let cre:Bool? = accepted[self.createdByUserId]
        if let cre = cre{
            createrAccep = cre
        }
        
        let rec:Bool? = accepted[self.receivedByUserId]
        if let rec = rec{
            reciveAccep = rec
        }
        */
        
        if(last_status == "accept_offer"){
            
            self.status = .accepted
            
        }else{
            
            if(last_status == ""){
                self.status = .non
            }else if(last_status == "offer"){
                self.status = .offer
            }else if(last_status == "cancel_offer"){
                self.status = .cancel
            }else if(last_status == "decline_offer"){
                self.status = .declined
            }else{
                self.status = .non
            }
            
        }
        
     
        
        
        
        
    }
    
    
    
    
    
    
    func getDictionary() -> [String:Any] {
        var dicData:[String:Any] = [String:Any]()
        
        
        dicData["createdAt"] = self.createdAt
        dicData["createdByUserId"] = self.createdByUserId
        dicData["isAccepted"] = self.isAccepted
        dicData["last_message"] = self.last_message
        dicData["offer_price"] = self.offer_price
        dicData["product_id"] = self.product_id
        dicData["receivedByUserId"] = self.receivedByUserId
        dicData["room_id"] = self.room_id
        dicData["updatedAt"] = FIRServerValue.timestamp()
        
        dicData["unread_count"] = self.unreadCount
    
        dicData["last_status"] = self.last_status
        
        
        var dicDelete:[String:Bool] = [String:Bool]()
        for str in self.isDeleteUser{
            dicDelete[str] = true
        }
        dicData["isDeleteUser"] = dicDelete
        
        
        return dicData
        
    }
    
    
}





