//
//  ProductDataModel.swift
//  SkySell
//
//  Created by DW02 on 4/21/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class ProductDataModel: NSObject {

    
    enum PostStatus:String{
        case active = "Active"
        case report = "Report"
        case ban = "Ban"
    }
    
    
    enum ProductStatus:String{
        case soldOut = "Sold Out"
        case chating = "Chatting"
        case offering = "Offering"
        case noOfferYet = "No Offer Yet"
        case reserved = "Reserved"
    }
    
    
    
    var category1:String = ""
    var category2:String = ""
    var created_at:NSInteger = 0
    var created_at_Date:Date! = Date()
    var created_at_server_timestamp:NSInteger = 0
    
    var image_name:String = ""
    var image_path:String = ""
    var image_src:String = ""
    
    
    var images:[PostImageObject] = [PostImageObject]()
    
    
    var isDeleted:Bool = false
    var isNew:Bool = true
    var likeCount:NSInteger = 0
    var manufacturer:String = ""
    var model:String = ""
    var price:String = ""
    
    var price_server_Number:Double = 0
    
    
    
    
    var product_description:String = ""
    var product_id:String = ""
    var product_id_number:String = ""
    var product_latitude:Double = 0.0
    var product_location:String = ""
    var product_longitude:Double = 0.0
    
    var product_serials:[SerialProductDataModel] = [SerialProductDataModel]()
    
    var product_status:String = ""
    var status:String = ""
    var title:String = ""
    var uid:String = ""
    var updated_at:NSInteger = 0
    var updated_at_Date:Date! = Date()
    var updated_at_server_timestamp:NSInteger = 0
    
    
    var year:String = ""
    var country:String = ""
    var points:Int = 0
    var accountType:String = ""

    var report_id:[String] = [String]()
    
    
    
    var viewCount:NSInteger = 0
    
    var likes:[String] = [String]()
    
    
    
    var isLoading:Bool = true
    
    
    
    
    
    var owner_FirstName:String = ""
    var owner_LastName:String = ""
    var owner_Image_src:String = ""
    
    var isUserLike:Bool = false
    
    var loadFinish:Bool = false
    
    
    override init() {
        super.init()
    }
    
    convenience init(dictionary:NSDictionary){
        
        self.init()
        self.readJson(obj: dictionary)
    }
    

    
    
    
    func readJson(obj:NSDictionary) {
        
        if let category1 = obj.object(forKey: "category1") as? String{
            self.category1 = category1
        }
        
        if let category2 = obj.object(forKey: "category2") as? String{
            self.category2 = category2
        }
        
        if let points = obj["points"] as? String ,let newPoint = Int(points){
            self.points = newPoint
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
        
        
        
        
        
        if let product_img = obj.object(forKey: "image") as? NSDictionary{
            let newImage:PostImageObject = PostImageObject()
            
            
            if let image_name = product_img.object(forKey: "name") as? String{
                self.image_name = image_name
                newImage.image_name = image_name
            }
            
            if let image_path = product_img.object(forKey: "path") as? String{
                self.image_path = image_path
                newImage.image_path = image_path
            }
            
            if let image_src = product_img.object(forKey: "src") as? String{
                self.image_src = image_src
                newImage.image_src = image_src
            }
            
            images.append(newImage)
            
        }
  
        //--------------------------------------------
        
        
        
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
                        images.append(newImage)
                    }
                    
                    
                }else if let item = item as? String{
                    if(self.image_src == item){
                    }else{
                        
                        let newImage:PostImageObject = PostImageObject()
                        newImage.image_src = item
                        images.append(newImage)
                    }
                }
            }
            
        }
        
        
        
        print(images.count)
        
        if((self.image_src == "") && (self.images.count > 0)){
            self.image_name = self.images[0].image_name
            self.image_path = self.images[0].image_path
            self.image_src = self.images[0].image_src
        }
        
        
        //---------------------------
        
        
        
        if let isDeleted = obj.object(forKey: "isDeleted") as? Bool{
            self.isDeleted = isDeleted
        }
        
        
        if let isNew = obj.object(forKey: "isNew") as? Bool{
            self.isNew = isNew
        }
        
        
