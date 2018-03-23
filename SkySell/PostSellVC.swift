//
//  PostSellVC.swift
//  SkySell
//
//  Created by DW02 on 5/17/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase

import MapKit
import CoreLocation

import GooglePlaces
import GooglePlacePicker


class PostSellVC: UIViewController {

    enum Condition{
        case nonSet
        case new
        case used
    }
    
    enum CellName:NSInteger {
        case space0 = 0
        case productImage
        case imageTitle
        case sellingTitle
        case titleInput
        case manufacturerTitle
        case manufacturerInput
        case modelTitle
        case modelInput
        case priceTitle
        case priceInput
        case yearTitle
        case yearInput
        case countryTitle
        case countryInput
        case categoryTitle
        case categoryInput
        case productIdTitle
        case productIdInput
        case conditionTitle
        case conditionInput
        case descriptionTitle
        case descriptionInput
        case serial1
        case serial2
        case serial3
        case serial4
        case serial5
        case serial6
        case serial7
        case serial8
        case serial9
        case serial10
        case serial11
        case serial12
        case serial13
        case serial14
        case serial15
        case serial16
        case serial17
        case serial18
        case serial19
        case serial20
        case serial21
        case serial22
        case serial23
        case serial24
        case serial25
        case serial26
        case serial27
        case serial28
        case serial29
        case serial30
        case add_serial
        case locationTitle
        case locationInput
        case edelete
        case delete
        
        
        static let count = 56
        
    }
    
    
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    
    
    @IBOutlet weak var viTopBar: UIView!
    
    
    @IBOutlet weak var btClose: UIButton!
    
    @IBOutlet weak var btSubmit: UIButton!
    
    @IBOutlet weak var myTable: UITableView!
    
    
    @IBOutlet weak var layout_Bottom_Sol: NSLayoutConstraint!
    @IBOutlet weak var btMakeSold: UIButton!
    
    
    
    
    
    
    
    var arImage:[PostImageObject] = [PostImageObject]()
    
    var arImageBeforEdit:[PostImageObject] = [PostImageObject]()
    
    
    var userProduct:ProductDataModel! = ProductDataModel()
    var arSerial:[SerialProductDataModel] = [SerialProductDataModel]()
    
    
    var strTitle:String = ""
    var strManufacturer:String = ""
    var strModel:String = ""
  
    var strPriceOnDevice:String = ""
  
    
    
    var fPrice:Double = 0
    
    var strYear:String = ""
    var strCountry:String = ""
    var strCategory1:String = ""
    var strCategory2:String = ""
    var strProductUserId:String = ""
    var condition_isNew:Bool = true
    var strDrscription:String = ""
    
    var latitude:Double = 0
    var longitude:Double = 0
    var strLocation:String = ""
    
    
    var displayCategory:String = ""
    
    
    let cellFont:UIFont = UIFont(name: "Avenir-Book", size: 14)!
    
    var bufferSelectCategories:CategoriesDataModel! = nil
    
    var myData:ShareData = ShareData.sharedInstance
    var mySetting:SettingData = SettingData.sharedInstance
    
    var myActivityView:ActivityLoadingView! = nil
    
    var working:Bool = false
    
    
    var storageRef: FIRStorageReference!
    
    var imageUploadWorking:PostImageObject! = nil
    
    var coverImageBuffer:PostImageObject! = nil
    
    var viInPutAcc:UIView! = nil
    var btOK:UIButton! = nil
    
    var viInPutAccSerial:UIView! = nil
    var btOKSerial:UIButton! = nil
    
    
    
    
    
    var editMode:Bool = false
    

    var callBackEditData:(ProductDataModel, Bool)->Void = {(product, isRemove) in }
    var useNavigater:Bool = false
    
    
    var textFildBuffer:UITextField? = nil
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
   
        
        // [START configurestorage]
        storageRef = FIRStorage.storage().reference()
        
        
        ///--------------
        
        strTitle = userProduct.title
        strManufacturer = userProduct.manufacturer
        strModel = userProduct.model
   
        
        var fPrice:Double = 0//CGFloat(Double(userProduct.price)!)
        if let pd = Double(userProduct.price){
            fPrice = pd
        }
        
        
        let currentPrice = self.mySetting.exchangeFrom(form: self.mySetting.serverCurrency, To: self.mySetting.displayCurrency, Amount: fPrice)
        
        
        //let pNum:NSNumber = NSNumber(value: Double(currentPrice))
        
        
        for i in 0..<30{
            let newRerial:SerialProductDataModel = SerialProductDataModel()
            newRerial.serial_Id = "\(i)"
            newRerial.isSelect = false
            self.arSerial.append(newRerial)
        }
        
       
        
        
        
        
        strPriceOnDevice = String(format: "%.02f", currentPrice)//userProduct.price
        
        

        
        
        
        
        
        
        
        
        
        
        strYear = userProduct.year
        strCountry = userProduct.country
        strCategory1 = userProduct.category1
        strCategory2 = userProduct.category2
        strProductUserId = userProduct.product_id_number
        condition_isNew = userProduct.isNew
        strDrscription = userProduct.product_description
        
        latitude = userProduct.product_latitude
        longitude = userProduct.product_longitude
        
        for i in 0..<userProduct.product_serials.count{
            let item = userProduct.product_serials[i]
            self.arSerial[i].serial_Id = "\(i)"
            self.arSerial[i].serial_Title = item.serial_Title
            self.arSerial[i].amount = item.amount
            self.arSerial[i].isSelect = true
        }
        
        
        strLocation = userProduct.product_location
        
        if(arImage.count <= 0){
            arImage = userProduct.images
        }
        
        
        
        if(self.editMode == true){
            for im in arImage{
                self.arImageBeforEdit.append(im)
            }
            
            
            
        }
        ///--------------
        
        self.viTopBar.isUserInteractionEnabled = true
        
        
        self.viTopBar.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viTopBar.layer.shadowRadius = 1
        self.viTopBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viTopBar.layer.shadowOpacity = 0.5
        //self.viTipBar.backgroundColor = UIColor.clear
        
        
        
        
        
