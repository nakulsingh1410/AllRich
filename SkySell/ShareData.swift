//
//  ShareData.swift
//  SkySell
//
//  Created by supapon pucknavin on 4/16/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift


enum SkySell_Notification_Name:String{
    case HomeVCTapOnBack = "HomeVCTapOnBack"
    case HomeVCSetShowBackButton = "HomeVCSetShowBackButton"
    case GroupVCSetShowBackButton = "GroupVCSetShowBackButton"
    case HidenMainTapBar = "HidenMainTapBar"
    case SelectProductsCategories = "SelectProductsCategories"
    case HomeVCGotoLastMode = "HomeVCGotoLastModeNoti"
    case HomeVCGotoSearchModeAll = "HomeVCGotoSearchModeAll"
    case HomeVC_CancelSearch = "HomeVC_CancelSearch"
    case HomeVC_SearchWithKey = "HomeVC_SearchWithKey"
    case GotoLikesScene = "GotoLikesScene"
    case SearchMapShow = "SearchMapShow"
    case ChangeToLikeButton = "ChangeToLikeButton"
}


// MARK: - Healper
func showTapBar(show:Bool) {
    var object:[String:Bool] = [String:Bool]()
    object["show"] = show
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HidenMainTapBar.rawValue), object: nil, userInfo: object)
    
    
}


func getUserDataWith(UID uid:String, Finish finish:@escaping (_ userData:UserDataModel)->Void) {
    
    print("getUserDataWith : \(uid)")
    
    if(uid.count > 2){
        let postRef = FIRDatabase.database().reference().child("users").child(uid)
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            var userData:UserDataModel = UserDataModel()
            if let value = snapshot.value as? NSDictionary{
                
                
                userData = UserDataModel(dictionary: value)
                
                let rUser:RealmUserDataObject = RealmUserDataObject()
                rUser.readJson(dictionary: value)
                
                
                
                let realm = try! Realm()
                
                let predicate = NSPredicate(format: "uid = %@", rUser.uid)
                
                let rProduct = realm.objects(RealmProductDataModel.self).filter(predicate)
                
                
                try! realm.write {
                    realm.add(rUser, update: true)
                    
                    for p in rProduct{
                        
                        p.owner_FirstName = rUser.first_name
                        p.owner_LastName = rUser.last_name
                        p.owner_Image_src = rUser.profileImage_src
                        
                        realm.add(p, update: true)
                    }
                }
                
                
                
            }
            
            finish(userData)
        })
    }else{
        finish(UserDataModel())
    }
    
    
}

func getProductDataWith(ProductID productID:String, Finish finish:@escaping (_ product:ProductDataModel)->Void){
    
    let postRef = FIRDatabase.database().reference().child("products").child(productID)
    
    postRef.observeSingleEvent(of: .value, with: { (snapshot) in
        
        
        var productData:ProductDataModel! = ProductDataModel()
        if let value = snapshot.value as? NSDictionary{
            
            
            productData = ProductDataModel(dictionary: value)
            
            
            let rProduct:RealmProductDataModel = RealmProductDataModel()
            rProduct.readJson(obj: value)
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(rProduct, update: true)
            }
            
            
        }
        
        
        finish(productData)
        
        
    })
    
    
}




func getAllPlans(Finish finish:@escaping (_ plabs:[PlansDataModel], _ appSecret:String)->Void){
    
    
    
    
    
    getiTuneAppSecret { (secret) in
        
        let appS:String = secret
        
        
        let postRef = FIRDatabase.database().reference().child("plans")
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            var arPlans:[PlansDataModel] = [PlansDataModel]()
            
            
            if let value = snapshot.value as? [String:Any]{
                
                
                for obj in value.values{
                    
                    if let obj = obj as? [String:Any]{
                        let newPlan:PlansDataModel = PlansDataModel(dictionary: obj)
                        
                        arPlans.append(newPlan)
                    }
                    
                }
                
                
            }
            
            
           
            finish(arPlans, appS)
            
            
        })
        
        
    }
    

    
}






func getiTuneAppSecret(Finish finish:@escaping (_ secret:String)->Void){
    
    
    
    
    let postRef = FIRDatabase.database().reference().child("iOS_InAppPurchases_Setting").child("AppSecret")
    
    postRef.observeSingleEvent(of: .value, with: { (snapshot) in
        
        
        var str:String = ""
        
        
        if let value = snapshot.value as? String{
            
            
            str = value
            
            
        }
        
        
        finish(str)
        
        
    })
}