//        if let likeCount = obj.object(forKey: "likeCount") as? NSInteger{
//            self.likeCount = likeCount
//        }
        
        
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
        }
        
        
        if let price_number = obj.object(forKey: "price_number") as? Double{
            self.price_server_Number = price_number

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
                
                let newItem:SerialProductDataModel = SerialProductDataModel()
                newItem.serial_Id = "\(i)"
                if let amount = item["amount"] as? String{
                    if let am = NSInteger(amount){
                        newItem.amount = am
                    }
                    
                }
                
                if let serialNumber = item["serialNumber"] as? String{
                    newItem.serial_Title = serialNumber
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
        
        
        
        
        if let updated_at = obj.object(forKey: "updated_at") as? NSInteger{
            self.updated_at = updated_at
            
            self.updated_at_Date = Date(timeIntervalSince1970: TimeInterval(updated_at/1000))
        }
        
        
        if let updated_at_server_timestamp = obj.object(forKey: "updated_at_server_timestamp") as? NSInteger{
            self.updated_at_server_timestamp = updated_at_server_timestamp
            
            self.updated_at = updated_at_server_timestamp
            self.updated_at_Date = Date(timeIntervalSince1970: TimeInterval(updated_at_server_timestamp/1000))
        }
        
        
        
        if let year = obj.object(forKey: "year") as? String{
            self.year = year
        }
        
        
        
        if let country = obj.object(forKey: "country") as? String{
            self.country = country
        }
        
        
        //-----
        self.report_id.removeAll()
        if let dicreport_id = obj.object(forKey: "report_id") as? NSDictionary{
            let arKey = dicreport_id.allKeys
            for key in arKey{
                
                let value:Bool? = dicreport_id.object(forKey: key) as? Bool
                if let value = value{
                    if(value == true){
                        
                        if let strKey = key as? String{
                            self.report_id.append(strKey)
                        }
                    }
                }
                
            }
        }
        
        //-----
        
        self.likes.removeAll()
        if let dicreport_id = obj.object(forKey: "likes") as? NSDictionary{
            let arKey = dicreport_id.allKeys
            for key in arKey{
                
                let value:Bool? = dicreport_id.object(forKey: key) as? Bool
                if let value = value{
                    if(value == true){
                        
                        if let strKey = key as? String{
                            self.likes.append(strKey)
                        }
                    }
                }
                
            }
        }
        
        //-----
        
        self.isUserLike = false
        let myData:ShareData = ShareData.sharedInstance
        if(myData.userInfo != nil){
            
            for like in myData.userLike{
                
                if(self.product_id == like.product_id){
                    self.isUserLike = true
                }
            }
            
        }
        self.likeCount = myData.getLikToProduct(productID: self.product_id).count
        self.isLoading = false
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
        
        
        
        var arProduct_serials:[[String:String]] = [[String:String]]()
        
        for i in 0..<self.product_serials.count{
            let item = self.product_serials[i]
            
            if((item.serial_Title != "") && (item.amount != 0)){
                var newItem:[String:String] = [String:String]()
                newItem["amount"] = "\(item.amount)"
                newItem["serialNumber"] = item.serial_Title
                
                arProduct_serials.append(newItem)
            }
            
            
        }
        
        
        dicData["product_serials"] = arProduct_serials
        
        
        
        dicData["status"] = status
        
        
        var arReport_id:[String:Bool] = [String:Bool]()
        for item in self.report_id{
            arReport_id[item] = true
            
        }
        dicData["report_id"] = arReport_id
        

        dicData["product_status"] = product_status
        
        dicData["created_at"] = created_at
        dicData["updated_at"] = updated_at
        
        dicData["created_at_server_timestamp"] = created_at_server_timestamp
        dicData["updated_at_server_timestamp"] = updated_at_server_timestamp
        
        
        
        
        dicData["isDeleted"] = isDeleted
        dicData["viewCount"] = viewCount
        dicData["likeCount"] = likeCount
        
        var arLike:[String:Bool] = [String:Bool]()
        for item in self.likes{
            arLike[item] = true
            
        }
        dicData["likes"] = arLike
        
        dicData["uid"] = uid
        dicData["points"] = points

        
        
    
        return dicData
        
    }
    
}
