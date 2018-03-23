//
//  PKImV3Operation.swift
//  DownloadImageV3
//
//  Created by supapon pucknavin on 5/14/2560 BE.
//  Copyright © 2560 supapon pucknavin. All rights reserved.
//

import UIKit

class PKImV3Operation: AsyncOperation {

    
    var handleCallback:(PKImV3ImageDataModel)->Void = {(imageData) in }
    
    var strURL:String = ""
    
    
    var imModel:PKImV3ImageDataModel! = PKImV3ImageDataModel()
    
    init(sURL:String, callBack:@escaping (PKImV3ImageDataModel)->Void){
        
        self.strURL = sURL
        self.handleCallback = callBack
        
        self.imModel.strURL = sURL
    
        super.init()
    }
    
    
    override func main() {
        OperationQueue().addOperation {
            
            
            let newDownload:PKImV3DownloadGet = PKImV3DownloadGet()
            newDownload.loadFileMethodsGetWithURL(strUrl: self.imModel.strURL, HandleCallback: { (imageModelDownload) in
                
                if(self.imModel.strURL == imageModelDownload.strURL){
                    
                    self.imModel.imageName = imageModelDownload.imageName
                    self.imModel.imageThumbnailName = imageModelDownload.imageThumbnailName
                    self.imModel.imageOriginalPath = imageModelDownload.imageOriginalPath
                    self.imModel.imageThumbnailPath = imageModelDownload.imageThumbnailPath
                    self.imModel.imageOriginalURL = imageModelDownload.imageOriginalURL
                    self.imModel.imageThumbnailURL = imageModelDownload.imageThumbnailURL
                    self.imModel.downloadStatus = imageModelDownload.downloadStatus
                
                }
                
                self.handleCallback(self.imModel)

            })
            
        }
    }
}
