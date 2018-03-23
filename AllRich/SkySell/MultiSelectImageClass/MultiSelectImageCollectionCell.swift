//
//  MultiSelectImageCollectionCell.swift
//  MultiSelectImage2
//
//  Created by DW02 on 2/15/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Photos
import PhotosUI



class MultiSelectImageCollectionCell: UICollectionViewCell {

    @IBOutlet weak var viBaackground: UIView!
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    @IBOutlet weak var viNumberBG: UIView!
    
    @IBOutlet weak var lbNumber: UILabel!
    
    var viMask: UIView! = nil
  
    
    
    
    
    var number:NSInteger = 0
    
    
    
    var asset:PHAsset?{
        didSet{
            
         
            if let asset = asset{
                
        
                var sc:CGFloat = 1
                if(asset.pixelWidth > asset.pixelHeight){
                    sc = 200 / CGFloat(asset.pixelWidth)
                }else{
                    sc = 200 / CGFloat(asset.pixelHeight)
                }
                
                let tSize:CGSize = CGSize(width: CGFloat(asset.pixelWidth) * sc, height: CGFloat(asset.pixelHeight) * sc)
                
                
                PHImageManager.default().requestImage(for: asset, targetSize: tSize, contentMode: PHImageContentMode.aspectFit, options: nil, resultHandler: { image, _ in
                    
                    self.thumbnailImage.image = image
                })
                
            }else{
                self.thumbnailImage.image = nil
            }
            
            
        }
    }
    
    
    
    let colorActive:UIColor = UIColor(red: (59.0/255.0), green: (121.0/255.0), blue: (255.0/255.0), alpha: 1.0)
    
    
    var cellSize:CGSize = CGSize(width: 0, height: 0)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.clipsToBounds = true
        
        self.viBaackground.clipsToBounds = true
        
        
        
        if self.viMask == nil {
            self.viMask = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            self.viBaackground.addSubview(self.viMask)
            self.viMask.backgroundColor = UIColor.white
        }
        
        
        self.viMask.clipsToBounds = true
        self.viMask.layer.cornerRadius = 5
        
        self.viNumberBG.alpha = 0
        self.viNumberBG.clipsToBounds = true
        self.viNumberBG.layer.cornerRadius = 5
        
        thumbnailImage.mask = viMask
        
        
        self.viBaackground.bringSubview(toFront: viNumberBG)
        self.viNumberBG.backgroundColor = colorActive
        
    }
    
    
    func setActiveCellWith(selectNumber:NSInteger) {
        
        self.number = selectNumber
        self.lbNumber.text = String(format: "%d", self.number)
        
        
        if(selectNumber <= 0){
            self.viMask.frame = CGRect(x: 0, y: 0, width: self.cellSize.width, height: self.cellSize.height)
            self.viBaackground.backgroundColor = UIColor.white
            
            self.viNumberBG.alpha = 0
        }else{
            self.viMask.frame = CGRect(x: 4, y: 4, width: self.cellSize.width - 8, height: self.cellSize.height - 8)
            self.number = selectNumber
            self.viBaackground.backgroundColor = colorActive
         
            self.viNumberBG.alpha = 1
            
           
        }
    }
    
    
    
    func animateButton() {
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.viBaackground.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            
            
            if(self.number <= 0){
                
                self.viMask.frame = CGRect(x: 0, y: 0, width: self.cellSize.width, height: self.cellSize.height)
                self.viBaackground.backgroundColor = UIColor.white
                self.viNumberBG.alpha = 0
            }else{
          
                self.viMask.frame = CGRect(x: 4, y: 4, width: self.cellSize.width - 8, height: self.cellSize.height - 8)
                self.viBaackground.backgroundColor = self.colorActive
                self.lbNumber.text = String(format: "%d", self.number)
                self.viNumberBG.alpha = 1
                
                
               
            }
            
            
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.40, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.viBaackground.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (_) in
                
                
                
                
            }
            
            
        }
    }
    
    
    func updateCellSize(size:CGSize) {
        
        self.cellSize = size
        
        if(self.number <= 0){
            self.viMask.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            self.viNumberBG.alpha = 0
        }else{
            self.viMask.frame = CGRect(x: 4, y: 4, width: size.width - 8, height: size.height - 8)
            self.lbNumber.text = String(format: "%d", self.number)
            self.viNumberBG.alpha = 1
        }
        
        
        
        
    }

}
