//
//  UserMainSceneVC.swift
//  SkySell
//
//  Created by DW02 on 5/10/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase

class UserMainSceneVC: UIViewController {

    
    var screenSize:CGRect = UIScreen.main.bounds
    
    
    
    @IBOutlet weak var viContaintBG: UIView!
    
    @IBOutlet weak var viTipBar: UIView!
    
    @IBOutlet weak var layout_TopbarTop: NSLayoutConstraint!
    @IBOutlet weak var layout_topbarHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var viUserImageBG: UIView!
    
    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbCompanyName: UILabel!
    
    
    @IBOutlet weak var imSmile: UIImageView!
    @IBOutlet weak var imNormal: UIImageView!
    @IBOutlet weak var imSad: UIImageView!
    
    
    
    
    @IBOutlet weak var viUserToolBarBG: UIView!
    @IBOutlet weak var layout_ToolBar_Height: NSLayoutConstraint!
    
    
    
    
    @IBOutlet weak var lbSmile: UILabel!
    @IBOutlet weak var lbNormal: UILabel!
    @IBOutlet weak var lbSad: UILabel!
    
    
    @IBOutlet weak var layout_TopCollection: NSLayoutConstraint!
    
    @IBOutlet weak var layout_BottomTV: NSLayoutConstraint!
    
    
    @IBOutlet weak var viSmileBG: UIView!
    
    @IBOutlet weak var lbBIO: UITextView!
    
    @IBOutlet weak var lbWeb: UILabel!
    
    @IBOutlet weak var btOpenWeb: UIButton!
    
    
    
    @IBOutlet weak var viNoItemImage: UIView!
    
    @IBOutlet weak var viNoitemBG: UIView!
    
    @IBOutlet weak var myCollection: UICollectionView!
    
    @IBOutlet weak var btLikes: UIButton!
    
    
    
    @IBOutlet weak var btBack: UIButton!
    
    var lazyImage:PKImV3View! = nil
    
    
    
    let fontBio:UIFont = UIFont(name: "Avenir-Medium", size: 14)!
    let fontName:UIFont = UIFont(name: "Avenir-Medium", size: 16)!
    let fontCompanyName:UIFont = UIFont(name: "Avenir-Medium", size: 14)!
    let fontWeb:UIFont = UIFont(name: "Avenir-Book", size: 14)!
    
    
    
    @IBOutlet weak var btEditProfile: UIButton!
    
    @IBOutlet weak var btItemLike: UIButton!
    @IBOutlet weak var btSetting: UIButton!
    
    
    
    let myData:ShareData = ShareData.sharedInstance
    let mySetting:SettingData = SettingData.sharedInstance
    
    var arUserProduct:[ProductDataModel] = [ProductDataModel]()
    
    
    
    var numberOfColumns = 2
    var cellPadding: CGFloat = 8.0
    var maxWidth:CGFloat = 195.0
    
    var topBarHeight:CGFloat = 0
    
    
    
    var refreshControl:UIRefreshControl! = nil
    
    
    var workOnProduct_UserId:String = ""
    
    let likeQueue = OperationQueue()
    
    
    var arWorkingProductId:[String] = [String]()
    
    
    
    var sellerMode:String = ""
    var seller:UserDataModel! = nil
    var lastSellerID:String = ""
    
    
    
    
    let imageLike:UIImage = UIImage(named: "heart.png")!
    let imageNoLike:UIImage = UIImage(named: "iconNoLike.png")!
    
    
    var needUpdate:Bool = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        self.viContaintBG.clipsToBounds = true
        
        
     
        self.viTipBar.isUserInteractionEnabled = true
        
        
        self.viTipBar.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viTipBar.layer.shadowRadius = 1
        self.viTipBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viTipBar.layer.shadowOpacity = 0.5
        //self.viTipBar.backgroundColor = UIColor.clear
        
        self.viSmileBG.clipsToBounds = true
        self.viSmileBG.layer.cornerRadius = 2
        
        self.viUserImageBG.clipsToBounds = true
        self.viUserImageBG.layer.cornerRadius = 42.5
        
        
        
        
        
        
        
