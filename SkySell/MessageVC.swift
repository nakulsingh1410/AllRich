//
//  MessageVC.swift
//  SkySell
//
//  Created by supapon pucknavin on 4/16/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift


class MessageVC: UIViewController {

    
    enum ChatMode{
        case buying
        case selling
    }
    
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    
    
    @IBOutlet weak var viTopBarBG: UIView!
    
 
    
    @IBOutlet weak var btLike: UIButton!
    
    
    
    @IBOutlet weak var viSectionBG: UIView!
    
    @IBOutlet weak var layout_SectionBG_Height: NSLayoutConstraint!
    
    @IBOutlet weak var section0Line: UIView!
    @IBOutlet weak var section1Line: UIView!
    
    
    @IBOutlet weak var btBuying: UIButton!
    @IBOutlet weak var btSelling: UIButton!
    
    
    @IBOutlet weak var lbNoMessage: UILabel!
    
    
    
    @IBOutlet weak var myTable: UITableView!
    
    
    ///------------------
    @IBOutlet weak var lbProductName: UILabel!
    
    @IBOutlet weak var lbProductPrice: UILabel!
    
    @IBOutlet weak var viProductBG: UIView!
    
    @IBOutlet weak var viProductImageBG: UIView!
    var lazyImageProduct:PKImV3View! = nil
    @IBOutlet weak var layout_HeightProductCell: NSLayoutConstraint!
    
    
    @IBOutlet weak var btProduct: UIButton!
    
    var displayMode:ChatMode = .selling
    
    
    
    
    let blueColor:UIColor = UIColor(red: (39.0/255.0), green: (47.0/255.0), blue: (85.0/255.0), alpha: 1.0)
    let pinkColor:UIColor = UIColor(red: (3.0/255.0), green: (210.0/255.0), blue: (99.0/255.0), alpha: 1.0)
    
    
    
    
    
    var myActivityView:ActivityLoadingView! = nil
    
    var working:Bool = false
    var refreshControl:UIRefreshControl! = nil
    
    
    
    var arRoom:[RoomMessagesDataModel] = [RoomMessagesDataModel]()
    
    
    let myData:ShareData = ShareData.sharedInstance
    let mySetting:SettingData = SettingData.sharedInstance
    
    
    @IBOutlet weak var btBack: UIButton!
    
    
    var showBackBT:Bool = false
    var showOnlyProductID:String = ""
    var showProduct:ProductDataModel? = nil
    var showOnlyOffer:Bool = false
    
    
    
    var isFirstTime:Bool = true
    
    
    
    var needUpdate:Bool = false
    
    
    var comeFromProductDetail:Bool = false
    
    
    let fontProductName:UIFont = UIFont(name: "Avenir-Medium", size: 16)!
    let fontPriceName:UIFont = UIFont(name: "Avenir-Medium", size: 20)!
    
    
    var haveNoti:Bool = false
    var updateing:Bool = false
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.clipsToBounds = true
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        self.viSectionBG.clipsToBounds = true
        
        
        
