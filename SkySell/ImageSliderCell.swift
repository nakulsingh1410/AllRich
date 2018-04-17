//
//  ImageSliderCell.swift
//  DemoHome
//
//  Created by supapon pucknavin on 10/22/2559 BE.
//  Copyright © 2559 DW02. All rights reserved.
//

import UIKit

class ImageSliderCell: UITableViewCell {

    @IBOutlet weak var viContentBackground: UIView!
    
    
    var myCollection: UICollectionView!
    
    var screenSize:CGRect = UIScreen.main.bounds
    var customLayout:UICollectionViewFlowLayout!
    
    
    
    var nowSize:CGSize = CGSize(width: 0, height: 0)
    
    @IBOutlet weak var myPageControl: UIPageControl!
    
    
    var arImageName:[PostImageObject] = [PostImageObject]()
    
    var myTag:NSInteger = 0
    var callBackTapOnCell:(NSInteger, NSInteger)->Void = {(tag, item) in }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        viContentBackground.clipsToBounds = true
        
        
        if(self.customLayout == nil){
            self.customLayout = UICollectionViewFlowLayout()
            self.customLayout.minimumLineSpacing = 11
            self.customLayout.minimumInteritemSpacing = 0
        }
        
        
        
     
        self.customLayout.itemSize = CGSize(width: screenSize.width, height: 200)
        self.customLayout.scrollDirection = .horizontal
        
        
        if(self.myCollection == nil){
            self.myCollection = UICollectionView(frame: CGRect(x:-11, y:0, width:screenSize.width + 22 , height:300), collectionViewLayout: self.customLayout)
            self.viContentBackground.addSubview(self.myCollection)
            self.myCollection.backgroundColor = UIColor.clear
            self.myCollection.contentInset.left = 0
            self.myCollection.contentInset.right = 11
            self.myCollection.isPagingEnabled = true
            
            let nib1:UINib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
            
            self.myCollection.register(nib1, forCellWithReuseIdentifier: "ImageCollectionViewCell")
            //self.myCollection.register(nib1, forCellReuseIdentifier: "PopularCollectionViewCell")
        }
        
        
        
        self.myCollection.delegate = self
        self.myCollection.dataSource = self
      
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateFrameSize(size:CGSize) {
        self.nowSize = size
        
        self.myPageControl.numberOfPages = self.arImageName.count
        
        self.customLayout.itemSize = CGSize(width:nowSize.width, height: nowSize.height)
        self.myCollection.frame = CGRect(x:0, y:0, width:nowSize.width+11, height:nowSize.height)
        self.myCollection.reloadData()
        
        let indexPath:IndexPath = IndexPath(row: self.myPageControl.currentPage, section: 0)
        self.myCollection.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        
    }
}



// MARK: - UICollectionViewDataSource, UICollectionViewDelegate


extension ImageSliderCell:UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arImageName.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        if indexPath.row < self.arImageName.count {
            //cell.layzyImage.setImageWithFileName(name: self.arImageName[indexPath.row])
            cell.layzyImage.loadImage(imageURL: self.arImageName[indexPath.row].image_src, Thumbnail: false)
            
        }
        
        cell.updateFrameSize(size: self.customLayout.itemSize)
        
        let page = collectionView.contentOffset.x / (self.nowSize.width + 11)
        self.myPageControl.currentPage = NSInteger(page)
        
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row < self.arImageName.count {
            /*
            let message:ImageSliderMessage = ImageSliderMessage()
            message.imageName = self.arImageName
            message.startAt = indexPath.row
            let object:[String:ImageSliderMessage] = ["ImageList": message]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectSliderImage"), object: nil, userInfo: object)
 
 */
            
            
            self.callBackTapOnCell(self.myTag, indexPath.item)
        }
        
        
        
//
//
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / (self.nowSize.width + 11)
        self.myPageControl.currentPage = NSInteger(page)
    }
}
