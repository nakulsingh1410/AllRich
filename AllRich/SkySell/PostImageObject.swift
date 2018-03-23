//
//  PostImageObject.swift
//  SkySell
//
//  Created by DW02 on 5/18/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class PostImageObject: NSObject {

    var image_name:String = ""
    var image_path:String = ""
    var image_src:String = ""
    
    
    
    var local_image:UIImage! = nil
    
    var local_tag:NSInteger = 0

    var uploadError:Bool = false
    
    var messID:String = ""
    
}