func updatePlanToCurrentUser(inApp:NSDictionary){
    
    guard let expiryDate = inApp["expires_date_ms"] as? NSString else {
        //It's not a subscription production since it has no expiry_date_ms field
        //If it's not subscription then skip this item
        return
    }
    

    
    
    guard let purchaseDate = inApp["purchase_date_ms"] as? NSString else {
        //It's not a subscription production since it has no expiry_date_ms field
        //If it's not subscription then skip this item
        return
    }
    
    
    guard let productID = inApp["product_id"] as? NSString else {
        //It's not a subscription production since it has no expiry_date_ms field
        //If it's not subscription then skip this item
        return
    }
    
    
    guard let transactionID = inApp["transaction_id"] as? NSString else {
        //It's not a subscription production since it has no expiry_date_ms field
        //If it's not subscription then skip this item
        return
    }

    
    
    
    
    
    
    let dateFormatFull:DateFormatter = DateFormatter()
    dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    
    
    
    let myData:ShareData = ShareData.sharedInstance
    
    
    
    
    //let isTrial = inApp["is_trial_period"] as? NSString
    
    let expire:Date = Date.init(timeIntervalSince1970: expiryDate.doubleValue / 1000)
    
    let purchase:Date = Date.init(timeIntervalSince1970: purchaseDate.doubleValue / 1000)
    
    
    var itune_plan_id:String = ""
    
    for plan in myData.bufferAllPlans{
        if(plan.itunes_id == productID as String){
            itune_plan_id = plan.plan_id
        }else if((itune_plan_id == "") && (plan.amount <= 0) && (plan.isActive == true)){
            itune_plan_id = plan.plan_id
        }
    }
    
    
    
    if(myData.userInfo != nil){
        if(myData.userInfo.uid.count > 5){
            
            
            
            
            print("user Id: \(myData.userInfo.uid)")
            
            
            //-------
            let postRef_iTune_expire = FIRDatabase.database().reference().child("users").child(myData.userInfo.uid).child("plan").child("iTune_expire")
            
            let strEx:String = dateFormatFull.string(from: expire)
            postRef_iTune_expire.setValue(strEx)
            myData.userInfo.iTune_expire_Date = expire
            myData.userInfo.iTune_expire = strEx
            
            
            //-------
            let postRef_iTune_plan_id = FIRDatabase.database().reference().child("users").child(myData.userInfo.uid).child("plan").child("iTune_plan_id")
            postRef_iTune_plan_id.setValue(itune_plan_id)
            myData.userInfo.iTune_plan_id = itune_plan_id
            
            
            //-------
            let postRef_iTune_transactionID = FIRDatabase.database().reference().child("users").child(myData.userInfo.uid).child("plan").child("iTune_transactionID")
            postRef_iTune_transactionID.setValue(transactionID as String)
            myData.userInfo.iTune_transactionID = transactionID as String
            
            
            //-------
            let postRef_iTune_productID = FIRDatabase.database().reference().child("users").child(myData.userInfo.uid).child("plan").child("iTune_productID")
            postRef_iTune_productID.setValue(productID as String)
            myData.userInfo.iTune_productID = productID as String
            
            
            //-------
            let postRef_iTune_purchaseDate = FIRDatabase.database().reference().child("users").child(myData.userInfo.uid).child("plan").child("iTune_purchaseDate")
            let strPurc:String = dateFormatFull.string(from: purchase)
            postRef_iTune_purchaseDate.setValue(strPurc)
            myData.userInfo.iTune_purchaseDate = strPurc
            
            
            
            
            //-------
            let postRef_iTune_transaction = FIRDatabase.database().reference().child("iTune_transaction").child(transactionID as String).child(myData.userInfo.uid)
            postRef_iTune_transaction.setValue(true, withCompletionBlock: { (error, reference) in
                setAnotherUserToExpire(transitionID: transactionID as String)
                
            })
            
            
            
        }
    }
    
    
    
    
    
    
}


func setAnotherUserToExpire(transitionID:String){
    let dateFormatFull:DateFormatter = DateFormatter()
    dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    
    
    let dateNow:String = dateFormatFull.string(from: Date().addingTimeInterval(-200))
    
    let myData:ShareData = ShareData.sharedInstance
    
    let postRef = FIRDatabase.database().reference().child("iTune_transaction").child(transitionID)
    
    postRef.observeSingleEvent(of: .value, with: { (snapshot) in
        
        
     
        if let value = snapshot.value as? [String:Bool]{
            
            
            for k in value.keys{
                
                if(k != myData.userInfo.uid){
                    let postRef_iTune_expire = FIRDatabase.database().reference().child("users").child(k).child("plan").child("iTune_expire")
                    
                    postRef_iTune_expire.setValue(dateNow)
                }
                
                
            }
            
            
            
        }
        
        
    })
    
    
}




