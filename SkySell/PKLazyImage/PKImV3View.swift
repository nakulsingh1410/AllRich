//
//  PKImV3View.swift
//  DownloadImageV3
//
//  Created by supapon pucknavin on 5/13/2560 BE.
//  Copyright © 2560 supapon pucknavin. All rights reserved.
//

import UIKit
import Nuke

protocol PKImV3ViewDelegate {
    func startLoadImage(view:PKImV3View)
    func finishLoadImage(view:PKImV3View)
   
}



class PKImV3View: UIView {

    var myFrame:CGRect = CGRect.zero
    
    var imageView:UIImageView! = nil
    
    
    var strURL:String = ""
    
    
    var myTimerUpdate:Timer?
    var manager = Nuke.Manager.shared
    
    var myImageData:PKImV3ImageDataModel! = PKImV3ImageDataModel()
    let downloadManager:PKImV3ImageFileManager! = PKImV3ImageFileManager.sharedInstance
    
    
    var isLoadThumbnail:Bool = false
    
    var delegate:PKImV3ViewDelegate?
    
    convenience init() {
        self.init(frame:CGRect.zero)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
        self.updateFrame(newFrame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    func setupView() {
        
        self.clipsToBounds = true
        
        if(imageView == nil){
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: myFrame.width, height: myFrame.height))
            self.addSubview(imageView)
            imageView.contentMode = .scaleAspectFill
        }
        
        
    }

    
    func updateFrame(newFrame:CGRect) {
        
        if((newFrame.origin.x != myFrame.origin.x) || (newFrame.origin.y != myFrame.origin.y) || (newFrame.size.width != myFrame.size.width) || (newFrame.size.height != myFrame.size.height)){
            
            myFrame = newFrame
            
            self.frame = newFrame
            
            if(imageView == nil){
                imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: myFrame.width, height: myFrame.height))
                self.addSubview(imageView)
            }else{
                imageView.frame = CGRect(x: 0, y: 0, width: myFrame.width, height: myFrame.height)
            }
            
            
        }
    }
    
    
    func updateImageSize(size:CGSize) {
        
        
        if((size.width != myFrame.size.width) || (size.height != myFrame.size.height)){
            
            myFrame = CGRect(x: myFrame.origin.x, y: myFrame.origin.y, width: size.width, height: size.height)
            
            
            
            if(imageView == nil){
                imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: myFrame.width, height: myFrame.height))
                self.addSubview(imageView)
            }else{
                imageView.frame = CGRect(x: 0, y: 0, width: myFrame.width, height: myFrame.height)
            }
            
            
        }
    }
    
    func loadImage(imageURL:String, Thumbnail thum:Bool) {
        
        //var startLoad:Bool = false
        
        self.imageView.image = nil
        let url:URL? = URL(string: imageURL)
        if let url = url{
            let request = makeRequest(with: url)
            manager.loadImage(with: request, into: self.imageView)
        }
        
        
        
        
        
        
        
        /*
        if((imageURL != self.strURL) || (thum != self.isLoadThumbnail) ){
            
            self.strURL = imageURL
            self.isLoadThumbnail = thum
            
            self.imageView.alpha = 0
            
            startLoad = true
            
            delegate?.startLoadImage(view: self)
            
            
            self.myImageData = downloadManager.getImageWithURL(strURL: imageURL)
            
            if(self.myImageData.downloadStatus == .finish){
                
            
                if(thum == true){
                    self.imageView.image = UIImage(contentsOfFile: self.myImageData.imageThumbnailPath)
                }else{
                    self.imageView.image = UIImage(contentsOfFile: self.myImageData.imageOriginalPath)
                }
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.imageView.alpha = 1
                })
                
            }
        }else{
            
            
            
            if(self.myImageData.downloadStatus != .finish){
                self.imageView.alpha = 0
                
                if(self.myImageData.downloadStatus == .fail){
                    
                }else{
                    startLoad = true
                    self.myImageData = downloadManager.getImageWithURL(strURL: imageURL)
                }
                
            }else{
                
            
                
                if(thum == true){
                    self.imageView.image = UIImage(contentsOfFile: self.myImageData.imageThumbnailPath)
                }else{
                    self.imageView.image = UIImage(contentsOfFile: self.myImageData.imageOriginalPath)
                }
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.imageView.alpha = 1
                })
                
            }
        }
        
        
        
        if(startLoad == true){
            if(self.myTimerUpdate == nil){
                self.myTimerUpdate = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PKImV3View.downloadLoop), userInfo: nil, repeats: true)
            }
            
        }else{
            self.stopTimer()
            delegate?.finishLoadImage(view: self)
        }
*/
        
    }
    
    
    func stopTimer() {
        if(myTimerUpdate != nil){
            
            if(myTimerUpdate?.isValid == true){
                myTimerUpdate?.invalidate()
            }
            myTimerUpdate = nil
        }
    }
    
    
    func removeObject(){
        
        self.stopTimer()
        
        
        if(imageView != nil){
            imageView?.removeFromSuperview()
            imageView = nil
        }
    }
    
    
    
    func downloadLoop() {
        
        self.loadImage(imageURL: self.strURL, Thumbnail: self.isLoadThumbnail)
        
    }
    
    
    // MARK: - Action
    
    func makeRequest(with url: URL) -> Request {
        return Request(url: url)
    }
    
    
    
}