        self.viTopBarBG.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viTopBarBG.layer.shadowRadius = 1
        self.viTopBarBG.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viTopBarBG.layer.shadowOpacity = 0.5
        
        
        
        
        
        
        
        
        self.viProductBG.clipsToBounds = true
        self.viProductBG.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viProductBG.layer.shadowRadius = 1
        self.viProductBG.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viProductBG.layer.shadowOpacity = 0.5
        
        
        self.viProductImageBG.clipsToBounds = true
        self.viProductImageBG.layer.cornerRadius = 2
        self.lazyImageProduct = PKImV3View(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
        self.viProductImageBG.addSubview(self.lazyImageProduct)
        
        
        
        
        
        
        self.section0Line.clipsToBounds = true
        self.section1Line.clipsToBounds = true
        
        self.section0Line.layer.cornerRadius = 1.5
        self.section1Line.layer.cornerRadius = 1.5
        
        if(showBackBT == false){
            self.setDisplayMode(dmode: .buying)
            self.layout_SectionBG_Height.constant = 40
        }else{
            
            self.displayMode = .buying
            self.setDisplayMode(dmode: .selling)
            
            self.layout_SectionBG_Height.constant = 0
        }
        
        
        if(self.showOnlyProductID.count > 0){
            self.layout_SectionBG_Height.constant = 0
            self.updateDisPlayTopBar()
        }else{
            self.layout_HeightProductCell.constant = 0
        }
        
        
        
        do{
            let nib:UINib = UINib(nibName: "ChatRoomCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "ChatRoomCell")
        }
        
        
        
        
        self.myTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor(red: (3.0/255.0), green: (210.0/255.0), blue: (99.0/255.0), alpha: 1.0)
        self.refreshControl.addTarget(self, action: #selector(MessageVC.pullToRefresh), for: UIControlEvents.valueChanged)
        self.myTable.addSubview(self.refreshControl)
        self.myTable.dataSource = self
        self.myTable.delegate = self
        self.myTable.allowsSelection = true
        
        
        
        if(showBackBT == false){
            self.btBack.alpha = 0
            self.btBack.isEnabled = false
        }else{
            self.btBack.alpha = 1
            self.btBack.isEnabled = true
        }
        
        
        self.lbNoMessage.alpha = 0
        
        
        self.view.updateConstraints()
        self.view.layoutIfNeeded()
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        //self.lbNoMessage.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if(self.haveNoti == false){
            self.haveNoti = true
            NotificationCenter.default.addObserver(self, selector: #selector(self.notireloadChat(notification:)), name:NSNotification.Name(rawValue: "SkySell_Notification_NameReloadChat"), object: nil)
            
            
        }
        
        
        
        
        
        
        if(self.needUpdate == true){
            self.refeshData()
        }
        
        
        
        let indexPath = self.myTable.indexPathForSelectedRow
        if let indexPath = indexPath{
            self.myTable.deselectRow(at: indexPath, animated: true)
            
        }
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if(self.haveNoti == true){
            self.haveNoti = false
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "SkySell_Notification_NameReloadChat"), object: nil)

        }
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
    
    // MARK: - notitfication
    func notireloadChat(notification:NSNotification){
        
        if(self.updateing == false){
            self.updateing = true
            self.refeshData()
            
        }
    }
    // MARK: - Activity
    
    func addActivityView(Finish finish:@escaping ()->Void){
        
        if(self.myActivityView == nil){
            
            
            
            
            
            if(showBackBT == false){
                myActivityView = ActivityLoadingView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
            }else{
                myActivityView = ActivityLoadingView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
            }
            
            
            
            
            myActivityView.alpha = 0
            self.view.addSubview(myActivityView)
            self.view.bringSubview(toFront: self.viTopBarBG)
            
            
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
                }
                
                self.myActivityView = nil
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
        self.updateing = true
        
        
        
        //print("uid: \(self.myData.userInfo.uid)")
        if(self.myData.userInfo != nil){
            let postRef = FIRDatabase.database().reference().child("room-messages")
            
            var query:FIRDatabaseQuery! = nil
            
            if(self.displayMode == .buying){
                query = postRef.queryOrdered(byChild: "createdByUserId").queryEqual(toValue: self.myData.userInfo.uid)
            }else{
                query = postRef.queryOrdered(byChild: "receivedByUserId").queryEqual(toValue: self.myData.userInfo.uid)
                
                
                
            }
            
            query.observeSingleEvent(of: FIRDataEventType.value, with:{ (snapshot) in
                
                var arRoomM:[RoomMessagesDataModel] = [RoomMessagesDataModel]()
                
                
                
                
                
                
                if let value = snapshot.value as? NSDictionary{
                    
                    
                    
                    
                    for object in value.allValues{
                        
                        if let object = object as? NSDictionary{
                            
                            let newRoom:RoomMessagesDataModel = RoomMessagesDataModel(dictionary: object)
                            
                            
                            var add:Bool = true
                            
                         
                        
                            
                            
                            if(self.showOnlyProductID.count > 0){
                                
                                //print("Show product : \(self.showOnlyProductID)")
                                //print("Product ID \(newRoom.product_id)  : ")
                                
                                if(newRoom.product_id != self.showOnlyProductID){
                                    add = false
                                    
                                }
                            }
                            
                            
                            if(newRoom.isDeleteUser.count > 0){
                                for duser in newRoom.isDeleteUser{
                                    if(duser == self.myData.userInfo.uid){
                                        add = false
                                        
                                    }
                                }
                            }
                            
                            
                            if(self.showOnlyOffer == true){
                                if((newRoom.status == .offer) || (newRoom.status == .declined) || (newRoom.status == .cancel)){
                                    
                                }else{
                                    add = false
                                }
                            }
                            
                            if(add == true){
                                arRoomM.append(newRoom)
                            }
                            
                            
                            
                        }
                    }
                    
                }
                
                
                
                self.arRoom = arRoomM.sorted(by: { (obj1, obj2) -> Bool in
                    
                    
                    
                    
                    return obj1.updatedAt_Date.timeIntervalSince1970 > obj2.updatedAt_Date.timeIntervalSince1970
                })
                
                
                
                for r in self.arRoom{
                    print("roomID:\(r.room_id) , Time:\(r.updatedAt_Date.timeIntervalSince1970)   ")
                }
                
                
                //--------------
                
                /*
                UIView.animate(withDuration: 0.45, animations: {
                    if(self.arRoom.count <= 0){
                        //self.myTable.alpha = 0
                        self.lbNoMessage.alpha = 1
                    }else{
                        self.myTable.alpha = 1
                        self.lbNoMessage.alpha = 0
                    }
                })
                
                if(self.isFirstTime == true){
                    self.isFirstTime = false
                    
                    self.myTable.reloadData()
                }else{
                    //self.myReloadTable()
                    self.myTable.reloadData()
                }
                
                
                
                
                self.refreshControl.endRefreshing()
                self.working = false
                
                self.startLoadProductData()
                
                
                
                self.startLoadUserData()
                
                self.removeActivityView {
                    
                }
                */
                
                self.startLoadProductData()
                
                //--------------
            })
            
            
            
            
            
            
        }else{
            self.refreshControl.endRefreshing()
            self.working = false
            
            self.removeActivityView {
                self.updateing = false
            }
        }
        
        
    }
    
    
    
    
    
    func startLoadProductData(){
        
        for chat in self.arRoom{
            
            if(chat.product == nil){
                
                self.loadProductDataWith(ProductId: chat.product_id, Finish: { (arProduct) in
                    
                    if(arProduct.count > 0){
                        let product = arProduct[0]
                        
                        var count:NSInteger = 0
                        for c in self.arRoom{
                            if(c.product_id == product.product_id){
                                c.product = product
                                
                                
                                
                                
                                
                                
                                
                                
                                /*
                                let indexP = IndexPath(row: count, section: 0)
                                self.myReloadCellAt(Index: indexP)
 */
                                
                            }
                            
                            count += 1
                        }
                        
                        self.checkFinishLoadProductData()
                        
                        
                    }else{
                        
                        var count:NSInteger = self.arRoom.count - 1
                        while( count >= 0){
                            let c = self.arRoom[count]
                            if(c.product_id == chat.product_id){
                                
                                //update unread
                                
                                self.updateSelfUnreadToRoomData(room: chat)
                                self.arRoom.remove(at: count)
                                //let indexP = IndexPath(row: count, section: 0)
                                //self.myTable.reloadRows(at: [indexP], with: UITableViewRowAnimation.fade)
                                
                            }
                            
                            
                            count = count - 1
                        }
                        
                        self.checkFinishLoadProductData()
                        
             
                        
                        
                    }
                })
            }
            
        }
        
        if(self.arRoom.count <= 0){
            self.checkFinishLoadData()
        }
    }
    
    
    
    func updateSelfUnreadToRoomData(room:RoomMessagesDataModel) {
        
       
        
        
        
        let postRef = FIRDatabase.database().reference().child("room-messages").child(room.room_id).child("unread_count").child(room.createdByUserId)
        
        postRef.setValue(0)
        
        let postRef2 = FIRDatabase.database().reference().child("room-messages").child(room.room_id).child("unread_count").child(room.receivedByUserId)
        
        postRef2.setValue(0)
        
    }
    
    
    

    
    
    func checkFinishLoadProductData(){
        var finsh:Bool = true
        
        for chat in self.arRoom{
            
            if(chat.product == nil){
                finsh = false
            }
        }
        
        
        if(finsh){

            if(self.myData.masterView != nil){
                self.myData.masterView.reloadallMessage()
            }
            self.startLoadUserData()

        }
    }
    
    
    func checkFinishLoadData(){
        var finsh:Bool = true
        
  
        
        
        for chat in self.arRoom{
            
            if((chat.createBy == nil) || (chat.reciveBy == nil)){
                
                finsh = false
            }
        }
        
        
        
        
        if(finsh){
            UIView.animate(withDuration: 0.45, animations: {
                if(self.arRoom.count <= 0){
                    //self.myTable.alpha = 0
                    self.lbNoMessage.alpha = 1
                }else{
                    self.myTable.alpha = 1
                    self.lbNoMessage.alpha = 0
                }
            })
            
            if(self.isFirstTime == true){
                self.isFirstTime = false
                
                self.myTable.reloadData()
            }else{
                //self.myReloadTable()
                self.myTable.reloadData()
            }
            
            
            
            
            self.refreshControl.endRefreshing()
            self.working = false
            

            
            //self.startLoadUserData()
            
            self.removeActivityView {
                
                
                
                self.updateing = false
                
                
            }
        }
    }
    
    
    
    
    
    func loadProductDataWith(ProductId pID:String, Finish finish:@escaping ([RealmProductDataModel])->Void){
        DispatchQueue.main.async {
            
            
            var arProduct:[RealmProductDataModel] = [RealmProductDataModel]()
            
            let otherRealm = try! Realm()
            
            let predicate = NSPredicate(format: "product_id = %@", pID)
            
            let otherResults = otherRealm.objects(RealmProductDataModel.self).filter(predicate)
            
            //print("Number of product \(otherResults.count)")
            
            for p in otherResults{
                arProduct.append(p)
            }
            
            finish(arProduct)
            
        }
    }
    
    
    
    
    
    
    func startLoadUserData(){
     
        print("startLoadUserData")
        
        
        if(self.arRoom.count <= 0){
            self.checkFinishLoadData()
        }else{
            for chat in self.arRoom{
                
                if((chat.createBy == nil) || (chat.reciveBy == nil)){
                    
                    
                    
                    var userID:String = ""
                    
                    if(chat.createBy == nil){
                        userID = chat.createdByUserId
                        
                        self.loadAndUpdateUser(UserID: userID)
                    }
                    
                    
                    
                    
                    if(chat.reciveBy == nil){
                        userID = chat.receivedByUserId
                        
                        self.loadAndUpdateUser(UserID: userID)
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
            }
        }
        
        
        
    }
    
    
    
    
    func loadAndUpdateUser(UserID userID:String){
        
        
        self.loadRUserDataWith(UserID: userID, Finish: { (arUser) in
            if(arUser.count > 0){
                let user = arUser[0]
                
                
                print(user.first_name)
                
                
                
                var count:NSInteger = 0
                for c in self.arRoom{
                    
                    var have:Bool = false
                    
                    if(c.createdByUserId == user.uid){
                        c.createBy = user
                        
                        have = true
                        
                    }
                    
                    if(c.receivedByUserId == user.uid){
                        c.reciveBy = user
                        
                        have = true
                        
                    }
                    
                    
                    
                    if(have == true){
                        let indexP = IndexPath(row: count, section: 0)
                        //self.myTable.reloadRows(at: [indexP], with: UITableViewRowAnimation.none)
                        self.myReloadCellAt(Index: indexP)
                    }
                    
                    count += 1
                }
                
                
            }else{
                getUserDataWith(UID: userID, Finish: { (user) in
                    
                    self.loadAndUpdateUser(UserID: userID)
                })
            }
            
            
            self.checkFinishLoadData()
        })
    }
    
    
    func loadRUserDataWith(UserID uID:String, Finish finish:@escaping([RealmUserDataObject])->Void){
        
        
        DispatchQueue.main.async {
            
            
            var arUser:[RealmUserDataObject] = [RealmUserDataObject]()
            
            let otherRealm = try! Realm()
            
            let predicate = NSPredicate(format: "uid = %@", uID)
            
            let otherResults = otherRealm.objects(RealmUserDataObject.self).filter(predicate)
            
            //print("Number of product \(otherResults.count)")
            
            for p in otherResults{
                arUser.append(p)
            }
            
            finish(arUser)
            
        }
    }
    
    // MARK: - Action
    
    func updateDisPlayTopBar(){
        if(self.showProduct != nil){
            
            
            if let showProduct = self.showProduct{
                self.lbProductName.text = showProduct.title
                if(showProduct.price.count > 0){
                    self.lbProductPrice.text = self.mySetting.priceWithString(strPricein: showProduct.price)
                }else{
                    self.lbProductPrice.text = ""
                }
                
                self.lazyImageProduct.loadImage(imageURL: showProduct.image_src, Thumbnail: true)
                
                let space:CGFloat = 15 + 15 + 65 + 8 + 10
                let pNameH:CGFloat = heightForView(text: showProduct.title, Font: self.fontProductName, Width: self.screenSize.width - space)
                let pPriceH:CGFloat = heightForView(text: self.mySetting.priceWithString(strPricein: showProduct.price), Font: self.fontProductName, Width: self.screenSize.width - space)
                
                
                var h:CGFloat = pNameH + pPriceH + (15 + 8 + 15)
                if(h < 96){
                    h = 96
                }
                
                
                self.layout_HeightProductCell.constant = h
                self.viProductBG.clipsToBounds = false
                self.view.updateConstraints()
                self.view.layoutIfNeeded()
                
            }else{
                self.layout_HeightProductCell.constant = 0
                self.viProductBG.clipsToBounds = true
                self.view.updateConstraints()
                self.view.layoutIfNeeded()
                
            }
        }
    }
    
    @IBAction func tapOnProduct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func tapOnBack(_ sender: UIButton) {
        
        
        self.navigationController?.popViewController(animated: true)

        
    }
    
    
    
    
    
    @IBAction func tapOnLike(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.GotoLikesScene.rawValue), object: nil, userInfo: nil)
        
        
        
    }
    
    
    
    
    @IBAction func tapOnBuying(_ sender: UIButton) {
        
        self.setDisplayMode(dmode: .buying)
    }
    
    
    
    @IBAction func tapOnSelling(_ sender: UIButton) {
        self.setDisplayMode(dmode: .selling)
        
    }
    
    
    
    func setDisplayMode(dmode:ChatMode){
        
        
        if(dmode != self.displayMode){
            
            self.displayMode = dmode
            
            switch dmode {
            case .buying:
                
                self.btBuying.setTitleColor(self.pinkColor, for: UIControlState.normal)
                self.btSelling.setTitleColor(self.blueColor, for: UIControlState.normal)
                
                
                self.section0Line.alpha = 1
                self.section1Line.alpha = 0
                
                break
            case .selling:
                
                self.btBuying.setTitleColor(self.blueColor, for: UIControlState.normal)
                self.btSelling.setTitleColor(self.pinkColor, for: UIControlState.normal)
                
                
                self.section0Line.alpha = 0
                self.section1Line.alpha = 1
                
                
                break
                
            }
            
            
            self.addActivityView {
                self.refeshData()
            }
            
            
            
        }
        
    }
    
    
    
    
    func getAutoMessage(message:String)->String{
        var str:String = message
        if(message == "decline_offer"){
            str = "Decline offer"
        }else if(message == "offer"){
            str = "Offer"
        }else if(message == "cancel_offer"){
            str = "Cancel offer"
        }else if(message == "accept_offer"){
            str = "Accepted offer"
        }
        
        
        
        return str
    }
    
    

}





// MARK: - UITableViewDelegate, UITableViewDataSource
extension MessageVC:UITableViewDelegate, UITableViewDataSource{
    
