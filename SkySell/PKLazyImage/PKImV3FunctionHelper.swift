//
//  PKImV3FunctionHelper.swift
//  DownloadImageV3
//
//  Created by supapon pucknavin on 5/13/2560 BE.
//  Copyright © 2560 supapon pucknavin. All rights reserved.
//

import UIKit

// MARK: - Helper
func getImageDownloadPath()->String{
    
    let cachesPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    
    let cachDirectory:String = cachesPaths[0]
    let dataPath:String = cachDirectory.appending("/PickyDownloadImage")
    
    
    //print(dataPath)
    
    if(  (FileManager.default.fileExists(atPath: dataPath)) == false ){
        
        
        do{
            try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
        }catch{
            
        }
        
        
    }
    
    return dataPath
}


func getImageThumbnailPath()->String{
    
    let cachesPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    
    let cachDirectory:String = cachesPaths[0]
    let dataPath:String = cachDirectory.appending("/PickyDownloadImageThumbnail")
    
    
    //print(dataPath)
    
    if(  (FileManager.default.fileExists(atPath: dataPath)) == false ){
        
        
        do{
            try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
        }catch{
            
        }
        
        
    }
    
    return dataPath
}





class PKImV3FunctionHelper: NSObject {

}
