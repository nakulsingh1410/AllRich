//
//  FriendListModel.swift
//  SkySell
//
//  Created by Nakul Singh on 3/30/18.
//  Copyright © 2018 DW02. All rights reserved.
//

import UIKit
import ObjectMapper

class FriendListModel:Mappable {

    var first_name : String?
    var last_name : String?
    var user_joinDate : Int?
    var user_type : String?
    var status:String?
    var profile_img:String?
    var numberOfPosts:Int?
    var user_id:String?
    var requestStatus:String?
   
    required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        user_joinDate <- map["user_joinDate"]
        user_type <- map["user_type"]
        status <- map["status"]
        profile_img <- map["profile_img"]
        numberOfPosts <- map["numberOfPosts"]
        user_id <- map["user_id"]
        requestStatus <- map["requestStatus"]
    }
}


class FrindList:Mappable {
    var freeUsers:[FriendListModel]?
    var premiumUsers:[FriendListModel]?
    
    required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        freeUsers <- map["freeUsers"]
        premiumUsers <- map["premiumUsers"]
    }
    
}
class UserList:NSObject {
    var usersList:FrindList?
    
}
