//
//  ViewController.swift
//  SkySell
//
//  Created by DW02 on 4/12/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import Photos
import PhotosUI

class ViewController: UIViewController {

    var myHomeContainer:HomeContainerVC? = nil
    
    @IBOutlet weak var viMenuBarBG: UIView!
   // @IBOutlet weak var viCameraBG: UIView!
    @IBOutlet weak var btHome: UIButton!
    @IBOutlet weak var btGroup: UIButton!
    @IBOutlet weak var btMessage: UIButton!
    @IBOutlet weak var viMessageBadge: UIView!
    @IBOutlet weak var lbMessagaBadge: UILabel!
    @IBOutlet weak var layout_BadgeWidth: NSLayoutConstraint!
    @IBOutlet weak var btProfile: UIButton!
    @IBOutlet weak var btCamera: UIButton!
    @IBOutlet weak var viMenuBarBG_Layout_Buttom: NSLayoutConstraint!
    @IBOutlet weak var btFriendRequest: UIButton!

   // @IBOutlet weak var btCamera_Layout_Buttom: NSLayoutConstraint!
    var screenSize:CGRect = UIScreen.main.bounds
    var myActivityView:ActivityLoadingView! = nil
    var haveNoti:Bool = false
    var isMemberPremium : Bool?
    var lastMode:HomeContainerVC.SegName = HomeContainerVC.SegName.toHome
    var thisUserForCheckInProductDetail:HomeContainerVC.SegName = HomeContainerVC.SegName.toHome
    
    let myData:ShareData = ShareData.sharedInstance
    
    var arImageBuffer:[PostImageObject] = [PostImageObject]()
    
    

    let mySetting:SettingData = SettingData.sharedInstance
    
    var workOnProduct_UserId:String = ""
    var arProduct:[RealmProductDataModel] = [RealmProductDataModel]()
    var haveConnectChatNoti:Bool = false
    var arRoomC:[RoomMessagesDataModel] = [RoomMessagesDataModel]()
    var arRoomR:[RoomMessagesDataModel] = [RoomMessagesDataModel]()
    var messageCount_Create:NSInteger = 0
    var messageCount_Recive:NSInteger = 0
    
    let badgeFont:UIFont = UIFont(name: "Avenir-Medium", size: 11)!
    
    @IBOutlet weak var viMask: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.myData.masterView = self
        //        self.viCameraBG.clipsToBounds = false
        //        self.btCamera.layer.cornerRadius = 17.0
        //        self.btCamera.clipsToBounds = true
        //        self.view.bringSubview(toFront: self.viCameraBG)
        //        self.view.bringSubview(toFront: self.viMask)
        //        self.viCameraBG.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        //        self.viCameraBG.layer.shadowRadius = 6
        //        self.viCameraBG.layer.shadowOffset = CGSize(width: 0, height: 6)
        //        self.viCameraBG.layer.shadowOpacity = 0.5
        //        self.viCameraBG.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        self.viMessageBadge.clipsToBounds = true
        self.viMessageBadge.layer.cornerRadius = 11
        self.viMessageBadge.isUserInteractionEnabled = false
        self.viMessageBadge.alpha = 0
        
