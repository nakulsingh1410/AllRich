//
//  SearchVC.swift
//  SkySell
//
//  Created by supapon pucknavin on 6/11/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift


class SearchVC: UIViewController {

    enum SearchMode{
        case all
        case myGroup
    }
   
    enum SortBy{
        case heighestPrice
        case recent
        case popular
        case lowest
        case points
    }
    
    var sortBy:SortBy = .popular
    
    var haveNoti:Bool = false
    
    
    var searchMode:SearchMode = .all
    

    var screenSize:CGRect = UIScreen.main.bounds
    
    
    @IBOutlet weak var viNoItem: UIView!
    
    
    
    @IBOutlet weak var viFilterBG: UIView!
    @IBOutlet weak var viFilterBG_Layout_Height: NSLayoutConstraint!
    
    @IBOutlet weak var layout_Between_Filter_Product: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var viCollectionProductBG: UIView!
    
    
    @IBOutlet weak var lbSortTitle: UILabel!
    
    
    @IBOutlet weak var btSort_Filter: UIButton!
    
    
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
    
    
    
    var strKeyword:String = ""
    
    
    let imageLike:UIImage = UIImage(named: "heart.png")!
    let imageNoLike:UIImage = UIImage(named: "iconNoLike.png")!
    
    var workOnProduct_UserId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        
        // Do any additional setup after loading the view.
        
