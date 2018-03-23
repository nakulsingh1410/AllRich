//
//  RealmDataObject.swift
//  SkySell
//
//  Created by DW02 on 5/26/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

// MARK: -
// MARK: - RealmProductDataModel
class RealmProductDataModel: Object {
    
    
  
    dynamic var category1:String = ""
    dynamic var category2:String = ""

    dynamic var created_at_Date:Date! = Date()
    dynamic var created_at_server_timestamp:NSInteger = 0
    
    
    
    dynamic var image_name:String = ""
    dynamic var image_path:String = ""
    dynamic var image_src:String = ""
    

    
    
    dynamic var isDeleted:Bool = false
    dynamic var isNew:Bool = true
    dynamic var likeCount:NSInteger = 0
    dynamic var manufacturer:String = ""
    dynamic var model:String = ""
    dynamic var price:String = ""
    dynamic var price_server_Number:Double = 0
    
    
    dynamic var product_description:String = ""
    dynamic var product_id:String = ""
    dynamic var product_id_number:String = ""
    dynamic var product_latitude:Double = 0.0
    dynamic var product_location:String = ""
    dynamic var product_longitude:Double = 0.0
    
    
    let product_serials = List<RealmSerial>()
    
    
    
    
    
    dynamic var product_status:String = ""
    dynamic var status:String = ""
    dynamic var title:String = ""
    dynamic var uid:String = ""

    dynamic var updated_at_Date:Date! = Date()
    dynamic var updated_at_server_timestamp:NSInteger = 0
    dynamic var year:String = ""
    dynamic var country:String = ""
    

    dynamic var priceInNumber:Double = 0.0
    
    
    dynamic var viewCount:NSInteger = 0
    
 
    
    dynamic var owner_FirstName:String = ""
    dynamic var owner_LastName:String = ""
    dynamic var owner_Image_src:String = ""
    dynamic var loadFinish:Bool = false

    
    dynamic var distance:Double = 0
   
    dynamic var isUserLike:Bool = false
    /*
    required init() {
        super.init()
    }
    
    
    convenience init(dictionary:NSDictionary){
        
        self.init()
        self.readJson(obj: dictionary)
    }
 
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
        fatalError("init(realm:schema:) has not been implemented")
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
        fatalError("init(value:schema:) has not been implemented")
    }
    */
    
    override class func primaryKey() -> String? {
        return "product_id"
    }
    
    
    
