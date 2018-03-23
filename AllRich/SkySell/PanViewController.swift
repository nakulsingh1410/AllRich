//
//  PanViewController.swift
//  DemoHome
//
//  Created by supapon pucknavin on 10/22/2559 BE.
//  Copyright © 2559 DW02. All rights reserved.
//

import UIKit

class PanViewController: UIViewController {

    var isURLImage:Bool = false
    
    var strImageName:String = ""
 
    
    var haveNoti:Bool = false
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    
    //-----
    
    var lazyImage:PKImV3View! = nil
    var pinchGesture:UIPinchGestureRecognizer! = nil
    var panGesture:UIPanGestureRecognizer! = nil
    var tapGesture:UITapGestureRecognizer! = nil
    
    var lastPont:CGPoint = CGPoint(x: 0, y: 0)
    var lastImagePoint:CGPoint = CGPoint(x: 0, y: 0)
    
    var scaleMap:CGFloat =  1
    var minScale:CGFloat = 1
    
    var pageIndex:NSInteger = 0
    
    var localImage:UIImage! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.lazyImage = PKImV3View(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.view.addSubview(self.lazyImage)
        self.lazyImage.imageView.image = nil

        if(localImage == nil){
            if(isURLImage == false){
                self.lazyImage.imageView.image = UIImage(named: strImageName)
            }else{
                self.lazyImage.loadImage(imageURL: strImageName, Thumbnail: false)
            }
        }else{
            self.lazyImage.imageView.image = localImage
        }
        
        
        self.lazyImage.imageView.contentMode = .center
        
        self.view.clipsToBounds = true
        
        
        self.pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(PanViewController.zoomMap(sender:)))
        self.view.addGestureRecognizer(pinchGesture)
        
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(PanViewController.moveMap(sender:)))
        
        self.view.addGestureRecognizer(self.panGesture)
        self.panGesture.isEnabled = false
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(PanViewController.tapGesture(sender:)))
        self.tapGesture.numberOfTapsRequired = 1
        
        self.view.addGestureRecognizer(tapGesture)
        
        
        
        let dTapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PanViewController.doubleTapGesture(sender:)))
        dTapGesture.numberOfTapsRequired = 2
        
        self.view.addGestureRecognizer(dTapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.updateFrame()
        
        if(haveNoti == false){
            haveNoti = true
            //NotificationCenter.default.addObserver(self, selector: #selector(PanViewController.orientationChanged(notification:)), name:NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(PanViewController.reciveEnablePan(notification:)), name:NSNotification.Name(rawValue: "EnablePanImagePanView"), object: nil)
            
            
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.resetMap(sender: tapGesture)
        UIView.animate(withDuration: 0.45, animations: {
            self.lazyImage.alpha = 1
        })
        
        print(self.pageIndex)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if(haveNoti == true){
            haveNoti = false
            //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)//removeObserver(self, name: name:UIDeviceOrientationDidChangeNotification, object: nil)
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "EnablePanImagePanView"), object: nil)
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - RotageView
    func orientationChanged(notification:NSNotification){
        self.adjustViewsForOrientation(orientation: UIApplication.shared.statusBarOrientation, Animate: false)
    }
    
    func adjustViewsForOrientation(orientation:UIInterfaceOrientation, Animate animate:Bool){
        
        
        
        switch(orientation){
        case .portrait, .portraitUpsideDown:
            break
            
            
        case .landscapeLeft, .landscapeRight:
            break
        default:
            break
            
        }
        
        screenSize = UIScreen.main.bounds
        updateFrame()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // It's an iPhone
            break
        case .pad:
            // It's an iPad
            
            
            let seconds = 0.20
            
            
            let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                self.updateFrame()
            }
            
            
            
            break
        case .unspecified:
            // Uh, oh! What could it be?
            break
        default:
            break
        }
    }
    
    
    func updateFrame() {
        
        self.screenSize = UIScreen.main.bounds
   
        self.resetMap(sender: tapGesture)
    }
    
    
    
    // MARK: - Action
    func reciveEnablePan(notification:NSNotification){
        if let enable = notification.userInfo?["enable"] as? Bool {
            self.enablePan(enable: enable)
        }
        
    }
    
    
    func enablePan(enable:Bool)  {
        self.panGesture.isEnabled = enable
    }
    
    func tapGesture(sender:UITapGestureRecognizer) {
   
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tapForOpenTopBar"), object: nil, userInfo: nil)
    }
    
    func doubleTapGesture(sender:UITapGestureRecognizer) {
        self.resetMap(sender: sender)
 
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tapForOpenTopBar"), object: nil, userInfo: nil)
    }
    
    
    func moveMap(sender:UIPanGestureRecognizer) {
        
        let touchLocation:CGPoint = sender.location(in: self.view)
        
        if(sender.state == .began){
            self.lastPont = touchLocation
            self.lastImagePoint = self.lazyImage.center
        }else{
            
            let dx = touchLocation.x - self.lastPont.x
            let dy = touchLocation.y - self.lastPont.y
            
            self.lazyImage.center = CGPoint(x:self.lastImagePoint.x + dx, y:self.lastImagePoint.y + dy)
        }
        
        
        if(sender.state == .ended){
            self.moveImageToCenter()
            
        }
        
    }
    
    
    func resetMap(sender:UITapGestureRecognizer) {
        
        
        
        self.scaleMap = 1
        let cx:CGFloat = self.view.bounds.size.width / 2.0
        let cy:CGFloat = self.view.bounds.size.height / 2.0
        
       
        UIView.animate(withDuration: 0.25) {
            self.lazyImage.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.lazyImage.center = CGPoint(x:cx, y:cy)
            
            self.lazyImage.updateFrame(newFrame: CGRect(x:0, y:0, width:self.view.bounds.size.width, height:self.view.bounds.size.height))
            self.lazyImage.imageView.contentMode = .scaleAspectFit
            
            
        }
        
    }
    
    
    func zoomMap(sender:UIPinchGestureRecognizer) {
        
        

        
        
        scaleMap = scaleMap * sender.scale

        
        self.lazyImage.transform = CGAffineTransform(scaleX: scaleMap, y: scaleMap)
        
        
        pinchGesture.scale = 1.0
        
        
        
        if(sender.state == .ended){
            if(scaleMap < minScale){
                scaleMap = minScale
                
                let cx:CGFloat = self.view.bounds.size.width / 2.0
                let cy:CGFloat = self.view.bounds.size.height / 2.0
                UIView.animate(withDuration: 0.25) {
                    self.lazyImage.transform = CGAffineTransform(scaleX: self.scaleMap, y: self.scaleMap)
                    self.lazyImage.center = CGPoint(x:cx, y:cy)
                }
            }
            
            self.moveImageToCenter()
        }
    }
    
    
    func moveImageToCenter() {
        
        let scW = self.lazyImage.imageView!.bounds.size.width / self.lazyImage.imageView!.image!.size.width
        let scH = self.lazyImage.imageView!.bounds.size.height / self.lazyImage.imageView!.image!.size.height
        var reSC = scW
        if(scH < scW){
            reSC = scH
        }
        
        let realSize = CGSize(width:self.lazyImage.imageView!.image!.size.width * reSC, height:self.lazyImage.imageView!.image!.size.height * reSC)
        
        
        
        
        let imageBounds = CGRect(x:0, y:0, width:realSize.width * self.scaleMap, height:realSize.height * self.scaleMap)
        print("\(self.lazyImage.center.x) - \(realSize)")
        let ox = self.lazyImage.center.x - (imageBounds.width / 2)
        let oy = self.lazyImage.center.y - (imageBounds.height / 2)
        
        let tx = self.lazyImage.center.x + (imageBounds.width / 2)
        let ty = self.lazyImage.center.y + (imageBounds.height / 2)
        
        
        var newCX = self.lazyImage.center.x
        var newCY = self.lazyImage.center.y
        if((ox < 0) && (tx > self.view.bounds.width)){
            
        }else{
            
            
            if(imageBounds.width > self.view.bounds.width){
                if(ox > 0){
                    newCX = imageBounds.width / 2
                }else if(tx < self.view.bounds.width){
                    newCX = self.view.bounds.width - (imageBounds.width / 2)
                }
            }else{
                if(ox < 0){
                    newCX = imageBounds.width / 2
                }else if(tx > self.view.bounds.width){
                    newCX = self.view.bounds.width - (imageBounds.width / 2)
                }
            }
            
            
            
            
        }
        
        if((oy < 0) && (ty > self.view.bounds.height)){
            
        }else{
            
            if(imageBounds.height > self.view.bounds.height){
                if(oy > 0){
                    newCY = imageBounds.height / 2
                }else if(ty < self.view.bounds.height){
                    newCY = self.view.bounds.height - (imageBounds.height / 2)
                }
            }else{
                if(oy < 0){
                    newCY = imageBounds.height / 2
                }else if(ty > self.view.bounds.height){
                    newCY = self.view.bounds.height - (imageBounds.height / 2)
                }
            }
            
            
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.lazyImage.center = CGPoint(x:newCX, y:newCY)
        })
    }
    
    
    
    
}