func sendNotificationToUser(UserID tuid:String, Title title:String, Message message:String){
    
    var dic:[String:Any] = [String:Any]()
    
    let topics:String = String(format: "/topics/%@", tuid)
    dic["to"] = topics
    dic["priority"] = "high"
    
    var notification:[String:String] = [String:String]()
    notification["body"] = message
    notification["title"] = title
    
    
    dic["notification"] = notification
    
    
    print(dic)
    //Serialize the dictionary to JSON data
    let json = try! JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions())//try! JSONSerialization.data(withJSONObject: dic, options: [])
    
    
    
    //Create a URLRequest
    let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.httpBody = json
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.addValue("key=AAAAcojL89I:APA91bGBztCAUXYN_K8mznuoGpQA4kS1io3uSRXcymchYLVeuUh54-Ubs5yOu9DkAhw-jf6tZ5COBVDA5g1bGNzF9ybB0AWvELxi5pJ5UNJJ9BWzfwf0vOupkgQMqSYgF0fDXK4Ve4oO", forHTTPHeaderField:"Authorization" )
    
    
    
    
    
    //Let's use the shared URLSession to send the request
    
    let session = URLSession.shared
    
    let task = session.dataTask(with: urlRequest) { (data:Data?, response:URLResponse?, error:Error?) in
        
        if let receiptData = data{
            
            do{
                let reData:[String:Any]? = try JSONSerialization.jsonObject(with: receiptData, options: []) as? [String:Any]
                
               
                 if let reData = reData{
                    print(reData)
                 }
            }catch{
                
            }
            
            
            //self.handleData(data: receiptData)
            
        }else{
            
            
            print(error.debugDescription)
        }
        
        
    }
    
    
    //WE need to tell the task to start
    task.resume()
}








func loadProductLikeByUser(uid:String, Finish finish:@escaping ([LikeDataObjec])->Void) {
    
    
    print(uid)
    let myData:ShareData = ShareData.sharedInstance
    
    
    
    myData.loadAllLikeData {
        
        var arLike:[LikeDataObjec] = [LikeDataObjec]()
        
        
        let postRef = FIRDatabase.database().reference().child("favorite")
        let query = postRef.queryOrdered(byChild: "uid").queryEqual(toValue: uid)//postRef.queryEqual(toValue: uid, childKey: "uid")
        
        
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //var arFavorite:[LikeDataObjec] = [LikeDataObjec]()
            print(snapshot)
            if let value = snapshot.value as? [String:Any]{
                
                
                for (key, va) in value{
                    if let va = va as? [String:Any]{
                        let like:LikeDataObjec = LikeDataObjec(dictionary: va)
                        like.favoriteID = key
                        
                        arLike.append(like)
                        
                    }
                }
                
                
                
            }
            
            finish(arLike)
            
        }) { (error) in
            
           
            finish(arLike)
        }
        
    }
    
   
    
    
    
    
    
    
    
}


func loadWhoLikeProduct(productId:String, Finish finish:@escaping ([LikeDataObjec])->Void) {
    
    
    var arLike:[LikeDataObjec] = [LikeDataObjec]()
    
    
    let postRef = FIRDatabase.database().reference().child("favorite")
    let query = postRef.queryOrdered(byChild: "product_id").queryEqual(toValue: productId)//postRef.queryEqual(toValue: productId, childKey: "product_id")
    query.observeSingleEvent(of: .value, with: { (snapshot) in
        
        //var arFavorite:[LikeDataObjec] = [LikeDataObjec]()
        
        if let value = snapshot.value as? [String:Any]{
            
            
            for (key, va) in value{
                if let va = va as? [String:Any]{
                    let like:LikeDataObjec = LikeDataObjec(dictionary: va)
                    like.favoriteID = key
                    
                    arLike.append(like)
                    
                }
            }
            
            
            
        }
        
        
        finish(arLike)
        
    }) { (error) in
        
        finish(arLike)
    }
    
}
















// MARK: - ShareData
class ShareData: NSObject {

    
    enum ProductDownload{
        case noData
        case loading
        case finish
    }
    
    
    enum PlansStatus{
        case cannotConnect
        case live
        case expired
    }
    
    
    
    
    
    
    
