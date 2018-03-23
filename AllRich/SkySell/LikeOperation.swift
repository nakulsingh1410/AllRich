//
//  LikeOperation.swift
//  SkySell
//
//  Created by DW02 on 5/25/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase


class LikeOperation: AsyncOperation {

    
    var handleCallback:(ProductDataModel)->Void = {(ProductDataModel) in }
    
    var productId:String = ""
    
    var addLike:Bool = false
    
    var nowLike:NSInteger = 0
    
    
    var bufferProduct:ProductDataModel! = nil
    
    
    var userId:String = ""
    var userBuffer:UserDataModel! = nil
    
    
    init(userID:String, like:Bool, productID:String, callBack:@escaping (ProductDataModel)->Void){
        
        self.productId = productID
        self.handleCallback = callBack
        self.addLike = like
    
        self.userId = userID
        
        super.init()
    }
    
    
    override func main() {
        OperationQueue().addOperation {
            
            
       
            self.getLikeForProduct(ProductID: self.productId, UserID: self.userId, Finish: { (favoriteID) in
                
                if(favoriteID == ""){
                    
                    if(self.addLike == true){
                        self.addFavoriteWith(ProductID: self.productId, UserID: self.userId, Finish: { (favoriteID2) in
                            
                            self.updateLikeCountToProductData()
                        })
                    }else{
                        self.updateLikeCountToProductData()
                    }
                }else{
                    
                    if(self.addLike == false){
                        self.removeLikeWithFavoriteID(fid: favoriteID, Finish: {
                            self.updateLikeCountToProductData()
                        })
                    }else{
                        self.updateLikeCountToProductData()
                    }
                }
            })
 
            
           
            /*
            self.getProductDataWith(ProductID: self.productId, Finish: { (product) in
                if(product.product_id.characters.count > 1){
                    
                    self.bufferProduct = product
                    self.nowLike = product.likeCount
                    
                    
                    self.postLikeProductDataWith(ProductID: self.productId, Finish: { 
                        
                        
                        self.getUserDataWith(UID: self.userId, Finish: { (uData) in
                            self.userBuffer = uData
                            ShareData.sharedInstance.userInfo = uData
                            
                            if(self.userBuffer.uid.characters.count > 1){
                                self.updateUserData(Finish: {
                                    
                                    
                                    self.handleCallback(self.bufferProduct)
                                    
                                })
                            }
                            
                            
                            
                            
                        })
                        
                    })
                    
                    
                    
                    
                }
            })
 */
        }
            
    }
    
    
    
