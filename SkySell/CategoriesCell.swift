//
//  CategoriesCell.swift
//  SkySell
//
//  Created by DW02 on 5/19/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class CategoriesCell: UITableViewCell {

    var screenSize:CGRect = UIScreen.main.bounds
    
    @IBOutlet weak var viHeaderBG: UIView!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    
    @IBOutlet weak var viLine: UIView!
    
    @IBOutlet weak var myCollection: UICollectionView!
    
    
    var myCategories:CategoriesDataModel = CategoriesDataModel()
    
    var allSubId:[String] = [String]()
    
    let cellFont:UIFont = UIFont(name: "Avenir-Medium", size: 11)!
    
    
    var myTag:NSInteger = 0
    
    var callBack:(_ subCat:SubCategoriesDataModel, _ cellTag:NSInteger)->Void = {(SubCategoriesDataModel, NSInteger) in }
    
    var myLayout:CategoriesPickerCellLayout! = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        //CategoriesTextLabelCell
        
        
        
        let nib1:UINib = UINib(nibName: "CategoriesTextLabelCell", bundle: nil)
        self.myCollection.register(nib1, forCellWithReuseIdentifier: "CategoriesTextLabelCell")
        
        //self.myCollection.contentInset = UIEdgeInsets(top: (topBarHeight-40) + 8, left: 8, bottom: 40, right: 8)
        self.myCollection.delegate = self
        self.myCollection.dataSource = self
        
        
        
        myLayout = CategoriesPickerCellLayout()

        myLayout.delegate = self
      
        
        myCollection.setCollectionViewLayout(myLayout, animated: false)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func reloadDataWithCategories(categorie:CategoriesDataModel) {
        self.myCategories = categorie
        self.allSubId.removeAll()
        
        //print(" =======  ")
       
        for i in 0..<self.myCategories.arSubCategory.count{
       
            let objec = self.myCategories.arSubCategory[i]
            self.allSubId.append(objec.sub_category_id)
            
           // print("\(objec.key)   :  \(objec.value.sub_category_name)")
        }
        
       
        
        //print(" =======  ")
        self.myLayout.delegate = self
        self.myLayout.reloadLayout()
        self.myCollection.reloadData()
    }
}




/*
extension CategoriesCell:UICollectionViewDelegateFlowLayout{
    
    
    
    
 
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let key:String = self.allSubId[indexPath.row]
        let subCat:SubCategoriesDataModel = self.myCategories.subCategory[key]!
        
        
        let text:String = subCat.sub_category_name
        
        
        let w = widthForView(text: text, Font: self.cellFont, Height: 30) + 20
        
        return CGSize(width: w, height: 30)
        
    }
    
}

*/
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate


extension CategoriesCell:UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
        
        let itemCount = self.allSubId.count
        
        
        
        return itemCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        
        let cell:CategoriesTextLabelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesTextLabelCell", for: indexPath) as! CategoriesTextLabelCell
        
        
        if(indexPath.item < self.allSubId.count){
            let key:String = self.allSubId[indexPath.item]
            let subCat:SubCategoriesDataModel? = self.myCategories.subCategory[key]
            if let subCat = subCat{
                cell.lbTitle.text = subCat.sub_category_name
                
                
                
                cell.setToSelect(select: subCat.isSelect)
                
                
                
            }else{
                cell.lbTitle.text = ""
            }
        }
        
        
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(indexPath.item < self.allSubId.count){
            let key:String = self.allSubId[indexPath.item]
            let subCat:SubCategoriesDataModel? = self.myCategories.subCategory[key]
            if let subCat = subCat{
                self.callBack(subCat, self.myTag)
            }
            
        }
       
        
        
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    
    
}


extension CategoriesCell:CategoriesPickerCellLayoutDelegate{
    func collectionView(collectionView: UICollectionView, widthForPhotoAtAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        var w:CGFloat = 0
        
        
        if(indexPath.item < self.allSubId.count){
            let key:String = self.allSubId[indexPath.item]
            
            
            var text:String = ""
            
            
            
            let subCat:SubCategoriesDataModel? = self.myCategories.subCategory[key]
            if let subCat = subCat{
                text = subCat.sub_category_name
            }else{
                text = ""
            }
            
            
            
            
            
            w = widthForView(text: text, Font: self.cellFont, Height: 30) + 20
        }
        
        
        return w
    }
}


