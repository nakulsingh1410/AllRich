//
//  CategoriesPickerCellLayout.swift
//  SkySell
//
//  Created by DW02 on 5/22/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

protocol CategoriesPickerCellLayoutDelegate {
    func collectionView(collectionView:UICollectionView, widthForPhotoAtAtIndexPath indexPath:IndexPath)-> CGFloat
    
}

class CategoriesPickerCellLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var cellWidth: CGFloat = 0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! CategoriesPickerCellLayoutAttributes
        copy.cellWidth = cellWidth
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? CategoriesPickerCellLayoutAttributes{
            if attributes.cellWidth == cellWidth{
                return super.isEqual(object)
            }
        }
        return false
    }
}


class CategoriesPickerCellLayout: UICollectionViewLayout {

    
    var screenSize:CGRect = UIScreen.main.bounds
    
    var cellPandding:CGFloat = 0
    var delegate:CategoriesPickerCellLayoutDelegate!
   
    private var cache = [CategoriesPickerCellLayoutAttributes]()
    private var contentHeight:CGFloat = 0
    
    private var width:CGFloat{
        get{
            let insets = collectionView!.contentInset
            return collectionView!.bounds.width - (insets.left + insets.right)
        }
    }
    
    override class var layoutAttributesClass: AnyClass {
        // ...
        return CategoriesPickerCellLayoutAttributes.self
    }
    
    
    
    override var collectionViewContentSize: CGSize{
        return CGSize(width: width, height: contentHeight)
    }
    
    
    override func prepare() {
        
        
        self.reloadLayout()
    }
    
    
    func reloadLayout() {
        
        cache.removeAll()
        
        if cache.isEmpty{
            
            
            var lastX:CGFloat = 0
            var lastY:CGFloat = 8
            
            
            for item in 0..<collectionView!.numberOfItems(inSection: 0){
                let indexPath = IndexPath(item: item, section: 0)
                
                let cellW = delegate.collectionView(collectionView: collectionView!, widthForPhotoAtAtIndexPath: indexPath)
                
                let checkX:CGFloat = lastX + cellW
                if(checkX > width){
                    lastY = lastY + 34
                    lastX = 0
                }
                
                let frame = CGRect(x: lastX, y: lastY, width: cellW, height: 30)
                
                lastX = lastX + cellW + 4
                let insetFrame = frame.insetBy(dx: cellPandding, dy: cellPandding)
                
                let attributes = CategoriesPickerCellLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                attributes.cellWidth = cellW
                
                cache.append(attributes)
            }
            
            contentHeight = lastY + 38
            
            
            
        }
        
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache{
            if attributes.frame.intersects(rect){
                layoutAttributes.append(attributes)
            }
        }
        
        
        return layoutAttributes
    }
    
    
    
}
