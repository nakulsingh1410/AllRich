//
//  PKImV3ImageFileManager.swift
//  DownloadImageV3
//
//  Created by supapon pucknavin on 5/13/2560 BE.
//  Copyright © 2560 supapon pucknavin. All rights reserved.
//

import UIKit

class PKImV3ImageFileManager: NSObject {

    static let sharedInstance = PKImV3ImageFileManager()
    
    
    
    
    
    var arImageQueue:[PKImV3ImageDataModel] = [PKImV3ImageDataModel]()
    var working:Bool = false
    
    
    
    var arOperation:[PKImV3Operation] = [PKImV3Operation]()
    let downloadQueue = OperationQueue()
    
    override init() {
        super.init()
        
        //downloadQueue.maxConcurrentOperationCount = 5
        
        self.loadSaveData()
        
        
        if(self.arImageQueue.count == 0){
            let timeNow = NSDate().timeIntervalSince1970
            self.removeCastImage()
            let lastSave:NSNumber = NSNumber(value: timeNow)
            self.saveLastClearCast(Time: lastSave)
        }
    }
    
    
    
    func getImageWithURL(strURL:String) -> PKImV3ImageDataModel {
        
        var imModel:PKImV3ImageDataModel! = nil
        
        for im in self.arImageQueue{
            
            if(im.strURL == strURL){
                imModel = im
                
                var indexQ:NSInteger = -1
                if(imModel.downloadStatus != .wait){
                    for i in 0..<self.arOperation.count{
                        let q = self.arOperation[i]
                         if(q.strURL == strURL){
                           indexQ = i
                            break
                        }
                    }
                }
                
                
                if(indexQ >= 0){
                    self.arOperation.remove(at: indexQ)
                }
                break
            }
        }
        
        if(imModel == nil){
            //Create new
            imModel = PKImV3ImageDataModel()
            imModel.strURL = strURL
            imModel.downloadStatus = .wait
            
            self.arImageQueue.append(imModel)
            
            
        }
        
        
        
        
        if(imModel.downloadStatus == .wait){
        
            self.runDownload()
        }
        return imModel
    }
    
    
    
    func runDownload() {
        
        if(self.working == false){
            
            
            var imModel:PKImV3ImageDataModel! = nil
            for im in self.arImageQueue{
                if(im.downloadStatus == .wait){
                    imModel = im
                    break
                }
            }
            
            
            if(imModel != nil){
                //self.working = true
                
                /*
                let newDownload:PKImV3DownloadGet = PKImV3DownloadGet()
                newDownload.loadFileMethodsGetWithURL(strUrl: imModel.strURL, HandleCallback: { (imageModelDownload) in
                    
                    for im in self.arImageQueue{
                        if(im.strURL == imageModelDownload.strURL){
                            
                            im.imageName = imageModelDownload.imageName
                            im.imageThumbnailName = imageModelDownload.imageThumbnailName
                            im.imageOriginalPath = imageModelDownload.imageOriginalPath
                            im.imageThumbnailPath = imageModelDownload.imageThumbnailPath
                            im.imageOriginalURL = imageModelDownload.imageOriginalURL
                            im.imageThumbnailURL = imageModelDownload.imageThumbnailURL
                            im.downloadStatus = imageModelDownload.downloadStatus
                            break
                        }
                    }
 

                
                
                    
                    self.working = false
                    
                    
                })
                
 */
                
                var haveQeue:Bool = false
                
                for q in self.arOperation{
                    
                    if(q.strURL == imModel.strURL){
                        haveQeue = true
                        break
                    }
                }
                
                
                if(haveQeue == false){
                    let nwQeue:PKImV3Operation = PKImV3Operation(sURL: imModel.strURL, callBack: { (imageModelDownload) in
                        for im in self.arImageQueue{
                            if(im.strURL == imageModelDownload.strURL){
                                
                                im.imageName = imageModelDownload.imageName
                                im.imageThumbnailName = imageModelDownload.imageThumbnailName
                                im.imageOriginalPath = imageModelDownload.imageOriginalPath
                                im.imageThumbnailPath = imageModelDownload.imageThumbnailPath
                                im.imageOriginalURL = imageModelDownload.imageOriginalURL
                                im.imageThumbnailURL = imageModelDownload.imageThumbnailURL
                                im.downloadStatus = imageModelDownload.downloadStatus
                                break
                            }
                        }
                        
                        
                        
                        
                        
                        self.working = false
                        
                        PKImV3ImageFileManager.sharedInstance.saveImageListData()
                        
                    })
                    
                    //print("Add Qeue")
                    self.arOperation.append(nwQeue)
                    downloadQueue.addOperation(nwQeue)
                }
                
                
            }else{
                
            }
            
        }
    }
    
    
    
    
    