        self.viFilterBG.clipsToBounds = true
        
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
        
        
        self.view.clipsToBounds = true
        
        
        
        
        self.setSortTitle()
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
        
        
        
        
        myActivityView = ActivityLoadingView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - 112))
        self.view.addSubview(myActivityView)
        
        
        self.viNoItem.alpha = 0
        self.viNoItem.isUserInteractionEnabled = false
        
        self.view.bringSubview(toFront: self.viNoItem)
        
        self.myData.haveLogout = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if(self.myData.haveLogout == true){
            self.navigationController?.popToRootViewController(animated: false)
            
            var object:[String:Bool] = [String:Bool]()
            object["show"] = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVCSetShowBackButton.rawValue), object: nil, userInfo: object)
            self.myData.haveLogout = false
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        if(self.haveNoti == false){
            self.haveNoti = true
            NotificationCenter.default.addObserver(self, selector: #selector(SearchVC.tapOnCancel(notification:)), name:NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVC_CancelSearch.rawValue), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(SearchVC.searchWithKey(notification:)), name:NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVC_SearchWithKey.rawValue), object: nil)
        }
        
        
        
        
        if((self.arProduct.count <= 0) || (self.myData.needUpdateAfterEdit == true)){
            self.myData.needUpdateAfterEdit = false
            
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
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if(self.haveNoti == true){
            self.haveNoti = false
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVC_CancelSearch.rawValue), object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVC_SearchWithKey.rawValue), object: nil)
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
    
    // MARK: - notitfication
    func tapOnCancel(notification:NSNotification){
        
        self.exitScene()
    }
    
    func searchWithKey(notification:NSNotification){
        if let key = notification.userInfo?["key"] as? String {
            print(key)
            self.strKeyword = key
            
            self.connectToProductList()
        }
        
    }
    // MARK: - Action

    
    
    func exitScene() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //if let show = notification.userInfo?["show"] as? Bool {

    
    // MARK: - Helper
    // MARK: - Action
    
    func setSortTitle() {
        
        let fontTitle:UIFont = UIFont(name: "Avenir-Roman", size: 14)!
        let fontSelect:UIFont = UIFont(name: "Avenir-Medium", size: 14)!
        
        let colorTitle:UIColor = UIColor(red: (39.0/255.0), green: (47.0/255.0), blue: (85.0/255.0), alpha: 1.0)
        
        let colorSelect:UIColor = UIColor(red: (3.0/255.0), green: (210.0/255.0), blue: (99.0/255.0), alpha: 1.0)
        
        
        var strTitle:String = "Sort by/Filter: Popular ▾"
        
        switch self.sortBy {
        case .heighestPrice:
            strTitle = "Sort by/Filter: Highest price ▾"
            break
        case .recent:
            strTitle = "Sort by/Filter: Recent ▾"
            break
        case .popular:
            strTitle = "Sort by/Filter: Popular ▾"
            break
        case .lowest:
            strTitle = "Sort by/Filter: Lowest price ▾"
            break
            
        case .points:
            strTitle = "Sort by/Filter: Points ▾"
            break
        }
        
        self.lbSortTitle.text = strTitle
        self.lbSortTitle.font = fontTitle
        self.lbSortTitle.textColor = colorTitle
        
        
        let strNS:NSString = NSString(string: strTitle)
        
        
        var rangOfString = strNS.range(of: "Popular ▾")
        
        switch self.sortBy {
        case .heighestPrice:
            
            rangOfString = strNS.range(of: "Highest price ▾")
            break
        case .recent:
            rangOfString = strNS.range(of: "Recent ▾")
            
            break
        case .popular:
            rangOfString = strNS.range(of: "Popular ▾")
            break
        case .lowest:
            rangOfString = strNS.range(of: "Lowest price ▾")
            break
            
        case .points:
            rangOfString = strNS.range(of: "Points ▾")
            break
        }
        
        
        
        
        let mutableText:NSMutableAttributedString = NSMutableAttributedString(attributedString: self.lbSortTitle.attributedText!)
        mutableText.addAttributes([NSForegroundColorAttributeName:colorSelect, NSFontAttributeName: fontSelect], range: rangOfString)
        self.lbSortTitle.attributedText = mutableText
        
        
        
    }
    
    
    @IBAction func tapOnSortFilter(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            // ...
        }
        alertController.addAction(cancelAction)
        
        
        
        
        let recentAction = UIAlertAction(title: "Recent", style: .default) { action in
            // ...
            self.sortBy = .recent
            
            self.setSortTitle()
            self.connectToProductList()
            
            
        }
        alertController.addAction(recentAction)
        
        
        
        
        let highestAction = UIAlertAction(title: "Highest price", style: .default) { action in
            // ...
            self.sortBy = .heighestPrice
            self.setSortTitle()
            self.connectToProductList()
        }
        alertController.addAction(highestAction)
        
        
        
        
        let lowestAction = UIAlertAction(title: "Lowest price", style: .default) { action in
            // ...
            self.sortBy = .lowest
            self.setSortTitle()
            self.connectToProductList()
        }
        alertController.addAction(lowestAction)
        
        
        
        
        let popularAction = UIAlertAction(title: "Popular", style: .default) { action in
            // ...
            self.sortBy = .popular
            self.setSortTitle()
            self.connectToProductList()
        }
        alertController.addAction(popularAction)
        
        
        
        self.present(alertController, animated: true) {
            // ...
            
        }
    }
    
    
    func getCollectionFrame() -> CGRect {
        let statusBarH:CGFloat = 20
        
        
        let frame = CGRect(x: 0, y: 0, width: self.screenSize.width, height: self.screenSize.height - (statusBarH + 47 + 42 + 45))
        
        return frame
        
    }
    
    
    // MARK: - Activity
    
    func addActivityView(Finish finish:@escaping ()->Void){
        
        if(self.myActivityView == nil){
            myActivityView = ActivityLoadingView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - 112))
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
            
            self.myData.loadAllProduct({
                self.myData.productDownloading = .finish
                
                self.connectToProductList()
            })
            
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
        
        print("Search with key \(self.strKeyword)")
        self.arProduct.removeAll()
        ///-------------------------------
        
        //Search
        DispatchQueue.main.async {
            self.arProduct.removeAll()
            let otherRealm = try! Realm()
            
            
            
            var arKey:[String] = self.strKeyword.components(separatedBy: " ")
            
            if((arKey.count > 0) && (self.strKeyword.count > 0)){
                
                var strPredicate:String = String(format: "title CONTAINS[c] '%@'", arKey[0])
                
                for i in 1..<arKey.count{
                    strPredicate = String(format: "%@ AND title CONTAINS[c] '%@'", strPredicate, arKey[i])
                }
                
                //let predicate = NSPredicate(format: "category1 = %@", self.category.category_id)
                
                
                
                var sortByKey:String = "likeCount"
                var ascending:Bool = true
                
                switch self.sortBy {
                case .heighestPrice:
                    sortByKey = "priceInNumber"
                    ascending = false
                    break
                case .recent:
                    sortByKey = "updated_at_Date"
                    
                    break
                case .popular:
                    sortByKey = "likeCount"
                    ascending = false
                    break
                case .lowest:
                    sortByKey = "priceInNumber"
                    ascending = true
                    break
                    
                case .points:
                    sortByKey = "points"
                    ascending = false
                    break
                }
                
                
                let otherResults = otherRealm.objects(RealmProductDataModel.self).filter(strPredicate).sorted(byKeyPath: sortByKey, ascending: ascending)
                
                
                
                
                
                
                
                print("Number of product \(otherResults.count)")
                
                var arBuffer:[RealmProductDataModel] = [RealmProductDataModel]()
                
                for pro in otherResults{
                    
                    
                    let newP:RealmProductDataModel = RealmProductDataModel()
                    
                    newP.category1 = pro.category1
                    newP.category2 = pro.category2
                    
                    newP.created_at_Date = pro.created_at_Date
                    
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
                    
                    
                    
                    
                    if(self.searchMode == .myGroup){
                        
                        var haveLike:Bool = false
                        
                        for cat in self.myData.arCategoriesDataModel{
                            //var isFollow:Bool = false
                            
                            if(cat.category_id == newP.category1){
                                
                                for uid in cat.favorites{
                                    if(uid == self.myData.userInfo.uid){
                                        //isFollow = true
                                        if(haveLike == false){
                                            haveLike = true
                                            if((newP.product_status == "Sold Out") || (newP.isDeleted == true)){
                                                
                                                
                                            }else{
                                                arBuffer.append(newP)
                                            }
                                        }
                                        
                                        break
                                    }
                                }
                                
                                
                                
                            }
                            
                            if(haveLike == true){
                                break
                            }
                            
                        }
                        
                        
                        
                        
                    }else{
                        if((newP.product_status == "Sold Out") || (newP.isDeleted == true)){
                            
                            
                        }else{
                            arBuffer.append(newP)
                        }
                    }
                    
                    
                    
                    
                    
                }
                
                /*
                let sort = arBuffer.sorted(by: { (obj1, obj2) -> Bool in
                    return (obj1.updated_at_Date < obj2.updated_at_Date)
                })
                */
                self.arProduct = arBuffer
                
            }
            
            
            
            self.myCollection.reloadData()
            
            self.myCollectionLayout.reloadLayout()
            
            
            self.myCollection.reloadData()
            self.loadOwnerData()
            
            
            if(self.arProduct.count > 0){
                self.viNoItem.alpha = 0
        
            }else{
                self.viNoItem.alpha = 1
            }
            
            
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
            
            let predicate = NSPredicate(format: "category1 = %@ AND category2 = %@", self.category.category_id, subCat)
            
            
            
            var sortByKey:String = "likeCount"
            var ascending:Bool = true
            
            switch self.sortBy {
            case .heighestPrice:
                sortByKey = "priceInNumber"
                ascending = false
                break
            case .recent:
                sortByKey = "updated_at_Date"
                
                break
            case .popular:
                sortByKey = "likeCount"
                ascending = false
                break
            case .lowest:
                sortByKey = "priceInNumber"
                ascending = true
                break
                
            case .points:
                sortByKey = "points"
                ascending = false
                break
            }
            
            
            let otherResults = otherRealm.objects(RealmProductDataModel.self).filter(predicate).sorted(byKeyPath: sortByKey, ascending: ascending)
            
            
            
            
            print("Number of product \(otherResults.count)")
            
            var arBuffer:[RealmProductDataModel] = [RealmProductDataModel]()
            
            for pro in otherResults{
                
                
                let newP:RealmProductDataModel = RealmProductDataModel()
                
                newP.category1 = pro.category1
                newP.category2 = pro.category2
                
                newP.created_at_Date = pro.created_at_Date
                
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
                
                
                if((newP.product_status == "Sold Out") || (newP.isDeleted == true)){
                    
                    
                }else{
                    arBuffer.append(newP)
                }
             
                
                
                
                
            }
            
            /*
            let sort = arBuffer.sorted(by: { (obj1, obj2) -> Bool in
                return (obj1.updated_at_Date < obj2.updated_at_Date)
            })*/
            
            arProduct = arBuffer
            
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
                
                
                
        
                
                getProductDataWith(ProductID: product.product_id, Finish: { (product) in
                    for p in self.arProduct{
                        if(p.product_id == product.product_id){
                            p.likeCount = product.likeCount
                        }
                    }
                    
                    self.myCollection.reloadData()
                })
                
                
                
                
                
                
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


extension SearchVC:ProductListLayoutDelegate{
    
    
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


extension SearchVC:UICollectionViewDataSource, UICollectionViewDelegate{
    
    
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
                    let ind:IndexPath = IndexPath(item: tag+1, section: 0)
                    
                    
                    if(tag < self.arProduct.count){
                        let p:RealmProductDataModel = self.arProduct[tag]
                        
                        if(p.isUserLike == true){
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