    func readJson(obj:NSDictionary) {
        
        if let category1 = obj.object(forKey: "category1") as? String{
            self.category1 = category1
        }
        
        if let category2 = obj.object(forKey: "category2") as? String{
            self.category2 = category2
        }
        
        
        
        
        let dateFormatFull:DateFormatter = DateFormatter()
        dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        var haveDate:Bool = false
        if let created_at = obj.object(forKey: "created_at") as? String{
     
            haveDate = true
            self.created_at_Date = dateFormatFull.date(from: created_at)
        }else if let created_at = obj.object(forKey: "created_at") as? NSInteger{
           
            haveDate = true
            self.created_at_Date = Date(timeIntervalSince1970: TimeInterval(created_at/1000))//dateFormatFull.date(from: created_at)
        }
        
        
        if let created_at_server_timestamp = obj.object(forKey: "created_at_server_timestamp") as? NSInteger{
            self.created_at_server_timestamp = created_at_server_timestamp
            
         
            if(haveDate == false){
                self.created_at_Date = Date(timeIntervalSince1970: TimeInterval(created_at_server_timestamp/1000))
            }
            
        }
        
        
        ///////------------------------------------------------------------------
        if let product_img = obj.object(forKey: "image") as? NSDictionary{
            
            if let image_name = product_img.object(forKey: "name") as? String{
                self.image_name = image_name
            }
            
            if let image_path = product_img.object(forKey: "path") as? String{
                self.image_path = image_path
            }
            
            if let image_src = product_img.object(forKey: "src") as? String{
                self.image_src = image_src
            }
            
            
        }
        
        ///////------------------------------------------------------------------

        var arImage:[PostImageObject] = [PostImageObject]()
        if let product_imgs = obj.object(forKey: "images") as? NSArray{
            for item in product_imgs{
                if let item = item as? NSDictionary{
                    let newImage:PostImageObject = PostImageObject()
                    
                    if let image_name = item.object(forKey: "name") as? String{
                        newImage.image_name = image_name
                    }
                    
                    if let image_path = item.object(forKey: "path") as? String{
                        newImage.image_path = image_path
                    }
                    
                    if let image_src = item.object(forKey: "src") as? String{
                        newImage.image_src = image_src
                    }
                    
                    if(self.image_src == newImage.image_src){
                    }else{
                        arImage.append(newImage)
                    }
                    
                    
                }else if let item = item as? String{
                    let newImage:PostImageObject = PostImageObject()
                    newImage.image_src = item
                    
                    if(self.image_src == item){
                    }else{
                        arImage.append(newImage)
                    }
                    
                    
                }
            }
            
        }
        
        if((self.image_src == "") && (arImage.count > 0)){
            self.image_name = arImage[0].image_name
            self.image_path = arImage[0].image_path
            self.image_src = arImage[0].image_src
        }
        
        
        //---------------------------
        
        
        
        if let isDeleted = obj.object(forKey: "isDeleted") as? Bool{
            self.isDeleted = isDeleted
        }
        
        
        if let isNew = obj.object(forKey: "isNew") as? Bool{
            self.isNew = isNew
        }
        
        
        
        
        
        
        if let viewCount = obj.object(forKey: "viewCount") as? NSInteger{
            self.viewCount = viewCount
        }
        
        
        
        
        
        
        if let manufacturer = obj.object(forKey: "manufacturer") as? String{
            self.manufacturer = manufacturer
        }
        
        
        if let model = obj.object(forKey: "model") as? String{
            self.model = model
        }
        
        
        if let price = obj.object(forKey: "price") as? String{
            self.price = price
            
            
            if let nPrice = Double(price){
                self.priceInNumber = nPrice
            }
            
            
            //print("\(self.price) ======   \(self.priceInNumber)")
        }
        
        
        if let price_number = obj.object(forKey: "price_number") as? Double{
            self.price_server_Number = price_number
            
            
            if(self.priceInNumber <= 0){
                self.priceInNumber = price_number
            }
            //print("\(self.price) ======   \(self.priceInNumber)")
        }
        
        
        
        
        
        
        
        if let product_description = obj.object(forKey: "product_description") as? String{
            self.product_description = product_description
        }
        
        
        if let product_id = obj.object(forKey: "product_id") as? String{
            self.product_id = product_id
        }
        
        if let product_id_number = obj.object(forKey: "product_id_number") as? String{
            self.product_id_number = product_id_number
        }
        
        if let product_latitude = obj.object(forKey: "product_latitude") as? Double{
            self.product_latitude = product_latitude
        }
        
        if let product_location = obj.object(forKey: "product_location") as? String{
            self.product_location = product_location
        }
        
        if let product_longitude = obj.object(forKey: "product_longitude") as? Double{
            self.product_longitude = product_longitude
        }
        
        
        if let product_serials = obj.object(forKey: "product_serials") as? [[String:Any]]{
            
            for i in 0..<product_serials.count{
                
                let item = product_serials[i]
                
                let newItem:RealmSerial = RealmSerial()
                newItem.serialID = "\(i)"
                if let amount = item["amount"] as? String{
                    if let am = NSInteger(amount){
                        newItem.amount = am
                    }
                    
                }
                
                if let serialNumber = item["serialNumber"] as? String{
                    newItem.serialNumber = serialNumber
                }
                
                
                self.product_serials.append(newItem)
            }
   
        }
        
        
        
        
        
        
        if let product_status = obj.object(forKey: "product_status") as? String{
            self.product_status = product_status
        }
        
        
        
        if let status = obj.object(forKey: "status") as? String{
            self.status = status
        }
        
        if let title = obj.object(forKey: "title") as? String{
            self.title = title
        }
        
        
        if let uid = obj.object(forKey: "uid") as? String{
            self.uid = uid
        }
        
        
        
        var haveUpdate:Bool = false
        if let updated_at = obj.object(forKey: "updated_at") as? NSInteger{
    
            haveUpdate = true
            self.updated_at_Date = Date(timeIntervalSince1970: TimeInterval(updated_at/1000))//dateFormatFull.date(from: updated_at)
            
            
        }
        
        
        if let updated_at_server_timestamp = obj.object(forKey: "updated_at_server_timestamp") as? NSInteger{
            self.updated_at_server_timestamp = updated_at_server_timestamp
            
            if(haveUpdate == false){
                
                self.updated_at_Date = Date(timeIntervalSince1970: TimeInterval(updated_at_server_timestamp/1000))
            }
        }
        
        
        
        
        if let year = obj.object(forKey: "year") as? String{
            self.year = year
        }
        
        
        
        if let country = obj.object(forKey: "country") as? String{
            self.country = country
        }
        
        
        /*
         if let likeCount = obj.object(forKey: "likeCount") as? NSInteger{
         self.likeCount = likeCount
         }*/
        
        let myData:ShareData = ShareData.sharedInstance
        
        self.likeCount = myData.getLikToProduct(productID: self.product_id).count
        
        //-----

        //-----
   
        
    }
    
    
    
