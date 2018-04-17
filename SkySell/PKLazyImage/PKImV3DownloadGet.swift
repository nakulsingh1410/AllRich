//
//  PKImV3DownloadGet.swift
//  DownloadImageV3
//
//  Created by supapon pucknavin on 5/13/2560 BE.
//  Copyright © 2560 supapon pucknavin. All rights reserved.
//

import UIKit

class PKImV3DownloadGet: NSObject {

    
    
    
    
   

    
    func loadFileMethodsGetWithURL(strUrl:String, HandleCallback callback:@escaping (PKImV3ImageDataModel)->Void ) {
        
        let newImage:PKImV3ImageDataModel = PKImV3ImageDataModel()
        newImage.downloadStatus = .fail
        newImage.strURL = strUrl
        
        
        
        let urlUpdate:URL? = URL(string: strUrl)
        if let urlUpdate = urlUpdate{
            var request = URLRequest(url: urlUpdate)
            
            request.httpMethod = "GET"
         
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                
                
                if let _ = response, let data = data{
                    
                    let image:UIImage? = UIImage(data: data)
                    if let image = image{
                        
                        
                        let dataPNG = UIImagePNGRepresentation(image)
                        if let dataPNG = dataPNG{
                            
                            let oriPath:String = getImageDownloadPath()
                            let thumPath:String = getImageThumbnailPath()
                            
                            let dateFormatFull:DateFormatter = DateFormatter()
                            dateFormatFull.dateFormat = "yyyy_MM_dd_HH_mm_ss_SSSS"
                            dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
                            
                            let strDate:String = dateFormatFull.string(from: Date())
                            
                            let ran = arc4random_uniform(UInt32(1000))
                            
                            let imageName:String = String(format: "%@%d.png", strDate, ran)
                            let imageThumName:String = String(format: "Thumbnail_%@", imageName)
                            
                            
                            let oriP:String = String(format: "/%@", imageName)
                            let thumP:String = String(format: "/%@", imageThumName)
                            
                            let strImagePath:String = oriPath.appending(oriP)
                            let strImageThumPath:String = thumPath.appending(thumP)
                            
                            
                            let oriURL:URL = URL(fileURLWithPath: strImagePath)
                            let thumURL:URL = URL(fileURLWithPath: strImageThumPath)
                            do {
                                
                                
                                try dataPNG.write(to: oriURL, options: Data.WritingOptions.atomic)
                                
                                newImage.imageName = imageName
                                newImage.imageOriginalPath = strImagePath
                                newImage.imageOriginalURL = oriURL
                                //-----------
                            
                                
                                let size:CGSize = image.size
                                let minSize:CGSize = CGSize(width: 200, height: 200)
                                var sc:CGFloat = minSize.width / size.width
                                let scH:CGFloat = minSize.height / size.height
                                if(scH < sc){
                                    sc = scH
                                }
                                
                                let thumSize:CGSize = CGSize(width: (image.size.width * sc), height: (image.size.height * sc))
                                
                                let imageThumView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: thumSize.width, height: thumSize.height))
                                imageThumView.image = image
                                imageThumView.contentMode = .scaleAspectFill
                                
                                
                                /*
                                let buffer:UIView = UIView(frame: CGRect(x: 0, y: 0, width: thumSize.width, height: thumSize.height))
                                buffer.addSubview(imageThumView)
                                buffer.backgroundColor = UIColor.clear
                                buffer.setNeedsDisplay()
                                
                                
                              
                                UIGraphicsBeginImageContextWithOptions(buffer.bounds.size, imageThumView.isOpaque, 0.0)
                                buffer.drawHierarchy(in: buffer.bounds, afterScreenUpdates: false)
                                let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
                                UIGraphicsEndImageContext()
                                */
                                
                                
                                UIGraphicsBeginImageContext(imageThumView.frame.size)
                                imageThumView.layer.render(in: UIGraphicsGetCurrentContext()!)
                                let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
                                UIGraphicsEndImageContext()
                                
                                
                                
                                
                                //print(snapshotImageFromMyView)
                                let timage = snapshotImageFromMyView
                                if let timage = timage{
                                    let thumDataPNG = UIImagePNGRepresentation(timage)
                                    if let thumDataPNG = thumDataPNG{
                                        
                                        
                                        do {
                                            
                                            
                                            try thumDataPNG.write(to: thumURL, options: Data.WritingOptions.atomic)
                                            newImage.imageThumbnailName = imageThumName
                                            newImage.imageThumbnailPath = strImageThumPath
                                            newImage.imageThumbnailURL = thumURL
                                            
                                            
                                            newImage.downloadStatus = .finish
                                            callback(newImage)
                                            
                                            
                                            
                                        }catch{
                                            print(error.localizedDescription)
                                            
                                            callback(newImage)
                                        }
                                        
                                        
                                    }else{
                                        callback(newImage)
                                    }
                                    
                                }else{
                                    callback(newImage)
                                }
       
                            }catch{
                                print(error.localizedDescription)
                                
                                callback(newImage)
                            }
                        }else{
                            callback(newImage)
                        }
                    }else{
                        callback(newImage)
                    }
                }else{
                    var errMess:String = ""
                    if let error = error{
                        print(error)
                        errMess = error.localizedDescription
                    }
                    
                    print(errMess)
                    callback(newImage)
                }
            })
            
            task.resume()
            
            
        }else{
            callback(newImage)
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
