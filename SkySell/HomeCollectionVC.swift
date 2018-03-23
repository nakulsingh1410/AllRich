//
//  HomeCollectionVC.swift
//  SkySell
//
//  Created by supapon pucknavin on 4/16/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift


class HomeCollectionVC: UIViewController {

    var screenSize:CGRect = UIScreen.main.bounds
    
    
    @IBOutlet weak var myCollection: UICollectionView!
    var refreshControl:UIRefreshControl! = nil
    
    
 
    
    
    
    var myActivityView:ActivityLoadingView! = nil
    
    var working:Bool = false
    
    
    var myData:ShareData = ShareData.sharedInstance
    
    
    
    //var arCategoriesDataModel:[CategoriesDataModel] = [CategoriesDataModel]()
    //var arPKLazyImageHelpObject:[PKLazyImageHelpObject] = [PKLazyImageHelpObject]()
    
    
    let cellFont:UIFont = UIFont(name: "Avenir-Medium", size: 16)!
    
    let likeQueue = OperationQueue()
    
    
    var haveNoti:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        
        
        
        
        let nib1:UINib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.myCollection.register(nib1, forCellWithReuseIdentifier: "CollectionViewCell")
        
        
        
        self.myCollection.delegate = self
        self.myCollection.dataSource = self
        
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: (3.0/255.0), green: (210.0/255.0), blue: (99.0/255.0), alpha: 1.0)
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        myCollection.addSubview(refreshControl)
        myCollection.alwaysBounceVertical = true
        
        
        
        
        myActivityView = ActivityLoadingView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - 112))
        self.view.addSubview(myActivityView)
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        var object:[String:Bool] = [String:Bool]()
        object["show"] = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVCSetShowBackButton.rawValue), object: nil, userInfo: object)
        
        
        
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
 
        
        
        if((self.myData.arCategoriesDataModel.count <= 0) || (self.myData.needUpdateCategory == true)){
            
            self.myData.needUpdateCategory = false
            
            
            if(self.working == false){
                self.working = true
                
                if(self.myActivityView == nil){
                    myActivityView = ActivityLoadingView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - 112))
                    myActivityView.alpha = 0
                    self.view.addSubview(myActivityView)
                    
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.myActivityView.alpha = 1
                    }, completion: { (finish) in
                        
                        let loadUID = self.myData.loadsaveUserInfo_UID()
                        if(loadUID.count < 5){
                            self.connectToCollections()
                        }else{
                            loadProductLikeByUser(uid: self.myData.userInfo.uid, Finish: { (arLike) in
                                
                                self.myData.userLike = arLike
                                self.getUserDatainfo()
                                
                            })
                        }
                        
                        
                    })
                }else{
                    let loadUID = self.myData.loadsaveUserInfo_UID()
                    if(loadUID.count < 5){
                        self.connectToCollections()
                    }else{
                        
                        let loadSaveUID:String = self.myData.loadsaveUserInfo_UID()
                        loadProductLikeByUser(uid: loadSaveUID, Finish: { (arLike) in
                            
                            self.myData.userLike = arLike
                            self.getUserDatainfo()
                            
                        })
                    }
                }
            }
            
            
            
        }else{
            //self.myCollection.reloadSections([0])
            self.removeActivityView()
        }
        
        
        if(self.haveNoti == false){
            self.haveNoti = true
            NotificationCenter.default.addObserver(self, selector: #selector(HomeCollectionVC.gotoSearchAll(notification:)), name:NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVCGotoSearchModeAll.rawValue), object: nil)
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        if(self.haveNoti == true){
            self.haveNoti = false
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVCGotoSearchModeAll.rawValue), object: nil)
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
    func gotoSearchAll(notification:NSNotification){
        
        print("gotoSearchAll")
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:SearchVC = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        //vc.category = cat
        
        self.navigationController?.pushViewController(vc, animated: true)
        

        
        
        
    }
    
    
    func pullToRefresh() {
        
        if(self.myData.userInfo != nil){
            loadProductLikeByUser(uid: self.myData.userInfo.uid) { (arLike) in
                self.myData.userLike = arLike
                self.connectToCollections()
            }
        }else{
            self.connectToCollections()
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
    
    func connectToCollections() {
        let postRef = FIRDatabase.database().reference().child("categories")
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //self.arCategoriesDataModel.removeAll()
            self.myData.arCategoriesDataModel.removeAll()
            
            
            var arBufferCat:[CategoriesDataModel] = [CategoriesDataModel]()
            
            //print(snapshot.value)
            
            
            
            
            if let snapshot = snapshot.value as? NSDictionary{
                
                
                let realm = try! Realm()
                try! realm.write {
                    
                    for obj in snapshot.allValues{
                        if let obj = obj as? NSDictionary{
                            let newCat:RealmCategoriesDataModel = RealmCategoriesDataModel()
                            newCat.readJson(obj: obj)
                            
                            realm.add(newCat, update: true)
                            
                        }
                    }
                    
                    
                }
                
                
                
                
                
                
                for obj in snapshot.allValues{
                    if let obj = obj as? NSDictionary{
                        
                        let newCat:CategoriesDataModel = CategoriesDataModel(dictionary: obj)
                        arBufferCat.append(newCat)
                        
           
                        //----
                        
                        
                    }
                }
            }
            
            
            
            
            let arSort = arBufferCat.sorted(by: { (obj1, obj2) -> Bool in
                let value1 = obj1.category_name
                let value2 = obj2.category_name
                
                return value1 < value2
            })
            
            
            for newCat in arSort{
                //self.arCategoriesDataModel.append(newCat)
                
                self.myData.arCategoriesDataModel.append(newCat)
            }
            
            
            
            
            self.myCollection.reloadSections([0])
            self.removeActivityView()
            self.working = false
           
            
            
        }) { (error) in
            self.cannotConnetToServer()
        }
        
    }
    
    
    
    func getUserDatainfo() {
        
        let loadSaveUID:String = self.myData.loadsaveUserInfo_UID()
        
        if(loadSaveUID.count > 5){
            let postRef = FIRDatabase.database().reference().child("users").child(loadSaveUID)
            
            postRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let value = snapshot.value as? NSDictionary{
                    
                    
                    self.myData.userInfo = UserDataModel(dictionary: value)
                    
                    //self.myData.saveUserInfo(UID: self.myData.userInfo.uid)
                    
                    //print(self.myData.userInfo.first_name)
                   
                    
                }
                
                
                //------------
                if(self.myData.userInfo != nil){
                    loadProductLikeByUser(uid: self.myData.userInfo.uid) { (arLike) in
                        self.myData.userLike = arLike
                        self.connectToCollections()
                    }
                }else{
                    self.connectToCollections()
                }
                //------------
            })
        }else{
            //------------
            if(self.myData.userInfo != nil){
                loadProductLikeByUser(uid: self.myData.userInfo.uid) { (arLike) in
                    self.myData.userLike = arLike
                    self.connectToCollections()
                }
            }else{
                self.connectToCollections()
            }
            //------------
        }
        
        
        
        
        
    }
    
    
    
    
    
    func tapOnFollowAtTag(tag:NSInteger) {
        
        
        if(self.myData.userInfo != nil){
            let cat = self.myData.arCategoriesDataModel[tag]
            
            var isFollow:Bool = false
            for uid in cat.favorites{
                if(uid == self.myData.userInfo.uid){
                    isFollow = true
                    break
                }
            }
            
            if(isFollow == true){
                
                var count = cat.favorites.count - 1
                
                while (count >= 0) {
                    let u = cat.favorites[count]
                    if(u == self.myData.userInfo.uid){
                        cat.favorites.remove(at: count)
                    }
                    
                    count -= 1
                }
                
                
                
                self.postFollowToServerAtTag(tag: tag, Follow: false)
            }else{
                cat.favorites.append(self.myData.userInfo.uid)
                
                self.postFollowToServerAtTag(tag: tag, Follow: true)
            }
            
            
            
            let index = IndexPath(item: tag, section: 0)
            self.myCollection.reloadItems(at: [index])
        }
        
        
        
        
        
        
    }
    
    
    func postFollowToServerAtTag(tag:NSInteger,Follow isFollow:Bool) {
        let cat = self.myData.arCategoriesDataModel[tag]
        
        let newFollow:CategoriesFavoriteOperation = CategoriesFavoriteOperation(CategoriesId: cat.category_id, Like: isFollow, UserId: self.myData.userInfo.uid) { (catId, like) in
            
            
            
            
        }
        
        
        
        self.likeQueue.addOperation(newFollow)
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


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate


extension HomeCollectionVC:UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func myReloadCollection() {
        
        for i in 0..<self.myData.arCategoriesDataModel.count{
            let indexPath: IndexPath = IndexPath(item: i, section: 0)
            self.myReloadCollection(cellForItemAt: indexPath)
            
        }
        
    }
    
    
    
    
    
    func myReloadCollection(cellForItemAt indexPath: IndexPath){
        
        if let cell = self.myCollection.cellForItem(at: indexPath) as? CollectionViewCell{
            
            let cat = self.myData.arCategoriesDataModel[indexPath.item]
            
    
            let h:CGFloat = 50
            
            
            let size = self.myCollection.layoutAttributesForItem(at: indexPath)?.size
            if let size = size{
                cell.lazyImage.updateImageSize(size: size)

            }
            
            if(cat.category_img_src.count < 4){
                cell.lazyImage.imageView.image = nil
                cell.lazyImage.strURL = ""
                cell.lazyImage.stopTimer()
            }else{

                cell.lazyImage.loadImage(imageURL: cat.category_img_src, Thumbnail: true)
                cell.lazyImage.imageView.alpha = 1
            }

            cell.lbTitle.text = cat.category_name
            
            var isFollow:Bool = false
            
            if(self.myData.userInfo != nil){
                for uid in cat.favorites{
                    if(uid == self.myData.userInfo.uid){
                        isFollow = true
                        break
                    }
                }
            }
            
            
            cell.setIsFollow(follow: isFollow)
            
            cell.myTag = indexPath.item
            cell.callBackTapOnFollow = {(myTag) in
                
                
                self.tapOnFollowAtTag(tag: myTag)
                
            }

            cell.layout_TextHeight.constant = h
            cell.layoutIfNeeded()
            cell.updateConstraints()
            
            
            
        }
    }
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myData.arCategoriesDataModel.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        
        
        let cat = self.myData.arCategoriesDataModel[indexPath.item]
        
        
        //cell.lazyImage.setupDefaultImage(DefaultImage: self.imageDefault, DefaultImageContent: UIViewContentMode.center)
        //cell.lazyImage.setupDefaultImage(DefaultImage: nil, DefaultImageContent: UIViewContentMode.center)
        // cell.updateFrameSize(size: self.customLayout.itemSize)
        let h:CGFloat = 50
        
        
        let size = self.myCollection.layoutAttributesForItem(at: indexPath)?.size
        if let size = size{
            cell.lazyImage.updateImageSize(size: size)
            //print(size)
            
            
            //h = heightForView(text: cat.category_name, Font: cellFont, Width: size.width - 15) + 5
            
            
        }
        /*
        if(h < 40){
            h = 40
        }
        */
        
        
        
       
    
        if(cat.category_img_src.count < 4){
            cell.lazyImage.imageView.image = nil
            cell.lazyImage.strURL = ""
            cell.lazyImage.stopTimer()
        }else{
            //cell.lazyImage.loadImageWithGetURL(strURL: cat.category_img_src, ImageContent: UIViewContentMode.scaleAspectFill)
            
            cell.lazyImage.loadImage(imageURL: cat.category_img_src, Thumbnail: true)
            //cell.lazyImage.imageView.alpha = 1
        }
        //cell.lazyImage.slide(to: .right)
            
       
        cell.lbTitle.text = cat.category_name
        
        var isFollow:Bool = false
        
        if(self.myData.userInfo != nil){
            for uid in cat.favorites{
                if(uid == self.myData.userInfo.uid){
                    isFollow = true
                    break
                }
            }
        }
        
        
        cell.setIsFollow(follow: isFollow)
        
        cell.myTag = indexPath.item
        cell.callBackTapOnFollow = {(myTag) in
        
            
            self.tapOnFollowAtTag(tag: myTag)
        
        }
        
        
        
        cell.layout_TextHeight.constant = h
        cell.layoutIfNeeded()
        cell.updateConstraints()
        
        //cell.lazyImage.slide(to: .right)
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cat = self.myData.arCategoriesDataModel[indexPath.row]
        
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:ProductsViewCenterVC = storyboard.instantiateViewController(withIdentifier: "ProductsViewCenterVC") as! ProductsViewCenterVC
        vc.category = cat
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        
        //---------------
        var object:[String:Bool] = [String:Bool]()
        object["show"] = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVCSetShowBackButton.rawValue), object: nil, userInfo: object)
        //---------------
        
        
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
