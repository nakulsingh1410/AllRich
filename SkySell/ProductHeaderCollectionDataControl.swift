//
//  ProductHeaderCollectionDataControl.swift
//  SkySell
//
//  Created by DW02 on 4/19/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class ProductHeaderCollectionDataControl: NSObject {
    
    var arSubCategories:[SubCategoriesDataModel] = [SubCategoriesDataModel]()

    let imageDefault:UIImage = UIImage(named: "iconGallery.png")!
    
    var selsetAt:[NSInteger:Bool] = [NSInteger:Bool]()
    
    
    var callBackSelect:(NSInteger)->Void = {(row) in }
    
}

extension ProductHeaderCollectionDataControl:UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arSubCategories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:ProductSubCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductSubCategoryCell", for: indexPath) as! ProductSubCategoryCell
        
        
        // cell.updateFrameSize(size: self.customLayout.itemSize)
        let sebCat = arSubCategories[indexPath.row]
        
        cell.lbTitle.text = sebCat.sub_category_name
        //cell.lazyImage.setupDefaultImage(DefaultImage: imageDefault, DefaultImageContent: UIViewContentMode.center)
        
    
        //print(sebCat.image_sub_category_src)
        
        
        cell.lazyImage.loadImage(imageURL: sebCat.image_sub_category_src, Thumbnail: true)
        
      
        
        
        let select = self.selsetAt[indexPath.row]
        if let select = select{
            if(select == false){
               cell.setStatusToHighlight(highlight: false, Animation: false)
            }else{
                cell.setStatusToHighlight(highlight: true, Animation: false)
            }
        }else{
            cell.setStatusToHighlight(highlight: false, Animation: false)
        }
        
    
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        var selected = self.selsetAt[indexPath.row]
        if let select = selected{
            if(select == false){
                self.selsetAt[indexPath.row] = true
                selected = true
            }else{
                self.selsetAt[indexPath.row] = false
                selected = false
            }
        }else{
            self.selsetAt[indexPath.row] = true
            selected = true
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ProductSubCategoryCell{
            cell.setStatusToHighlight(highlight: selected!, Animation: true)
        }
   
        self.callBackSelect(indexPath.row)
        
    }
}