        self.viNoItemImage.clipsToBounds = true
        self.viNoItemImage.layer.cornerRadius = 34.5
        self.viNoitemBG.isUserInteractionEnabled = false
        
        self.viNoitemBG.alpha = 0
        self.viContaintBG.bringSubview(toFront: self.viNoitemBG)
        
        
        
        self.lazyImage = PKImV3View(frame: CGRect(x: 0, y: 0, width: 85, height: 85))
        self.viUserImageBG.addSubview(self.lazyImage)
        
        
        self.lazyImage.imageView.contentMode = .scaleAspectFill
        self.lazyImage.backgroundColor = UIColor.clear
        self.lazyImage.imageView.backgroundColor = UIColor.clear
        
        
        
        if(sellerMode.count <= 0){
            self.seller = myData.userInfo
            self.btBack.isEnabled = false
            self.btBack.alpha = 0
        }else{
            self.btBack.isEnabled = true
            self.btBack.alpha = 1
        }
        
        self.lbName.text = String(format: "%@  %@", self.seller.first_name, self.seller.last_name)
        self.lbCompanyName.text = self.seller.company_name
        
        self.lbBIO.text = self.seller.bio
        self.lbWeb.text = self.seller.company_website
        
        self.lazyImage.loadImage(imageURL: self.seller.profileImage_src, Thumbnail: false)
        
        //------
        var positive:NSInteger = 0
        for pos in self.seller.positive_list{
            positive += pos.arUser_Uid.count
        }
        self.lbSmile.text = String(format: "%d", positive)
        
        
        var neutral:NSInteger = 0
        for neu in self.seller.neutral_list{
            neutral += neu.arUser_Uid.count
        }
        self.lbNormal.text = String(format: "%d", neutral)
        
        
        
        var negative:NSInteger = 0
        for nega in self.seller.negative_list{
            negative += nega.arUser_Uid.count
        }
        self.lbSad.text = String(format: "%d", negative)
        
        
        //-------
        
        DispatchQueue.main.async {
        
            self.topBarHeight = self.caculateHeaderHeight()
            
            if(self.myData.userInfo.uid != self.seller.uid){
                self.viUserToolBarBG.alpha = 0
                self.topBarHeight = self.topBarHeight - 40
                self.viUserToolBarBG.isUserInteractionEnabled = false
            }else{
                self.viUserToolBarBG.alpha = 1
                self.viUserToolBarBG.isUserInteractionEnabled = true
            }
            
            print("First self.topBarHeight : \(self.topBarHeight)")
            
            //------------------------------
            
            
            //-----------------------------
            self.refreshControl = UIRefreshControl()
            self.refreshControl.tintColor = UIColor(red: (3.0/255.0), green: (210.0/255.0), blue: (99.0/255.0), alpha: 1.0)
            self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
            self.myCollection.addSubview(self.refreshControl)
            self.myCollection.alwaysBounceVertical = true
            
            
            //-----------------------------
            
            let nib2:UINib = UINib(nibName: "ProductListCollectionCell", bundle: nil)
            self.myCollection.register(nib2, forCellWithReuseIdentifier: "ProductListCollectionCell")
            
            
            self.myCollection.contentInset = UIEdgeInsets(top: (self.topBarHeight-40) + 8, left: 8, bottom: 40, right: 8)
            self.myCollection.delegate = self
            self.myCollection.dataSource = self
            self.myCollection.clipsToBounds = false
            
            
            
            
            //------------------------------
            
            self.layout_topbarHeight.constant = self.topBarHeight
            if(self.seller.uid == self.myData.userInfo.uid){
                self.layout_BottomTV.constant = 82
            }else{
                self.layout_BottomTV.constant = 30
            }
            
            self.view.layoutIfNeeded()
            self.view.updateConstraints()
            
        }
        
        
        
        
        
