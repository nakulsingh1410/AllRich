//
//  CategoriesPickerVC.swift
//  SkySell
//
//  Created by DW02 on 5/19/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase


class CategoriesPickerVC: UIViewController {

    
    @IBOutlet weak var btBack: UIButton!
    @IBOutlet weak var btDone: UIButton!
    
    @IBOutlet weak var viTopBar: UIView!
    
    
    @IBOutlet weak var viSearchBG: UIView!
    
    @IBOutlet weak var viSearchFrame: UIView!
    
    @IBOutlet weak var tfSearch: UITextField!
    
    @IBOutlet weak var myTable: UITableView!
    
    
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    let cellCollectionFont:UIFont = UIFont(name: "Avenir-Medium", size: 11)!
    
    

    
   
    
    var working:Bool = false
    
    
    var myData:ShareData = ShareData.sharedInstance
    
    
    
    
    var lastSelectAtRow:NSInteger = -1
    
    
    
  
    
    
    
    
    
    var callBack:(_ selectCategories:CategoriesDataModel?)->Void = {(CategoriesDataModel) in }
    
    
    var catID1:String = ""
    var catID2:String = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        
        self.tfSearch.delegate = self
        
        
        self.viTopBar.isUserInteractionEnabled = true
        
        
        self.viTopBar.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viTopBar.layer.shadowRadius = 1
        self.viTopBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viTopBar.layer.shadowOpacity = 0.5
        
        
        self.viSearchFrame.clipsToBounds = true
        self.viSearchFrame.layer.cornerRadius = 2
        
        
        
        
        
        for cat in self.myData.arCategoriesDataModel{
            cat.isSelect = false
            
            for sub in cat.subCategory.values{
                sub.isSelect = false
            }
        }
        
        
        
        
        
        if(catID1.count > 0){
            
            for i in 0..<self.myData.arCategoriesDataModel.count{
                if(self.myData.arCategoriesDataModel[i].category_id == catID1){
                    self.myData.arCategoriesDataModel[i].isSelect = true
                    
                    self.lastSelectAtRow = i
                    if(catID2.count > 0){
                        for key in self.myData.arCategoriesDataModel[i].subCategory.keys{
                            
                            if(key == catID2){
                                self.myData.arCategoriesDataModel[i].subCategory[key]?.isSelect = true
                            }
                            
                        }
                        
                    }
                    
                    
                    
                    
                }
                
            }
            
        }
        
        
        
        
        
        
        
        do{
            let nib:UINib = UINib(nibName: "CategoriesCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "CategoriesCell")
        }
        
     
        
        
        
        self.myTable.delegate = self
        self.myTable.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Action

    
    @IBAction func tapOnBack(_ sender: UIButton) {
        self.callBack(nil)
        self.exitScene()
        
    }
    
    @IBAction func tapOnDone(_ sender: UIButton) {
        
        var buffCat:CategoriesDataModel! = CategoriesDataModel()
        for cat in self.myData.arCategoriesDataModel{
            
            if(cat.isSelect == true){
                buffCat = cat
                break
            }
        }
        
        self.callBack(buffCat)
        self.exitScene()
        
        
    }
    
    func exitScene() {
        if let navigation = self.navigationController{
            navigation.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: {
                
            })
        }
    }
    
    
    
    
    func searchCategoriesWith(Key strKey:String){
        
        if(strKey.count <= 0){
            for cat in self.myData.arCategoriesDataModel{
                cat.isSearchShow = true
            }
        }else{
            
            for cat in self.myData.arCategoriesDataModel{
                let nsStr:NSString = NSString(string: cat.keywordForSearch.lowercased())
                
                let range = nsStr.range(of: strKey.lowercased())
                if(range.length > 0){
                    cat.isSearchShow = true
                }else{
                    cat.isSearchShow = false
                }
            }
            
            
            
            
        }
        
        self.myTable.reloadSections([0], with: UITableViewRowAnimation.fade)
        
        
    }
    

}





