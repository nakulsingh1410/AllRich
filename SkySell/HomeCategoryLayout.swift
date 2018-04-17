//
//  HomeCategoryLayout.swift
//  SkySell
//
//  Created by supapon pucknavin on 4/16/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class HomeCategoryLayout: UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {

    var screenSize:CGRect = UIScreen.main.bounds
    
    
    let minColumn:NSInteger = 1
    let maxWidth:CGFloat = UIScreen.main.bounds.width//199.0
    let spaceLeading:CGFloat = 8
    
    
    
    override init() {
        super.init()
        self.setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
        
    }
    
    
    func getFitCellWidthWithColumn(column:NSInteger) -> CGFloat {
        var width:CGFloat = (screenSize.width - (spaceLeading * 2.0)) / CGFloat(column)
        if(width > maxWidth){
            let addColumn:NSInteger = column + 1
            width = getFitCellWidthWithColumn(column: addColumn)
        }
        
        return width
    }
    
    func setup() {
        let minItemSpace:CGFloat = 8
        self.minimumInteritemSpacing = minItemSpace
        self.minimumLineSpacing = minItemSpace
        self.sectionInset = UIEdgeInsets(top: spaceLeading, left: spaceLeading, bottom: 30, right: spaceLeading)
        
   
        
        let cellW:CGFloat = self.getFitCellWidthWithColumn(column: minColumn)
        
   
        
        self.itemSize = CGSize(width: cellW, height: 160)
        self.scrollDirection = .vertical
        
        
        
        
    }
    
    
    
    
    override func prepare() {
        super.prepare()
        
    }
    
}