    func getLikeForProduct(ProductID productId:String, UserID uid:String, Finish finish:@escaping (String)->Void){
        
        let postRef = FIRDatabase.database().reference().child("favorite")
        let query = postRef.queryOrdered(byChild: "product_id").queryEqual(toValue: productId)
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //var arFavorite:[LikeDataObjec] = [LikeDataObjec]()
            
            var islike:String = ""
            if let value = snapshot.value as? [String:Any]{
                
                
                for (key, va) in value{
                    if let va = va as? [String:Any]{
                        let like:LikeDataObjec = LikeDataObjec(dictionary: va)
                        like.favoriteID = key
                        if(like.uid == uid){
                            islike = key
                            break
                        }
                    }
                }
                
                
                
            }
            
            
            finish(islike)
            
        }) { (error) in
            
            finish("")
        }
        
        
    }
    
    
    func removeLikeWithFavoriteID(fid:String, Finish finish:@escaping ()->Void) {
        let postRef = FIRDatabase.database().reference().child("favorite").child(fid)
        postRef.setValue(nil) { (error, reference) in
            
            finish()
        }
    }
    
    
    
    func addFavoriteWith(ProductID productId:String, UserID uid:String, Finish finish:@escaping (String)->Void) {
        
        
        let postRef = FIRDatabase.database().reference().child("favorite").childByAutoId()
        
        
        var likeData:[String:Any] = [String:Any]()
        
        likeData["uid"] = uid
        likeData["product_id"] = productId
        likeData["created_at"] = FIRServerValue.timestamp()
        
        postRef.setValue(likeData) { (error, reference) in
            
            finish(postRef.key)
        }
    }
    
    
    /*
    func loadProductLikeByUser(uid:String, Finish finish:@escaping ([LikeDataObjec])->Void) {
        
        
        var arLike:[LikeDataObjec] = [LikeDataObjec]()
        
        
        let postRef = FIRDatabase.database().reference().child("favorite")
        let query = postRef.queryEqual(toValue: uid, childKey: "uid")
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
    */
    
    /*
    func loadWhoLikeProduct(productId:String, Finish finish:@escaping ([LikeDataObjec])->Void) {
        
        
        var arLike:[LikeDataObjec] = [LikeDataObjec]()
        
        
        let postRef = FIRDatabase.database().reference().child("favorite")
        let query = postRef.queryEqual(toValue: productId, childKey: "product_id")
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
    
    */
    
    
    
    
    
    func updateLikeCountToProductData() {
        let myData:ShareData = ShareData.sharedInstance
        if(myData.userInfo != nil){
            
            
            
            loadProductLikeByUser(uid: self.userId) { (arLoke) in
                myData.userLike = arLoke
                
                
                
                
                
                ///-----------------
                ShareData.sharedInstance.loadAllLikeData {
                    self.getProductDataWith(ProductID: self.productId, Finish: { (produch) in
                        self.handleCallback(produch)
                        
                    })
                }
                
                
                
                
                ///--------------------------
            }
        }
        
        
    }
    
    
    
    
    
    func getProductDataWith(ProductID productID:String, Finish finish:@escaping (_ product:ProductDataModel)->Void){
        
        let postRef = FIRDatabase.database().reference().child("products").child(productID)
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            var productData:ProductDataModel! = nil
            if let value = snapshot.value as? NSDictionary{
                
                
                productData = ProductDataModel(dictionary: value)
                
                
                
            }
            
            
            finish(productData)
            
            
        })
        
        
    }
    
    
    
   
    func postLikeProductDataWith(ProductID productID:String, Finish finish:@escaping ()->Void){
        
        
        if(self.bufferProduct.likeCount < 0){
            self.bufferProduct.likeCount = 0
        }
        
        if(self.addLike == true){
            
            
            self.bufferProduct.likeCount = self.bufferProduct.likeCount + 1
        }else{
            self.bufferProduct.likeCount = self.bufferProduct.likeCount - 1
            
            
        }
        
        
        if(self.bufferProduct.likeCount < 0){
            self.bufferProduct.likeCount = 0
        }
        
        
        //let dicData = self.bufferProduct.getDictionary()
        
        
        
        
        let postRef = FIRDatabase.database().reference().child("products").child(productID).child("likeCount")
        
        postRef.setValue(self.bufferProduct.likeCount) { (error, ref) in
            finish()
        }
        
        /*
        postRef.updateChildValues(dicData) { (error, ref) in
        
            finish()
        
        }*/
        
        
    }
  
    
    func getUserDataWith(UID uid:String, Finish finish:@escaping (_ userData:UserDataModel)->Void) {
        
        if(uid.count > 2){
            let postRef = FIRDatabase.database().reference().child("users").child(uid)
            
            postRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                var userData:UserDataModel = UserDataModel()
                if let value = snapshot.value as? NSDictionary{
                    
                    
                    userData = UserDataModel(dictionary: value)
                    
                    
                    
                }
                
                finish(userData)
            })
        }else{
            finish(UserDataModel())
        }
        
        
    }
  
    
    
    func updateUserData(Finish finish:@escaping ()->Void) {
        
        
        /*
        if(self.addLike == true){
            
            self.userBuffer.products_liked.append(self.productId)
        }else{
            var i = self.userBuffer.products_liked.count - 1
            while i >= 0 {
                
                let pid:String = self.userBuffer.products_liked[i]
                if(pid == self.productId){
                    self.userBuffer.products_liked.remove(at: i)
                }
                i = i - 1
            }
            
            
        }
        */
        
        let postUserData = self.userBuffer.getDictionary()
        
        let postRef = FIRDatabase.database().reference().child("users").child(self.userId)
        
        postRef.updateChildValues(postUserData) { (error, ref) in
            
            finish()
        }
        
    }
    
}
