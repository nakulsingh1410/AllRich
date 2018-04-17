//
//  CategoriesFavoriteOperation.swift
//  SkySell
//
//  Created by DW02 on 6/5/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase


class CategoriesFavoriteOperation: AsyncOperation {
    
    var handleCallback:(String, Bool)->Void = {(categoryID, follow) in }
    
    var categoriesId:String = ""
    
    var addLike:Bool = false

    var userId:String = ""
    
    
    init(CategoriesId catID:String, Like like:Bool, UserId uID:String, callBack:@escaping (String, Bool)->Void) {
        self.categoriesId = catID
        self.addLike = like
        self.userId = uID
        
        self.handleCallback = callBack
        
    }
    
    
    
    
    override func main() {
        OperationQueue().addOperation {
            let postRef = FIRDatabase.database().reference().child("categories").child(self.categoriesId).child("favorite").child(self.userId)
            
            
            if(self.addLike == true){
                postRef.setValue(self.addLike, withCompletionBlock: { (error, reference) in
                    
                    self.handleCallback(self.categoriesId, self.addLike)
                })
            }else{
                postRef.setValue(nil, withCompletionBlock: { (error, reference) in
                    
                    self.handleCallback(self.categoriesId, self.addLike)
                })
            }
            
            
            
        }
    }
    
    
}
