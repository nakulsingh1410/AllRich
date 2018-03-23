//
//  MyLikesVC.swift
//  SkySell
//
//  Created by DW02 on 6/27/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift


class MyLikesVC: UIViewController {

    
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var viTopBarBG: UIView!
    
    @IBOutlet weak var btBack: UIButton!
    
    
    
    @IBOutlet weak var viCollectionProductBG: UIView!
    
    @IBOutlet weak var viNoItem: UIView!
    
    
    
    
    var myCollection:UICollectionView! = nil
    var refreshControl:UIRefreshControl! = nil
    
    
    
    var myCollectionLayout:ProductListLayout! = nil
    
    
    
    var myHeaderData:ProductHeaderCollectionDataControl! = nil
    
    
    var category:CategoriesDataModel! = nil // In this scene don't need
    
    
    
    var myActivityView:ActivityLoadingView! = nil
    
    var working:Bool = false
    
    
    var arProduct:[RealmProductDataModel] = [RealmProductDataModel]()
    
    
    var myData:ShareData = ShareData.sharedInstance
    var mySetting:SettingData = SettingData.sharedInstance
    
    
    var numberOfColumns = 2
    var cellPadding: CGFloat = 8.0
    var maxWidth:CGFloat = 195.0
    var arWorkingProductId:[String] = [String]()
    let likeQueue = OperationQueue()
    
    
    let imageLike:UIImage = UIImage(named: "heart.png")!
    let imageNoLike:UIImage = UIImage(named: "iconNoLike.png")!
    
    
    var workOnProduct_UserId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        
        self.viTopBarBG.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viTopBarBG.layer.shadowRadius = 1
        self.viTopBarBG.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viTopBarBG.layer.shadowOpacity = 0.5
        
        
        
        self.viCollectionProductBG.clipsToBounds = true
        
        self.myHeaderData = ProductHeaderCollectionDataControl()
        if(category != nil){
            
            for value in category.subCategory.values{
                
                self.myHeaderData.arSubCategories.append(value)
            }
        }
        
        
        self.myHeaderData.callBackSelect = {(row) in
            
            self.refeshData()
        }

        myCollectionLayout = ProductListLayout()
        myCollectionLayout.delegate = self
        
        
        
        self.myCollection = UICollectionView(frame: self.getCollectionFrame(), collectionViewLayout: myCollectionLayout)
        
        self.viCollectionProductBG.addSubview(self.myCollection)
        
        
        
