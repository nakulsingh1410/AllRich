//
//  ProductListCollectionCell.swift
//  SkySell
//
//  Created by DW02 on 4/18/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class ProductListCollectionCell: UICollectionViewCell {

    @IBOutlet weak var viImageBG: UIView!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbDetail: UILabel!
    
    @IBOutlet weak var viImageOwnerBG: UIView!
    
    @IBOutlet weak var viFavoriteBG: UIView!
    
    @IBOutlet weak var imageHeart: UIImageView!
    @IBOutlet weak var lbCount: UILabel!
    
    
    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var btFavorite: UIButton!
    
    
    @IBOutlet weak var viStatusBG: UIView!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    
    
    
    
    
    
    var lazyImage: PKImV3View!
    var lazyImage_Owner: PKImV3View!
    
    
    var myTag:NSInteger = 0
    
    var tapOnLike:(NSInteger)->Void = {(NSInteger) in }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblPoints.text = ""
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 2
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(red: (39.0/255.0), green: (47.0/255.0), blue: (85.0/255.0), alpha: 1.0).cgColor
        
        
        
        self.viImageOwnerBG.clipsToBounds = true
        self.viImageOwnerBG.layer.cornerRadius = 10
        
        
        
        if(self.lazyImage == nil){
            self.lazyImage = PKImV3View(frame: CGRect(x: 0, y: 0, width: 175, height: 145))
            self.viImageBG.addSubview(self.lazyImage)
            self.lazyImage.imageView.contentMode = .scaleAspectFill
            //self.lazyImage.updateImageSize(size: CGSize(width: 175, height: 145))
            self.viImageBG.clipsToBounds = true
            
        }
        
        
        if(self.lazyImage_Owner == nil){
            self.lazyImage_Owner = PKImV3View(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            self.viImageOwnerBG.addSubview(self.lazyImage_Owner)
            self.lazyImage_Owner.imageView.contentMode = .scaleAspectFill
            //self.lazyImage_Owner.updateImageSize(size: CGSize(width: 20, height: 20))
        }
        
        
        
    }

    
    func updateCellSize(size:CGSize) {
        if(self.lazyImage != nil){
          
             self.lazyImage.updateFrame(newFrame: CGRect(x: 0, y: 0, width: size.width, height: 145))
            
        }
        
    }
    
    
    
    @IBAction func TapOnFavorite(_ sender: UIButton) {
        
        
        
        self.tapOnLike(self.myTag)
    }
    
    
}