        if(self.seller.uid == self.myData.userInfo.uid){
            let image:UIImage = UIImage(named: "like.png")!
            self.btLikes.setImage(image, for: UIControlState.normal)
        }else{
            let image:UIImage = UIImage(named: "iconOther.png")!
            self.btLikes.setImage(image, for: UIControlState.normal)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(self.myData.showUserSceneFirstTime == true){
            self.view.alpha = 0
        }else{
            
            if(self.view.alpha < 1){
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.alpha = 1
                })
            }else{
                self.view.alpha = 1
            }
            
            
        }
        
        DispatchQueue.main.async {
            self.lbBIO.text = self.seller.bio
            self.lbBIO.setContentOffset(CGPoint.zero, animated: false)
        }
        //self.lbBIO.scrollsToTop = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
     
        if(self.seller != nil){
            if((self.lastSellerID != self.seller.uid) || (self.myData.needUpdateAfterEdit == true)){
                
                self.getUserDatainfo {
                    self.reloadDisPlay()
                    self.myData.needUpdateAfterEdit = false
                    
                    
                    self.getProductByUserId(UserId: self.seller.uid) { (products) in
                        
                        self.arUserProduct.removeAll()
 
                        self.arUserProduct = products.sorted(by: { (obj1, obj2) -> Bool in
                            return obj1.updated_at > obj2.updated_at
                        })
                        
                        UIView.animate(withDuration: 0.25, animations: {
                            if(self.arUserProduct.count <= 0){
                                self.viNoitemBG.alpha = 1
                            }else{
                                self.viNoitemBG.alpha = 0
                            }
                        })
                        
                        self.myCollection.reloadData()
                        
                        self.endRefresh()
                        self.loadOwnerData()
                    }
                }
                
                
            }
            
        }
        
        
        
        
        
        
        
        
        if(self.myData.showUserSceneFirstTime == true){
            self.myData.showUserSceneFirstTime = false
            
            if(self.myData.masterView != nil){
                self.myData.masterView.gotoHomeScene()
            }
            
            
            if(self.myData.autoCheckUerPlanNeedManage()){
                //need manage Plan
                
                ShareData.sharedInstance.showDeletePlanScene()
                
            }
        }else{
            
        }
        
        
        
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        if(self.seller != nil){
            self.lastSellerID = self.seller.uid
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

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    
    
    
    // MARK: - Healper
    func showTapBar(show:Bool) {
        var object:[String:Bool] = [String:Bool]()
        object["show"] = show
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HidenMainTapBar.rawValue), object: nil, userInfo: object)
        
        
    }
    
    
    
    
    func getUserDatainfo(_ finish:@escaping ()->Void) {
        
        let postRef = FIRDatabase.database().reference().child("users").child(self.seller.uid)
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary{
                
                
                self.seller = UserDataModel(dictionary: value)
                
                //self.myData.saveUserInfo(UID: self.myData.userInfo.uid)
                
                //print(self.myData.userInfo.first_name)
                
            }
            
            finish()
        })
        
        
        
    }
    
    
    /*
    func getUserDataWith(UID uid:String, Finish finish:@escaping (_ userData:UserDataModel)->Void) {
        
        let postRef = FIRDatabase.database().reference().child("users").child(uid)
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            var userData:UserDataModel = UserDataModel()
            if let value = snapshot.value as? NSDictionary{
                
                
                userData = UserDataModel(dictionary: value)
                
           
                
            }
            
            finish(userData)
        })
        
    }
    */
    
    
    /*
    func getProductDataWith(ProductID productID:String, Finish finish:@escaping (_ product:ProductDataModel)->Void){
        
        let postRef = FIRDatabase.database().reference().child("products").child(productID)
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            var productData:ProductDataModel! = nil
            if let value = snapshot.value as? NSDictionary{
                
                
                productData = ProductDataModel(dictionary: value)
                
               
               
            }
            
            
            finish(productData)
            
            
        })
        
        
    }*/
    
    
    
    func getProductByUserId(UserId uid:String, Finish finish:@escaping (_ products:[ProductDataModel])->Void){
        
        print(uid)
        
        
        
        let postRef = FIRDatabase.database().reference().child("products")
        let query = postRef.queryOrdered(byChild: "uid").queryEqual(toValue: uid)
        
        query.observeSingleEvent(of: FIRDataEventType.value, with:{ (snapshot) in
            
            var arProduct:[ProductDataModel] = [ProductDataModel]()
            
            
            

            
            
            if let value = snapshot.value as? NSDictionary{
                
                
                
                
                for object in value.allValues{
                    
                    if let object = object as? NSDictionary{
                        
                        let newProduct:ProductDataModel = ProductDataModel(dictionary: object)
                        
                        if(self.myData.userInfo.uid == uid){
                            if let have = self.seller.products[newProduct.product_id]{
                                if(have == true){
                                    arProduct.append(newProduct)
                                }
                            }
                        
                        }else{
                            
                           
                             if((newProduct.product_status.lowercased() == "sold out") || (newProduct.isDeleted == true)){
                                
                             }else{
                                if let have = self.seller.products[newProduct.product_id]{
                                    if(have == true){
                                        arProduct.append(newProduct)
                                    }
                                }
                            }
                            
                        }
                        
                        
                        
                    }
                }
                
            }
            
            
            finish(arProduct)
            
        })
        
        
    }
    
    
    
    
    
    
    
    func pullToRefresh() {
        
        //self.connectToCollections()
        self.getUserDatainfo {
            
            self.reloadDisPlay()
            
            
        }
        
        
        self.getProductByUserId(UserId: self.seller.uid) { (products) in
            
            self.arUserProduct.removeAll()
            
            self.arUserProduct = products.sorted(by: { (obj1, obj2) -> Bool in
                return obj1.updated_at > obj2.updated_at
                
            })
            
            
            
            
            UIView.animate(withDuration: 0.25, animations: {
                if(self.arUserProduct.count <= 0){
                    self.viNoitemBG.alpha = 1
                }else{
                    self.viNoitemBG.alpha = 0
                }
            })
            
            self.myCollection.reloadData()
            
            self.endRefresh()
            self.loadOwnerData()
        }
        
        
        
        
    }
    
    func endRefresh() {
      
        
        
        if refreshControl != nil {
            self.refreshControl.endRefreshing()
        }
        
        
    }
    
    
    
    func loadOwnerData() {
        
        var allHaveData:Bool = true
        
        var setToPro:ProductDataModel! = nil
        
        for pro in self.arUserProduct{
            if((pro.owner_FirstName == "") && (pro.owner_LastName == "") && (pro.loadFinish == false)){
                allHaveData = false
                
                self.workOnProduct_UserId = pro.uid
                
                setToPro = pro
            
                
                break
            }
        }
        
        
        if((allHaveData == false) && (setToPro != nil)){
            
            getUserDataWith(UID: self.workOnProduct_UserId, Finish: { (userData) in
                
                //var arReloadIndex:[IndexPath] = [IndexPath]()
                
                for i in 0..<self.arUserProduct.count{
                    let pro = self.arUserProduct[i]
                    if(pro.uid == self.workOnProduct_UserId){
                        pro.owner_FirstName = userData.first_name
                        pro.owner_LastName = userData.last_name
                        pro.owner_Image_src = userData.profileImage_src
                        pro.loadFinish = true
                        
                        
                        let indexRe:IndexPath = IndexPath(item: i, section: 0)
                        self.myReloadCollection(cellForItemAt: indexRe)
                        
                        //arReloadIndex.append(indexRe)
                    }
                }
                
                
                /*
                if(arReloadIndex.count > 0){
                    self.myCollection.reloadItems(at: arReloadIndex)
                }
                */
                
                
                self.loadOwnerData()
                
            })
        }
        
        
    }
    
    
    
    
    func addLiketo(ProductId productId:String, Like like:Bool) {
        
        var work:Bool = false
        
        for strID in self.arWorkingProductId{
            if(strID == productId){
                work = true
            }
        }
        
        
        
        if(work == false){
            let newLike:LikeOperation = LikeOperation(userID: self.seller.uid, like: like, productID: productId) { (product) in
                
                
                var i = self.arWorkingProductId.count - 1
                while i >= 0 {
                    
                    let pid:String = self.arWorkingProductId[i]
                    if(pid == productId){
                        self.arWorkingProductId.remove(at: i)
                    }
                    i = i - 1
                }
                
                
                
                
       
                
                
                
                getProductDataWith(ProductID: product.product_id, Finish: { (product) in
                    for p in self.arUserProduct{
                        if(p.product_id == product.product_id){
                            p.likeCount = product.likeCount
                        }
                    }
                    
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        if(self.arUserProduct.count <= 0){
                            self.viNoitemBG.alpha = 1
                        }else{
                            self.viNoitemBG.alpha = 0
                        }
                    })
                    
                    self.myReloadCollection()
                    //self.myCollection.reloadData()
                })
                
                
               
                
                
                
                
            }
            
            
            self.likeQueue.addOperation(newLike)
        }
        
        
        
    }
    
    
    
    // MARK: - Action
    
    func caculateHeaderHeight()->CGFloat {
        let spaceY:CGFloat = 19 + 5 + 6 + 33 + 10 + 8 + 20 + 10 + 40
        
        

        let name = String(format: "%@  %@", self.seller.first_name, self.seller.last_name)
        
        
        
        
        var nameH:CGFloat = heightForView(text: name, Font: self.fontName, Width: self.screenSize.width - (135 + 25 + 10))
        if(nameH < 30){
            nameH = 30
        }
        
        
        let companyH:CGFloat = heightForView(text: self.seller.company_name, Font: self.fontCompanyName, Width: self.screenSize.width - (135 + 25 + 10))
        //if(companyH < 30){
        //    companyH = 30
        //}
        
        var bioH:CGFloat = heightForView(text: self.seller.bio, Font: self.fontBio, Width: self.screenSize.width - (25 + 25 + 10))
        if(bioH < 30){
            bioH = 30
        }
        
        var h = spaceY + nameH + companyH + bioH
        if(h > 250){
            h = 250
        }
        return h
    }
    
    
    @IBAction func tapOnOpenWeb(_ sender: UIButton) {
        
        
        if(self.seller.company_website.count > 5){
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
            let vc:WebPreviewVC = storyboard.instantiateViewController(withIdentifier: "WebPreviewVC") as! WebPreviewVC
            
            
            let strURL:NSString = NSString(string: self.seller.company_website)
            let ranghttp:NSRange = strURL.range(of: "http")
            let rangeintranet:NSRange = strURL.range(of: "intranet")
            
            var urlChack:String = self.seller.company_website
            
            if((ranghttp.length > 0) || (rangeintranet.length > 0)){
                
            }else{
                urlChack = String(format: "http://%@", self.seller.company_website)
            }
            
            
            vc.strURL = urlChack
            vc.strTitle = self.seller.company_name
            self.present(vc, animated: true, completion: {
                
            })
        }
        
        
        
        
        
        
    }
    
    
    @IBAction func tapOnEditProfile(_ sender: UIButton) {
        self.needUpdate = true
        
        
        self.showTapBar(show: false)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:EditProfileVC = storyboard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        
        self.navigationController?.pushViewController(vc, animated: true)
  
    }
    
    
    @IBAction func tapOnItemLinked(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.GotoLikesScene.rawValue), object: nil, userInfo: nil)
        
        
        
    }
    
    
    @IBAction func tapOnSetting(_ sender: UIButton) {
        
        
        
        self.showTapBar(show: false)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:SettingMenuVC = storyboard.instantiateViewController(withIdentifier: "SettingMenuVC") as! SettingMenuVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    
    
    
    func reloadDisPlay() {
        
  
        
     
        DispatchQueue.main.async {
            if(self.seller.uid == self.myData.userInfo.uid){
                let image:UIImage = UIImage(named: "like.png")!
                self.btLikes.setImage(image, for: UIControlState.normal)
            }else{
                let image:UIImage = UIImage(named: "iconOther.png")!
                self.btLikes.setImage(image, for: UIControlState.normal)
            }
            
            
            
            
            self.lazyImage.loadImage(imageURL: self.seller.profileImage_src, Thumbnail: false)
            
            
            self.lbName.text = String(format: "%@  %@", self.seller.first_name, self.seller.last_name)
            
            self.lbCompanyName.text = self.seller.company_name
            
            
            self.lbBIO.text = self.seller.bio
            self.lbBIO.setContentOffset(CGPoint.zero, animated: false)
            
            self.lbWeb.text = self.seller.company_website
            
            
            
            
            var positive:NSInteger = 0
            for pos in self.seller.positive_list{
                positive += pos.arUser_Uid.count
            }
            self.lbSmile.text = String(format: "%d", positive)
            
            
            var neutral:NSInteger = 0
            for neu in self.seller.neutral_list{
                neutral += neu.arUser_Uid.count
            }
            self.lbNormal.text = String(format: "%d", neutral)
            
            
            
            var negative:NSInteger = 0
            for nega in self.seller.negative_list{
                negative += nega.arUser_Uid.count
            }
            self.lbSad.text = String(format: "%d", negative)
            
            
            
            
            
            
            self.topBarHeight = self.caculateHeaderHeight()
            print("reload self.topBarHeight : \(self.topBarHeight)")
            
            
            
            
            self.myCollection.contentInset = UIEdgeInsets(top: (self.topBarHeight-40) + 8, left: 8, bottom: 40, right: 8)
            //self.myCollection.reloadData()
            
            
            if(self.myData.userInfo.uid != self.seller.uid){
                self.viUserToolBarBG.alpha = 0
                self.topBarHeight = self.topBarHeight - 40
                self.viUserToolBarBG.isUserInteractionEnabled = false
            }else{
                self.viUserToolBarBG.alpha = 1
                self.viUserToolBarBG.isUserInteractionEnabled = true
            }
            
            self.layout_topbarHeight.constant = self.topBarHeight
            if(self.seller.uid == self.myData.userInfo.uid){
                self.layout_BottomTV.constant = 82
            }else{
                self.layout_BottomTV.constant = 30
            }
            //self.refreshControl.center = CGPoint(x: self.refreshControl.center.x, y: (self.topBarHeight - 60))
            
            
            // self.reloadDisplayAfter()
            
            
            self.view.layoutIfNeeded()
            self.view.updateConstraints()
            
        }
        
        
        
        
        
        
        
        
    }
    
    
    func openReportUser() {
        //ReportUserVC
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:ReportUserVC = storyboard.instantiateViewController(withIdentifier: "ReportUserVC") as! ReportUserVC
        vc.mode = .reportsUser
        vc.reportToUserID = self.seller.uid
        
        
        self.present(vc, animated: true) {
            
        }
        
    }
    
    
    
    @IBAction func tapFavorite(_ sender: UIButton) {
        
        
        
        
        if(self.seller.uid == self.myData.userInfo.uid){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.GotoLikesScene.rawValue), object: nil, userInfo: nil)
        }else{
            self.openReportUser()
        }
        
        
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.GotoLikesScene.rawValue), object: nil, userInfo: nil)
        
        
        //self.openReportUser()
        
        
        
    }
    
    @IBAction func tapOnBack(_ sender: UIButton) {
        
        if(self.myData.bufferDetailMainVC != nil){
            self.navigationController?.popToViewController(self.myData.bufferDetailMainVC, animated: true)
            
        }else{
            if let nav = self.navigationController{
                nav.popViewController(animated: true)
            }else{
                self.dismiss(animated: true, completion: { 
                    
                })
            }
        }
    }
    
    
    
    

}

