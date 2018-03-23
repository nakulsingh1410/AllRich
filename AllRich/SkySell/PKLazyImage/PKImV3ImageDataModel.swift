//
//  PKImV3ImageDataModel.swift
//  DownloadImageV3
//
//  Created by supapon pucknavin on 5/13/2560 BE.
//  Copyright © 2560 supapon pucknavin. All rights reserved.
//

import UIKit

class PKImV3ImageDataModel: NSObject {

    enum Status {
        case wait
        case loading
        case finish
        case fail
    }
    
    var strURL:String = ""
    var imageName:String = ""
    var imageThumbnailName:String = ""
    
    var imageOriginalPath:String = ""
    var imageThumbnailPath:String = ""
    
    var imageOriginalURL:URL! = nil
    var imageThumbnailURL:URL! = nil
    
    
    
    var downloadStatus:Status = .wait
}
