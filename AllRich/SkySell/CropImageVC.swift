//
//  CropImageVC.swift
//  SkySell
//
//  Created by DW02 on 5/5/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class CropImageVC: UIViewController {

    
    @IBOutlet weak var viTopbarBG: UIView!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var btClose: UIButton!
    
    @IBOutlet weak var btSave: UIButton!
    
    
    var image:UIImage! = nil
    
    
    var callBack:(_ image:UIImage)->Void = {(image) in }
    
    
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    
    
    @IBOutlet weak var viStage: UIView!
    
    
    
    var userImage:UIImageView! = nil
    
    
    var imageScale:CGFloat = 1.0
    var minScale:CGFloat = 1.0
    
 
    
    var originalSize:CGSize = CGSize.zero
    
    
    var lastPoint:CGPoint = CGPoint.zero
    var lastImagePoint:CGPoint = CGPoint.zero
    
    
    var pinchGesture:UIPinchGestureRecognizer! = nil
    var panGesture:UIPanGestureRecognizer! = nil
    var tapGesture:UITapGestureRecognizer! = nil
    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.clipsToBounds = true
        
        self.viStage.clipsToBounds = false
        self.lbTitle.text = ""
        
        if(image != nil){
            
            
            originalSize = image.size
            self.userImage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            
            
            self.viStage.addSubview(self.userImage)
            
            self.userImage.image = image
            
            
            self.userImage.center = CGPoint(x: (screenSize.width/2.0), y: (screenSize.width/2.0))
            
            
            let sw:CGFloat = screenSize.width/image.size.width
            let sh:CGFloat = screenSize.width/image.size.height
            
            self.imageScale = sw
            if(sh > self.imageScale){
                self.imageScale = sh
            }
            
            self.minScale = self.imageScale
            
            
            
            self.userImage.transform = CGAffineTransform(scaleX: self.imageScale, y: self.imageScale)
            
            
        }
        
        
        
        
        self.pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(CropImageVC.zoomMap(sender:)))
        self.view.addGestureRecognizer(pinchGesture)
        
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(CropImageVC.moveMap(sender:)))
        
        self.view.addGestureRecognizer(self.panGesture)
        //self.panGesture.isEnabled = false
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(CropImageVC.doubleTapGesture(sender:)))
        self.tapGesture.numberOfTapsRequired = 2
        
        self.view.addGestureRecognizer(tapGesture)
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - Gesture
    
   
    
    func doubleTapGesture(sender:UITapGestureRecognizer) {
        self.resetMap(sender: sender)
        
    }
    
    
    func moveMap(sender:UIPanGestureRecognizer) {
        
        let touchLocation:CGPoint = sender.location(in: self.view)
        
        if(sender.state == .began){
            self.lastPoint = touchLocation
            self.lastImagePoint = self.userImage.center
        }else{
            
            let dx = touchLocation.x - self.lastPoint.x
            let dy = touchLocation.y - self.lastPoint.y
            
            self.userImage.center = CGPoint(x:self.lastImagePoint.x + dx, y:self.lastImagePoint.y + dy)
        }
        
        
        if(sender.state == .ended){
            self.moveImageToCenter()
            
        }
        
    }
    
    
    func resetMap(sender:UITapGestureRecognizer) {
        
        
        self.imageScale = self.minScale
   
        
        
        UIView.animate(withDuration: 0.25) { 
            self.userImage.transform = CGAffineTransform(scaleX: self.imageScale, y: self.imageScale)
            
            self.userImage.center = CGPoint(x: (self.screenSize.width/2.0), y: (self.screenSize.width/2.0))
        }
        
        
        
        
        
    }
    
    
    func zoomMap(sender:UIPinchGestureRecognizer) {
        
        
        
        
        
        self.imageScale = self.imageScale * sender.scale
        
        
        self.userImage.transform = CGAffineTransform(scaleX: self.imageScale, y: self.imageScale)
        
        
        pinchGesture.scale = 1.0
        
        
        
        if(sender.state == .ended){
            if(self.imageScale < self.minScale){
                self.imageScale = self.minScale
                
                let cx:CGFloat = self.view.bounds.size.width / 2.0
                let cy:CGFloat = self.view.bounds.size.width / 2.0
                UIView.animate(withDuration: 0.25) {
                    self.userImage.transform = CGAffineTransform(scaleX: self.imageScale, y: self.imageScale)
                    self.userImage.center = CGPoint(x:cx, y:cy)
                }
            }else{
                self.moveImageToCenter()
            }
            
            
        }
    }
    
    
    func moveImageToCenter() {
        var ox:CGFloat = 0
        var oy:CGFloat = 0
        var tx:CGFloat = 0
        var ty:CGFloat = 0
        
        var cnter:CGPoint = self.userImage.center
        let nowSize:CGSize = CGSize(width: self.originalSize.width * self.imageScale, height: self.originalSize.height * self.imageScale)
        
        
        ox = cnter.x - (nowSize.width / 2)
        oy = cnter.y - (nowSize.height / 2)
        
        tx = cnter.x + (nowSize.width / 2)
        ty = cnter.y + (nowSize.height / 2)
        
        
        if(ox > 0){
            ox = 0
            cnter.x = nowSize.width / 2
        }else if(tx < self.screenSize.width){
            tx = self.screenSize.width
            
            let delta:CGFloat = nowSize.width - self.screenSize.width
             cnter.x = (nowSize.width / 2) - delta
        }
        
        
        if(oy > 0){
            oy = 0
            cnter.y = nowSize.height / 2
        }else if(ty < self.screenSize.width){
            ty = self.screenSize.width
            let delta:CGFloat = nowSize.height - self.screenSize.width
            cnter.y = (nowSize.height / 2) - delta
        }
        
        UIView.animate(withDuration: 0.25) {
            
            self.userImage.center = cnter
        }
        
    }
    
    
    
    // MARK: - Action
    
    @IBAction func tapOnClose(_ sender: UIButton) {
        
        self.dismiss(animated: true) { 
            
        }
        
    }
    
    @IBAction func tapOnSave(_ sender: UIButton) {
        
        UIGraphicsBeginImageContextWithOptions(viStage.bounds.size, viStage.isOpaque, 0.0)
        viStage.drawHierarchy(in: viStage.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //print(snapshotImageFromMyView)
        let uimage = snapshotImageFromMyView
        if let image = uimage{
            self.callBack(image)
        }
        
        
        self.dismiss(animated: true) {
            
        }
    }
    
    
    
}