    func loadSaveData() {
        let defaults = UserDefaults.standard
        let load:[[String:String]]? = defaults.value(forKey: "LZDownloadImageListV3") as? [[String:String]]
        if let load = load{
            
            
            for obj in load{
                
                let item:PKImV3ImageDataModel = PKImV3ImageDataModel()
                let strURL:String? = obj["strURL"]
                if let strURL = strURL{
                    item.strURL = strURL
                }
                
                let status:String? = obj["status"]
                if let status = status{
                    
                    if(status == "wait"){
                        item.downloadStatus = .wait
                    }else if(status == "loading"){
                        item.downloadStatus = .loading
                    }else if(status == "success"){
                        item.downloadStatus = .finish
                    }else if(status == "fail"){
                        item.downloadStatus = .fail
                    }
                    
                    
                }
                
                
                
                let imageName:String? = obj["imageName"]
                if let imageName = imageName{
                    item.imageName = imageName
                    
                    let oriPath:String = getImageDownloadPath()
                    let oriP:String = String(format: "/%@", imageName)
                    let strImagePath:String = oriPath.appending(oriP)
                    
                    item.imageOriginalPath = strImagePath
                    let oriURL:URL = URL(fileURLWithPath: strImagePath)
                    item.imageOriginalURL = oriURL
                }
                
                
                let imageThumbnailName:String? = obj["imageThumbnailName"]
                if let imageThumbnailName = imageThumbnailName{
                    item.imageThumbnailName = imageThumbnailName
                    
                    
                    let oriPath:String = getImageThumbnailPath()
                    let oriP:String = String(format: "/%@", imageThumbnailName)
                    let strImagePath:String = oriPath.appending(oriP)
                    
                    item.imageThumbnailPath = strImagePath
                    let thumURL:URL = URL(fileURLWithPath: strImagePath)
                    item.imageThumbnailURL = thumURL
                    
                }
                
                
            

                
                self.arImageQueue.append(item)
                
            }
            
            
        }
    }
    
    func saveImageListData(){
        
        var arSaveData:[[String:String]] = [[String:String]]()
        
        for item in self.arImageQueue{
            
            var newObject:[String:String] = [String:String]()
            
            newObject["strURL"] = item.strURL
            
            newObject["imageName"] = item.imageName
            
            newObject["imageThumbnailName"] = item.imageThumbnailName
            
            newObject["imageOriginalPath"] = item.imageOriginalPath
            
            newObject["imageThumbnailPath"] = item.imageThumbnailPath
            
            
            
            if(item.downloadStatus == .finish){
                let strStatus = "success"
                newObject["status"] = strStatus
                arSaveData.append(newObject)
            }
            
            
            
            
        }
        
        
        let defaults = UserDefaults.standard
        defaults.set(arSaveData, forKey: "LZDownloadImageListV3")
        defaults.synchronize()
        
        
    }
    
    
    
    
    func removeCastImage(){
        //[[NSFileManager defaultManager] removeItemAtPath: [DowloadImageManager getImageThumbnailPath] error: Nil];
        if(self.arImageQueue.count > 0){
            self.arImageQueue.removeAll()
        }
        self.saveImageListData()
        
        
        
        do{
            try FileManager.default.removeItem(atPath: getImageDownloadPath())
        }catch{
            
        }
        
        do{
            try FileManager.default.removeItem(atPath: getImageThumbnailPath())
        }catch{
            
        }
        
    }
    
    
    func getLastClearCast() -> NSNumber {
        let defaults = UserDefaults.standard
        let load:NSNumber? = defaults.object(forKey: "LastClearCastImage") as? NSNumber
        if let load = load{
            
            return load
        }
        return NSNumber(value: 0)
    }
    
    func saveLastClearCast(Time time:NSNumber) {
        
        
        let defaults = UserDefaults.standard
        defaults.set(time, forKey: "LastClearCastImage")
        defaults.synchronize()
    }
    
    
    
    
    func checkAutoClearCastImageWith(TimeSec timed:Double) {
        let timeNow = NSDate().timeIntervalSince1970
        
        let last = self.getLastClearCast().doubleValue
        
        let dif = Double(timeNow) - last
        if(dif > timed){
            self.removeCastImage()
            
            let lastSave:NSNumber = NSNumber(value: timeNow)
            self.saveLastClearCast(Time: lastSave)
        }
        
    }
    
    
    
    
    
}