    static let sharedInstance = ShareData()
    
    var userInfo:UserDataModel! = nil{
        didSet{
            
//            if(self.userInfo != nil){
//                self.loadAllLikeData()
//            }else{
//            
//            }
            
        }
    }
    
    var userLike:[LikeDataObjec] = [LikeDataObjec]()
    
    
    var arAllLikeData:[LikeDataObjec] = [LikeDataObjec]()
    
    
    
    var arCategoriesDataModel:[CategoriesDataModel] = [CategoriesDataModel]()
    
    
    
    
    var productDownloading:ProductDownload = .noData
    
    
    
    var masterView:ViewController! = nil
    
    
    var bufferDetailMainVC:ProductDetailVC! = nil
    
    var bufferAllPlans:[PlansDataModel] = [PlansDataModel]()
    var buuferItuneSecret:String = "c3aee60dd0b44360a3c021ab637b8153"
    

    
    
    
    var showingDeletePlan:Bool = false
    
    
    
    
    var imageWaitRemove:[PostImageObject] = [PostImageObject]()
    
    
    
    var removingImage:Bool = false
    var removeAtPath:String = ""
    
    
    var showUserSceneFirstTime:Bool = true
    
    var haveConnectProductAddChild:Bool = false
    var haveConnectProductRemoveChild:Bool = false
    
    var needUpdateCategory:Bool = true
    
    var needUpdateAfterEdit:Bool = false
    
    
    var arBanUser:[UserDataModel] = [UserDataModel]()
    

    var haveLogout:Bool = false
    
    var loadingLikeData:Bool = false
    // MARK: - Action
    
    func saveUserInfo(UID uid:String){
        
        let defaults = UserDefaults.standard
        defaults.set(uid, forKey: "SaveUserID")
        defaults.synchronize()
    }
    
    
    func loadsaveUserInfo_UID()->String{
        let defaults = UserDefaults.standard
        let load:String? = defaults.value(forKey: "SaveUserID") as? String
        
        if let load = load{
            return load
        }else{
            return ""
        }
    }
    
    
    func saveUserEmail(UID uid:String){
        
        let defaults = UserDefaults.standard
        defaults.set(uid, forKey: "SaveUserEmail")
        defaults.synchronize()
    }
    
    
    func loadsaveUserEmail()->String{
        let defaults = UserDefaults.standard
        let load:String? = defaults.value(forKey: "SaveUserEmail") as? String
        
        if let load = load{
            return load
        }else{
            return ""
        }
    }
    
    
    func saveUserPassword(UID uid:String){
        
        let defaults = UserDefaults.standard
        defaults.set(uid, forKey: "SaveUserPassword")
        defaults.synchronize()
    }
    
    
    func loadsaveUserPassword()->String{
        let defaults = UserDefaults.standard
        let load:String? = defaults.value(forKey: "SaveUserPassword") as? String
        
        if let load = load{
            return load
        }else{
            return ""
        }
    }
    
    
    
