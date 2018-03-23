//
//  RealmMessageDataObject.swift
//  SkySell
//
//  Created by DW02 on 6/7/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class RealmMessageDataObject: Object {

    enum messageType:String{
        case offer = "offer"
        case cancel_offer = "cancel_offer"
        case text = "text"
        case image = "image"
    }
    
    
    dynamic var messageID:String = ""
    dynamic var body:String = ""
    dynamic var isDeleteUser:Bool = false
    dynamic var isOffer:Bool = false
    dynamic var isRead:Bool = false
    dynamic var owner_uid:String = ""
    dynamic var receiver_uid:String = ""
    dynamic var timestamp:NSInteger = 0
    
    dynamic var room_id:String = ""
    
    
    dynamic var timestamp_Date:Date = Date()
    
    dynamic var type:String = ""
    
    
    dynamic var imageName:String = ""
    dynamic var imagePath:String = ""
    dynamic var imageSrc:String = ""
    
    let dateFormatFull:DateFormatter = DateFormatter()
    
    override class func primaryKey() -> String? {
        return "messageID"
    }
    
    
    func readJson(dictionary:NSDictionary) {
        dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let body = dictionary.object(forKey: "body") as? String
        if let body = body{
            self.body = body
        }
        
        let image = dictionary.object(forKey: "image") as? [String:String]
        if let image = image{
            
            if let imageName = image["name"]{
                self.imageName = imageName
            }
            
            
            if let impath = image["path"]{
                self.imagePath = impath
            }
            
            if let src = image["src"]{
                self.imageSrc = src
            }
            
        }
        
        
        
        let isDeleteUser = dictionary.object(forKey: "isDeleteUser") as? Bool
        if let isDeleteUser = isDeleteUser{
            self.isDeleteUser = isDeleteUser
        }
        
        
        let isOffer = dictionary.object(forKey: "isOffer") as? Bool
        if let isOffer = isOffer{
            self.isOffer = isOffer
        }
        
        
        
        let isRead = dictionary.object(forKey: "isRead") as? Bool
        if let isRead = isRead{
            self.isRead = isRead
        }
        
        
        
        
        let owner_uid = dictionary.object(forKey: "owner_uid") as? String
        if let owner_uid = owner_uid{
            self.owner_uid = owner_uid
        }
        
        
        let receiver_uid = dictionary.object(forKey: "receiver_uid") as? String
        if let receiver_uid = receiver_uid{
            self.receiver_uid = receiver_uid
        }
        
        
        
        let timestamp = dictionary.object(forKey: "timestamp") as? NSInteger
        if let timestamp = timestamp{
            self.timestamp = timestamp
            
            self.timestamp_Date = Date(timeIntervalSince1970: TimeInterval(timestamp/1000))
          
            
        }
        
        
        
        let type = dictionary.object(forKey: "type") as? String
        if let type = type{
            self.type = type
        }
        
        
        
        
    }
    
    
    
}









