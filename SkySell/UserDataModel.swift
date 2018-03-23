//
//  UserDataModel.swift
//  SkySell
//
//  Created by DW02 on 5/10/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class UserDataModel: NSObject {

    var bio:String = ""
    var company_name:String = ""
    var company_website:String = ""
    var created_at:NSInteger = 0
    var created_at_Date:Date = Date()
    var created_at_server_timestamp:NSInteger = 0
    var currency:String = ""
    var email:String = ""
    var first_name:String = ""
    var isActive:Bool = false
    var isSignUp:Bool = false
    var last_name:String = ""
    var password:String = ""
    var phone:String = ""
    
    var profileImage_name:String = ""
    var profileImage_path:String = ""
    var profileImage_src:String = ""
    
    var status:String = ""
    var uid:String = ""
    var updated_at:NSInteger = 0
    var updated_at_date:Date = Date()
    var updated_at_server_timestamp:NSInteger = 0
    var user_type:String = ""
    
    
    var report_id:[String] = [String]()
    
    
    
    var positive_list:[ProductEmotion] = [ProductEmotion]()
    var negative_list:[ProductEmotion] = [ProductEmotion]()
    var neutral_list:[ProductEmotion] = [ProductEmotion]()
    
    
    var plan_id:String = ""
    
    
    var plan_plan_id:String = ""
    var plan_emailGoogle:String = ""
    var plan_purchaseTime:String = ""
    var plan_purchaseTimeDate:Date = Date()
    
    
    
    
    
    var iTune_expire:String = ""
    var iTune_expire_Date:Date = Date().addingTimeInterval(-3000)
    var iTune_plan_id:String = ""
    var iTune_transactionID:String = ""
    var iTune_productID:String = ""
    var iTune_purchaseDate:String = ""
    
    var googlePlay_email:String = ""
    var googlePlay_expire:String = ""
    var googlePlay_expire_Date:Date = Date().addingTimeInterval(-3000)
    var googlePlay_plan_id:String = ""
    var googlePlay_transactionID:String = ""
    var googlePlay_purchaseDate:String = ""
    
    
    
    
    
    
    
    
    
    
    
    var products:[String:Bool] = [String:Bool]()
    
    
    
    
    //var products_liked:[String] = [String]()
    
    let dateFormatFull:DateFormatter = DateFormatter()
    
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
        
        let bio = dictionary.object(forKey: "bio") as? String
        if let bio = bio{
            self.bio = bio
        }
        
        let company_name = dictionary.object(forKey: "company_name") as? String
        if let company_name = company_name{
            self.company_name = company_name
        }
        
        let company_website = dictionary.object(forKey: "company_website") as? String
        if let company_website = company_website{
            self.company_website = company_website
        }
        
        
        
        
        let created_at = dictionary.object(forKey: "created_at") as? NSInteger
        if let created_at = created_at{
            self.created_at = created_at
            
            self.created_at_Date = Date(timeIntervalSince1970: TimeInterval(self.created_at/1000))//self.dateFormatFull.date(from: self.created_at)
          
            
        }
        
        
        if let created_at_server_timestamp = dictionary.object(forKey: "created_at_server_timestamp") as? NSInteger{
            self.created_at_server_timestamp = created_at_server_timestamp
            
            
        }
        
        
        
        
        let currency = dictionary.object(forKey: "currency") as? String
        if let currency = currency{
            self.currency = currency
        }
        
        
        let email = dictionary.object(forKey: "email") as? String
        if let email = email{
            self.email = email
        }
        
        
        let first_name = dictionary.object(forKey: "first_name") as? String
        if let first_name = first_name{
            self.first_name = first_name
        }
        
        
        let isActive = dictionary.object(forKey: "isActive") as? Bool
        if let isActive = isActive{
            self.isActive = isActive
        }
        
        
        let isSignUp = dictionary.object(forKey: "isSignUp") as? Bool
        if let isSignUp = isSignUp{
            self.isSignUp = isSignUp
        }
        
        
        let last_name = dictionary.object(forKey: "last_name") as? String
        if let last_name = last_name{
            self.last_name = last_name
        }
        
        
        
        let password = dictionary.object(forKey: "password") as? String
        if let password = password{
            self.password = password
        }
        
        let phone = dictionary.object(forKey: "phone") as? String
        if let phone = phone{
            self.phone = phone
        }
        
        
        let plan_id = dictionary.object(forKey: "plan_id") as? String
        if let plan_id = plan_id{
            self.plan_id = plan_id
        }
        
        
        
        let plan = dictionary.object(forKey: "plan") as? NSDictionary
        if let plan = plan{
            
            let emailGoogle = plan.object(forKey: "emailGooglePlay") as? String
            if let emailGoogle = emailGoogle{
                self.plan_emailGoogle = emailGoogle
            }
            
            
            let pID = plan.object(forKey: "plan_id") as? String
            if let pID = pID{
                self.plan_plan_id = pID
            }
            
            let purchaseTime = plan.object(forKey: "purchaseTime") as? String
            if let purchaseTime = purchaseTime{
                self.plan_purchaseTime = purchaseTime
                
                
                let pdate:Date? = self.dateFormatFull.date(from: purchaseTime)
                if let pdate = pdate{
                    self.plan_purchaseTimeDate = pdate
                }
                
                
            }
            
            
            
            //---------
            let iTune_expire = plan.object(forKey: "iTune_expire") as? String
            if let iTune_expire = iTune_expire{
                self.iTune_expire = iTune_expire
                
                let pdate:Date? = self.dateFormatFull.date(from: iTune_expire)
                if let pdate = pdate{
                    self.iTune_expire_Date = pdate
                }
                
                
            }
            
            
            let iTune_plan_id = plan.object(forKey: "iTune_plan_id") as? String
            if let iTune_plan_id = iTune_plan_id{
                self.iTune_plan_id = iTune_plan_id
            }
            
            
            let iTune_transactionID = plan.object(forKey: "iTune_transactionID") as? String
            if let iTune_transactionID = iTune_transactionID{
                self.iTune_transactionID = iTune_transactionID
            }
            
            
            let iTune_productID = plan.object(forKey: "iTune_productID") as? String
            if let iTune_productID = iTune_productID{
                self.iTune_productID = iTune_productID
            }
            
            
            let iTune_purchaseDate = plan.object(forKey: "iTune_purchaseDate") as? String
            if let iTune_purchaseDate = iTune_purchaseDate{
                self.iTune_purchaseDate = iTune_purchaseDate
            }
            
            let googlePlay_email = plan.object(forKey: "googlePlay_email") as? String
            if let googlePlay_email = googlePlay_email{
                self.googlePlay_email = googlePlay_email
            }
            
            
            let googlePlay_expire = plan.object(forKey: "googlePlay_expire") as? String
            if let googlePlay_expire = googlePlay_expire{
                self.googlePlay_expire = googlePlay_expire
                
                let pdate:Date? = self.dateFormatFull.date(from: googlePlay_expire)
                if let pdate = pdate{
                    self.googlePlay_expire_Date = pdate
                }
                
            }
            
            let googlePlay_plan_id = plan.object(forKey: "googlePlay_plan_id") as? String
            if let googlePlay_plan_id = googlePlay_plan_id{
                self.googlePlay_plan_id = googlePlay_plan_id
            }
            
            let googlePlay_transactionID = plan.object(forKey: "googlePlay_transactionID") as? String
            if let googlePlay_transactionID = googlePlay_transactionID{
                self.googlePlay_transactionID = googlePlay_transactionID
            }
            
            
            let googlePlay_purchaseDate = plan.object(forKey: "googlePlay_purchaseDate") as? String
            if let googlePlay_purchaseDate = googlePlay_purchaseDate{
                self.googlePlay_purchaseDate = googlePlay_purchaseDate
                
                
                
                
            }
            
            
            
        }
        
        
        
        
        //---------------------------------
        let positive_list_d = dictionary.object(forKey: "positive_list") as? NSDictionary
        if let positive_list_d = positive_list_d{
            
            let allKey:[String]? = positive_list_d.allKeys as? [String]
            if let allKey = allKey{
                for dicProductKey in allKey{
                    
                    
                    let prod:NSDictionary? = positive_list_d.object(forKey: dicProductKey) as? NSDictionary
                    if let prod = prod{
                        
                        
                        let newEmotion:ProductEmotion = ProductEmotion()
                        newEmotion.product_id = dicProductKey
                        
                        
                        let allUID:[String]? = prod.allKeys as? [String]
                        if let allUID = allUID{
                            for uidKey in allUID{
                                
                                let value:Bool? = prod.object(forKey: uidKey) as? Bool
                                if let value = value{
                                    
                                    if(value == true){
                                        
                                        newEmotion.arUser_Uid.append(uidKey)
                                        //print("positive_list == true")
                                    }
                                    
                                    
                                }
                                
                            }
                        }
                     
                        
                        self.positive_list.append(newEmotion)
                        
                    }
                    
                }
            }
            
        }
        //---------------------------------
       
        let negative_list_d = dictionary.object(forKey: "negative_list") as? NSDictionary
        if let negative_list_d = negative_list_d{
            
            let allKey:[String]? = negative_list_d.allKeys as? [String]
            if let allKey = allKey{
                for dicProductKey in allKey{
                    
                    
                    let prod:NSDictionary? = negative_list_d.object(forKey: dicProductKey) as? NSDictionary
                    if let prod = prod{
                        
                        
                        let newEmotion:ProductEmotion = ProductEmotion()
                        newEmotion.product_id = dicProductKey
                        
                        
                        let allUID:[String]? = prod.allKeys as? [String]
                        if let allUID = allUID{
                            for uidKey in allUID{
                                
                                let value:Bool? = prod.object(forKey: uidKey) as? Bool
                                if let value = value{
                                    
                                    if(value == true){
                                        
                                        newEmotion.arUser_Uid.append(uidKey)
                                        //print("negative_list == true")
                                    }
                                    
                                    
                                }
                                
                            }
                        }
                        
                        
                        self.negative_list.append(newEmotion)
                        
                    }
                    
                }
            }
            
        }
        //---------------------------------
        
        let neutral_list_d = dictionary.object(forKey: "neutral_list") as? NSDictionary
        if let neutral_list_d = neutral_list_d{
            
            let allKey:[String]? = neutral_list_d.allKeys as? [String]
            if let allKey = allKey{
                for dicProductKey in allKey{
                    
                    
                    let prod:NSDictionary? = neutral_list_d.object(forKey: dicProductKey) as? NSDictionary
                    if let prod = prod{
                        
                        
                        let newEmotion:ProductEmotion = ProductEmotion()
                        newEmotion.product_id = dicProductKey
                        
                        
                        let allUID:[String]? = prod.allKeys as? [String]
                        if let allUID = allUID{
                            for uidKey in allUID{
                                
                                let value:Bool? = prod.object(forKey: uidKey) as? Bool
                                if let value = value{
                                    
                                    if(value == true){
                                        
                                        newEmotion.arUser_Uid.append(uidKey)
                                        //print("neutral_list == true")
                                    }
                                    
                                    
                                }
                                
                            }
                        }
                        
                        
                        self.neutral_list.append(newEmotion)
                        
                    }
                    
                }
            }
            
        }
        //---------------------------------
        
        
        
        let dicproducts = dictionary.object(forKey: "products") as? NSDictionary
        if let dicproducts = dicproducts{
            
            for key in dicproducts.allKeys{
                
                let value:Bool? = dicproducts.object(forKey: key) as? Bool
                if let value = value{
                    if(value == true){
                        self.products[key as! String] = value
                    }
                    
                    
                }
            }
            
        }
        
        
        
        
        
        
        /*
        let dicproducts_liked = dictionary.object(forKey: "products_liked") as? NSDictionary
        if let dicproducts_liked = dicproducts_liked{
            
            for key in dicproducts_liked.allKeys{
                
                let value:Bool? = dicproducts_liked.object(forKey: key) as? Bool
                if let value = value{
                    if(value == true){
                        self.products_liked.append(key as! String)
                    }
                }
            }
            
        }*/
        
        
        let profile_img = dictionary.object(forKey: "profile_img") as? NSDictionary
        if let profile_img = profile_img{
            
            
            let name = profile_img.object(forKey: "name") as? String
            if let name = name{
                self.profileImage_name = name
            }
            
            
            let path = profile_img.object(forKey: "path") as? String
            if let path = path{
                self.profileImage_path = path
            }
            
            let src = profile_img.object(forKey: "src") as? String
            if let src = src{
                self.profileImage_src = src
            }
            
            
            
        }else{
            let profile_img_d = dictionary.object(forKey: "profile_img_data") as? NSDictionary
            if let profile_img_d = profile_img_d{
                
                
                let name = profile_img_d.object(forKey: "name") as? String
                if let name = name{
                    self.profileImage_name = name
                }
                
                
                let path = profile_img_d.object(forKey: "path") as? String
                if let path = path{
                    self.profileImage_path = path
                }
                
                let src = profile_img_d.object(forKey: "src") as? String
                if let src = src{
                    self.profileImage_src = src
                }
                
                
                
            }
        }
        
        
        
        
        let profile_img_s = dictionary.object(forKey: "profile_img") as? String
        if let profile_img_s = profile_img_s{
            self.profileImage_src = profile_img_s
        }
        
        
        
        
        
        
        
        let status = dictionary.object(forKey: "status") as? String
        if let status = status{
            self.status = status
        }
        
        let uid = dictionary.object(forKey: "uid") as? String
        if let uid = uid{
            self.uid = uid
        }
        
        let updated_at = dictionary.object(forKey: "updated_at") as? NSInteger
        if let updated_at = updated_at{
            self.updated_at = updated_at
            
            self.updated_at_date = Date(timeIntervalSince1970: TimeInterval(self.updated_at/1000))//self.dateFormatFull.date(from: self.updated_at)
           
            
        }
        
        
        
        
        if let updated_at_server_timestamp = dictionary.object(forKey: "updated_at_server_timestamp") as? NSInteger{
            self.updated_at_server_timestamp = updated_at_server_timestamp
        }
        
        
        
        
        
        
        let user_type = dictionary.object(forKey: "user_type") as? String
        if let user_type = user_type{
            self.user_type = user_type
        }
        
        
        
        
        
        //print("------")
        //print(self.getDictionary())
        
    }
    
    func getDictionary()->[String:Any]{
        
        
        
        var dicData:[String:Any] = [String:Any]()
        
        
        dicData["bio"] = bio
        
        
        dicData["company_name"] = company_name
        

        dicData["company_website"] = company_website
        
        
     
        dicData["created_at"] = created_at
        

        dicData["currency"] = currency
        
 
        
        dicData["email"] = email
        
   
        dicData["first_name"] = first_name
        
        
        dicData["isActive"] = isActive
        

        dicData["isSignUp"] = isSignUp
        
        
        dicData["last_name"] = last_name
        

        dicData["password"] = password
        
        
        dicData["phone"] = phone
        
        
        dicData["plan_id"] = plan_id
        
        
      
        
        var plan:[String:String] = [String:String]()
        plan["emailGooglePlay"] = self.plan_emailGoogle
        plan["plan_id"] = self.plan_plan_id
        plan["purchaseTime"] = self.plan_purchaseTime
        
        
        
        plan["iTune_expire"] = self.iTune_expire
        //plan["iTune_expireDate"] = self.iTune_expireDate
        plan["iTune_plan_id"] = self.iTune_plan_id
        plan["iTune_transactionID"] = self.iTune_transactionID
        plan["iTune_productID"] = self.iTune_productID
        plan["iTune_purchaseDate"] = self.iTune_purchaseDate
        plan["googlePlay_email"] = self.googlePlay_email
        plan["googlePlay_expire"] = self.googlePlay_expire
        plan["googlePlay_plan_id"] = self.googlePlay_plan_id
        plan["googlePlay_transactionID"] = self.googlePlay_transactionID
        plan["googlePlay_purchaseDate"] = self.googlePlay_purchaseDate
       // plan["googlePlay_purchaseDate_Date"] = self.googlePlay_purchaseDate_Date
        
        
        
        
        
        dicData["plan"] = plan
        
        
        
        //---------------
        var positive_list_Dic:[String:Any] = [String:Any]()
        
        for posi in self.positive_list{
            
            var newPosi:[String:Bool] = [String:Bool]()
            for uid in posi.arUser_Uid{
                newPosi[uid] = true
            }
            
            
            positive_list_Dic[posi.product_id] = newPosi
        }
        
        dicData["positive_list"] = positive_list_Dic
        //---------------
        
        var negative_list_Dic:[String:Any] = [String:Any]()
        
        for posi in self.negative_list{
            
            var newPosi:[String:Bool] = [String:Bool]()
            for uid in posi.arUser_Uid{
                newPosi[uid] = true
            }
            
            
            negative_list_Dic[posi.product_id] = newPosi
        }
        
        dicData["negative_list"] = negative_list_Dic
        //---------------
        
        var neutral_list_Dic:[String:Any] = [String:Any]()
        
        for posi in self.neutral_list{
            
            var newPosi:[String:Bool] = [String:Bool]()
            for uid in posi.arUser_Uid{
                newPosi[uid] = true
            }
            
            
            neutral_list_Dic[posi.product_id] = newPosi
        }
        
        dicData["neutral_list"] = neutral_list_Dic
        //---------------
        
        
        
        
        
        /*
        var newProductLiked:[String:Bool] = [String:Bool]()
        for key in self.products_liked{
            newProductLiked[key] = true
        }
        
        dicData["products_liked"] = newProductLiked
        */
        
        /*
        var newProduct:[String:Bool] = [String:Bool]()
        for key in self.products{
            newProduct[key] = true
        }
        */
        
        
        dicData["products"] = self.products
        
        
        
        
        
        
        
        var profile_img:[String:String] = [String:String]()
        profile_img["name"] = self.profileImage_name
        profile_img["path"] = self.profileImage_path
        profile_img["src"] = self.profileImage_src
        
        
        
        dicData["profile_img_data"] = profile_img
        
        dicData["profile_img"] = self.profileImage_src
        

        dicData["status"] = status
        
        

        dicData["uid"] = uid
        
        
        dicData["updated_at"] = updated_at
 
        
        dicData["user_type"] = user_type
        
        
  
        return dicData
        
        
        
    }
}


class ProductEmotion:NSObject {
    
    var product_id:String = ""
    var arUser_Uid:[String] = [String]()
    
    
    
    override init() {
        super.init()

    }
    
    convenience init(dictionary:NSDictionary){
        
        self.init()
        
        self.readJson(dictionary: dictionary)
    }
    
    
    
    
    func readJson(dictionary:NSDictionary) {
        
        
        
        let arKey:[String]? = dictionary.allKeys as? [String]
        if let arKey = arKey{
            for key in arKey{
                let value:Bool? = dictionary.object(forKey: key) as? Bool
                if(value == true){
                    arUser_Uid.append(key)
                }
            }
        }
        
        
    }
    
    
    func getDictionary()->[String:Any]{

        
        var dicData:[String:Any] = [String:Any]()
        for key in self.arUser_Uid{
            dicData[key] = true
        }
        
        return dicData

    }
    
    
    
    
    
}