    func saveDeviceToken(value:String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: "SaveNotificationToken")
        defaults.synchronize()
    }
    
    func loadDeviceToken()->String {
        let defaults = UserDefaults.standard
        let load:String? = defaults.value(forKey: "SaveNotificationToken") as? String
        if let load = load{
            return load
        }else{
            return ""
        }
    }
    
    
    
    
    func loadBanUser(_ finish:@escaping ()->Void) {
        //arBanUser
        
        let postRef = FIRDatabase.database().reference().child("users")
        let query = postRef.queryOrdered(byChild: "status").queryEqual(toValue: "Ban")
        
        query.observeSingleEvent(of: FIRDataEventType.value, with:{ (snapshot) in
            
            self.arBanUser.removeAll()
            
            
            
            if let value = snapshot.value as? NSDictionary{
                
                
                
                
                for object in value.allValues{
                    
                    if let object = object as? NSDictionary{
                        
                        let newUser:UserDataModel = UserDataModel(dictionary: object)
                        
                        self.arBanUser.append(newUser)
                        
                        print("Ban :\(newUser.uid)")
                    }
                    
                    
                    
                }
            }
            
            
            finish()
            
            
        })
        
        
        
    }
    
    
    func loadAllProduct(_ finish:@escaping ()->Void) {
        
        
        DispatchQueue.main.async {
            
            
            
            self.loadBanUser {
                
                
                let postRef = FIRDatabase.database().reference().child("products")
                
                postRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let value = snapshot.value as? NSDictionary{
                        
                        
                        // Realms are used to group data together
                        let realm = try! Realm() // Create realm pointing to default file
                        
                        // Save your object
                        realm.beginWrite()
                        
                        
                        for product in value.allValues{
                            if let product = product as? NSDictionary{
                                
                                //let newRP:RealmProductDataModel = RealmProductDataModel(dictionary: product)
                                
                                let newRP:RealmProductDataModel = RealmProductDataModel()
                                newRP.readJson(obj: product)
                                
                                
                                var isBan:Bool = false
                                for bu in self.arBanUser{
                                    if(newRP.uid == bu.uid){
                                        isBan = true
                                    }
                                }
                                
                                if(isBan == true){
                                    newRP.isDeleted = true
                                }
                                //print("Product :  \(newRP.product_id)")
                                realm.add(newRP, update: true)
                                
                            }
                        }
                        
                        
                        try! realm.commitWrite()
                        
                        
                        
                    }
                    
                    
                    self.connectProductEventAddValue()
                    self.connectProductEventDeleteValue()
                    
                    finish()
                    
                })
                
            }
 
        }

        
    }
    
    
    
    func connectProductEventAddValue(){
        
        
        DispatchQueue.global().async {
            
            
            
            if(self.haveConnectProductAddChild == false){
                self.haveConnectProductAddChild = true
                
                
                let postRef = FIRDatabase.database().reference().child("products")
                
                
                postRef.observe(.childAdded, with: { (snapshot) in
                    
                    if let value = snapshot.value as? NSDictionary{
                        
                        //print("connectProductEventAddValue")
                        //print(value)
                        //print("================")
                        
                        
                        
                        
                        // Realms are used to group data together
                        let realm = try! Realm() // Create realm pointing to default file
                        
                        // Save your object
                        realm.beginWrite()
                        
                        
                        
                        for product in value.allValues{
                            if let product = product as? NSDictionary{
                                
                                //let newRP:RealmProductDataModel = RealmProductDataModel(dictionary: product)
                                
                                let newRP:RealmProductDataModel = RealmProductDataModel()
                                newRP.readJson(obj: product)
                                
                                
                                
                                realm.add(newRP, update: true)
                                
                            }
                        }
                        
                        
                        try! realm.commitWrite()
                        
                        
                        
                    }
                    
                    
                }, withCancel: { (error) in
                    self.haveConnectProductAddChild = false
                    
                })
                
                
            }
            
          
            
        }
    }
    
    func connectProductEventDeleteValue(){
        
        
        DispatchQueue.global().async {
            
            
            
            if(self.haveConnectProductRemoveChild == false){
                self.haveConnectProductRemoveChild = true
                
                
                let postRef = FIRDatabase.database().reference().child("products")
                
                
                postRef.observe(.childRemoved, with: { (snapshot) in
                    
                    if let value = snapshot.value as? NSDictionary{
                        
                        print("connectProductEventDeleteValue")
                        //print(value)
                        //print("================")
                        
                        
                        
                        
                        // Realms are used to group data together
                        let realm = try! Realm() // Create realm pointing to default file
                        
                        // Save your object
                        
                        
                        
                        
                        for product in value.allValues{
                            if let product = product as? NSDictionary{
                                
                                //let newRP:RealmProductDataModel = RealmProductDataModel(dictionary: product)
                                
                                let newRP:RealmProductDataModel = RealmProductDataModel()
                                newRP.readJson(obj: product)
                                
                                
                                 let strPredicate:String = String(format: "product_id == '%@'", newRP.product_id)
                                
                                 let otherResults = realm.objects(RealmProductDataModel.self).filter(strPredicate)
                                
                                
                                if(otherResults.count > 0){
                                    try! realm.write {
                                        realm.delete(otherResults)
                                    }
                                }
                                
                                
                                
                            }
                        }
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                }, withCancel: { (error) in
                    self.haveConnectProductRemoveChild = false
                    
                })
                
                
            }
            
            
            
        }
    }
    
    
    
    func updateProduct(product:ProductDataModel){
        // Realms are used to group data together
        let realm = try! Realm() // Create realm pointing to default file

        
        let strPredicate:String = String(format: "product_id = %@", product.product_id )
        
        
        let products = realm.objects(RealmProductDataModel.self).filter(NSPredicate(format: strPredicate))
        
        if(products.count > 0){
            
            try! realm.write {
                
                for pro in products{
                    pro.category1 = product.category1
                    pro.category2 = product.category2
                    pro.created_at_Date = product.created_at_Date
                    pro.image_name = product.image_name
                    pro.image_path = product.image_path
                    pro.image_src = product.image_src
                    pro.isDeleted = product.isDeleted
                    pro.isNew = product.isNew
                    pro.manufacturer = product.manufacturer
                    pro.model = product.model
                    pro.price = product.price
                    pro.price_server_Number = product.price_server_Number
                    pro.product_description = product.product_description
                    pro.product_id = product.product_id
                    pro.product_id_number = product.product_id_number
                    pro.product_latitude = product.product_latitude
                    pro.product_location = product.product_location
                    pro.product_longitude = product.product_longitude
                   
                    pro.product_serials.removeAll()
                    for item in pro.product_serials{
                        let newItem:RealmSerial = RealmSerial()
                        newItem.amount = item.amount
                        newItem.serialID = item.serialID
                        newItem.serialNumber = item.serialNumber
                        pro.product_serials.append(newItem)
                    }
                    
                        
                    pro.product_status = product.product_status
                    pro.status = product.status
                    pro.title = product.title
                    pro.uid = product.uid
                    pro.updated_at_Date = product.updated_at_Date
                    pro.year = product.year
                    pro.country = product.country
                    pro.viewCount = product.viewCount
                    
                    pro.owner_FirstName = product.owner_FirstName
                    pro.owner_LastName = product.owner_LastName
                    pro.owner_Image_src = product.owner_Image_src
                    
                    
                }
                
                
            }
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    func startUpdateDashboardRegisterData() {
        
        self.getNumberOfSignUp { (num) in
            let next = num + 1
            self.updateNumberOfSignUp(number: next)
            
            self.updateLastOfSignUp(date: Date())
        }
    }
    
    func getNumberOfSignUp(_ finish:@escaping (NSInteger)->Void){
        
        let postRef = FIRDatabase.database().reference().child("dashboard").child("sign_up")
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSInteger{
                finish(value)
            }else{
                finish(-1)
            }
            
        })
        
        
        
        
    }
    
    func updateNumberOfSignUp(number:NSInteger){
        
        let postRef = FIRDatabase.database().reference().child("dashboard").child("sign_up")
        
        postRef.setValue(number)
        
    }
    
    func updateLastOfSignUp(date:Date){
        
        let dateFormatFull:DateFormatter = DateFormatter()
        dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        
        let postRef = FIRDatabase.database().reference().child("dashboard").child("sign_up_last_updated")
        
        postRef.setValue(dateFormatFull.string(from: date))
        
    }
    
    
    
    func checkUserIsExpired()->PlansStatus{
        
        if(self.userInfo == nil){
            return .cannotConnect
        }
        
        if(self.bufferAllPlans.count < 0){
            return .cannotConnect
        }
        
        let planID:String = self.userInfo.plan_id
        

        
        var isFree:Bool = false
        
        for p in self.bufferAllPlans{
            if(p.plan_id == planID){
                if(p.amount <= 0){
                    
                    isFree = true
                    break
                }
            }
        }
        
        if(planID == ""){
            isFree = true
        }
        
        if(isFree == true){
            return .live
        }
        
        
        
        let expireDate:Date? = self.getExpiredDate()
        
        
        if let expireDate = expireDate{
            
            let now = Date()
            
            if(now.timeIntervalSince1970 <=  expireDate.timeIntervalSince1970){
                return .live
            }else{
                return .expired
            }
        }else{
            return .expired
        }
        
        
        
    }
    
    func getExpiredDate() -> Date? {
        let expireDate:Date? = Calendar.current.date(byAdding: Calendar.Component.month, value: 1, to: self.userInfo.plan_purchaseTimeDate)
        
        return expireDate
    }
    
    
    func getListtingsUserCanPost() -> NSInteger {
        
    
        
        if(self.userInfo == nil){
            return 0
        }
        
        if(self.bufferAllPlans.count <= 0){
            return 99
        }
        
        
        var exStatus:NSInteger = 0
    
        let tItune:TimeInterval = self.userInfo.iTune_expire_Date.timeIntervalSince1970
        let tGoogle:TimeInterval = self.userInfo.googlePlay_expire_Date.timeIntervalSince1970
        let tNow:TimeInterval = Date().timeIntervalSince1970
        
      self.userInfo.plan_id = ""
        
        
        if(tNow < tItune){
            exStatus = 1// itune
            
            self.userInfo.plan_id = self.userInfo.iTune_plan_id
        }
        
        if(tNow < tGoogle){
            exStatus = 2 // google
            self.userInfo.plan_id = self.userInfo.googlePlay_plan_id
        }
        
        var amd:NSInteger = 0
        if((tNow < tItune) && (tNow < tGoogle)){
            exStatus = 3 // both
            
            self.userInfo.plan_id = self.userInfo.iTune_plan_id
            
            
            for p in self.bufferAllPlans{
                if((p.plan_id == self.userInfo.iTune_plan_id) && (p.listings > amd)){
                    amd = p.listings
                }
                
                if((p.plan_id == self.userInfo.googlePlay_plan_id) && (p.listings > amd)){
                    amd = p.listings
                }
                
            }
        }
        
        if(exStatus == 3){
            return amd
        }
        
        
        
        
        let planID:String = self.userInfo.plan_id
        
        
        var listings:NSInteger = 0
        
        for p in self.bufferAllPlans{
            
            
            if(planID == ""){
                
                if((p.amount <= 0) && (p.isActive == true)){
                    if(p.listings >= listings){
                        listings = p.listings
                    }
                }
                
            }else{
                if(p.plan_id == planID){
                    
                    if(p.listings >= listings){
                        listings = p.listings
                    }
                }
            }
        }
        
        
        print("user plan : \(self.userInfo.plan_id)")
        
        return listings
    }
    
    
    
    
    
    func getUserPlan() -> PlansDataModel? {
        if(self.userInfo == nil){
            return nil
        }
        
        if(self.bufferAllPlans.count < 0){
            return nil
        }
        
        
    
        
        var exStatus:NSInteger = 0
        
        let tItune:TimeInterval = self.userInfo.iTune_expire_Date.timeIntervalSince1970
        let tGoogle:TimeInterval = self.userInfo.googlePlay_expire_Date.timeIntervalSince1970
        let tNow:TimeInterval = Date().timeIntervalSince1970
        
        self.userInfo.plan_id = ""
        
        
        if(tNow < tItune){
            exStatus = 1// itune
            
            self.userInfo.plan_id = self.userInfo.iTune_plan_id
        }
        
        if(tNow < tGoogle){
            exStatus = 2 // google
            self.userInfo.plan_id = self.userInfo.googlePlay_plan_id
        }
        
        var amd:NSInteger = 0
        if((tNow < tItune) && (tNow < tGoogle)){
            exStatus = 3 // both
            
            self.userInfo.plan_id = self.userInfo.iTune_plan_id
            
            
            for p in self.bufferAllPlans{
                if((p.plan_id == self.userInfo.iTune_plan_id) && (p.listings > amd)){
                    amd = p.listings
                    self.userInfo.plan_id = self.userInfo.iTune_plan_id
                }
                
                if((p.plan_id == self.userInfo.googlePlay_plan_id) && (p.listings > amd)){
                    amd = p.listings
                    self.userInfo.plan_id = self.userInfo.googlePlay_plan_id
                }
                
            }
        }
        
    
        
        
        
        let planID:String = self.userInfo.plan_id
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        var plan:PlansDataModel? = nil
        var listings:NSInteger = 0
        
        for p in self.bufferAllPlans{
            
            
            if(planID == ""){
                
                if(p.amount <= 0){
                    if(p.listings >= listings){
                        plan = p
                        listings = p.listings
                    }
                }
                
            }else{
                if(p.plan_id == planID){
                    
                    plan = p
                    listings = p.listings
                }
            }
        }
        
        
        
        
        return plan
    }
    
    func autoCheckUerPlanNeedManage()->Bool {
        
        
      
        
        if((self.userInfo != nil) && (self.bufferAllPlans.count > 0)){
            //let isExpire = self.checkUserIsExpired()
            
            
            let userPost:NSInteger = self.userInfo.products.count
            let canpost:NSInteger = self.getListtingsUserCanPost()
            
            
            if(userPost > canpost){
                return true
            }else{
                return false
            }
            
            
        }else{
            return false
        }
    }
    
    
    func showDeletePlanScene() {
        
        if(self.showingDeletePlan == false){
            if(self.masterView != nil){
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
                let vc:DeletePlanVC = storyboard.instantiateViewController(withIdentifier: "DeletePlanVC") as! DeletePlanVC
                
                let nav:UINavigationController = UINavigationController(rootViewController: vc)
                
                nav.setNavigationBarHidden(true, animated: false)
                
                
                self.masterView.present(nav, animated: true, completion: {
                    
                })
                
                
            }
        }
    }
    
    
    
    
    func startRunRemoveImage(){
        if(self.removingImage == false){
            
            var imageForDelete:PostImageObject! = nil
            
            for im in self.imageWaitRemove{
                if((im.image_path != "") || (im.image_src != "")){
                    imageForDelete = im
                    break
                }
            }
            
            if(imageForDelete != nil){
                self.removingImage = true
                
                self.removeAtPath = imageForDelete.image_path
                
           
                
                //let storageRef:FIRStorageReference! = FIRStorage.storage().reference()
                
                var deleteImage:FIRStorageReference! = nil// = storageRef.child(self.removeAtPath)
                
                
                if(imageForDelete.image_path == ""){
                    self.removeAtPath = imageForDelete.image_src
                    deleteImage = FIRStorage.storage().reference(forURL: self.removeAtPath)
                }else{
                    deleteImage = FIRStorage.storage().reference(withPath: self.removeAtPath)
                }
                
                
                deleteImage.delete { (error) in
                    if let _ = error {
                        // Uh-oh, an error occurred!
                    } else {
                        // File deleted successfully
                    }
                    
                    print("remove \(imageForDelete.image_path)")
//                    self.myData.userInfo.profileImage_path = ""
//                    self.myData.userInfo.profileImage_src = ""
//                    self.myData.userInfo.profileImage_name = ""
                    
                    
                    for i in 0..<self.imageWaitRemove.count{
                        if((self.imageWaitRemove[i].image_path == self.removeAtPath) || (self.imageWaitRemove[i].image_src == self.removeAtPath)){
                            self.imageWaitRemove[i].image_path = ""
                            self.imageWaitRemove[i].image_src = ""
                            self.imageWaitRemove[i].image_name = ""
                        }
                    }
                    
                    
                    self.removingImage = false
                    
                    self.startRunRemoveImage()
                  
                }
                
            }else{
                self.imageWaitRemove.removeAll()
            }
            
        
            
            
        }
    }
    
    
    
    
    func removeProductFromRealm(productID:String) {
        
        let realm = try! Realm()
        let predicate = NSPredicate(format: "product_id = %@", productID)
        
        let otherResults = realm.objects(RealmProductDataModel.self).filter(predicate)
        
        
        try! realm.write {
            realm.delete(otherResults)
        }
        
        
        
    }
    
    
    
    
    
    
    
    func startDeleteListing(product:ProductDataModel, Finish finish:@escaping (ProductDataModel)->Void){
        
        for image in product.images{
            
            
            if(image.image_src.count > 0){
                self.imageWaitRemove.append(image)
            }
            
            
        }
        
        
        self.removeProductFromRealm(productID: product.product_id)
        
        
        
        
        let postRef = FIRDatabase.database().reference().child("users").child(product.uid).child("products").child(product.product_id)
        postRef.setValue(nil, withCompletionBlock: { (error, ref) in
            
            
            let postRefd = FIRDatabase.database().reference().child("products").child(product.product_id)
            postRefd.setValue(nil, withCompletionBlock: { (error, ref) in
                
                
                
                getUserDataWith(UID: product.uid, Finish: { (userData) in
                    self.startRunRemoveImage()
                    
                    
                    finish(product)
                })
            })
            
            
            
            
            
        })
        
        
        
    }
    
    
    
    
    
    
    func loadAllLikeData(Finish finish:@escaping ()->Void){
        
        
        let postRef = FIRDatabase.database().reference().child("favorite")
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //var arFavorite:[LikeDataObjec] = [LikeDataObjec]()
            
            if(self.loadingLikeData == false){
                self.loadingLikeData = true
                
                if let value = snapshot.value as? [String:Any]{
                    
                    self.arAllLikeData.removeAll()
                    
                    for (key, va) in value{
                        if let va = va as? [String:Any]{
                            let like:LikeDataObjec = LikeDataObjec(dictionary: va)
                            like.favoriteID = key
                            
                            self.arAllLikeData.append(like)
                            
                        }
                    }
                    
                    
                    
                }
                
                
                self.loadingLikeData = false
            }
            
            
            
     
            finish()
            
        }) { (error) in
            
            finish()
        }
        
    }
    
    
    func getLikToProduct(productID:String) -> [LikeDataObjec] {
        
        var arFavorite:[LikeDataObjec] = [LikeDataObjec]()
        for f in self.arAllLikeData{
            if(f.product_id == productID){
                arFavorite.append(f)
            }
        }
        
        return arFavorite
    }
    
}


extension UIColor {
    func brightened(by factor: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * factor, alpha: a)
    }
}