extension UserMainSceneVC:UICollectionViewDelegateFlowLayout{
    
    
    
    
    
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
        
        return CGSize(width: w, height: 230)
        
    }
    
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate


extension UserMainSceneVC:UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    
    
    func myReloadCollection() {
        for i in 0..<self.arUserProduct.count{
            
            let index:IndexPath = IndexPath(item: i, section: 0)
            self.myReloadCollection(cellForItemAt: index)
        }
    }
    
    func myReloadCollection(cellForItemAt indexPath: IndexPath){
        if let cell = self.myCollection.cellForItem(at: indexPath) as? ProductListCollectionCell{
            
            
            
            if(indexPath.item < self.arUserProduct.count){
                let product = self.arUserProduct[indexPath.item]
                
                cell.myTag = indexPath.item
                
                
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
                    
                    let ind:IndexPath = IndexPath(item: tag, section: 0)
                    
                    if(tag < self.arUserProduct.count){
                        let p:ProductDataModel = self.arUserProduct[tag]
                        
                        if(p.isUserLike == true){
                            self.addLiketo(ProductId: p.product_id, Like: false)
                            
                            self.arUserProduct[tag].isUserLike = false
                            
                            var likecount = p.likeCount - 1
                            if(likecount < 0){
                                likecount = 0
                            }
                            
                            self.arUserProduct[tag].likeCount = likecount
                            
                            let bufferCell:ProductListCollectionCell? = self.myCollection.cellForItem(at: ind) as? ProductListCollectionCell
                            if let bufferCell = bufferCell{
                                bufferCell.imageHeart.image = self.imageNoLike
                                bufferCell.lbCount.text = String(format: "%ld", likecount)
                            }
                            
                            
                        }else{
                            self.addLiketo(ProductId: p.product_id, Like: true)
                            
                            self.arUserProduct[tag].isUserLike = true
                            
                            var likecount = p.likeCount + 1
                            if(likecount < 0){
                                likecount = 0
                            }
                            
                            self.arUserProduct[tag].likeCount = likecount
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
            
            
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let itemCount = self.arUserProduct.count
        
        
       
        return itemCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        
        
        let cell:ProductListCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCollectionCell", for: indexPath) as! ProductListCollectionCell
        
  
        if(indexPath.item < self.arUserProduct.count){
            let product = self.arUserProduct[indexPath.item]
            
            cell.myTag = indexPath.item
            
            
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
                
                let ind:IndexPath = IndexPath(item: tag, section: 0)
                
                if(tag < self.arUserProduct.count){
                    let p:ProductDataModel = self.arUserProduct[tag]
                    
                    if(p.isUserLike == true){
                        self.addLiketo(ProductId: p.product_id, Like: false)
                        
                        self.arUserProduct[tag].isUserLike = false
                        
                        var likecount = p.likeCount - 1
                        if(likecount < 0){
                            likecount = 0
                        }
                        
                        self.arUserProduct[tag].likeCount = likecount
                        
                        let bufferCell:ProductListCollectionCell? = self.myCollection.cellForItem(at: ind) as? ProductListCollectionCell
                        if let bufferCell = bufferCell{
                            bufferCell.imageHeart.image = self.imageNoLike
                            bufferCell.lbCount.text = String(format: "%ld", likecount)
                        }
                        
                        
                    }else{
                        self.addLiketo(ProductId: p.product_id, Like: true)
                        
                        self.arUserProduct[tag].isUserLike = true
                        
                        var likecount = p.likeCount + 1
                        if(likecount < 0){
                            likecount = 0
                        }
                        
                        self.arUserProduct[tag].likeCount = likecount
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if(indexPath.item < self.arUserProduct.count){
            let product = self.arUserProduct[indexPath.item]
            
            //ProductDetailVC
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
            let vc:ProductDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            
            vc.sellerData = self.seller
            vc.myProductData = product
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
        
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print(screenSize.height)
        
        if((screenSize.height <= 600) && (scrollView.contentSize.height > (screenSize.height - 240))){
            let delta = (self.topBarHeight - 40) + 8 + scrollView.contentOffset.y
            
            var min:CGFloat = self.topBarHeight - 40
            
            if(self.seller.uid != self.myData.userInfo.uid){
                min = self.topBarHeight
            }
            
            if(delta < 0){
                
                self.layout_TopbarTop.constant = 0
            }else if((delta >= 0) && (delta <= min)){
                
                self.layout_TopbarTop.constant = (delta * -1)
                
            }else if(delta > min){
                self.layout_TopbarTop.constant = (min * -1)
            }
            
            self.view.layoutIfNeeded()
            self.view.updateConstraints()
        }
        
        
        
        
        //print(delta)
        
        
    }
}