        let nib1:UINib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.myCollection.register(nib1, forCellWithReuseIdentifier: "CollectionViewCell")
        
        
        
        
        let nib2:UINib = UINib(nibName: "ProductListCollectionCell", bundle: nil)
        self.myCollection.register(nib2, forCellWithReuseIdentifier: "ProductListCollectionCell")
        
        
        let nib3:UINib = UINib(nibName: "ProductHeaderCell", bundle: nil)
        self.myCollection.register(nib3, forCellWithReuseIdentifier: "ProductHeaderCell")
        
        
        
        
        self.myCollection.delegate = self
        self.myCollection.dataSource = self
        
        
        self.myCollection.backgroundColor = UIColor.white
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: (3.0/255.0), green: (210.0/255.0), blue: (99.0/255.0), alpha: 1.0)
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        myCollection.addSubview(refreshControl)
        myCollection.alwaysBounceVertical = true
        
        
        
        var frameA:CGRect = CGRect(x: 0, y: 67, width: screenSize.width, height: screenSize.height - 67)
        
        if((self.screenSize.width == 375) && (self.screenSize.height == 812)){
            frameA = CGRect(x: 0, y: 47 + 44, width: screenSize.width, height: screenSize.height - (47 + 44))
        }
        myActivityView = ActivityLoadingView(frame: frameA)
        self.view.addSubview(myActivityView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        if(self.arProduct.count <= 0){
            
            if(self.working == false){
                self.working = true
                
                if(self.myActivityView == nil){
                    myActivityView = ActivityLoadingView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - 112))
                    myActivityView.alpha = 0
                    self.view.addSubview(myActivityView)
                    
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.myActivityView.alpha = 1
                    }, completion: { (finish) in
                        self.connectToProductList()
                    })
                }else{
                    self.connectToProductList()
                }
            }
            
            
            
        }
        

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
    
    @IBAction func tapOnClose(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func getCollectionFrame() -> CGRect {
        //let statusBarH:CGFloat = 20
        
        
        let frame = CGRect(x: 0, y: 0, width: self.screenSize.width, height: self.screenSize.height - 67)
        
        return frame
        
    }
    
    
    // MARK: - Activity
    
    func addActivityView(Finish finish:@escaping ()->Void){
        
        if(self.myActivityView == nil){
            
            
            var frameA:CGRect = CGRect(x: 0, y: 67, width: screenSize.width, height: screenSize.height - 67)
            
             if((self.screenSize.width == 375) && (self.screenSize.height == 812)){
                frameA = CGRect(x: 0, y: 47 + 44, width: screenSize.width, height: screenSize.height - (47 + 44))
            }
            
            
            myActivityView = ActivityLoadingView(frame: frameA)
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
    
    func pullToRefresh() {
        
        self.refeshData()
        
    }
    
    
    func refeshData() {
        var haveFilter:Bool = false
        
        for obj in self.myHeaderData.selsetAt{
            if(obj.value == true){
                haveFilter = true
                
            }
        }
        
        
        if(haveFilter){
            self.startSearch()
        }else{
            self.connectToProductList()
        }
    }
    
    
    func removeActivityView() {
        if(self.myActivityView != nil){
            
            UIView.animate(withDuration: 0.45, animations: {
                self.myActivityView.alpha = 0
            }, completion: { (_) in
                
                if(self.myActivityView != nil){
                    self.myActivityView.removeFromSuperview()
                    self.myActivityView = nil
                }
            })
        }
        
        
        
        if refreshControl != nil {
            self.refreshControl.endRefreshing()
        }
        
        
    }
    // MARK: - connect server
    
    func connectToProductList() {
        
      
        self.arProduct.removeAll()
        ///-------------------------------
        
        //Search
        DispatchQueue.main.async {
            self.arProduct.removeAll()
            let otherRealm = try! Realm()
            
            
            
        
            
            //let predicate = NSPredicate(format: "category1 = %@", self.category.category_id)
            
            
            
            
            let otherResults = otherRealm.objects(RealmProductDataModel.self)
            
            
            
            
            
            
            
            print("Number of product \(otherResults.count)")
            
            var arBuffer:[RealmProductDataModel] = [RealmProductDataModel]()
            
            for pro in otherResults{
                
                
                let newP:RealmProductDataModel = RealmProductDataModel()
                
                newP.category1 = pro.category1
                newP.category2 = pro.category2
                
                newP.created_at_Date = pro.created_at_Date
                newP.created_at_server_timestamp = pro.created_at_server_timestamp
                
                newP.image_name = pro.image_name
                newP.image_path = pro.image_path
                newP.image_src = pro.image_src
                
                
                
                
                newP.isDeleted = pro.isDeleted
                newP.isNew = pro.isNew
                newP.likeCount = pro.likeCount
                newP.manufacturer = pro.manufacturer
                newP.model = pro.model
                newP.price = pro.price
                newP.price_server_Number = pro.price_server_Number
                newP.product_description = pro.product_description
                newP.product_id = pro.product_id
                newP.product_id_number = pro.product_id_number
                newP.product_latitude = pro.product_latitude
                newP.product_location = pro.product_location
                newP.product_longitude = pro.product_longitude
                
                for item in pro.product_serials{
                    let newItem:RealmSerial = RealmSerial()
                    newItem.amount = item.amount
                    newItem.serialID = item.serialID
                    newItem.serialNumber = item.serialNumber
                    newP.product_serials.append(newItem)
                }
                
                
                
                newP.product_status = pro.product_status
                newP.status = pro.status
                newP.title = pro.title
                newP.uid = pro.uid
                
                newP.updated_at_Date = pro.updated_at_Date
                newP.updated_at_server_timestamp = pro.updated_at_server_timestamp
                newP.year = pro.year
                newP.country = pro.country
                
                
                
                
                
                newP.viewCount = pro.viewCount
                
                
                
                newP.owner_FirstName = pro.owner_FirstName
                newP.owner_LastName = pro.owner_LastName
                newP.owner_Image_src = pro.owner_Image_src
                
                newP.isUserLike = false
                let myData:ShareData = ShareData.sharedInstance
                if(myData.userInfo != nil){
                    
                    for like in myData.userLike{
                        
                        if(newP.product_id == like.product_id){
                            newP.isUserLike = true
                        }
                    }
                    
                }
                
                
                
                
                if(newP.isUserLike == true){
                    arBuffer.append(newP)
                }
                
                
                
                
                
                
            }
            
            
            let sort = arBuffer.sorted(by: { (obj1, obj2) -> Bool in
                return (obj1.updated_at_Date < obj2.updated_at_Date)
            })
            
            self.arProduct = sort
            
            
            if(self.arProduct.count <= 0){
                self.myCollection.alpha = 0
            }else{
                self.myCollection.alpha = 1
            }
            
            self.myCollection.reloadData()
            
            self.myCollectionLayout.reloadLayout()
            
            
            self.myCollection.reloadData()
            
            self.loadOwnerData()
            
            self.removeActivityView()
            self.working = false
            
        }
        
        
        
        
        
        
        
        ///--------------------------------
        
    }
    
    
    
    
    func loadOwnerData() {
        
        var allHaveData:Bool = true
        
        var setToPro:RealmProductDataModel! = nil
        
        for pro in self.arProduct{
            if((pro.owner_FirstName == "") && (pro.owner_LastName == "") && (pro.loadFinish == false)){
                allHaveData = false
                
                self.workOnProduct_UserId = pro.uid
                
                setToPro = pro
                
                
                break
            }
        }
        
        
        if((allHaveData == false) && (setToPro != nil)){
            
            getUserDataWith(UID: self.workOnProduct_UserId, Finish: { (userData) in
                
                
                

                
                var arReloadIndex:[IndexPath] = [IndexPath]()
                
                for i in 0..<self.arProduct.count{
                    let pro = self.arProduct[i]
                    if(pro.uid == self.workOnProduct_UserId){
                        pro.owner_FirstName = userData.first_name
                        pro.owner_LastName = userData.last_name
                        pro.owner_Image_src = userData.profileImage_src
                        pro.loadFinish = true
                        
                        let indexRe:IndexPath = IndexPath(item: i+1, section: 0)
                        arReloadIndex.append(indexRe)
                    }
                }
              
                
                
                if(arReloadIndex.count > 0){
                    self.myCollection.reloadItems(at: arReloadIndex)
                }
                
                
                self.loadOwnerData()
                
            })
        }
        
        
    }
    
    
    
    
    func startSearch(){
        
        
        
        self.arProduct.removeAll()
        self.myCollection.reloadData()
        self.myCollectionLayout.reloadLayout()
        self.myCollection.reloadData()
        
        
        
        
        
        
        self.connectToProductList()
        
        
        
        /*
         for obj in self.myHeaderData.selsetAt{
         
         if(obj.value == true){
         
         let sebCat = self.myHeaderData.arSubCategories[obj.key]
         
         self.searchWithSubCategory(subCat: sebCat.sub_category_id, callBack: { (products) in
         
         if(products.count > 0){
         
         for p in products{
         self.arProduct.append(p)
         }
         
         
         
         self.myCollection.reloadData()
         self.myCollectionLayout.reloadLayout()
         self.myCollection.reloadData()
         }
         
         
         })
         }
         }
         */
        
        
    }
    
    
    
    func searchWithSubCategory(subCat:String, callBack:@escaping ([RealmProductDataModel])->Void){
        
        
        
        DispatchQueue.main.async {
            var arProduct:[RealmProductDataModel] = [RealmProductDataModel]()
            
            
            
            let otherRealm = try! Realm()
            
            let predicate = NSPredicate(format: "category1 = %@ AND category2 = %@ ", self.category.category_id, subCat)
            
            let otherResults = otherRealm.objects(RealmProductDataModel.self).filter(predicate)
            
            print("Number of product \(otherResults.count)")
            
            var arBuffer:[RealmProductDataModel] = [RealmProductDataModel]()
            
            for pro in otherResults{
                
                
                let newP:RealmProductDataModel = RealmProductDataModel()
                
                newP.category1 = pro.category1
                newP.category2 = pro.category2
                
                newP.created_at_Date = pro.created_at_Date
                newP.created_at_server_timestamp = pro.created_at_server_timestamp
                
                
                newP.image_name = pro.image_name
                newP.image_path = pro.image_path
                newP.image_src = pro.image_src
                
                
                
                
                newP.isDeleted = pro.isDeleted
                newP.isNew = pro.isNew
                newP.likeCount = pro.likeCount
                newP.manufacturer = pro.manufacturer
                newP.model = pro.model
                newP.price = pro.price
                newP.price_server_Number = pro.price_server_Number
                newP.product_description = pro.product_description
                newP.product_id = pro.product_id
                newP.product_id_number = pro.product_id_number
                newP.product_latitude = pro.product_latitude
                newP.product_location = pro.product_location
                newP.product_longitude = pro.product_longitude
                
                for item in pro.product_serials{
                    let newItem:RealmSerial = RealmSerial()
                    newItem.amount = item.amount
                    newItem.serialID = item.serialID
                    newItem.serialNumber = item.serialNumber
                    newP.product_serials.append(newItem)
                }
                
                
                newP.product_status = pro.product_status
                newP.status = pro.status
                newP.title = pro.title
                newP.uid = pro.uid
                
                newP.updated_at_Date = pro.updated_at_Date
                newP.updated_at_server_timestamp = pro.updated_at_server_timestamp
                newP.year = pro.year
                newP.country = pro.country
                
                
                
                
                
                newP.viewCount = pro.viewCount
                
                
                
                newP.owner_FirstName = pro.owner_FirstName
                newP.owner_LastName = pro.owner_LastName
                newP.owner_Image_src = pro.owner_Image_src
                
                
                newP.isUserLike = false
                let myData:ShareData = ShareData.sharedInstance
                if(myData.userInfo != nil){
                    
                    for like in myData.userLike{
                        
                        if(newP.product_id == like.product_id){
                            newP.isUserLike = true
                        }
                    }
                    
                }
                
                
                
                arBuffer.append(newP)
                
                
                
                
            }
            
            
            let sort = arBuffer.sorted(by: { (obj1, obj2) -> Bool in
                return (obj1.updated_at_Date < obj2.updated_at_Date)
            })
            
            arProduct = sort
            
            callBack(arProduct)
            
            
        }
        
        ////---------------------------
        /*
         let postRef = FIRDatabase.database().reference().child("products").queryOrdered(byChild: "category2").queryEqual(toValue: subCat)
         
         postRef.observeSingleEvent(of: .value, with: { (snapshot) in
         
         
         var arProduct:[ProductDataModel] = [ProductDataModel]()
         //print(snapshot.value)
         if let snapshot = snapshot.value as? NSDictionary{
         
         
         
         for item in snapshot.allValues{
         
         if let item = item as? NSDictionary{
         let newProduct:ProductDataModel = ProductDataModel(dictionary: item)
         arProduct.append(newProduct)
         }
         
         }
         
         
         }
         
         
         callBack(arProduct)
         
         
         }) { (error) in
         
         let arProduct:[ProductDataModel] = [ProductDataModel]()
         callBack(arProduct)
         
         
         }
         */
    }
    
    
    
    
    
    func addLiketo(ProductId productId:String, Like like:Bool) {
        
        var work:Bool = false
        
        for strID in self.arWorkingProductId{
            if(strID == productId){
                work = true
            }
        }
        
        
        
        if(work == false){
            let newLike:LikeOperation = LikeOperation(userID: self.myData.userInfo.uid, like: like, productID: productId) { (product) in
                
                
                var i = self.arWorkingProductId.count - 1
                while i >= 0 {
                    
                    let pid:String = self.arWorkingProductId[i]
                    if(pid == productId){
                        self.arWorkingProductId.remove(at: i)
                    }
                    i = i - 1
                }
                
                
                
                self.refeshData()
                
                
                
                
                
               /*
                
                getProductDataWith(ProductID: product.product_id, Finish: { (product) in
                    for p in self.arProduct{
                        if(p.product_id == product.product_id){
                            p.likeCount = product.likeCount
                        }
                    }
                    
                    self.myCollection.reloadData()
                })
                */
                
                
                
            }
            
            
            self.likeQueue.addOperation(newLike)
        }
        
        
        
    }
    
    
    // MARK: - connect server
    func cannotConnetToServer() {
        
        self.removeActivityView()
        
        
        
        self.view.isUserInteractionEnabled = true
        
        let alertController = UIAlertController(title: "Can't connect to server. Please try again later.", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            self.working = false
        }
        alertController.addAction(cancelAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }

}




extension MyLikesVC:ProductListLayoutDelegate{
    
    
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
    
    
    
    func collectionView(collectionView: UICollectionView, HeightForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.item == 0){
            if(self.myHeaderData.arSubCategories.count <= 0){
                return 0
            }
            return 118.0
        }else{
            
            
            return 230.0
        }
    }
}



// MARK: - UICollectionViewDataSource, UICollectionViewDelegate


extension MyLikesVC:UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let itemCount = self.arProduct.count + 1
        
        
        print("Cell count: \(itemCount)")
        return itemCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if(indexPath.item > 0){
            //ProductListCollectionCell
            let cell:ProductListCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCollectionCell", for: indexPath) as! ProductListCollectionCell
            
            
            if((indexPath.item - 1) < self.arProduct.count){
                let product = self.arProduct[indexPath.item - 1]
                
                cell.myTag = indexPath.item - 1
                
                
                cell.lbTitle.text = product.title
                cell.lbDetail.text = self.mySetting.priceWithString(strPricein: product.price)
                
                if(product.image_src.count > 5){
                    cell.lazyImage.alpha = 1
                    cell.lazyImage.loadImage(imageURL: product.image_src, Thumbnail: true)
                }else{
                    cell.lazyImage.imageView.image = nil
                }
                
                
                cell.lbName.text = String(format: "%@  %@", product.owner_FirstName, product.owner_LastName)
                
                if(product.owner_Image_src.count > 5){
                    cell.lazyImage_Owner.loadImage(imageURL: product.owner_Image_src, Thumbnail: true)
                    cell.lazyImage_Owner.alpha = 1
                }else{
                    cell.lazyImage_Owner.alpha = 0
                }
                
                
                cell.lbCount.text = String(format: "%ld", product.likeCount)
                
                if(product.isUserLike == true){
                    
                    cell.imageHeart.image = self.imageLike
                }else{
                    cell.imageHeart.image = self.imageNoLike
                    
                }
                
                
                
                if(product.product_status == "Sold Out"){
                    cell.lbStatus.text = "SOLD"//product.product_status
                    cell.viStatusBG.alpha = 1
                    
                    
                }else{
                    cell.viStatusBG.alpha = 0
                }
                
                cell.tapOnLike = {(tag) in
                    
                    
                    if(tag < self.arProduct.count){
                        let ind:IndexPath = IndexPath(item: tag+1, section: 0)
                        let p:RealmProductDataModel = self.arProduct[tag]
                        
                        if(p.isUserLike == true){
                            
                            
                            self.addActivityView {
                                self.addLiketo(ProductId: p.product_id, Like: false)
                                
                                self.arProduct[tag].isUserLike = false
                                
                              
                                var likecount = p.likeCount - 1
                                if(likecount < 0){
                                    likecount = 0
                                }
                                
                                self.arProduct[tag].likeCount = likecount
                                
                                
                                
                                let bufferCell:ProductListCollectionCell? = self.myCollection.cellForItem(at: ind) as? ProductListCollectionCell
                                if let bufferCell = bufferCell{
                                    bufferCell.imageHeart.image = self.imageNoLike
                                    bufferCell.lbCount.text = String(format: "%ld", likecount)
                                }
                                
                            }
                            
                            
                            
                            
                            
                            
                        }else{
                            self.addLiketo(ProductId: p.product_id, Like: true)
                            
                            self.arProduct[tag].isUserLike = true
                            
                            var likecount = p.likeCount + 1
                            if(likecount < 0){
                                likecount = 0
                            }
                            
                            self.arProduct[tag].likeCount = likecount
                            
                            
                            let bufferCell:ProductListCollectionCell? = self.myCollection.cellForItem(at: ind) as? ProductListCollectionCell
                            
                          
                            
                            if let bufferCell = bufferCell{
                                bufferCell.imageHeart.image = self.imageLike
                                bufferCell.lbCount.text = String(format: "%ld", likecount)
                            }
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                    
                    //self.myCollection.reloadItems(at: [ind])
                    
                }
            }
            
            
            
            let w = self.getFitCellWidthWithColumn(column: self.numberOfColumns)
            cell.updateCellSize(size: CGSize(width: w, height: 230))
            
            
            
            return cell
        }
        
        
        let cell:ProductHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductHeaderCell", for: indexPath) as! ProductHeaderCell
        
        if((cell.myCollection != nil) && (self.myHeaderData != nil)){
            cell.myCollection.dataSource = myHeaderData
            cell.myCollection.delegate = myHeaderData
        }
        
        
        
        
        /*
         cell.lazyImage.setupDefaultImage(DefaultImage: imageDefault, DefaultImageContent: UIViewContentMode.scaleAspectFit)
         // cell.updateFrameSize(size: self.customLayout.itemSize)
         
         let size = self.myCollection.layoutAttributesForItem(at: indexPath)?.size
         if let size = size{
         cell.lazyImage.updateImageSize(size: size)
         print(size)
         }
         
         
         cell.lazyImage.loadImageWithImageName(imagename: "pictures-icon.png", ImageContent: UIViewContentMode.scaleAspectFit)
         
         
         */
        
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if(indexPath.item > 0){
            
            
            
            if((indexPath.item - 1) < self.arProduct.count){
                
                
                self.addActivityView {
                    
                    let realmPro = self.arProduct[indexPath.item - 1]
                    
                    getProductDataWith(ProductID: realmPro.product_id, Finish: { (product) in
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
                        let vc:ProductDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
                        
                        vc.thisFirstDetail = true
                        vc.myProductData = product
                        
                        if(self.myData.masterView != nil){
                            self.myData.masterView.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                        self.removeActivityView {
                            
                        }
                        
                    })
                    
                }
                
                /*
                 
                 let product = self.arProduct[indexPath.item - 1]
                 let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
                 let vc:ProductDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
                 
                 
                 vc.myProductData = product
                 
                 if(self.myData.masterView != nil){
                 self.myData.masterView.navigationController?.pushViewController(vc, animated: true)
                 }else{
                 self.navigationController?.pushViewController(vc, animated: true)
                 }
                 */
                
                
            }
            
            
            
        }
        
        
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}





