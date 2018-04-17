//
//  ProductListModel.swift
//  SkySell
//
//  Created by Nakul Singh on 4/1/18.
//  Copyright © 2018 DW02. All rights reserved.
//

import UIKit
import ObjectMapper

class ProductListModel: NSObject,Mappable {

    var  category1:String?
    var category2:String?
    var country:String?
    var created_at_server_timestamp:String?
    var images:[String]?
    var isDeleted:String?
    var isNew:String?
    var likeCount:String?
    var points:String?
    var postType:String?
    var price:String?
    var product_description:String?
    var product_id:String?
    var product_id_number:String?
    var product_latitud:String?
    var product_location:String?
    var product_longitude:String?
    var product_status:String?
    var status:String?
    var title:String?
    var uid:String?
    var updated_at_server_timestamp:String?
    var viewCount:String?
    var year:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        category1 <- map["category1"]
        category2 <- map["category2"]
        country <- map["country"]
        created_at_server_timestamp <- map["created_at_server_timestamp"]
        images <- map["images"]
        isDeleted <- map["isDeleted"]
        isNew <- map["isNew"]
        likeCount <- map[""]
        points <- map["points"]
        postType <- map["postType"]
        price <- map["price"]
        product_description <- map["product_description"]
        product_id <- map["product_id"]
        product_id_number <- map["product_id_number"]
        product_latitud <- map["product_latitud"]
        product_location <- map["product_location"]
        product_longitude <- map["product_longitude"]
        product_status <- map["product_status"]
        status <- map["status"]
        title <- map["title"]
        uid <- map["uid"]
        updated_at_server_timestamp <- map["updated_at_server_timestamp"]
        viewCount <- map["viewCount"]
        year <- map["year"]
    }

}

