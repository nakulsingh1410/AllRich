//
//  ProductHeaderCell.swift
//  SkySell
//
//  Created by DW02 on 4/18/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class ProductHeaderCell: UICollectionViewCell {

    
    @IBOutlet weak var viBG: UIView!
    
    
    
    
    
    var cellHeight:CGFloat = 118.0
    var screenSize:CGRect = UIScreen.main.bounds
    var customLayout:UICollectionViewFlowLayout!
    var myCollection:UICollectionView! = nil
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if(self.customLayout == nil){
            self.customLayout = UICollectionViewFlowLayout()
            self.customLayout.minimumLineSpacing = 0
            self.customLayout.minimumInteritemSpacing = 0
            self.customLayout.itemSize = CGSize(width: 98, height: cellHeight)
            self.customLayout.scrollDirection = .horizontal
            
        }
        
        
        if(self.myCollection == nil){
            self.myCollection = UICollectionView(frame: CGRect(x:0, y:0, width:screenSize.width, height:cellHeight), collectionViewLayout: self.customLayout)
            self.viBG.addSubview(self.myCollection)
            self.myCollection.backgroundColor = UIColor.clear
            self.myCollection.contentInset.left = 3
            self.myCollection.contentInset.right = 3
            self.myCollection.alwaysBounceHorizontal = true
            
            
            let nib1:UINib = UINib(nibName: "ProductSubCategoryCell", bundle: nil)
            
            self.myCollection.register(nib1, forCellWithReuseIdentifier: "ProductSubCategoryCell")
            
            
            
        }
        
        
        
       
    }

    
   
    
    
    
}