    func getDictionary()->[String:Any]{
        
        
        var dicData:[String:Any] = [String:Any]()
        
        
        dicData["product_id"] = product_id
        dicData["product_id_number"] = product_id_number
        
        var coverImage:[String:String] = [String:String]()
        coverImage["name"] = image_name
        coverImage["path"] = image_path
        coverImage["src"] = image_src
        
        dicData["image"] = coverImage
        
        
/*
        var productImage:[[String:String]] = [[String:String]]()
        var arPIm:[String] = [String]()
        for item in self.images{
            
            var newimage:[String:String] = [String:String]()
            newimage["name"] = item.image_name
            newimage["path"] = item.image_path
            newimage["src"] = item.image_src
            productImage.append(newimage)
            
            arPIm.append(item.image_src)
        }
        dicData["images"] = arPIm
        //dicData["images_data"] = productImage
        */
        
        dicData["title"] = title
        
        dicData["manufacturer"] = manufacturer
        dicData["model"] = model
        dicData["price"] = price
        
        dicData["price_number"] = price_server_Number
       
        
        
        
        
        dicData["year"] = year
        dicData["country"] = country
        dicData["category1"] = category1
        
        dicData["category2"] = category2
        dicData["isNew"] = isNew
        
        dicData["product_description"] = product_description
        dicData["product_location"] = product_location
        dicData["product_latitude"] = product_latitude
        dicData["product_longitude"] = product_longitude
        dicData["status"] = status
        
        

        
        
        dicData["product_status"] = product_status
        
   
        
        
        dicData["isDeleted"] = isDeleted
        dicData["viewCount"] = viewCount
        //dicData["likeCount"] = likeCount
        
 
        
        dicData["uid"] = uid
        
        
        
        
        return dicData
        
    }
    
}



// MARK: -
// MARK: - RealmSubCategoriesDataModel
class RealmSubCategoriesDataModel: Object {
    
    dynamic var category_id:String = ""
    dynamic var sub_category_id:String = ""
    
    dynamic var image_sub_category_name:String = ""
    dynamic var image_sub_category_path:String = ""
    dynamic var image_sub_category_src:String = ""
    
    dynamic var sub_category_name:String = ""
    
    
    dynamic var isSelect:Bool = false
    
    
    override class func primaryKey() -> String? {
        return "sub_category_id"
    }
    
    
    func readJson(obj:NSDictionary) {
        
        if let category_id = obj.object(forKey: "category_id") as? String{
            self.category_id = category_id
        }
        
        
        if let sub_category_id = obj.object(forKey: "sub_category_id") as? String{
            self.sub_category_id = sub_category_id
        }
        
        if let sub_category_name = obj.object(forKey: "sub_category_name") as? String{
            self.sub_category_name = sub_category_name
        }
        
        
        
        
        if let sub_category_img = obj.object(forKey: "sub_category_img") as? NSDictionary{
            
            if let sub_category_name = sub_category_img.object(forKey: "name") as? String{
                self.image_sub_category_name = sub_category_name
            }
            
            if let sub_category_path = sub_category_img.object(forKey: "path") as? String{
                self.image_sub_category_path = sub_category_path
            }
            
            if let sub_category_src = sub_category_img.object(forKey: "src") as? String{
                self.image_sub_category_src = sub_category_src
            }
            
            
        }
        

    }
    
    
}
// MARK: -
// MARK: - RealmSerial
class RealmSerial:Object{
    dynamic var serialID:String = ""
    dynamic var serialNumber:String = ""
    dynamic var amount:NSInteger = 0
}

// MARK: -
// MARK: - RealmString
class RealmString:Object{
    dynamic var str:String = ""
}

// MARK: -
// MARK: - RealmCategoriesDataModel
class RealmCategoriesDataModel: Object {
    
    dynamic var category_id:String = ""
    dynamic var category_img_name:String = ""
    dynamic var category_img_path:String = ""
    dynamic var category_img_src:String = ""
    