    func myReloadTable(){
        for i in 0..<self.arRoom.count{
            let indexPath:IndexPath = IndexPath(row: i, section: 0)
            
            
            self.myReloadCellAt(Index: indexPath)
        }
        
    }
    
    
    
    
    func myReloadCellAt(Index indexPath: IndexPath){
        
        
        DispatchQueue.main.async {
            
            if let cell:ChatRoomCell = self.myTable.cellForRow(at: indexPath) as? ChatRoomCell{
                
                cell.clipsToBounds = true
                cell.tag = indexPath.row
                
                cell.myTag = indexPath.row
                
                
                let chat = self.arRoom[indexPath.row]
                
                if(chat.offer_price.count > 0){
                    
                    let testNum:Double? = Double(chat.offer_price)
                    if let _ = testNum{
                        if(self.displayMode == .buying){
                            cell.lbPrice.text = String(format: "offered %@", self.mySetting.priceWithString(strPricein: chat.offer_price))
                        }else{
                            cell.lbPrice.text = String(format: "offered %@", self.mySetting.priceWithString(strPricein: chat.offer_price))
                        }
                    }else{
                        cell.lbPrice.text = " "
                    }
                    
                    
                    
                    
                }else{
                    cell.lbPrice.text = " "
                }
                
                
                var sell:Bool = false
                if(self.displayMode == .buying){
                    
                }else{
                    sell = true
                }
                
                cell.setStatusTo(st: chat.status, ChatAsSelling: sell)
                
                
                if(chat.product != nil){
                    
                    
                    cell.lazyImageProduct.loadImage(imageURL: chat.product.image_src, Thumbnail: true)
                    cell.lbProductName.text = chat.product.title
                    
                    
                    
                    if(chat.product.product_status == "Sold Out"){
                        cell.lbStatus.text = "SOLD"
                        cell.viStatusBG.alpha = 1
                        
                        
                    }else{
                        cell.viStatusBG.alpha = 0
                    }
                    
                    
                }else{
                    cell.lazyImageProduct.imageView.alpha = 0
                    cell.lbProductName.text = "Loading..."
                    cell.viStatusBG.alpha = 0
                    
                }
                
                
                if(self.displayMode == .buying){
                    if(chat.reciveBy != nil){
                        
                        cell.lbName.text = String(format: "%@  %@", chat.reciveBy.first_name, chat.reciveBy.last_name)
                        
                        cell.lazyImageUser.loadImage(imageURL: chat.reciveBy.profileImage_src, Thumbnail: true)
                    }else{
                        cell.lbName.text = " "
                    }
                    
                }else{
                    if(chat.createBy != nil){
                        
                        cell.lbName.text = String(format: "%@  %@", chat.createBy.first_name, chat.createBy.last_name)
                        
                        cell.lazyImageUser.loadImage(imageURL: chat.createBy.profileImage_src, Thumbnail: true)
                        
                    }else{
                        cell.lbName.text = " "
                    }
                }
                
                
                let unread:NSInteger? = chat.unreadCount[self.myData.userInfo.uid]
                if let unread = unread{
                    
                    if(unread > 0){
                        cell.unreadCount = unread
                        cell.viUnreadBG.alpha = 1
                    }else{
                        cell.unreadCount = unread
                        cell.viUnreadBG.alpha = 0
                    }
                    
                }else{
                    cell.viUnreadBG.alpha = 0
                }
                
            }
            
            
        }
        
    }
    
    
    // MARK: - numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
    }
    
    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //var numberOfCell:NSInteger = 0
        
        
        return self.arRoom.count
    }
    
    // MARK: - Cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        var cellHeight:CGFloat = 115
        
        
        let chatRoom = self.arRoom[indexPath.row]
        if(self.showOnlyProductID.count > 0){
            
            
            
            if(chatRoom.product_id != self.showOnlyProductID){
                cellHeight = 0
            }
        }
       
        
        if(chatRoom.isDeleteUser.count > 0){
            for duser in chatRoom.isDeleteUser{
                if(duser == self.myData.userInfo.uid){
                    cellHeight = 0
                    break
                }
            }
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
        
        
        let cell:ChatRoomCell? = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath) as? ChatRoomCell
        //cell?.selectionStyle = .none
        cell?.clipsToBounds = true
        cell?.tag = indexPath.row
        
        cell?.myTag = indexPath.row
    
        
        let chat = self.arRoom[indexPath.row]
        
        if(chat.offer_price.count > 0){
            
            let testNum:Double? = Double(chat.offer_price)
            if let _ = testNum{
                if(self.displayMode == .buying){
                    cell?.lbPrice.text = String(format: "offered %@", self.mySetting.priceWithString(strPricein: chat.offer_price))
                }else{
                    cell?.lbPrice.text = String(format: "offered %@", self.mySetting.priceWithString(strPricein: chat.offer_price))
                }
            }else{
                cell?.lbPrice.text = ""
            }
            
            
            
            
        }else{
            cell?.lbPrice.text = ""
        }
        
        
        var sell:Bool = false
        if(self.displayMode == .buying){
            
        }else{
            sell = true
        }
        
        cell?.setStatusTo(st: chat.status, ChatAsSelling: sell)
        
        
        if(chat.product != nil){
         
            
            cell?.lazyImageProduct.loadImage(imageURL: chat.product.image_src, Thumbnail: true)
            cell?.lbProductName.text = chat.product.title
        
            
            
            if(chat.product.product_status == "Sold Out"){
                cell?.lbStatus.text = "SOLD"
                cell?.viStatusBG.alpha = 1
                
                
            }else{
                cell?.viStatusBG.alpha = 0
            }
            
            
        }else{
            cell?.lazyImageProduct.imageView.alpha = 0
            cell?.lbProductName.text = ""
            cell?.viStatusBG.alpha = 0
            
        }
        
        
        if(self.displayMode == .buying){
            if(chat.reciveBy != nil){
                
                cell?.lbName.text = String(format: "%@  %@", chat.reciveBy.first_name, chat.reciveBy.last_name)
                
                cell?.lazyImageUser.loadImage(imageURL: chat.reciveBy.profileImage_src, Thumbnail: true)
            }else{
                cell?.lbName.text = ""
            }
            
        }else{
            if(chat.createBy != nil){
                
                cell?.lbName.text = String(format: "%@  %@", chat.createBy.first_name, chat.createBy.last_name)
                
                cell?.lazyImageUser.loadImage(imageURL: chat.createBy.profileImage_src, Thumbnail: true)
                
            }else{
                cell?.lbName.text = ""
            }
        }
        
        
        let unread:NSInteger? = chat.unreadCount[self.myData.userInfo.uid]
        
        print("\(self.myData.userInfo.uid)  :  \(chat.unreadCount)")
        if let unread = unread{
            
            if(unread > 0){
                cell?.unreadCount = unread
                cell?.viUnreadBG.alpha = 1
            }else{
                cell?.unreadCount = unread
                cell?.viUnreadBG.alpha = 0
            }
            
        }else{
            cell?.viUnreadBG.alpha = 0
        }
        
        
        
        return cell!
        
    }
    
    // MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        
        self.gotoChatWithInde(index: indexPath.row)
        
        
        
        //self.myTable.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    func gotoChatWithInde(index:NSInteger){
        if(index < self.arRoom.count){
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
            let vc:ChatRoomVC = storyboard.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
            
            
            vc.myRoom = self.arRoom[index]
            vc.mode = self.displayMode
            
            
            
            self.needUpdate = true
            
            
            
            
            self.arRoom[index].unreadCount[self.myData.userInfo.uid] = 0
            
            let postRef = FIRDatabase.database().reference().child("room-messages").child(self.arRoom[index].room_id).child("unread_count").child(self.myData.userInfo.uid)
            
            postRef.setValue(0)
            
            
            
            
            if(self.myData.masterView != nil){
                self.myData.masterView.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
}