        if(self.haveNoti == false){
            self.haveNoti = true
            NotificationCenter.default.addObserver(self, selector: #selector(ViewController.showTapMenubar(notification:)), name:NSNotification.Name(rawValue: SkySell_Notification_Name.HidenMainTapBar.rawValue), object: nil)
        
            NotificationCenter.default.addObserver(self, selector: #selector(ViewController.gotoLastMode(notification:)), name:NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVCGotoLastMode.rawValue), object: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(ViewController.gotoLikesScene(notification:)), name:NSNotification.Name(rawValue: SkySell_Notification_Name.GotoLikesScene.rawValue), object: nil)
        }
        /*
         if(self.myActivityView == nil){
         myActivityView = ActivityLoadingView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
         myActivityView.alpha = 1
         self.view.addSubview(myActivityView)
         }*/
        self.view.bringSubview(toFront: self.viMask)
        
    }

    deinit {
        if(self.haveNoti == true){
            self.haveNoti = false
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SkySell_Notification_Name.HidenMainTapBar.rawValue), object: nil)
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVCGotoLastMode.rawValue), object: nil)
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SkySell_Notification_Name.GotoLikesScene.rawValue), object: nil)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if(self.myData.userInfo == nil){
            let uid = self.myData.loadsaveUserInfo_UID()
            if((FIRAuth.auth()?.currentUser == nil) || (uid.count < 2)){
                //LoginVC
                if let con = self.myHomeContainer{
                    //con.swapToview(identifier: HomeContainerVC.SegName.toProfile)
                    con.swapToview(identifier: HomeContainerVC.SegName.segToNavigationProfileVC)
                    self.thisUserForCheckInProductDetail = HomeContainerVC.SegName.toProfile
                    // self.lastMode = HomeContainerVC.SegName.segToNavigationProfileVC.rawValue
                }
            }else{
                loadProductLikeByUser(uid: uid, Finish: { (arLike) in
                    self.myData.userLike = arLike
                    getUserDataWith(UID: uid, Finish: { (user) in
                        self.myData.showUserSceneFirstTime = false
                        self.myData.userInfo = user
                        if(self.myData.userInfo.status.lowercased() == "ban"){
                            self.myData.userInfo = nil
                            self.myData.saveUserInfo(UID: "")
                            self.removeActivityView {
                                let alertController = UIAlertController(title: "Account Banned", message: "Your user account has been banned from Allrich.\nPlease contact administrator for infomation.", preferredStyle: .alert)
                                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                                    //LoginVC
                                    if let con = self.myHomeContainer{
                                        //con.swapToview(identifier: HomeContainerVC.SegName.toProfile)
                                        con.swapToview(identifier: HomeContainerVC.SegName.segToNavigationProfileVC)
                                        self.thisUserForCheckInProductDetail = HomeContainerVC.SegName.toProfile
                                        // self.lastMode = HomeContainerVC.SegName.segToNavigationProfileVC.rawValue
                                    }
                                }
                                alertController.addAction(cancelAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }else{
                            self.removeActivityView {
                                self.afterLogin()
                            }
                        }
                    })
                })
            }
        }else{
            
            self.removeActivityView {
                self.afterLogin()
            }
        }
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
         appDelegate.getUserPoints()
        checkUserPremium(isDollerButtonTapped: false, isCameraTapped: false)
    }

    func afterLogin() {
        if(FIRAuth.auth()?.currentUser != nil){
            if(self.myData.bufferAllPlans.count <= 0){
                getAllPlans(Finish: { (plans, secret) in
                    self.myData.bufferAllPlans = plans
                    self.myData.buuferItuneSecret = secret
                    StoreManager.shared.setup()
                })
            }
            if(self.myData.productDownloading == .noData){
                self.myData.productDownloading = .loading
                self.myData.loadAllProduct({
                    self.myData.productDownloading = .finish
                    self.testReadData()
                })
            }
            if(self.mySetting.haveConnect == false){
                self.mySetting.startConnect()
            }
            self.reloadallMessage()
        }else{
            if let con = self.myHomeContainer{
                //con.swapToview(identifier: HomeContainerVC.SegName.toProfile)
                con.swapToview(identifier: HomeContainerVC.SegName.segToNavigationProfileVC)
                self.thisUserForCheckInProductDetail = HomeContainerVC.SegName.toProfile
                // self.lastMode = HomeContainerVC.SegName.segToNavigationProfileVC.rawValue
            }
        }
        if(self.myData.autoCheckUerPlanNeedManage()){
            //need manage Plan
            ShareData.sharedInstance.showDeletePlanScene()
        }
        self.connectChatRoomNoti()
    }

    func connectChatRoomNoti(){
        if(self.myData.userInfo != nil){
            FIRMessaging.messaging().subscribe(toTopic: self.myData.userInfo.uid)
        }
        if(self.haveConnectChatNoti == false){
            if(self.myData.userInfo != nil){
                self.haveConnectChatNoti = true
                if(self.myData.userInfo.uid.count > 5){
                let postRef = FIRDatabase.database().reference().child("users").child(self.myData.userInfo.uid).child("message_timeStamp")
                postRef.observe(.value, with: { (snapshot) in
                        print(snapshot)
                        //have new message
                        self.reloadallMessage()
                    }, withCancel: { (error) in
                        self.haveConnectChatNoti = false
                    })
                }
            }
        }
    }
    func reloadallMessage() {
        if(self.myData.userInfo != nil){
            self.messageCount_Create = 0
            self.messageCount_Recive = 0
            let postRef = FIRDatabase.database().reference().child("room-messages")
            let query:FIRDatabaseQuery! = postRef.queryOrdered(byChild: "createdByUserId").queryEqual(toValue: self.myData.userInfo.uid)
            query.observeSingleEvent(of: FIRDataEventType.value, with:{ (snapshot) in
                var arRoomM:[RoomMessagesDataModel] = [RoomMessagesDataModel]()
                if let value = snapshot.value as? NSDictionary{
                    for object in value.allValues{
                        if let object = object as? NSDictionary{
                            let newRoom:RoomMessagesDataModel = RoomMessagesDataModel(dictionary: object)
                            var add:Bool = true
                            if(newRoom.isDeleteUser.count > 0){
                                for duser in newRoom.isDeleteUser{
                                    if(duser == self.myData.userInfo.uid){
                                        add = false
                                        break
                                    }
                                }
                            }
                            if(add == true){
                                arRoomM.append(newRoom)
                            }
                        }
                    }
                }
                self.arRoomC = arRoomM.sorted(by: { (obj1, obj2) -> Bool in
                    return obj1.updatedAt_Date < obj2.updatedAt_Date
                })
                self.messageCount_Create = 0
                for r in self.arRoomC{
                    if let ur = r.unreadCount[self.myData.userInfo.uid]{
                        self.messageCount_Create += ur
                    }
                }
                //--------------
                self.updateNotiBad()
                //--------------
            })
 
            /////////
            let query2:FIRDatabaseQuery! = postRef.queryOrdered(byChild: "receivedByUserId").queryEqual(toValue: self.myData.userInfo.uid)
            query2.observeSingleEvent(of: FIRDataEventType.value, with:{ (snapshot) in
                var arRoomM:[RoomMessagesDataModel] = [RoomMessagesDataModel]()
                if let value = snapshot.value as? NSDictionary{
                    for object in value.allValues{
                        if let object = object as? NSDictionary{
                            let newRoom:RoomMessagesDataModel = RoomMessagesDataModel(dictionary: object)
                            var add:Bool = true
                            if(newRoom.isDeleteUser.count > 0){
                                /*
                                for duser in newRoom.isDeleteUser{
                                    if(duser == self.myData.userInfo.uid){
                                        add = false
                                        break
                                    }
                                }*/
                                 add = false
                            }
                            if(add == true){
                                arRoomM.append(newRoom)
                            }
                        }
                    }
                }
                self.arRoomR = arRoomM.sorted(by: { (obj1, obj2) -> Bool in
                    return obj1.updatedAt_Date < obj2.updatedAt_Date
                })
                
                self.messageCount_Recive = 0
                for r in self.arRoomR{
                    if let ur = r.unreadCount[self.myData.userInfo.uid]{
                        self.messageCount_Recive += ur
                    }
                }
                //--------------
                self.updateNotiBad()
                //--------------
            })
        }else{
            self.haveConnectChatNoti = false
        }
    }

    func updateNotiBad(){
        let notRead:NSInteger = self.messageCount_Recive + self.messageCount_Create
        var str:String = String(format: "%d", notRead)
        if(notRead >= 100){
            str = "99+"
        }
        self.lbMessagaBadge.text = str
        var nW:CGFloat = widthForView(text: str, Font: self.badgeFont, Height: 22) + 4
        if(nW < 22){
            nW = 22
        }
        self.layout_BadgeWidth.constant = nW
        UIView.animate(withDuration: 0.2) { 
            self.view.layoutIfNeeded()
            self.view.updateConstraints()
            if(notRead > 0){
                self.viMessageBadge.alpha = 1
            }else{
                self.viMessageBadge.alpha = 0
            }
        }
        print("Unread : \(notRead)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SkySell_Notification_NameReloadChat"), object: nil, userInfo: nil)
    }

    func testReadData() {
        // Multi-threading
        DispatchQueue.main.async {
            let otherRealm = try! Realm()
            let otherResults = otherRealm.objects(RealmProductDataModel.self)
            for pro in otherResults{
                self.arProduct.append(pro)
            }
            self.loadOwnerData()
            print("Number of product \(otherResults.count)")
        }
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
        print(self.workOnProduct_UserId)
        if((allHaveData == false) && (setToPro != nil)){
            getUserDataWith(UID: self.workOnProduct_UserId, Finish: { (userData) in
                let realm = try! Realm()
                
                try! realm.write {
                    for pro in self.arProduct{
                        if(pro.uid == self.workOnProduct_UserId){
                            pro.owner_FirstName = userData.first_name
                            pro.owner_LastName = userData.last_name
                            pro.loadFinish = true
                            if((userData.first_name == "") && (userData.last_name == "")){
                                pro.owner_FirstName = "-"
                            }
                            pro.owner_Image_src = userData.profileImage_src
                        }
                    }
                }
                //self.myCollection.reloadData()
                self.loadOwnerData()
            })
        }else{
            self.arProduct.removeAll()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - notitfication
    func showTapMenubar(notification:NSNotification){
        
        self.view.bringSubview(toFront: self.viMask)
        if let show = notification.userInfo?["show"] as? Bool {
            
            print(show)
            
            if(show == true){
               /// self.btCamera_Layout_Buttom.constant = 16
                self.viMenuBarBG_Layout_Buttom.constant = 0
                
                self.viMenuBarBG.isUserInteractionEnabled = true
                
               // self.viCameraBG.isUserInteractionEnabled = true
                
                
            }else{
               // self.btCamera_Layout_Buttom.constant = -65
                self.viMenuBarBG_Layout_Buttom.constant = -45
                
                self.viMenuBarBG.isUserInteractionEnabled = false
                
               // self.viCameraBG.isUserInteractionEnabled = false
                
            }
            
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.view.updateConstraints()
                
                if(show == true){
                    self.viMenuBarBG.alpha = 1
                  //  self.viCameraBG.alpha = 1
                    
                    self.viMenuBarBG.isUserInteractionEnabled = true
                   // self.viCameraBG.isUserInteractionEnabled = true
                }else{
                    self.viMenuBarBG.alpha = 0
                    //self.viCameraBG.alpha = 0
                    
                    self.viMenuBarBG.isUserInteractionEnabled = false
                    //self.viCameraBG.isUserInteractionEnabled = false
                }
                
                
            })
            
        }
        
    }
    
    
    func gotoLastMode(notification:NSNotification){
        if let con = self.myHomeContainer{
            con.swapToview(identifier: self.lastMode)
        }
    }
    
    func gotoLikesScene(notification:NSNotification){
        if(self.myData.userInfo != nil){
            self.openMyLikesView()
        }else{
            if let con = self.myHomeContainer{
                //con.swapToview(identifier: HomeContainerVC.SegName.toProfile)
                con.swapToview(identifier: HomeContainerVC.SegName.segToNavigationProfileVC)
                self.thisUserForCheckInProductDetail = HomeContainerVC.SegName.toProfile
                // self.lastMode = HomeContainerVC.SegName.segToNavigationProfileVC.rawValue
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segToHomeContainerVC" {
            
            self.myHomeContainer = segue.destination as? HomeContainerVC
            
            if let con = self.myHomeContainer{
                con.myMaster = self
                con.delegete = self
            }
            
            
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
    
    
    func gotoHomeScene(){
        if let con = self.myHomeContainer{
            con.swapToview(identifier: HomeContainerVC.SegName.toHome)
            
            self.lastMode = HomeContainerVC.SegName.toHome
            self.thisUserForCheckInProductDetail = HomeContainerVC.SegName.toHome
        }
    }
    // MARK: - Action
    @IBAction func btnUpgradePlanTapped(_ sender: Any) {
        
        if let isPremium = isMemberPremium {
            if isPremium == true {
                showActionSheetForPremiumMember()
            }else{
                 showActionSheetForFreeMember()
            }
        }else{
            checkUserPremium(isDollerButtonTapped: true, isCameraTapped: false)
        }
    }
    
    @IBAction func btnFriendRequestTapped(_ sender: Any) {
        
        if(self.myData.userInfo != nil){
            if let con = self.myHomeContainer{
                con.swapToview(identifier: HomeContainerVC.SegName.toFriendRequest)
                
                self.lastMode = HomeContainerVC.SegName.toFriendRequest
                self.thisUserForCheckInProductDetail = HomeContainerVC.SegName.toFriendRequest
            }
        }else{
            if let con = self.myHomeContainer{
                //con.swapToview(identifier: HomeContainerVC.SegName.toProfile)
                con.swapToview(identifier: HomeContainerVC.SegName.segToNavigationProfileVC)
                self.thisUserForCheckInProductDetail = HomeContainerVC.SegName.toProfile
                // self.lastMode = HomeContainerVC.SegName.segToNavigationProfileVC.rawValue
            }
        }
    }
    
    
    @IBAction func tapOnHome(_ sender: UIButton) {
     if let con = self.myHomeContainer{
            con.swapToview(identifier: HomeContainerVC.SegName.toHome)
            
            self.lastMode = HomeContainerVC.SegName.toHome
            self.thisUserForCheckInProductDetail = HomeContainerVC.SegName.toHome
        }
    }
    
    @IBAction func tapOnGroup(_ sender: UIButton) {
        if(self.myData.userInfo != nil){
            if let con = self.myHomeContainer{
                con.swapToview(identifier: HomeContainerVC.SegName.toGroup)
                
                self.lastMode = HomeContainerVC.SegName.toGroup
                self.thisUserForCheckInProductDetail = HomeContainerVC.SegName.toGroup
            }
        }else{
            if let con = self.myHomeContainer{
                //con.swapToview(identifier: HomeContainerVC.SegName.toProfile)
                con.swapToview(identifier: HomeContainerVC.SegName.segToNavigationProfileVC)
                self.thisUserForCheckInProductDetail = HomeContainerVC.SegName.toProfile
                // self.lastMode = HomeContainerVC.SegName.segToNavigationProfileVC.rawValue
            }
        }
    }
    
    @IBAction func tapOnMessage(_ sender: UIButton) {
        if(self.myData.userInfo != nil){
          if let con = self.myHomeContainer{
                con.swapToview(identifier: HomeContainerVC.SegName.toMessage)
                self.lastMode = HomeContainerVC.SegName.toMessage
                self.thisUserForCheckInProductDetail = HomeContainerVC.SegName.toMessage
            }
        }else{
            if let con = self.myHomeContainer{
                //con.swapToview(identifier: HomeContainerVC.SegName.toProfile)
                con.swapToview(identifier: HomeContainerVC.SegName.segToNavigationProfileVC)
                self.thisUserForCheckInProductDetail = HomeContainerVC.SegName.toProfile
                // self.lastMode = HomeContainerVC.SegName.segToNavigationProfileVC.rawValue
            }
        }
    }
    
    @IBAction func tapOnProfile(_ sender: UIButton) {
        if let con = self.myHomeContainer{
            //con.swapToview(identifier: HomeContainerVC.SegName.toProfile)
            con.swapToview(identifier: HomeContainerVC.SegName.segToNavigationProfileVC)
            self.thisUserForCheckInProductDetail = HomeContainerVC.SegName.toProfile
            // self.lastMode = HomeContainerVC.SegName.segToNavigationProfileVC.rawValue
        }
    }
    
    @IBAction func tapOnCamera(_ sender: UIButton) {
        if let isPremium = isMemberPremium {
            if isPremium == true {
                openCamera()
            }else{
               showActionSheetForFreeMember()
            }
        }else{
            checkUserPremium(isDollerButtonTapped: false, isCameraTapped:true)
            
        }
    }
    
    
   private func openCamera(){
        
        if(self.myData.userInfo == nil){
            if let con = self.myHomeContainer{
                con.swapToview(identifier: HomeContainerVC.SegName.segToNavigationProfileVC)
            }
        }else{
            if(self.myData.userInfo.uid.count < 4){
                if let con = self.myHomeContainer{
                    con.swapToview(identifier: HomeContainerVC.SegName.segToNavigationProfileVC)
                }
            }else{
                //-------------------------
                let userPost:NSInteger = self.myData.userInfo.products.count + 1
                let canpost:NSInteger = self.myData.getListtingsUserCanPost()
                
                var need:Bool = false
                if(userPost > canpost){
                    need = true
                }
                if((self.myData.autoCheckUerPlanNeedManage()) || (need == true)){
                    //need manage Plan
                    ShareData.sharedInstance.showDeletePlanScene()
                }else{
                    self.openImagePicker()
                }
                //-------------------------
            }
        }
    }

    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
        //handle authorized status
            break
        case .denied, .restricted :
        //handle denied status
            break
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                // as above
                    break
                case .denied, .restricted:
                // as above
                    break
                case .notDetermined:
                    // won't happen but still
                    break
                }
            }
        }
    }

    func openImagePicker() {
        let album:MultiSelectImageVC = MultiSelectImageVC(nibName: "MultiSelectImageVC", bundle: nil)
        album.singleImage = false
        album.limit = 4
        album.callBack = {(images) in
            self.arImageBuffer.removeAll()
            for pickedImage in images{
                let newImage:PostImageObject = PostImageObject()
                newImage.local_image = pickedImage
                self.arImageBuffer.append(newImage)
            }
        }
        album.callBackExit = { _ in
            let seconds = 0.450
            let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
                let vc:PostSellVC = storyboard.instantiateViewController(withIdentifier: "PostSellVC") as! PostSellVC
                vc.arImage = self.arImageBuffer
                let nav1 = UINavigationController()
                nav1.viewControllers = [vc]
                vc.navigationController?.isNavigationBarHidden = true
                self.present(nav1, animated: true) {
                    
                }
            }
            
        }
        let navigation:UINavigationController = UINavigationController(rootViewController: album)
        self.present(navigation, animated: true) {
            
        }
    }

    func openMyLikesView(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:MyLikesVC = storyboard.instantiateViewController(withIdentifier: "MyLikesVC") as! MyLikesVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension ViewController:HomeContainerDelegate{
    func beginTransition(FromView from: HomeContainerVC.SegName, ToView to: HomeContainerVC.SegName) {
        switch to {
        case .toHome:
            self.btHome.setImage(UIImage(named: "iconHomeActive.png"), for: UIControlState.normal)
            self.btGroup.setImage(UIImage(named: "iconGroupNonactive.png"), for: UIControlState.normal)
            self.btMessage.setImage(UIImage(named: "iconChat.png"), for: UIControlState.normal)
            self.btProfile.setImage(UIImage(named: "iconProfileNonactive.png"), for: UIControlState.normal)
            self.btFriendRequest.setImage(UIImage(named: "icon_friend"), for: UIControlState.normal)

            break
        case .toGroup:
            
            self.btHome.setImage(UIImage(named: "iconHomeNonactive.png"), for: UIControlState.normal)
            self.btGroup.setImage(UIImage(named: "iconGroupActive.png"), for: UIControlState.normal)
            self.btMessage.setImage(UIImage(named: "iconChat.png"), for: UIControlState.normal)
            self.btProfile.setImage(UIImage(named: "iconProfileNonactive.png"), for: UIControlState.normal)
            self.btFriendRequest.setImage(UIImage(named: "icon_friend"), for: UIControlState.normal)

            break
        case .toMessage:
            
            self.btHome.setImage(UIImage(named: "iconHomeNonactive.png"), for: UIControlState.normal)
            self.btGroup.setImage(UIImage(named: "iconGroupNonactive.png"), for: UIControlState.normal)
            self.btMessage.setImage(UIImage(named: "iconInboxActive.png"), for: UIControlState.normal)
            self.btProfile.setImage(UIImage(named: "iconProfileNonactive.png"), for: UIControlState.normal)
            self.btFriendRequest.setImage(UIImage(named: "icon_friend"), for: UIControlState.normal)

            break
        case .toProfile:
            
            self.btHome.setImage(UIImage(named: "iconHomeNonactive.png"), for: UIControlState.normal)
            self.btGroup.setImage(UIImage(named: "iconGroupNonactive.png"), for: UIControlState.normal)
            self.btMessage.setImage(UIImage(named: "iconChat.png"), for: UIControlState.normal)
            self.btProfile.setImage(UIImage(named: "iconProfileActive.png"), for: UIControlState.normal)
            self.btFriendRequest.setImage(UIImage(named: "icon_friend"), for: UIControlState.normal)

            break
        case .segToNavigationProfileVC:
            
            self.btHome.setImage(UIImage(named: "iconHomeNonactive.png"), for: UIControlState.normal)
            self.btGroup.setImage(UIImage(named: "iconGroupNonactive.png"), for: UIControlState.normal)
            self.btMessage.setImage(UIImage(named: "iconChat.png"), for: UIControlState.normal)
            self.btProfile.setImage(UIImage(named: "iconProfileActive.png"), for: UIControlState.normal)
            self.btFriendRequest.setImage(UIImage(named: "icon_friend"), for: UIControlState.normal)

            break
        case .toFriendRequest:
            self.btHome.setImage(UIImage(named: "iconHomeNonactive.png"), for: UIControlState.normal)
            self.btGroup.setImage(UIImage(named: "iconGroupNonactive.png"), for: UIControlState.normal)
            self.btMessage.setImage(UIImage(named: "iconChat.png"), for: UIControlState.normal)
            self.btProfile.setImage(UIImage(named: "iconProfileNonactive.png"), for: UIControlState.normal)
            self.btFriendRequest.setImage(UIImage(named: "icon_friend_active"), for: UIControlState.normal)

            break
        }
    }
    func finishTransition(FromView from: HomeContainerVC.SegName, ToView to: HomeContainerVC.SegName) {
        
    }
}

//MARK:

extension ViewController{
    
    func showActionSheetForFreeMember()  {
        // 1
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let upgradePlan = UIAlertAction(title: "Upgrade Plan", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let email = ShareData.sharedInstance.userInfo.email
            let userId = ShareData.sharedInstance.userInfo.uid
            NavigationManager.navigateToPayment(navigationController: self.navigationController, email: email, userId: userId,iSTopup:false)
        })
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        // 4
        optionMenu.addAction(upgradePlan)
        optionMenu.addAction(cancelAction)
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func showActionSheetForPremiumMember()  {
        // 1
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // 2
        let topUp = UIAlertAction(title: "Top up Points", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let email = ShareData.sharedInstance.userInfo.email
            let userId = ShareData.sharedInstance.userInfo.uid
            NavigationManager.navigateToPayment(navigationController: self.navigationController, email: email, userId: userId,iSTopup:true)
        })
        let viewPayment = UIAlertAction(title: "Payment History", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            NavigationManager.navigateToPaymentHistory(navigationController: self.navigationController)
        })
        //3
        let inviteFriend = UIAlertAction(title: "Refer & Earn", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            NavigationManager.navigateToReferAndEarn(navigationController: self.navigationController)
            
        })
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        // 4
        optionMenu.addAction(topUp)
        optionMenu.addAction(viewPayment)
        
        optionMenu.addAction(inviteFriend)
        optionMenu.addAction(cancelAction)
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
}

//MARK: API
extension ViewController {
    func checkUserPremium(isDollerButtonTapped:Bool,isCameraTapped:Bool)  {
        WebServiceModel.isPremiunMember { (isPremium) in
              DispatchQueue.main.async {
                self.isMemberPremium = isPremium
                if isDollerButtonTapped{
                    self.btnUpgradePlanTapped(UIButton())
                }
                if isCameraTapped{
                    self.tapOnCamera(UIButton())
                }
            }
        }
    }
}












