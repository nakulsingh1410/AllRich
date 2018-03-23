//
//  CategoriesDataModel.swift
//  SkySell
//
//  Created by DW02 on 4/20/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class CategoriesDataModel: NSObject {

    var category_id:String = ""
    var category_img_name:String = ""
    var category_img_path:String = ""
    var category_img_src:String = ""
    
    var category_name:String = ""
    var created_at:NSInteger = 0
    var created_at_Date:Date! = Date()
    var created_at_server_timestamp:NSInteger = 0
    
    
    
    var subCategory:[String:SubCategoriesDataModel] = [String:SubCategoriesDataModel]()
    var arSubCategory:[SubCategoriesDataModel] = [SubCategoriesDataModel]()
    
    var updated_at:NSInteger = 0
    var updated_at_Date:Date! = Date()
    var updated_at_server_timestamp:NSInteger = 0
    
    
    
    var favorites:[String] = [String]()
    
    
    
    
    
    var isSelect:Bool = false
    var isSearchShow:Bool = true
    
    var keywordForSearch:String = ""
    
    
    override init() {
        super.init()
    }
    
    convenience init(dictionary:NSDictionary){
        
        self.init()
        self.readJson(obj: dictionary)
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
            
            
        }
        
        
        
        
        
        
        
        
        
        if let updated_at = obj.object(forKey: "updated_at") as? NSInteger{
            self.updated_at = updated_at
            self.updated_at_Date = Date(timeIntervalSince1970: TimeInterval(updated_at/1000))//dateFormatFull.date(from: updated_at)
        }
        
        
        if let updated_at_server_timestamp = obj.object(forKey: "updated_at_server_timestamp") as? NSInteger{
            self.updated_at_server_timestamp = updated_at_server_timestamp
            
            
        }
        
        
        
        
        
        if let favor = obj.object(forKey: "favorite") as? NSDictionary{
            let allKey = favor.allKeys
            for key in allKey{
                if let key = key as? String{
                    if let value = favor.object(forKey: key) as? Bool{
                        if(value == true){
                            self.favorites.append(key)
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
                        
                        let newSub:SubCategoriesDataModel = SubCategoriesDataModel(dictionary: sub)
                        
                        self.subCategory[key] = newSub
                        
                        self.keywordForSearch = String(format: "%@, %@", self.keywordForSearch, newSub.sub_category_name.lowercased())
                        
                    }
                    
                    
                }
            }
            
            
        }
        
        
        self.arSubCategory.removeAll()
        
        var bufArr:[SubCategoriesDataModel] = [SubCategoriesDataModel]()
        
        for v in self.subCategory.values{
            bufArr.append(v)
        }
       
        
        self.arSubCategory = bufArr.sorted(by: { (obj1, obj2) -> Bool in
            return obj1.order < obj2.order
        })
        
        
    }
    
    
}


class SubCategoriesDataModel: NSObject{
    var category_id:String = ""
    var sub_category_id:String = ""
    
    var image_sub_category_name:String = ""
    var image_sub_category_path:String = ""
    var image_sub_category_src:String = ""
    
    var sub_category_name:String = ""
    
    
    
    
    var order:NSInteger = 0
    var haveOrder:Bool = false
    
    var isSelect:Bool = false
    
    override init() {
        super.init()
    }
    
    convenience init(dictionary:NSDictionary){
        
        self.init()
        self.readJson(obj: dictionary)
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
        
        
        if let order = obj.object(forKey: "order") as? NSInteger{
            self.order = order
            self.haveOrder = true
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