        do{
            let nib:UINib = UINib(nibName: "ImagePostSlideCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "ImagePostSlideCell")
        }
        
        
        
        do{
            let nib:UINib = UINib(nibName: "EmptyCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "EmptyCell")
        }
        
        
        do{
            let nib:UINib = UINib(nibName: "PostTitleCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "PostTitleCell")
        }
        
        do{
            let nib:UINib = UINib(nibName: "PostTextFieldCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "PostTextFieldCell")
        }
        
        
        do{
            let nib:UINib = UINib(nibName: "PostLabelButtonCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "PostLabelButtonCell")
        }
        
        do{
            let nib:UINib = UINib(nibName: "ConditionCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "ConditionCell")
        }
        
        
        do{
            let nib:UINib = UINib(nibName: "PostTextViewCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "PostTextViewCell")
        }
        
        
        do{
            let nib:UINib = UINib(nibName: "PostLocationButtonCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "PostLocationButtonCell")
        }
        
        do{
            let nib:UINib = UINib(nibName: "PostTextViewButtonCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "PostTextViewButtonCell")
        }
        
        
        do{
            let nib:UINib = UINib(nibName: "DeleteItemCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "DeleteItemCell")
        }
        
        do{
            let nib:UINib = UINib(nibName: "PostSerialHeaderCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "PostSerialHeaderCell")
        }
        
        do{
            let nib:UINib = UINib(nibName: "AddMoreSerialCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "AddMoreSerialCell")
        }
        
        
        
        
        self.myTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 340, right: 0)
        
        
        
        self.myTable.delegate = self
        self.myTable.dataSource = self
        
        
        
        ///-----------------
        self.viInPutAcc = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 50) )
        self.viInPutAcc.backgroundColor = UIColor.white
        
        self.btOK = UIButton(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 50) )
        
        self.btOK.setTitle("DONE", for: UIControlState.normal)
        self.btOK.addTarget(self, action: #selector(tapOnOKKeyboard(sender:)), for: UIControlEvents.touchUpInside)
        self.btOK.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        
        self.viInPutAcc.addSubview(self.btOK)
        
        
        self.viInPutAcc.backgroundColor = UIColor(red: (3/255), green: (210/255), blue: (99/255), alpha: 1.0)
        
        ///---------------------
    
      
        
        
        self.viInPutAccSerial = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 50) )
        self.viInPutAccSerial.backgroundColor = UIColor.white
        
        self.btOKSerial = UIButton(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 50) )
        
        self.btOKSerial.setTitle("DONE", for: UIControlState.normal)
        self.btOKSerial.addTarget(self, action: #selector(tapOnOKKeyboardSerial(sender:)), for: UIControlEvents.touchUpInside)
        self.btOKSerial.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        
        self.viInPutAccSerial.addSubview(self.btOKSerial)
        
        
        self.viInPutAccSerial.backgroundColor = UIColor(red: (3/255), green: (210/255), blue: (99/255), alpha: 1.0)
        
        ///---------------------
        
        
        
        
        
        if(self.editMode == true){
            self.setDisplayCategory()
        }
        
        self.btMakeSold.alpha = 0
        self.btMakeSold.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        self.checkShowMorkAsSold()
        
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

    
    func exitScene(){
        if let txt = self.textFildBuffer{
            txt.resignFirstResponder()
        }
        
        if(self.useNavigater == false){
            if let navigation = self.navigationController{
                navigation.dismiss(animated: true, completion: {
                    
                })
            }else{
                self.dismiss(animated: true, completion: {
                    
                })
            }
            
        }else{
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Activity
    
    func addActivityView(Finish finish:@escaping ()->Void){
        
        if(self.myActivityView == nil){
            myActivityView = ActivityLoadingView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
            myActivityView.alpha = 0
            self.view.addSubview(myActivityView)
            
            
            UIView.animate(withDuration: 0.25, animations: {
                self.myActivityView.alpha = 1
            }, completion: { (_) in
                
                finish()
            })
        }else{
            finish()
        }
    }
    
    
    
    func removeActivityView(Finish finish:@escaping ()->Void) {
        if(self.myActivityView != nil){
            
            UIView.animate(withDuration: 0.45, animations: {
                self.myActivityView.alpha = 0
            }, completion: { (_) in
                
                if(self.myActivityView != nil){
                    self.myActivityView.removeFromSuperview()
                    self.myActivityView = nil
                }
                finish()
            })
        }else{
            finish()
        }
        
    }

    
    
    
    // MARK: - Action
    
    @IBAction func tapOnClose(_ sender: UIButton) {
        if let txt = self.textFildBuffer{
            txt.resignFirstResponder()
        }
        
        
        let alertController = UIAlertController(title: "Are you sure you want to leave this page?", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Stay on Page", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        
        let okAction = UIAlertAction(title: "Leave Page", style: .default) { (action) in
            
            //var save:Bool = true
            
            self.exitScene()
            
        }
        alertController.addAction(okAction)
        
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func tapSubmit(_ sender: UIButton) {
        
        if let txt = self.textFildBuffer{
            txt.resignFirstResponder()
        }
        
        self.checkComplete { (isError, message) in
            
            
            if(isError == true){
                let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    
                }
                alertController.addAction(cancelAction)
                
                
                self.present(alertController, animated: true, completion: nil)
            }else{
                
                
                self.addActivityView {
                    for i in 0..<self.arImage.count{
                        self.arImage[i].local_tag = i
                        self.arImage[i].uploadError = false
                    }
                    
                    
                    
                    for defImage in self.arImageBeforEdit{
                        var have:Bool = false
                        
                        for im in self.self.arImage{
                            if(im.image_src == defImage.image_src){
                                have = true
                            }
                        }
                        
                        if((have == false) && (defImage.image_src != "")){
                            self.myData.imageWaitRemove.append(defImage)
                        }
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    self.startRunUploadImage()
                }

            
            }
            
            
        }
    }
    
    
    
    
    func setDisplayCategory() {
        
        var categories:CategoriesDataModel! = CategoriesDataModel()
        
        for cat in self.myData.arCategoriesDataModel{
            
            if(cat.category_id == self.userProduct.category1){
                categories = cat
                break
            }
        }
        
        
        
        
        
        
        self.bufferSelectCategories = categories
        
        
        let mainCategoryName:String = self.bufferSelectCategories.category_name
        self.displayCategory = self.bufferSelectCategories.category_name
        
        self.strCategory1 = self.bufferSelectCategories.category_id
        
        
        var subCategoryName:String = ""
        for sub in self.bufferSelectCategories.subCategory.values{
            if(sub.sub_category_id == self.userProduct.category2){
                subCategoryName = sub.sub_category_name
                self.displayCategory = sub.sub_category_name
                self.strCategory2 = sub.sub_category_id
            }
        }
        self.displayCategory = mainCategoryName
        if(subCategoryName.count > 0){
            self.displayCategory = mainCategoryName + " - " + subCategoryName
        }
        
        
        let index:IndexPath = IndexPath(row: CellName.categoryInput.rawValue, section: 0)
        self.myTable.reloadRows(at: [index], with: UITableViewRowAnimation.fade)
        
        
    }
    
    
    
    
    func checkShowMorkAsSold() {
        
        
        if(self.editMode == false){
            self.layout_Bottom_Sol.constant = -44
            self.btMakeSold.isEnabled = false
            
        }else{
            if(self.userProduct.product_status != "Sold Out"){
                self.layout_Bottom_Sol.constant = 0
                self.btMakeSold.isEnabled = true
            }else{
                self.layout_Bottom_Sol.constant = -44
                self.btMakeSold.isEnabled = false
            }
        }
        
        UIView.animate(withDuration: 0.45) { 
            self.view.layoutIfNeeded()
            self.view.updateConstraints()
            
            if(self.editMode == false){
               
                self.btMakeSold.alpha = 0
                
            }else{
                if(self.userProduct.product_status != "Sold Out"){
                    self.btMakeSold.alpha = 1
                }else{
                    self.btMakeSold.alpha = 0
                }
            }
            
            
        }
        
    }
    
    @IBAction func tapOnMarkAsSoldOut(_ sender: UIButton) {
        
        
        let alertController = UIAlertController(title: "Mark as Sold", message: "Are you sure you want to mark item as sold? You will no longer receive offers for the listing. A SOLD badge will be added to your listing.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        
        let okAction = UIAlertAction(title: "Mark as Sold", style: .default) { (action) in
            
            //var save:Bool = true
            
            
            
            self.addActivityView {
                let postRef = FIRDatabase.database().reference().child("products").child(self.userProduct.product_id).child("product_status")
                postRef.setValue("Sold Out", withCompletionBlock: { (error, ref) in
                    
                    getProductDataWith(ProductID: self.userProduct.product_id, Finish: { (prodetail) in
                        
                        self.userProduct = prodetail
                        
                        self.removeActivityView {
                            self.checkShowMorkAsSold()
                        }
                        
                        
                    })
                })
                
            }
            
            
            
           
            
        }
        alertController.addAction(okAction)
        
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
 
        
        
        
    }
    
    
    
    
    
    func deleteThisProduct(){
        let alertController = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this listing?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Don't Delete", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        
        let okAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            
        
            //delete
            self.startDeleteListing()
            
            
            
        }
        alertController.addAction(okAction)
        
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func startDeleteListing(){
        
        self.addActivityView {
            
        
            for image in self.arImage{
                
                
                if(image.image_src.count > 0){
                    self.myData.imageWaitRemove.append(image)
                }
           
                
            }
            
            
            
            self.myData.removeProductFromRealm(productID: self.userProduct.product_id)
            
            
            
            let postRef = FIRDatabase.database().reference().child("users").child(self.userProduct.uid).child("products").child(self.userProduct.product_id)
            postRef.setValue(nil, withCompletionBlock: { (error, ref) in
                
                
                let postRefd = FIRDatabase.database().reference().child("products").child(self.userProduct.product_id)
                postRefd.setValue(nil, withCompletionBlock: { (error, ref) in
                    
                    
                    
                    getUserDataWith(UID: self.userProduct.uid, Finish: { (userData) in
                        self.removeActivityView {
                            self.myData.startRunRemoveImage()
                            self.finishRemove()
                            
                        }
                    })
                    })
                    
                    
                
                
                
            })
            
            
            
            
            
        }
        
        
        
    }
    
    func finishRemove(){
        
        
        let alertController = UIAlertController(title: "SUCCESS!!", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            //self.navigationController?.popViewController(animated: true)
            
            self.callBackEditData(self.userProduct, true)
            
            self.exitScene()
            
            
        }
        alertController.addAction(cancelAction)
        
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    // MARK: - Upload
    
    func startRunUploadImage() {
        
        self.imageUploadWorking = nil
        for image in self.arImage{
            if((image.image_src == "") && (image.local_image != nil) && (image.uploadError == false)){
                self.imageUploadWorking = image
                break
            }
            
        }
        
        
        if(self.imageUploadWorking == nil){
            
            
            var checkHaveSomeCanUpload:Bool = false
            for im in self.arImage{
                if(im.uploadError == false){
                    checkHaveSomeCanUpload = true
                    
                    self.coverImageBuffer = im
                    break
                }
            }
            
            
            
            
            if((checkHaveSomeCanUpload == true) && (self.coverImageBuffer != nil)){
                //Next state
                self.startUploadProductData()
                
            }else{
                //Error
                
                self.removeActivityView {
                    let alertController = UIAlertController(title: "Can't upload image", message: "Please try again", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        
                        
                    }
                    alertController.addAction(cancelAction)
                    
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                
            }
            
        }else{
            self.runUploadImage {
                self.startRunUploadImage()
            }
        }
        
    }
    

    
    
    func runUploadImage(finish:@escaping ()->Void) {
        
        self.imageUploadWorking = nil
        for image in self.arImage{
            if((image.image_src == "") && (image.local_image != nil) && (image.uploadError == false)){
                self.imageUploadWorking = image
                break
            }
            
        }
        
        
        if(self.imageUploadWorking != nil){
            
            
            
            self.uploadImage(image: self.imageUploadWorking.local_image, Complete: { (success, name, path, src) in
                
                
                for im in self.arImage{
                    
                    if(self.imageUploadWorking.local_tag == im.local_tag){
                        if(success){
                            im.uploadError = false
                        }else{
                            im.uploadError = true
                        }
                        
                        im.image_name = name
                        im.image_path = path
                        im.image_src = src
                    }
                    
                }
                
                finish()
                
                
            })
            
            
            
            
        }else{
            finish()
        }
        
    }
    
    
    
    
    func uploadImage(image:UIImage, Complete complete:@escaping (_ success:Bool, _ name:String, _ path:String,  _ src:String)->Void){
        
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {
            
            complete(false, "", "", "")
            
            return
        }
        
        let fileName:String = FIRAuth.auth()!.currentUser!.uid + "\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        let imagePath = "products" + "/" + fileName
        
        
        //.currentUser!.uid + "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        
        
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        self.storageRef.child(imagePath)
            .put(imageData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    complete(false, "", "", "")
                    return
                }
                
                let strURL:String = (metadata?.downloadURL()?.absoluteString)!
                print(strURL)
                
                complete(true, fileName, imagePath, strURL)
                
                //self.uploadSuccess(metadata!, storagePath: imagePath)
        }
    }
    
    
    //-------
    
    func startUploadProductData() {
        
        userProduct.title = strTitle
        userProduct.manufacturer = strManufacturer
        userProduct.model = strModel
        
        
        let convertPrice = Double(strPriceOnDevice)
        if let convertPrice = convertPrice{
            
            if(self.mySetting.currencyReadyToUse == true){
                
                
                let serverPrice = self.mySetting.exchangeToServerCurrency(amount: convertPrice)
                let strP:String = String(format: "%.06f", serverPrice)
                userProduct.price = strP
                userProduct.price_server_Number = Double(serverPrice)
                
            }else{
                userProduct.price = strPriceOnDevice
                userProduct.price_server_Number = convertPrice
            }
            
        }else{
            userProduct.price = strPriceOnDevice
            if let convertPrice = convertPrice{
                userProduct.price_server_Number = convertPrice
            }
            
        }
        
        
        userProduct.year = strYear
        userProduct.country = strCountry
        userProduct.category1 = strCategory1
        userProduct.category2 = strCategory2
        userProduct.product_id_number = strProductUserId
        userProduct.isNew = condition_isNew
        userProduct.product_description = strDrscription
        
        userProduct.product_latitude = latitude
        userProduct.product_longitude = longitude
        userProduct.product_location = strLocation
        
        userProduct.product_serials.removeAll()
        for i in 0..<self.arSerial.count{
            let item = self.arSerial[i]
            
            if((item.serial_Title != "") && (item.amount != 0) && (item.isSelect == true)){
                let newItem:SerialProductDataModel = SerialProductDataModel()
                newItem.amount = item.amount
                newItem.serial_Title = item.serial_Title
                
                userProduct.product_serials.append(newItem)
            }
        }
        
        
        
        
        userProduct.images = arImage
        
       
        userProduct.image_src = self.coverImageBuffer.image_src
        userProduct.image_name = self.coverImageBuffer.image_name
        userProduct.image_path = self.coverImageBuffer.image_path
        
        if(self.editMode == false){
            userProduct.product_status = "No Offer Yet"
            userProduct.status = "Active"
            userProduct.uid = self.myData.userInfo.uid
        }
        
        
        
        
        
        let dateFormatFull:DateFormatter = DateFormatter()
        dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        if(self.editMode == false){
            userProduct.created_at_Date = Date()
            userProduct.created_at = NSInteger(userProduct.created_at_Date.timeIntervalSince1970)////FIRServerValue.timestamp()//dateFormatFull.string(from: userProduct.created_at_Date)
        }
        
        userProduct.updated_at_Date = Date()
        
        
        userProduct.updated_at = NSInteger(userProduct.updated_at_Date.timeIntervalSince1970)//FIRServerValue.timestamp()//dateFormatFull.string(from: userProduct.updated_at_Date)
        
        ///--------------
        
        
        
        
        
        
        
        
        if(self.editMode == false){
            //Create
            let postRef = FIRDatabase.database().reference().child("products").childByAutoId()
            
            let pId:String = postRef.key
            
            userProduct.product_id = pId
            
            var postUserData = userProduct.getDictionary()
            
            
            postUserData["created_at"] = FIRServerValue.timestamp()
            postUserData["updated_at"] = FIRServerValue.timestamp()
            
            postUserData["created_at_server_timestamp"] = FIRServerValue.timestamp()
            postUserData["updated_at_server_timestamp"] = FIRServerValue.timestamp()
                
                
            postRef.updateChildValues(postUserData) { (error, ref) in
                
                if let error = error {
                    self.removeActivityView {
                        
                        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                            
                        }
                        alertController.addAction(cancelAction)
                        
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                        
                    }
                }else{
                    
                    
                    
                    
                    
                    self.getUserDatainfo {
                        self.postUpdateProductIdToUserTable()
                    }
                    
                }
            }
            
            
        }else{
            
            //Edit
            let postRef = FIRDatabase.database().reference().child("products").child(userProduct.product_id)
            
          
            
            var postUserData = userProduct.getDictionary()
            postUserData["updated_at_server_timestamp"] = FIRServerValue.timestamp()
            
            postRef.updateChildValues(postUserData) { (error, ref) in
                
                if let error = error {
                    self.removeActivityView {
                        
                        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                            
                        }
                        alertController.addAction(cancelAction)
                        
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                        
                    }
                }else{
                    
                    
                    
                    
                    
                    self.getUserDatainfo {
                        self.postUpdateProductIdToUserTable()
                    }
                    
                }
            }
            
        }
        
        
        
        
        
        
    }
    
    
    
    func getUserDatainfo(_ finish:@escaping ()->Void) {
        
        let postRef = FIRDatabase.database().reference().child("users").child(self.myData.userInfo.uid)
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary{
                
                
                self.myData.userInfo = UserDataModel(dictionary: value)
                
                self.myData.saveUserInfo(UID: self.myData.userInfo.uid)
                
                
                
                //print(self.myData.userInfo.first_name)
                
            }
            
           finish()
        })
        
        
        
    }
    
    
    
    
    
    func postUpdateProductIdToUserTable() {
        
        //var products:[String:Bool] = self.myData.userInfo.products
        
        
        /*
        for pid in self.myData.userInfo.products{
            products[pid] = true
            
        }
        */
        
        
        
        //products[userProduct.product_id] = true
        
        
        let postRef = FIRDatabase.database().reference().child("users").child(userProduct.uid).child("products").child(userProduct.product_id)
        
        
        postRef.setValue(true) { (error, ref) in
            if let error = error {
                self.removeActivityView {
                    
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        
                    }
                    alertController.addAction(cancelAction)
                    
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    
                }
            }else{
                
                
                
                self.getUserDatainfo {
                    ShareData.sharedInstance.startRunRemoveImage()
                    
                    getProductDataWith(ProductID: self.userProduct.product_id, Finish: { (product) in
                        self.finishPostSell()
                        
                    })
                    
                }
                
                
                
            }
        }
        
        
        
        
        
        
       
        
        
    }
    
    
    
    func finishPostSell(){
        
        self.myData.needUpdateAfterEdit = true
        
        
        
        self.removeActivityView {
            
            let alertController = UIAlertController(title: "SUCCESS!!", message: nil, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                //self.navigationController?.popViewController(animated: true)
                
                
                self.callBackEditData(self.userProduct, false)
                
                
                
                self.exitScene()
                
                
            }
            alertController.addAction(cancelAction)
            
            
            self.present(alertController, animated: true, completion: nil)
            
            
            
        }
    }
    
    
    
    
    // MARK: - Helper
    func openImagePicker() {
        let album:MultiSelectImageVC = MultiSelectImageVC(nibName: "MultiSelectImageVC", bundle: nil)
        album.singleImage = false
        album.limit = 4 - self.arImage.count
        
        
        album.callBack = {(images) in
            
            //var arImage:[PostImageObject] = [PostImageObject]()
            for pickedImage in images{
                
                
                let newImage:PostImageObject = PostImageObject()
                newImage.local_image = pickedImage
                //arImage.append(newImage)
                self.arImage.append(newImage)
            }
            
            
            let indexPath:IndexPath = IndexPath(row: CellName.productImage.rawValue, section: 0)
            
            
            self.myTable.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
        }
        
        let navigation:UINavigationController = UINavigationController(rootViewController: album)
        
        self.present(navigation, animated: true) {
            
        }
        
        
        
    }
    
    
    
    
    
    func openLocationPicker(){
        
        self.showGoogleAutocomplete()
        
        
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:SelectLocationVC = storyboard.instantiateViewController(withIdentifier: "SelectLocationVC") as! SelectLocationVC
        
        
        vc.startLatitude = self.latitude
        vc.startLongitude = self.longitude
        
        
        
        vc.callBack = {(latitude, longitude, locationData, strLocationName) in
            
            
            self.latitude = latitude
            self.longitude = longitude
            
            //print(locationData)
            //let zip:String? = locationData["Zip"]
            self.strLocation = strLocationName
            
            
            let indexZIP:IndexPath = IndexPath(row: CellName.locationInput.rawValue, section: 0)
            self.myTable.reloadRows(at: [indexZIP], with: UITableViewRowAnimation.fade)
            
         }

        self.navigationController?.pushViewController(vc, animated: true)
        */
        /*
        self.present(vc, animated: true, completion: {
            
        })*/

    }
    
    func openCountryPicker(){
        //CountryPickerVC
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:CountryPickerVC = storyboard.instantiateViewController(withIdentifier: "CountryPickerVC") as! CountryPickerVC
        
        
        
        vc.selectedCountry = self.strCountry
        vc.callBack = {(countryObject) in
            self.strCountry = countryObject.countryName
            
            
            let index:IndexPath = IndexPath(row: CellName.countryInput.rawValue, section: 0)
            self.myTable.reloadRows(at: [index], with: UITableViewRowAnimation.fade)
            
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func openCategoriPicker() {
        //CategoriesPickerVC
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:CategoriesPickerVC = storyboard.instantiateViewController(withIdentifier: "CategoriesPickerVC") as! CategoriesPickerVC
        
        
        if(self.bufferSelectCategories == nil){
            vc.catID1 = ""
            vc.catID2 = ""
        }else{
            
            
            vc.catID1 = self.bufferSelectCategories.category_id
            
            
            
            var subID:String = ""
            for subKey in self.bufferSelectCategories.subCategory.keys{
                if(self.bufferSelectCategories.subCategory[subKey]?.isSelect == true){
                    subID = subKey
                }
            }
            
            vc.catID2 = subID
            
            
            
            /*
            for cat in self.myData.arCategoriesDataModel{
                if(cat.category_id == self.bufferSelectCategories.category_id){
                    cat.isSelect = true
                    
                    for sub in cat.subCategory.values{
                        
                        let proSub = self.bufferSelectCategories.subCategory[sub.sub_category_id]
                        if let proSub = proSub{
                            sub.isSelect = proSub.isSelect
                        }
                        
                    }
                    
                }
            }*/
            
        }
        
        vc.callBack = {(categories) in
        
        
            if let categories = categories{
                self.bufferSelectCategories = categories
                
                
                let mainCategoryName:String = self.bufferSelectCategories.category_name
                //self.displayCategory = self.bufferSelectCategories.category_name
                
                self.strCategory1 = self.bufferSelectCategories.category_id
                
                var subCategoryName:String = ""
                for sub in self.bufferSelectCategories.subCategory.values{
                    if(sub.isSelect){
                        subCategoryName = sub.sub_category_name
                        //self.displayCategory = sub.sub_category_name
                        self.strCategory2 = sub.sub_category_id
                    }
                }
                self.displayCategory = mainCategoryName
                if(subCategoryName != ""){
                    self.displayCategory = mainCategoryName + " - " + subCategoryName
                }
                
                
                
                
                let index:IndexPath = IndexPath(row: CellName.categoryInput.rawValue, section: 0)
                self.myTable.reloadRows(at: [index], with: UITableViewRowAnimation.fade)
                
                
            }else{
                
                
            }
        
        }
        
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        
    }
    
    
    
    func checkComplete(_ callBack:(Bool, String)->Void){
        
        var isError:Bool = false
        var strMessage:String = ""
        
        
        if(strTitle.count <= 0){
            isError = true
            strMessage = "Please enter Title"
        }else if(strPriceOnDevice.count <= 0){
            isError = true
            strMessage = "Please enter Price"
        }else if(strCategory1.count <= 0){
            isError = true
            strMessage = "Please select Category"
        }else if(strLocation.count <= 0){
            isError = true
            strMessage = "Please select Location"
            
            
        }else if(arImage.count <= 0){
            isError = true
            strMessage = "Please select Cover picture"
        }/*/if(strDrscription.characters.count <= 0){
        isError = true
        strMessage = "Please enter Description"
    }else*/
    
    
        callBack(isError, strMessage)
    }
    
    
    
    
    
    func orderSerial(){
        var buff:[SerialProductDataModel] = [SerialProductDataModel]()
        
        for item in self.arSerial{
            if(item.isSelect == true){
                buff.append(item)
            }
        }
        
        for i in 0..<self.arSerial.count{
            
            if((i >= 0) && (i < buff.count)){
                self.arSerial[i].serial_Id = buff[i].serial_Id
                self.arSerial[i].serial_Title = buff[i].serial_Title
                self.arSerial[i].amount = buff[i].amount
                self.arSerial[i].isSelect = buff[i].isSelect
            }else{
                self.arSerial[i].serial_Id = ""
                self.arSerial[i].serial_Title = ""
                self.arSerial[i].amount = 0
                self.arSerial[i].isSelect = false
            }
            
        }
        
        
        
   
        
        if(self.arSerial.count == 0){
            let newRerial:SerialProductDataModel = SerialProductDataModel()
            newRerial.serial_Id = "0"
            newRerial.isSelect = false
            self.arSerial.append(newRerial)
        }
        
        
        var arIndex:[IndexPath] = [IndexPath]()
        for i in CellName.serial1.rawValue...CellName.serial30.rawValue{
            let indexP = IndexPath(row: i, section: 0)
            arIndex.append(indexP)
        }
        
        self.myTable.reloadRows(at: arIndex, with: UITableViewRowAnimation.fade)
        
        
    }
    func addNewSerial(){
        self.arSerial[0].isSelect = true
        
        for i in 0..<self.arSerial.count{
            let item = self.arSerial[i]
            if (item.isSelect == false){
                self.arSerial[i].isSelect = true
                break
            }
        }
        
        var arIndex:[IndexPath] = [IndexPath]()
        for i in CellName.serial1.rawValue...CellName.serial30.rawValue{
            let indexP = IndexPath(row: i, section: 0)
            arIndex.append(indexP)
        }
        
        self.myTable.reloadRows(at: arIndex, with: UITableViewRowAnimation.fade)
    }
    
    
    
    
    func deleteSerialAtIndex(tag:NSInteger){
        
        let alertController = UIAlertController(title: "Are you sure you want to remove serial?", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        
        let okAction = UIAlertAction(title: "Remove", style: .default) { (action) in
            
            //var save:Bool = true
           
            if((tag >= 0) && (tag < self.arSerial.count)){
                self.arSerial[tag].isSelect = false
                
                self.orderSerial()
            }
            
            
        }
        alertController.addAction(okAction)
        
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }
}





// MARK: - UITableViewDelegate, UITableViewDataSource
extension PostSellVC:UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
    }
    
    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //var numberOfCell:NSInteger = 0
        
        if(self.editMode == true){
            return CellName.count + 2
        }
        
        return CellName.count
    }
    
    // MARK: - Cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        var cellHeight:CGFloat = 101
        
        
        if(indexPath.row == CellName.space0.rawValue){
            cellHeight = 12
        }else if(indexPath.row == CellName.productImage.rawValue){
            cellHeight = 101
        }else if(indexPath.row == CellName.imageTitle.rawValue){
            cellHeight = 37
        }else if(indexPath.row == CellName.sellingTitle.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.titleInput.rawValue){
            cellHeight = 37
        }else if(indexPath.row == CellName.manufacturerTitle.rawValue){
            cellHeight = 0//45
        }else if(indexPath.row == CellName.manufacturerInput.rawValue){
            cellHeight = 0//37
        }else if(indexPath.row == CellName.modelTitle.rawValue){
            cellHeight = 0//45
        }else if(indexPath.row == CellName.modelInput.rawValue){
            cellHeight = 0//37
        }else if(indexPath.row == CellName.priceTitle.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.priceInput.rawValue){
            cellHeight = 37
        }else if(indexPath.row == CellName.yearTitle.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.yearInput.rawValue){
            cellHeight = 37
        }else if(indexPath.row == CellName.countryTitle.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.countryInput.rawValue){
            cellHeight = 37
        }else if(indexPath.row == CellName.categoryTitle.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.categoryInput.rawValue){
            cellHeight = 37
        }else if(indexPath.row == CellName.productIdTitle.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.productIdInput.rawValue){
            cellHeight = 37
        }else if(indexPath.row == CellName.conditionTitle.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.conditionInput.rawValue){
            cellHeight = 37
        }else if(indexPath.row == CellName.descriptionTitle.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.descriptionInput.rawValue){
            
            cellHeight = heightForView(text: self.strDrscription, Font: self.cellFont, Width: (self.screenSize.width - (22 + 22 + 20) ) ) + 25
            
            
            if(cellHeight < 37){
                cellHeight = 120
            }
        }else if((indexPath.row >= CellName.serial1.rawValue) && (indexPath.row <= CellName.serial30.rawValue)){
            cellHeight = 90
            
            
            var item_index:NSInteger = indexPath.row - CellName.serial1.rawValue
            
            if(item_index < 0){
                item_index = 0
            }
            
            if(item_index >= self.arSerial.count){
                item_index = self.arSerial.count - 1
            }
            
            let serialItem = self.arSerial[item_index]
            
            if(item_index == 0){
                cellHeight = 90
            }else{
                if(serialItem.isSelect == true){
                    cellHeight = 90
                }else{
                    cellHeight = 0
                }
            }
            
            
        }else if(indexPath.row == CellName.add_serial.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.locationTitle.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.locationInput.rawValue){
            cellHeight = heightForView(text: self.strLocation, Font: self.cellFont, Width: (self.screenSize.width - (22 + 22 + 23 + 50) ) ) + 25
            
            
            if(cellHeight < 37){
                cellHeight = 37
            }
        }else if(indexPath.row == CellName.edelete.rawValue){
            cellHeight = 20
        }else if(indexPath.row == CellName.delete.rawValue){
            cellHeight = 60
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
        
        
        if(indexPath.row == CellName.space0.rawValue){
            let cell:EmptyCell? = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as? EmptyCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            cell?.contentView.backgroundColor = UIColor(red: (241.0/255.0), green: (241.0/255.0), blue: (241.0/255.0), alpha: 1.0)
            
            
            
            return cell!
            
        }else if(indexPath.row == CellName.productImage.rawValue){
            let cell:ImagePostSlideCell? = tableView.dequeueReusableCell(withIdentifier: "ImagePostSlideCell", for: indexPath) as? ImagePostSlideCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            cell?.contentView.backgroundColor = UIColor(red: (241.0/255.0), green: (241.0/255.0), blue: (241.0/255.0), alpha: 1.0)
          
            
            cell?.arImage = self.arImage
            cell?.myCollection.reloadData()
            
            
            cell?.callBackSelectOnIndex = {(imageIndex) in
                
              
                
                
                
                if(imageIndex < self.arImage.count){
                    
                    
                
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
                    let vc:ImagePreviewVC = storyboard.instantiateViewController(withIdentifier: "ImagePreviewVC") as! ImagePreviewVC
                    vc.strTitle = "Cover picture"
                    
                    vc.arImageName = self.arImage
                    vc.currentPage = imageIndex
                    vc.isEditMode = true
                    
                    vc.callBackDelete = { (imageIndex) in
                    
                    
                        if((imageIndex < self.arImage.count) && (imageIndex >= 0)){
                            self.arImage.remove(at: imageIndex)
                            
                            let indexPath:IndexPath = IndexPath(row: CellName.productImage.rawValue, section: 0)
                            
                            
                            self.myTable.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                          
                            
                            
                        }
                        
                    }
                   
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                    
                    
                }else{
                    self.openImagePicker()
                }

            }
            
                
            
            
            return cell!
        }else if(indexPath.row == CellName.imageTitle.rawValue){
            
            let cell:PostTitleCell? = tableView.dequeueReusableCell(withIdentifier: "PostTitleCell", for: indexPath) as? PostTitleCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor(red: (241.0/255.0), green: (241.0/255.0), blue: (241.0/255.0), alpha: 1.0)
            
            cell?.lbTitle.text = "Cover Pic"
            return cell!
        }else if(indexPath.row == CellName.sellingTitle.rawValue){
            
            let cell:PostTitleCell? = tableView.dequeueReusableCell(withIdentifier: "PostTitleCell", for: indexPath) as? PostTitleCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.lbTitle.text = "Title"
            return cell!
            
        }else if(indexPath.row == CellName.titleInput.rawValue){
            
            let cell:PostTextFieldCell? = tableView.dequeueReusableCell(withIdentifier: "PostTextFieldCell", for: indexPath) as? PostTextFieldCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.myTextField.tag = indexPath.row
            cell?.myTextField.placeholder = "Title of item you are selling…"
            cell?.myTextField.delegate = self
            cell?.myTextField.keyboardType = .default
            cell?.myTextField.inputAccessoryView = nil
            
            cell?.myTextField.text = self.strTitle

            return cell!
        }else if(indexPath.row == CellName.manufacturerTitle.rawValue){
            
            let cell:PostTitleCell? = tableView.dequeueReusableCell(withIdentifier: "PostTitleCell", for: indexPath) as? PostTitleCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.lbTitle.text = "Manufacturer"
            return cell!
            
        }else if(indexPath.row == CellName.manufacturerInput.rawValue){
            
            let cell:PostTextFieldCell? = tableView.dequeueReusableCell(withIdentifier: "PostTextFieldCell", for: indexPath) as? PostTextFieldCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.myTextField.tag = indexPath.row
            cell?.myTextField.placeholder = "Writing your manufacturer…"
            cell?.myTextField.delegate = self
            cell?.myTextField.keyboardType = .default
            cell?.myTextField.inputAccessoryView = nil
            
            cell?.myTextField.text = self.strManufacturer
            
            
            
            return cell!
        }else if(indexPath.row == CellName.modelTitle.rawValue){
            
            let cell:PostTitleCell? = tableView.dequeueReusableCell(withIdentifier: "PostTitleCell", for: indexPath) as? PostTitleCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.lbTitle.text = "Model"
            
            
            return cell!
            
        }else if(indexPath.row == CellName.modelInput.rawValue){
            
            let cell:PostTextFieldCell? = tableView.dequeueReusableCell(withIdentifier: "PostTextFieldCell", for: indexPath) as? PostTextFieldCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.myTextField.tag = indexPath.row
            cell?.myTextField.placeholder = "Writing your model series…"
            cell?.myTextField.delegate = self
            cell?.myTextField.keyboardType = .default
            cell?.myTextField.inputAccessoryView = nil
            
            cell?.myTextField.text = self.strModel
            
            
            
            return cell!
        }else if(indexPath.row == CellName.priceTitle.rawValue){
            
            let cell:PostTitleCell? = tableView.dequeueReusableCell(withIdentifier: "PostTitleCell", for: indexPath) as? PostTitleCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.lbTitle.text = "Price"
            return cell!
            
        }else if(indexPath.row == CellName.priceInput.rawValue){
            
            let cell:PostTextFieldCell? = tableView.dequeueReusableCell(withIdentifier: "PostTextFieldCell", for: indexPath) as? PostTextFieldCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.myTextField.tag = indexPath.row
            cell?.myTextField.placeholder = "Set a price…"
            cell?.myTextField.delegate = self
            cell?.myTextField.keyboardType = .numberPad
            cell?.myTextField.inputAccessoryView = self.viInPutAcc
            
            
            
            if(self.strPriceOnDevice == ""){
                cell?.myTextField.text = ""
            }else{
                
                let numberF = NumberFormatter()
                numberF.numberStyle = .currency
                numberF.currencyCode = myData.userInfo.currency
                
                
                var strPrice:String = numberF.string(from: NSNumber(value: 0))!
                
                if let pdb = Double(self.strPriceOnDevice){
                    
                    strPrice = numberF.string(from: NSNumber(value: pdb))!
                }
                
                
                
                cell?.myTextField.text = strPrice//self.mySetting.priceWithString(strPricein: self.strPriceOnDevice)
            }
            
            //cell?.myTextField.keyboardType = .numberPad
            
            return cell!
        }else if(indexPath.row == CellName.yearTitle.rawValue){
            
            let cell:PostTitleCell? = tableView.dequeueReusableCell(withIdentifier: "PostTitleCell", for: indexPath) as? PostTitleCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.lbTitle.text = "Year of Issue"
            
            
            
            return cell!
            
        }else if(indexPath.row == CellName.yearInput.rawValue){
            
            let cell:PostTextFieldCell? = tableView.dequeueReusableCell(withIdentifier: "PostTextFieldCell", for: indexPath) as? PostTextFieldCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.myTextField.tag = indexPath.row
            cell?.myTextField.placeholder = "Set the year…"
            cell?.myTextField.delegate = self
            
            cell?.myTextField.text = self.strYear
            
            cell?.myTextField.keyboardType = .default
            cell?.myTextField.inputAccessoryView = nil
            
            //cell?.myTextField.keyboardType = .numberPad
            
            
            
            
            return cell!
        }else if(indexPath.row == CellName.countryTitle.rawValue){
            
            let cell:PostTitleCell? = tableView.dequeueReusableCell(withIdentifier: "PostTitleCell", for: indexPath) as? PostTitleCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.lbTitle.text = "Country of Origin"
            return cell!
            
        }else if(indexPath.row == CellName.countryInput.rawValue){
            
            let cell:PostLabelButtonCell? = tableView.dequeueReusableCell(withIdentifier: "PostLabelButtonCell", for: indexPath) as? PostLabelButtonCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.myTextField.tag = indexPath.row
            cell?.myTextField.placeholder = "Choose Country"
            cell?.myTextField.delegate = self
            cell?.myTextField.keyboardType = .default
            cell?.myTextField.inputAccessoryView = nil
            
            cell?.myTextField.text = self.strCountry
            
            
            
            
            return cell!
        }else if(indexPath.row == CellName.categoryTitle.rawValue){
            
            let cell:PostTitleCell? = tableView.dequeueReusableCell(withIdentifier: "PostTitleCell", for: indexPath) as? PostTitleCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.lbTitle.text = "Category"
            return cell!
            
        }else if(indexPath.row == CellName.categoryInput.rawValue){
            
            let cell:PostLabelButtonCell? = tableView.dequeueReusableCell(withIdentifier: "PostLabelButtonCell", for: indexPath) as? PostLabelButtonCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.myTextField.tag = indexPath.row
            cell?.myTextField.placeholder = "Choose Category"
            cell?.myTextField.delegate = self
            cell?.myTextField.keyboardType = .default
            cell?.myTextField.inputAccessoryView = nil
            
            cell?.myTextField.text = self.displayCategory
            /*
            if(self.strCategory2.characters.count > 0){
                cell?.myTextField.text = self.strCategory2
            }else{
                cell?.myTextField.text = self.strCategory1
            }
            */
            
            
            return cell!
        }else if(indexPath.row == CellName.productIdTitle.rawValue){
            
            let cell:PostTitleCell? = tableView.dequeueReusableCell(withIdentifier: "PostTitleCell", for: indexPath) as? PostTitleCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.lbTitle.text = "Product id"
            return cell!
            
        }else if(indexPath.row == CellName.productIdInput.rawValue){
            
            let cell:PostTextFieldCell? = tableView.dequeueReusableCell(withIdentifier: "PostTextFieldCell", for: indexPath) as? PostTextFieldCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.myTextField.tag = indexPath.row
            cell?.myTextField.placeholder = "Input product id…"
            cell?.myTextField.delegate = self
            cell?.myTextField.keyboardType = .default
            cell?.myTextField.inputAccessoryView = nil
            
            cell?.myTextField.text = self.strProductUserId
            
            
            
            return cell!
        }else if(indexPath.row == CellName.conditionTitle.rawValue){
            
            let cell:PostTitleCell? = tableView.dequeueReusableCell(withIdentifier: "PostTitleCell", for: indexPath) as? PostTitleCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.lbTitle.text = "Condition of the item"
            return cell!
            
        }else if(indexPath.row == CellName.conditionInput.rawValue){
            
            let cell:ConditionCell? = tableView.dequeueReusableCell(withIdentifier: "ConditionCell", for: indexPath) as? ConditionCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
           
            
            if(self.condition_isNew == true){
                cell?.setButtonHighlightTo(status: ConditionCell.ActionOn.left)
            }else{
                cell?.setButtonHighlightTo(status: ConditionCell.ActionOn.right)
            }
      
            
            cell?.callBack = {(tapOn) in
            
            
                if(tapOn == ConditionCell.ActionOn.left){
                    self.condition_isNew = true
                    
                }else{
                    self.condition_isNew = false
                }
            
                let bIndex:IndexPath = IndexPath(row: CellName.conditionInput.rawValue, section: 0)
                
                let cellB:ConditionCell? = self.myTable.cellForRow(at: bIndex) as? ConditionCell
                if let cellB = cellB{
                    cellB.setButtonHighlightTo(status: tapOn)
                }
            }
            
            
            
            
            return cell!
        }else if(indexPath.row == CellName.descriptionTitle.rawValue){
            
            let cell:PostTitleCell? = tableView.dequeueReusableCell(withIdentifier: "PostTitleCell", for: indexPath) as? PostTitleCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.lbTitle.text = "Description"
            
            return cell!
            
        }else if(indexPath.row == CellName.descriptionInput.rawValue){
            
            let cell:PostTextViewCell? = tableView.dequeueReusableCell(withIdentifier: "PostTextViewCell", for: indexPath) as? PostTextViewCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.tvInput.text = self.strDrscription
            cell?.tvInput.isUserInteractionEnabled = false
            cell?.tfPlaceholder.isUserInteractionEnabled = false
            
            
            
            if(self.strDrscription.count > 0){
                cell?.tfPlaceholder.alpha = 0
                cell?.tvInput.alpha = 1
            }else{
                cell?.tfPlaceholder.alpha = 1
                cell?.tvInput.alpha = 0
            }
            
            return cell!
        }else if((indexPath.row >= CellName.serial1.rawValue)&&(indexPath.row <= CellName.serial30.rawValue)){
            
            let cell:PostSerialHeaderCell? = tableView.dequeueReusableCell(withIdentifier: "PostSerialHeaderCell", for: indexPath) as? PostSerialHeaderCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            var serialIndex:NSInteger = indexPath.row - CellName.serial1.rawValue
            if(serialIndex < 0){
                serialIndex = 0
            }
            if(serialIndex >= self.arSerial.count){
                serialIndex = self.arSerial.count - 1
            }
            
            let serilaItem = self.arSerial[serialIndex]
            
            
            
            if(serilaItem.isSelect == true){
                cell?.btDelete.alpha = 1
                cell?.btDelete.isEnabled = true
                
                cell?.tfSeial.text = serilaItem.serial_Title
                if(serilaItem.amount == 0){
                    cell?.tfAmount.text = ""
                    
                }else{
                    cell?.tfAmount.text = "\(serilaItem.amount)"
                }
                
                
                
            }else{
                cell?.btDelete.alpha = 0
                cell?.btDelete.isEnabled = false
                
                cell?.tfSeial.text = ""
                cell?.tfAmount.text = ""
            }
            
            cell?.tfAmount.keyboardType = .numberPad
            cell?.tfAmount.inputAccessoryView = self.viInPutAccSerial
            
            cell?.tfSeial.keyboardType = .default
            cell?.tfSeial.inputAccessoryView = nil
            
            
            
            
            
            cell?.myTag = indexPath.row
            
            cell?.tfSeial.tag = 1000 + indexPath.row
            cell?.tfAmount.tag = 10000 + indexPath.row
            
            cell?.tfSeial.delegate = self
            cell?.tfAmount.delegate = self
            
            
            
            
            cell?.callBackDelete = {(myTag) in
                
                let cellTag:NSInteger = myTag - CellName.serial1.rawValue
                
                self.deleteSerialAtIndex(tag: cellTag)
                
            }
            //cell?.lbTitle.text = "Description"
            
            return cell!
            
        }else if(indexPath.row == CellName.add_serial.rawValue){
            
            let cell:AddMoreSerialCell? = tableView.dequeueReusableCell(withIdentifier: "AddMoreSerialCell", for: indexPath) as? AddMoreSerialCell
            cell?.selectionStyle = .default
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            //cell?.lbTitle.text = "Description"
            
            return cell!
            
        }else if(indexPath.row == CellName.locationTitle.rawValue){
            
            let cell:PostTitleCell? = tableView.dequeueReusableCell(withIdentifier: "PostTitleCell", for: indexPath) as? PostTitleCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.lbTitle.text = "Location"
            return cell!
            
        }else if(indexPath.row == CellName.locationInput.rawValue){
            
            let cell:PostTextViewButtonCell? = tableView.dequeueReusableCell(withIdentifier: "PostTextViewButtonCell", for: indexPath) as? PostTextViewButtonCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.contentView.backgroundColor = UIColor.white
            
            cell?.myTextField.tag = indexPath.row
            cell?.myTextField.placeholder = "Choose Location"
            cell?.myTextField.delegate = self
            cell?.myTextField.keyboardType = .default
            cell?.myTextField.inputAccessoryView = nil
     
            
            
            cell?.myTextView.text = self.strLocation
            
            
            if(self.strLocation.count > 0){
                cell?.myTextField.alpha = 0
                cell?.myTextView.alpha = 1
            }else{
                cell?.myTextField.alpha = 1
                cell?.myTextView.alpha = 0
            }
            
            
            
            return cell!
        }else if(indexPath.row == CellName.delete.rawValue){
            
            //DeleteItemCell
            let cell:DeleteItemCell? = tableView.dequeueReusableCell(withIdentifier: "DeleteItemCell", for: indexPath) as? DeleteItemCell
            cell?.selectionStyle = .default
            cell?.clipsToBounds = true
            
            return cell!
        }
        
        
        
        
        
        let cell:EmptyCell? = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as? EmptyCell
        cell?.selectionStyle = .none
        cell?.clipsToBounds = true
        cell?.tag = indexPath.row
        cell?.contentView.backgroundColor = UIColor.white
        
        
        
        
        return cell!
        
    }
    
    // MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        

        if(indexPath.row == CellName.descriptionInput.rawValue){
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
            let vc:TextMessageInputVC = storyboard.instantiateViewController(withIdentifier: "TextMessageInputVC") as! TextMessageInputVC
            
            vc.strTitle = "Description"
            vc.strMessage = self.strDrscription
            
            vc.callBack = {(message) in
                
                /*
                 var m:String = message
                 if(m.characters.count > 200){
                 
                 let ns:NSString = NSString(string: m)
                 m = ns.substring(with: NSMakeRange(0, 200))
                 
                 }
                 */
                
                self.strDrscription = message
                
                let indexp = IndexPath(row: CellName.descriptionInput.rawValue, section: 0)
                self.myTable.reloadRows(at: [indexp], with: UITableViewRowAnimation.fade)
                
                
                
                
                
            }
            
            self.present(vc, animated: true, completion: {
                
            })
            
            
            
        }else if(indexPath.row == CellName.locationInput.rawValue){
            self.openLocationPicker()
        }else if(indexPath.row == CellName.categoryInput.rawValue){
            self.openCategoriPicker()
        }else if(indexPath.row == CellName.countryInput.rawValue){
            self.openCountryPicker()
        }else if(indexPath.row == CellName.delete.rawValue){
            
            
            //
            print("tap on delete")
            self.deleteThisProduct()
            
        }else if(indexPath.row == CellName.add_serial.rawValue){
            self.addNewSerial()
        }
        
        
        
        
        
        
        
        
        
        
        self.myTable.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
   
}





// MARK: - UITextFieldDelegate
extension PostSellVC:UITextFieldDelegate{
    func tapOnOKKeyboard(sender:UIButton) {
        
        let indexP = IndexPath(row: CellName.priceInput.rawValue, section: 0)
        
        if let cell = myTable.cellForRow(at: indexP) as? PostTextFieldCell{
            
            
            if let dPrice:Double = Double(cell.myTextField.text!){
                
                let fPrice:CGFloat = CGFloat(dPrice)
                self.strPriceOnDevice = String(format: "%.02f", fPrice)
            }else{
                self.strPriceOnDevice = "0"
            }
            
            
            //self.strPriceOnDevice = cell.myTextField.text!
            cell.myTextField.resignFirstResponder()
        }
        
        
      
    }
    
    
    func tapOnOKKeyboardSerial(sender:UIButton) {
        
        for i in CellName.serial1.rawValue...CellName.serial30.rawValue{
            let indexP = IndexPath(row: i, section: 0)
            
            if let cell = myTable.cellForRow(at: indexP) as? PostSerialHeaderCell{
                
              
                
                //self.strPriceOnDevice = cell.myTextField.text!
                cell.tfAmount.resignFirstResponder()
            }
        }
    
        
        /*
        let indexP = IndexPath(row: CellName.priceInput.rawValue, section: 0)
        
        if let cell = myTable.cellForRow(at: indexP) as? PostTextFieldCell{
            
            
            if let dPrice:Double = Double(cell.myTextField.text!){
                
                let fPrice:CGFloat = CGFloat(dPrice)
                self.strPriceOnDevice = String(format: "%.02f", fPrice)
            }else{
                self.strPriceOnDevice = "0"
            }
            
            
            //self.strPriceOnDevice = cell.myTextField.text!
            cell.myTextField.resignFirstResponder()
        }*/
        
        
        
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      
        self.textFildBuffer = textField
        
        
        if(textField.tag == CellName.priceInput.rawValue){
            
            //strPriceOnDevice
            
            textField.text = self.strPriceOnDevice
        }
        
        
        var cellTag:NSInteger = textField.tag
        
       
        
        
        
        
        //Serial
        if(textField.tag > 1000){
            cellTag = textField.tag - 1000

        }
        
        
        //Amout
        if(textField.tag > 10000){
            cellTag = textField.tag - 10000
        }
        
        
        if(textField.tag > 1000){
            
            if(self.arSerial.count > 0){
                
                if(self.arSerial[0].isSelect == false){
                    self.arSerial[0].isSelect = true
                    let cellIndex:IndexPath = IndexPath(row: cellTag, section: 0)
                    if let cell = myTable.cellForRow(at: cellIndex) as? PostSerialHeaderCell{
                        
                        cell.btDelete.isEnabled = true
                        UIView.animate(withDuration: 0.25, animations: {
                            cell.btDelete.alpha = 1
                        })
                        
                    }
                    
                }
                
            }
        }
        
        
        
        
        let cellIndex:IndexPath = IndexPath(row: cellTag, section: 0)
        
        //var newY:CGFloat = 0
        
        //var cellRect:CGRect = CGRect.zero
        
        
        let rectOfCellInTableView = self.myTable.rectForRow(at: cellIndex)
        let rectOfCellInSuperview = self.myTable.convert(rectOfCellInTableView, to: self.view)
        
        let limitY = self.screenSize.height - 352
        
        if(rectOfCellInSuperview.origin.y > limitY){
            
            let delta:CGFloat = rectOfCellInSuperview.origin.y - limitY
            
            let newPY:CGFloat = self.myTable.contentOffset.y + delta
            
            
            self.myTable.setContentOffset(CGPoint(x: 0, y: newPY), animated: true)
            
        }
        
        
      
 
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
      
        var cellTag:NSInteger = textField.tag
        
        
        
        
        //Serial
        if((textField.tag > 1000) && (textField.tag < 10000)){
            cellTag = textField.tag - 1000
            
            let serialIndex:NSInteger = cellTag - CellName.serial1.rawValue
            if((serialIndex >= 0) && (serialIndex < self.arSerial.count)){
                self.arSerial[serialIndex].serial_Title = textField.text!
            }
            
        }
        
        //Amout
        if(textField.tag > 10000){
            cellTag = textField.tag - 10000
            
            let serialIndex:NSInteger = cellTag - CellName.serial1.rawValue
            if((serialIndex >= 0) && (serialIndex < self.arSerial.count)){
                if let am = NSInteger(textField.text!){
                    self.arSerial[serialIndex].amount = am
                }
                
            }
            
            
        }
        
        
        
        
        switch cellTag {
        case CellName.titleInput.rawValue:
            
            self.strTitle = textField.text!
            
            break
        case (CellName.manufacturerInput.rawValue):
            
            self.strManufacturer = textField.text!
            
            break
        case (CellName.modelInput.rawValue):
            
            self.strModel = textField.text!
            
            break
        case CellName.priceInput.rawValue:
            print(textField.text!)
            
            //self.fPrice = Double(textField.text!)!
            if let dPrice:Double = Double(textField.text!){
                
                let fPrice:CGFloat = CGFloat(dPrice)
                self.strPriceOnDevice = String(format: "%.02f", fPrice)
            }else{
                self.strPriceOnDevice = "0"
            }
            
            /*
            self.strPriceOnDevice = textField.text!
            if(self.strPriceOnDevice.characters.count < 0){
                self.strPriceOnDevice = "0"
            }*/
            
            
            let numberF = NumberFormatter()
            numberF.numberStyle = .currency
            numberF.currencyCode = myData.userInfo.currency
            
            
            var strPrice:String = numberF.string(from: NSNumber(value: 0))!
            
            if let pdb = Double(self.strPriceOnDevice){
               
                strPrice = numberF.string(from: NSNumber(value: pdb))!
            }
            
            
            
            
            
            textField.text = strPrice
            
            break
        case CellName.yearInput.rawValue:
            
            self.strYear = textField.text!
            
            break
        case CellName.countryInput.rawValue:
            
            self.strCountry = textField.text!
            
            break

        case CellName.productIdInput.rawValue:
            
            self.strProductUserId = textField.text!
            
            break

        case CellName.descriptionInput.rawValue:
            
            self.strDrscription = textField.text!
            
            break
            
        default:
            break
        }
        
        //return true

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
    
        var cellTag:NSInteger = textField.tag
        
        
        
        
        //Serial
        if((textField.tag > 1000) && (textField.tag < 10000)){
            cellTag = textField.tag - 1000
            
            let serialIndex:NSInteger = cellTag - CellName.serial1.rawValue
            if((serialIndex >= 0) && (serialIndex < self.arSerial.count)){
                self.arSerial[serialIndex].serial_Title = textField.text!
            }
            
        }
        
        //Amout
        if(textField.tag > 10000){
            cellTag = textField.tag - 10000
            
            let serialIndex:NSInteger = cellTag - CellName.serial1.rawValue
            if((serialIndex >= 0) && (serialIndex < self.arSerial.count)){
                if let am = NSInteger(textField.text!){
                    self.arSerial[serialIndex].amount = am
                }
                
            }
            
            
        }
        
        
        
        switch cellTag {
        case CellName.titleInput.rawValue:
            
            self.strTitle = textField.text!
            
            break
        case (CellName.manufacturerInput.rawValue):
            
            self.strManufacturer = textField.text!
            
            break
        case (CellName.modelInput.rawValue):
            
            self.strModel = textField.text!
            
            break
        case CellName.priceInput.rawValue:
            
            print(textField.text!)
            //self.strPrice = textField.text!
            //textField.text = self.mySetting.priceWithString(strPricein: self.strPrice)
            
            
            break
        case CellName.yearInput.rawValue:
            
            self.strYear = textField.text!
            
            break
        case CellName.countryInput.rawValue:
            
            self.strCountry = textField.text!
            
            break
            
        case CellName.productIdInput.rawValue:
            
            self.strProductUserId = textField.text!
            
            break
            
        case CellName.descriptionInput.rawValue:
            
            self.strDrscription = textField.text!
            
            break
            
        default:
            break
        }
        
        
        return true
 
    }
    
}



// MARK: - GMSAutocompleteViewControllerDelegate
extension PostSellVC:GMSAutocompleteViewControllerDelegate{
    
    func showGoogleAutocomplete() {
        
        
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.tableCellSeparatorColor = UIColor(red: (99.0/255.0), green: (99.0/255.0), blue: (99.0/255.0), alpha: 1.0)
        
        present(autocompleteController, animated: true, completion: nil)
        
        
        
        
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print(place.name)
        //print(place.formattedAddress)
        
        
        

        
        self.latitude = place.coordinate.latitude
        self.longitude = place.coordinate.longitude
        
        //print(locationData)
        //let zip:String? = locationData["Zip"]
        self.strLocation = place.name
        
        
        
        
        
        
        self.dismiss(animated: true) {
            
            let indexZIP:IndexPath = IndexPath(row: CellName.locationInput.rawValue, section: 0)
            self.myTable.reloadRows(at: [indexZIP], with: UITableViewRowAnimation.fade)
            
        }
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
        //self.dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
        
        
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    
}




