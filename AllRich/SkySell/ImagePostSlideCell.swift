//
//  ImagePostSlideCell.swift
//  SkySell
//
//  Created by DW02 on 5/17/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class ImagePostSlideCell: UITableViewCell {

    var screenSize:CGRect = UIScreen.main.bounds
    
    
    var numberOfColumns = 4
    var cellPadding: CGFloat = 4.0
    var maxWidth:CGFloat = 195.0
    
    
    
    @IBOutlet weak var myCollection: UICollectionView!
    
    
    var arImage:[PostImageObject] = [PostImageObject]()
    
    
    
    
    var callBackSelectOnIndex:(NSInteger)->Void = {(index) in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        let nib1:UINib = UINib(nibName: "AddImageCollectionViewCell", bundle: nil)
        self.myCollection.register(nib1, forCellWithReuseIdentifier: "AddImageCollectionViewCell")
        
        //self.myCollection.contentInset = UIEdgeInsets(top: (topBarHeight-40) + 8, left: 8, bottom: 40, right: 8)
        self.myCollection.delegate = self
        self.myCollection.dataSource = self
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension ImagePostSlideCell:UICollectionViewDelegateFlowLayout{
    
    
    
    
    
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
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = self.getFitCellWidthWithColumn(column: self.numberOfColumns)
        
        return CGSize(width: w, height: 99)
        
    }
    
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate


extension ImagePostSlideCell:UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let itemCount = 4
        
        
        
        return itemCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        
        let cell:AddImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImageCollectionViewCell", for: indexPath) as! AddImageCollectionViewCell
        
        
        
        if(indexPath.row < self.arImage.count){
            
            
            let imObj = self.arImage[indexPath.row]
            if(imObj.local_image == nil){
                
                if(imObj.image_src.count < 5){
                    cell.lazyImage.imageView.image = nil
                }else{
                    cell.lazyImage.loadImage(imageURL: imObj.image_src, Thumbnail: true)
                    cell.lazyImage.imageView.contentMode = .scaleAspectFill
                    cell.lazyImage.alpha = 1
                }
                
                
            }else{
                
                cell.lazyImage.imageView.image = imObj.local_image
                cell.lazyImage.imageView.contentMode = .scaleAspectFill
                cell.lazyImage.alpha = 1
            }
            
            
        }else{
            

            cell.lazyImage.imageView.image = nil
        }
        
        cell.cellTag = indexPath.row
        
        
        let w = self.getFitCellWidthWithColumn(column: self.numberOfColumns)
        
        let size = CGSize(width: w, height: 99)
      
        cell.updateCellSize(size: size)
        
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        self.callBackSelectOnIndex(indexPath.row)
        
        
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    
  
}