// MARK: - UITableViewDelegate, UITableViewDataSource
extension CategoriesPickerVC:UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
    }
    
    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //var numberOfCell:NSInteger = 0
        
        
        return myData.arCategoriesDataModel.count
    }
    
    // MARK: - Cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        var cellHeight:CGFloat = 50
        
        
        
   
        
        let categories = self.myData.arCategoriesDataModel[indexPath.row]
        
        
        
        
        
        
        if(categories.isSearchShow == true){
            if(categories.isSelect == true){
                if(categories.subCategory.count > 0){
                    
                    var arKey:[String] = [String]()
                    for obj in categories.subCategory{
                        arKey.append(obj.key)
                    }
                    
                    
                    let width:CGFloat = self.screenSize.width - 44
                    var lastX:CGFloat = 0
                    var lastY:CGFloat = 8
                    
                    
                    for key in arKey{
                        
                        let subCat:SubCategoriesDataModel = categories.subCategory[key]!
                        
                        
                        let text:String = subCat.sub_category_name
                        
                        
                        let cellW = widthForView(text: text, Font: self.cellCollectionFont, Height: 30) + 20
                        
                        let checkX:CGFloat = lastX + cellW
                        if(checkX > width){
                            lastY = lastY + 34
                            lastX = 0
                        }
                        
                        lastX = lastX + cellW + 4
                        
                    }
                    
                    lastY = lastY + 38
                    cellHeight = cellHeight + lastY
                    
                    
                    
                }
            }
        }else{
            cellHeight = 0
        }
        
        
        
        
        
        
        
        return cellHeight
    }
    
    /*
     // MARK: - Header height
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     
     var cellHeight:CGFloat = 30
     
     return cellHeight
     
     }
     
     // MARK: - Header cell
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
     let cell:LabelHeaderCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LabelHeaderCell") as? LabelHeaderCell
     
     return cell
     }*/
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
     
        
        //print("Cell =====   \(indexPath)")
        
        
        let cell:CategoriesCell? = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell", for: indexPath) as? CategoriesCell
        cell?.selectionStyle = .none
        cell?.clipsToBounds = true
        cell?.tag = indexPath.row
        
        
        let categories = self.myData.arCategoriesDataModel[indexPath.row]
        cell?.lbTitle.text = categories.category_name
        
        cell?.reloadDataWithCategories(categorie: categories)
        cell?.myCollection.alwaysBounceVertical = false
        cell?.myCollection.isScrollEnabled = false
        cell?.myTag = indexPath.row
        
        cell?.callBack = {(subCate, cellTag) in
            
            
            if(cellTag < self.myData.arCategoriesDataModel.count){
                
                let bSCat = self.myData.arCategoriesDataModel[cellTag].subCategory[subCate.sub_category_id]
                
                if let bSCat = bSCat{
                    
                    let value:Bool = bSCat.isSelect
                    
                    
                    for subCat in self.myData.arCategoriesDataModel[cellTag].subCategory{
                        subCat.value.isSelect = false
                    }
                    
                    
                    if(value == true){
                        self.myData.arCategoriesDataModel[cellTag].subCategory[subCate.sub_category_id]?.isSelect = false
                    }else{
                        self.myData.arCategoriesDataModel[cellTag].subCategory[subCate.sub_category_id]?.isSelect = true
                    }
                    
                    
                    let cindex:IndexPath = IndexPath(row: cellTag, section: 0)
                    self.myTable.reloadRows(at: [cindex], with: UITableViewRowAnimation.fade)
                    
                }
                
                
                
                
                
            }
            
            
            
            
            
        }
        
        
        if(categories.isSelect == false){
            cell?.contentView.backgroundColor = UIColor.white
        }else{
            cell?.contentView.backgroundColor = UIColor(red: (237.0/255.0), green: (237.0/255.0), blue: (237.0/255.0), alpha: 1.0)
        }
        
        return cell!
        
    }
    
    // MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if(indexPath.row != self.lastSelectAtRow){
            
            
            if((self.lastSelectAtRow >= 0) && (self.lastSelectAtRow < self.myData.arCategoriesDataModel.count)){
                
                for cat in self.myData.arCategoriesDataModel{
                    cat.isSelect = false
                    
                    for sub in cat.subCategory.values{
                        sub.isSelect = false
                    }
                }
            }
            
            
            self.myData.arCategoriesDataModel[indexPath.row].isSelect = true
            
            
            
            if((self.lastSelectAtRow >= 0) && (self.lastSelectAtRow < self.myData.arCategoriesDataModel.count)){
                
                let indexLast:IndexPath = IndexPath(row: self.lastSelectAtRow, section: 0)
                
                self.myTable.reloadRows(at: [indexLast, indexPath], with: UITableViewRowAnimation.fade)
                
            }else{
                self.myTable.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
            
            
            
            self.lastSelectAtRow = indexPath.row
            
            
            
            
            
            
            
            
        }
       
        
        
        
        
        
        
        
        
        self.myTable.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    
}






// MARK: - UITableViewDelegate, UITableViewDataSource
extension CategoriesPickerVC:UITextFieldDelegate{
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        
        
        
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let seconds = 0.150
        let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            
            self.searchCategoriesWith(Key: self.tfSearch.text!)
            
        }
        
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        let seconds = 0.150
        let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            
            self.searchCategoriesWith(Key: self.tfSearch.text!)
            
        }
       
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
    
        self.searchCategoriesWith(Key: self.tfSearch.text!)
        
        
        return true
        
    }
    
}






