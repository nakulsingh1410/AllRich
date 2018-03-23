//
//  ProductListLayout.swift
//  SkySell
//
//  Created by supapon pucknavin on 4/17/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

protocol ProductListLayoutDelegate {
    
    func collectionView(collectionView:UICollectionView, HeightForCellAtIndexPath indexPath:IndexPath) -> CGFloat
    
    
    
}

class ProductListLayoutAttributes:UICollectionViewLayoutAttributes {
    
    // 1. Custom attribute
    var cellHeight: CGFloat = 0.0
    var cellWidth: CGFloat = 0.0
    // 2. Override copyWithZone to conform to NSCopying protocol
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! ProductListLayoutAttributes
        copy.cellHeight = cellHeight
        copy.cellWidth = cellWidth
        return copy
    }
    

    
    // 3. Override isEqual
    override func isEqual(_ object: Any?) -> Bool {
        
        if let attributtes = object as? ProductListLayoutAttributes {
            if( (attributtes.cellHeight == cellHeight) && (attributtes.cellWidth == cellWidth)  ) {
                return super.isEqual(object)
            }
        }
        return false
    }
    
   
}



class ProductListLayout: UICollectionViewLayout {
    var screenSize:CGRect = UIScreen.main.bounds
    
    var delegate:ProductListLayoutDelegate!
    
    //2. Configurable properties
    var numberOfColumns = 2
    var cellPadding: CGFloat = 8.0
    var maxWidth:CGFloat = 195.0
    
    
    
    //3. Array to keep a cache of attributes.
    var cache = [ProductListLayoutAttributes]()
    
    //4. Content height and size
    private var contentHeight:CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    
    
    override class var layoutAttributesClass: AnyClass {
        return ProductListLayoutAttributes.self
    }
    
    
  
    
    var showingAttributes = [UICollectionViewLayoutAttributes]()
    override func prepare() {
        
        if cache.isEmpty {
            
            contentHeight = 0
            // 2. Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
            let columnWidth = getFitCellWidthWithColumn(column: 2)
            
            var xOffset = [CGFloat]()
            
            
            for column in 0..<numberOfColumns {
                xOffset.append( cellPadding +  (CGFloat(column) * (cellPadding + columnWidth) ))
            }
          
            
            var column = 0
            var row = 0
            
            
            let tCell:NSInteger = (collectionView!.numberOfItems(inSection: 0) - 1)
            
            var totalRow:NSInteger = tCell / 2
            let over:NSInteger = tCell % 2
            if(over > 0){
                totalRow = totalRow + 3
            }else{
                totalRow = totalRow + 2
            }
            
            
            
            
            var yOffset = [CGFloat](repeating: 8, count: totalRow)
            
            // 3. Iterates through the list of items in the first section
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                
                let indexPath = IndexPath(item: item, section: 0)
                
                // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
                
  
                var width = columnWidth
                
                let height = delegate.collectionView(collectionView: collectionView!, HeightForCellAtIndexPath: indexPath)
               
                
                
                var frame = CGRect(x: xOffset[column], y: yOffset[row], width: width, height: height)
                
                
                if(indexPath.item == 0){
                    width = screenSize.width
                    
                    var pan:CGFloat = 0
                    if(height > 0){
                        pan = cellPadding
                    }
                    
                    frame = CGRect(x: 0, y: pan, width: width, height: height)
                }
                
                
                
                let insetFrame = frame//.insetBy(dx: cellPadding, dy: cellPadding)
                
                // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
                let attributes = ProductListLayoutAttributes(forCellWith: indexPath)
                attributes.cellHeight = height
                attributes.cellWidth = width
                
                attributes.frame = insetFrame
                cache.append(attributes)
                
                // 6. Updates the collection view content height
                contentHeight = max(contentHeight, frame.maxY)
                
              
                var pan:CGFloat = 0
                if(height > 0){
                    pan = cellPadding
                }
                yOffset[row + 1] = yOffset[row] + height + pan
                
                
                if(column >= (numberOfColumns - 1)){
                    column = 0
                    row = row + 1
                }else{
                    if(item == 0){
                        row = row + 1
                    }else{
                        column = column + 1
                    }
                    
                }
                //column = column >= (numberOfColumns - 1) ? 0 : ++column
            }
        }
        
        
        
    }
   
    func reloadLayout() {
        self.cache.removeAll()
        self.prepare()
   
    }
    

    
    func getFitCellWidthWithColumn(column:NSInteger) -> CGFloat {
        var width:CGFloat = (screenSize.width - (cellPadding * (2.0 + CGFloat(column - 1)))) / CGFloat(column)
        
        self.numberOfColumns = column
        if(width > maxWidth){
            let addColumn:NSInteger = column + 1
            self.numberOfColumns = addColumn
            width = getFitCellWidthWithColumn(column: addColumn)
        }
        
        return width
    }
    
    
    override var collectionViewContentSize: CGSize{
        return CGSize(width: contentWidth, height: contentHeight + 30)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes  in cache {
            //if attributes.frame.intersects(rect ) {
                layoutAttributes.append(attributes)
            //}
        }
        self.showingAttributes = layoutAttributes
        return layoutAttributes
        
    }
}