    dynamic var category_name:String = ""
    dynamic var created_at:NSInteger = 0
    dynamic var created_at_Date:Date! = Date()
    dynamic var created_at_server_timestamp:NSInteger = 0
    
    
    
    let subCategory = List<RealmSubCategoriesDataModel>()
    
    
    
    dynamic var updated_at:NSInteger = 0
    dynamic var updated_at_Date:Date! = Date()
    dynamic var updated_at_server_timestamp:NSInteger = 0
    
    
    let favorites = List<RealmString>()
    
    
    
    dynamic var isSelect:Bool = false
    dynamic var isSearchShow:Bool = true
    
    dynamic var keywordForSearch:String = ""
    
    
    override class func primaryKey() -> String? {
        return "category_id"
    }
    
    func readJson(obj:NSDictionary) {
        
        if let category_id = obj.object(forKey: "category_id") as? String{
            self.category_id = category_id
        }
        
        
        if let category_img = obj.object(forKey: "category_img") as? NSDictionary{
            
            if let category_img_name = category_img.object(forKey: "name") as? String{
                self.category_img_name = category_img_name
            }
            
            if let category_img_path = category_img.object(forKey: "path") as? String{
                self.category_img_path = category_img_path
            }
            
            if let category_img_src = category_img.object(forKey: "src") as? String{
                self.category_img_src = category_img_src
            }
            
            
        }else if let category_img = obj.object(forKey: "category_img") as? String{
            
            self.category_img_name = ""
            
            self.category_img_path = ""
            
            self.category_img_src = category_img
            
            
        }
        
        
        if let category_name = obj.object(forKey: "category_name") as? String{
            self.category_name = category_name
            
            self.keywordForSearch = category_name.lowercased()
        }
        
        
        
        
        let dateFormatFull:DateFormatter = DateFormatter()
        dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        
        
        if let created_at = obj.object(forKey: "created_at") as? NSInteger{
            self.created_at = created_at
            
            self.created_at_Date = Date(timeIntervalSince1970: TimeInterval(created_at/1000))//dateFormatFull.date(from: created_at)
        }
        
        if let created_at_server_timestamp = obj.object(forKey: "created_at_server_timestamp") as? NSInteger{
            self.created_at_server_timestamp = created_at_server_timestamp
            
            
            self.created_at = created_at_server_timestamp
            self.created_at_Date = Date(timeIntervalSince1970: TimeInterval(created_at_server_timestamp/1000))
            
            
            
        }
        
        
        
        if let updated_at = obj.object(forKey: "updated_at") as? NSInteger{
            self.updated_at = updated_at
            self.updated_at_Date = Date(timeIntervalSince1970: TimeInterval(updated_at/1000))//dateFormatFull.date(from: updated_at)
        }
        
        if let updated_at_server_timestamp = obj.object(forKey: "updated_at_server_timestamp") as? NSInteger{
            self.updated_at_server_timestamp = updated_at_server_timestamp
            
            self.updated_at = updated_at_server_timestamp
            self.updated_at_Date = Date(timeIntervalSince1970: TimeInterval(updated_at_server_timestamp/1000))
        }
   
        
        
        
        
        
        if let favor = obj.object(forKey: "favorite") as? NSDictionary{
            let allKey = favor.allKeys
            for key in allKey{
                if let key = key as? String{
                    if let value = favor.object(forKey: key) as? Bool{
                        if(value == true){
                            
                            
                            let newStr:RealmString = RealmString()
                            newStr.str = key
                            self.favorites.append(newStr)
                        }
                        
                    }
                }
            }
        }
        
        
        
        
        
        
        if let sub_category = obj.object(forKey: "sub_category") as? NSDictionary{
            
            
            let allKey = sub_category.allKeys
            for key in allKey{
                if let key = key as? String{
                    
                    if let sub = sub_category.object(forKey: key) as? NSDictionary{
                        
                        let newSub:RealmSubCategoriesDataModel = RealmSubCategoriesDataModel()
                        newSub.readJson(obj: sub)
                        
                        
                        self.subCategory.append(newSub)
                        
                        self.keywordForSearch = String(format: "%@, %@", self.keywordForSearch, newSub.sub_category_name.lowercased())
                        
                    }
                    
                    
                }
            }
            
            
        }
        
        
        
    }
    
    
}




// MARK: -
// MARK: - RealmDataObject
class RealmDataObject: NSObject {

}
