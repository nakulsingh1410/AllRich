//
//  ProductDetailVC.swift
//  SkySell
//
//  Created by supapon pucknavin on 5/25/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import RealmSwift



class CellSectionCustom{
    var section:NSInteger = 0
    var arCellName:[NSInteger] = [NSInteger]()
    var cellType:String = ""
    var isEnable:Bool = true
    var title:String = ""
    
    var tag:NSInteger = 0
}


class ProductDetailVC: UIViewController {

    enum ChatMode{
        case buying
        case selling
    }
    
    
    
    enum CellName:NSInteger{
        case image = 0
        //-------
        case title
        case manufacturer
        case model
        case price
        case year
        case country
        case category
        case productId
        case condition
        case points
        case description
        //------
        case serial
        //------
        case meetTheSeller
        //-------
        case map
        
        static let count = 14
    }
    
    @IBOutlet weak var btBack: UIButton!
    
    @IBOutlet weak var btMore: UIButton!
    
    @IBOutlet weak var viTopBar: UIView!
    
    @IBOutlet weak var lbTitle: UILabel!

    
    @IBOutlet weak var viFooterBG: UIView!
    
    
    @IBOutlet weak var layout_Bottom_viFooter: NSLayoutConstraint!
    
    
    var serialStartAtRow:NSInteger = 0
    
    
    
    
    
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    let cellCollectionFont:UIFont = UIFont(name: "Avenir-Medium", size: 11)!
    
    
    var working:Bool = false
    
    
    var myData:ShareData = ShareData.sharedInstance
    
    
    var strTitle:String = ""
    
    

    
    @IBOutlet weak var myTable: UITableView!
    
    var myProductData:ProductDataModel! = ProductDataModel()
    
    var arImageName:[PostImageObject] = [PostImageObject]()
    
    
    
    
    
    let fontTitle:UIFont = UIFont(name: "Avenir-Heavy", size: 16)!
    let fontSubTitle:UIFont = UIFont(name: "Avenir-Roman", size: 16)!
    let fontDetail:UIFont = UIFont(name: "Avenir-Book", size: 15)!
    
    
    
    var strCategory:String = ""
    var strIsNew:String = "NEW"
    
    
    
    var sellerData:UserDataModel = UserDataModel()
    
    
    var dateFormatFull:DateFormatter = DateFormatter()
    
    
    
    var mySetting:SettingData = SettingData.sharedInstance
    
    var arSection:[CellSectionCustom] = [CellSectionCustom]()
    
    var thisFirstDetail:Bool = false
    
    
    var numberSectionOfMeetTheSeller:NSInteger = -1
    
    
    
    @IBOutlet weak var btViewChat: UIButton!
    
    
    
    
    
    var myActivityView:ActivityLoadingView! = nil
    
    
    var arRoom:[RoomMessagesDataModel] = [RoomMessagesDataModel]()
    var displayMode:ChatMode = .selling
    
    
    
    let likeQueue = OperationQueue()
 
    

    var comeFromChat:Bool = false
    
    var refreshControl:UIRefreshControl! = nil
    
    
    var haveGotoChat:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        dateFormatFull.dateFormat = "dd MMMM yyyy"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        if(self.myProductData != nil){
            self.lbTitle.text = self.myProductData.title
            
            for im in self.myProductData.images{
                
                
                self.arImageName.append(im)
                
            }
            
            
            
            if(self.arImageName.count <= 0){
                if(self.myProductData.image_src.count > 3){
                    
                    let newImage:PostImageObject = PostImageObject()
                    newImage.image_path = self.myProductData.image_path
                    newImage.image_name = self.myProductData.image_name
                    newImage.image_src = self.myProductData.image_src
                    
                    self.arImageName.append(newImage)
                }
            }
        }
        
        
        //----------
        
        for i in 0..<mySetting.arProductDetail.count{
            let pro = mySetting.arProductDetail[i]
            let newSection:CellSectionCustom = CellSectionCustom()
            
            newSection.section = i
            newSection.cellType = pro.type
            newSection.title = pro.title
            newSection.isEnable = pro.isActive
          
            switch pro.type {
            case ProductCellPosition.CellType.product_image.rawValue:
                
                newSection.arCellName.append(CellName.image.rawValue)
                break
            case ProductCellPosition.CellType.profile.rawValue:
                
                newSection.arCellName.append(CellName.meetTheSeller.rawValue)
                self.numberSectionOfMeetTheSeller = i
           
                
                
                break
            case ProductCellPosition.CellType.description.rawValue:
                
                
                
                newSection.arCellName.append(CellName.title.rawValue)
                newSection.arCellName.append(CellName.manufacturer.rawValue)
                newSection.arCellName.append(CellName.model.rawValue)
                newSection.arCellName.append(CellName.price.rawValue)
                newSection.arCellName.append(CellName.year.rawValue)
                newSection.arCellName.append(CellName.country.rawValue)
                newSection.arCellName.append(CellName.category.rawValue)
                newSection.arCellName.append(CellName.productId.rawValue)
                newSection.arCellName.append(CellName.condition.rawValue)
                newSection.arCellName.append(CellName.points.rawValue)
                newSection.arCellName.append(CellName.description.rawValue)
                
                self.serialStartAtRow = 10
                if(self.myProductData != nil){
                    for _ in self.myProductData.product_serials{
                        newSection.arCellName.append(CellName.serial.rawValue)
                    }
                }
                
                
                
                
                break
            case ProductCellPosition.CellType.map.rawValue:
                newSection.arCellName.append(CellName.map.rawValue)
                
                break
            default:
                break
            }
            
            
            if(pro.isActive == true){
                
                if(pro.type == ProductCellPosition.CellType.product_image.rawValue){
                    if(self.arImageName.count > 0){
                        self.arSection.append(newSection)
                    }
                }else{
                    self.arSection.append(newSection)
                }
                
            }
            
        }
        
        
        
        
        //----------
        
        self.viTopBar.isUserInteractionEnabled = true
        
        
        self.viTopBar.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viTopBar.layer.shadowRadius = 1
        self.viTopBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viTopBar.layer.shadowOpacity = 0.5
        
        
        
        
        print(strTitle)
        self.lbTitle.text = strTitle
        
        
        
        
        
        var strCat:String = ""
        
        
        for cat1 in self.myData.arCategoriesDataModel{
            
            if(cat1.category_id == self.myProductData.category1){
                strCat = cat1.category_name
                
                for cat2 in cat1.subCategory.values{
                    if(cat2.sub_category_id == self.myProductData.category2){
                        strCat = String(format: "%@ - %@", strCat, cat2.sub_category_name)
                        break
                    }
                }
                
                break
            }
            
        }
        
        self.strCategory = strCat
        
        
        
        if(self.myProductData.isNew == true){
            self.strIsNew = "NEW"
        }else{
            self.strIsNew = "USED"
        }
        
        
        
        
        do{
            let nib:UINib = UINib(nibName: "EmptyCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "EmptyCell")
        }
        
        
        do{
            let nib:UINib = UINib(nibName: "ImageSliderCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "ImageSliderCell")
        }
        
        
        do{
            let nib:UINib = UINib(nibName: "PDTitleCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "PDTitleCell")
        }
        
        do{
            let nib:UINib = UINib(nibName: "PDDetailCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "PDDetailCell")
        }
        
        do{
            let nib:UINib = UINib(nibName: "MeetTheSellerCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "MeetTheSellerCell")
        }
        
        do{
            let nib:UINib = UINib(nibName: "MapCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "MapCell")
        }
        
        do{
            let nib:UINib = UINib(nibName: "SerialNoCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "SerialNoCell")
        }
        
        
        
        
        
        //self.myTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor(red: (3.0/255.0), green: (210.0/255.0), blue: (99.0/255.0), alpha: 1.0)
        self.refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: UIControlEvents.valueChanged)
        self.myTable.addSubview(self.refreshControl)
        
        
        
        
        self.myTable.delegate = self
        self.myTable.dataSource = self
        
        
        print("\(self.myProductData.product_id) :  \(self.myProductData.product_status)")
        
        
        
        
        if(self.myData.userInfo == nil){
            self.btViewChat.isEnabled = false
            self.layout_Bottom_viFooter.constant = -40
        }else{
            
            
            if(self.myProductData.product_status.lowercased() == ProductDataModel.ProductStatus.soldOut.rawValue.lowercased()){
                
//                self.btViewChat.isEnabled = false
//                self.layout_Bottom_viFooter.constant = -40
                self.btViewChat.isEnabled = true
                self.layout_Bottom_viFooter.constant = 0
                self.btViewChat.setTitle("View Chats", for: UIControlState.normal)
                
            }else if(self.myProductData.product_status.lowercased() == ProductDataModel.ProductStatus.chating.rawValue.lowercased()){
                self.btViewChat.isEnabled = true
                self.layout_Bottom_viFooter.constant = 0
                
                
                if(self.myData.userInfo.uid == self.myProductData.uid){
                    self.btViewChat.setTitle("View Chats", for: UIControlState.normal)
                }else{
                    self.btViewChat.setTitle("Chat", for: UIControlState.normal)
                }
                
            }else if(self.myProductData.product_status.lowercased() == ProductDataModel.ProductStatus.offering.rawValue.lowercased()){
                self.btViewChat.isEnabled = true
                self.layout_Bottom_viFooter.constant = 0
                
                if(self.myData.userInfo.uid == self.myProductData.uid){
                    self.btViewChat.setTitle("View Offer", for: UIControlState.normal)
                }else{
                    self.btViewChat.setTitle("Chat", for: UIControlState.normal)
                }
                
            }else if(self.myProductData.product_status.lowercased() == ProductDataModel.ProductStatus.noOfferYet.rawValue.lowercased()){
                
                self.btViewChat.isEnabled = true
                self.layout_Bottom_viFooter.constant = 0
                
                if(self.myData.userInfo.uid == self.myProductData.uid){
                    self.btViewChat.setTitle("No Offer Yet", for: UIControlState.normal)
                }else{
                    self.btViewChat.setTitle("Chat", for: UIControlState.normal)
                }
                
            }else{
                self.btViewChat.isEnabled = false
                self.layout_Bottom_viFooter.constant = -40
            }
            
        }
        
        
        
        
        if(self.myData.userInfo != nil){
            if(self.myData.userInfo.uid == self.myProductData.uid){
                self.displayMode = .selling
            }else{
                self.displayMode = .buying
            }
        }
        
        
        //self.view.updateConstraints()
        //self.view.layoutIfNeeded()
        
        if(self.myData.userInfo != nil){
            //likeQueue
            
            let newAddView:AddViewCountOperation = AddViewCountOperation(userID: self.myData.userInfo.uid, productID: self.myProductData.product_id)
            
            self.likeQueue.addOperation(newAddView)
            
            
        }
        
        
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
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVC_CancelSearch.rawValue), object: nil, userInfo: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.ChangeToLikeButton.rawValue), object: nil, userInfo: nil)
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        showTapBar(show: false)
        
        
        self.getSellerData()
        
        if(self.haveGotoChat == true){
            self.haveGotoChat = false
            self.pullToRefresh()
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
    func pullToRefresh() {
        
        //self.refeshData()
        
        getProductDataWith(ProductID: self.myProductData.product_id) { (product) in
            
            self.myProductData = product
            self.getSellerData()
            self.reloadDisplay()
            
        }
        
    }
    
    
    func reloadDisplay() {
        
        
        if(self.myProductData != nil){
            self.arImageName.removeAll()
            self.lbTitle.text = self.myProductData.title
            
            for im in self.myProductData.images{
                
                
                self.arImageName.append(im)
                
            }
            
        }
        
        
        //----------
        self.arSection.removeAll()
        
        
        for i in 0..<mySetting.arProductDetail.count{
            let pro = mySetting.arProductDetail[i]
            let newSection:CellSectionCustom = CellSectionCustom()
            
            newSection.section = i
            newSection.cellType = pro.type
            newSection.title = pro.title
            newSection.isEnable = pro.isActive
            
            switch pro.type {
            case ProductCellPosition.CellType.product_image.rawValue:
                
                newSection.arCellName.append(CellName.image.rawValue)
                break
            case ProductCellPosition.CellType.profile.rawValue:
                
                newSection.arCellName.append(CellName.meetTheSeller.rawValue)
                self.numberSectionOfMeetTheSeller = i
                
                
                
                break
            case ProductCellPosition.CellType.description.rawValue:
                
                
                newSection.arCellName.append(CellName.title.rawValue)
                newSection.arCellName.append(CellName.manufacturer.rawValue)
                newSection.arCellName.append(CellName.model.rawValue)
                newSection.arCellName.append(CellName.price.rawValue)
                newSection.arCellName.append(CellName.year.rawValue)
                newSection.arCellName.append(CellName.country.rawValue)
                newSection.arCellName.append(CellName.category.rawValue)
                newSection.arCellName.append(CellName.productId.rawValue)
                newSection.arCellName.append(CellName.condition.rawValue)
                newSection.arCellName.append(CellName.points.rawValue)
                newSection.arCellName.append(CellName.description.rawValue)
                
                self.serialStartAtRow = 10
                if(self.myProductData != nil){
                    for _ in self.myProductData.product_serials{
                        newSection.arCellName.append(CellName.serial.rawValue)
                    }
                }
                
                
                break
            case ProductCellPosition.CellType.map.rawValue:
                newSection.arCellName.append(CellName.map.rawValue)
                
                break
            default:
                break
            }
            
            
            if(pro.isActive == true){
                
                if(pro.type == ProductCellPosition.CellType.product_image.rawValue){
                    if(self.arImageName.count > 0){
                        self.arSection.append(newSection)
                    }
                }else{
                    self.arSection.append(newSection)
                }
                
            }
            
        }
        
        
        
        
        //----------
        
     
        
        
        
        
        
        self.lbTitle.text = strTitle
        
        
        
        
        
        var strCat:String = ""
        
        
        for cat1 in self.myData.arCategoriesDataModel{
            
            if(cat1.category_id == self.myProductData.category1){
                strCat = cat1.category_name
                
                for cat2 in cat1.subCategory.values{
                    if(cat2.sub_category_id == self.myProductData.category2){
                        strCat = String(format: "%@ - %@", strCat, cat2.sub_category_name)
                        break
                    }
                }
                
                break
            }
            
        }
        
        self.strCategory = strCat
        
        
        
        if(self.myProductData.isNew == true){
            self.strIsNew = "NEW"
        }else{
            self.strIsNew = "USED"
        }
        
      
        
        
        print("\(self.myProductData.product_id) :  \(self.myProductData.product_status)")
        
        
        
        
        if(self.myData.userInfo == nil){
            self.btViewChat.isEnabled = false
            self.layout_Bottom_viFooter.constant = -40
        }else{
            
            
            if(self.myProductData.product_status.lowercased() == ProductDataModel.ProductStatus.soldOut.rawValue.lowercased()){
                
                self.btViewChat.isEnabled = true
                self.layout_Bottom_viFooter.constant = 0
                self.btViewChat.setTitle("View Chats", for: UIControlState.normal)
                
            }else if(self.myProductData.product_status.lowercased() == ProductDataModel.ProductStatus.chating.rawValue.lowercased()){
                self.btViewChat.isEnabled = true
                self.layout_Bottom_viFooter.constant = 0
                
                
                if(self.myData.userInfo.uid == self.myProductData.uid){
                    self.btViewChat.setTitle("View Chats", for: UIControlState.normal)
                }else{
                    self.btViewChat.setTitle("Chat", for: UIControlState.normal)
                }
                
            }else if(self.myProductData.product_status.lowercased() == ProductDataModel.ProductStatus.offering.rawValue.lowercased()){
                self.btViewChat.isEnabled = true
                self.layout_Bottom_viFooter.constant = 0
                
                if(self.myData.userInfo.uid == self.myProductData.uid){
                    self.btViewChat.setTitle("View Offer", for: UIControlState.normal)
                }else{
                    self.btViewChat.setTitle("Chat", for: UIControlState.normal)
                }
                
            }else if(self.myProductData.product_status.lowercased() == ProductDataModel.ProductStatus.noOfferYet.rawValue.lowercased()){
                
                self.btViewChat.isEnabled = true
                self.layout_Bottom_viFooter.constant = 0
                
                if(self.myData.userInfo.uid == self.myProductData.uid){
                    self.btViewChat.setTitle("No Offer Yet", for: UIControlState.normal)
                }else{
                    self.btViewChat.setTitle("Chat", for: UIControlState.normal)
                }
                
            }else{
                self.btViewChat.isEnabled = false
                self.layout_Bottom_viFooter.constant = -40
            }
            
        }
        
        
        
        
        if(self.myData.userInfo != nil){
            if(self.myData.userInfo.uid == self.myProductData.uid){
                self.displayMode = .selling
            }else{
                self.displayMode = .buying
            }
        }
        
        
    
        self.myTable.reloadData()
        
        self.refreshControl.endRefreshing()
    }

    // MARK: - Activity
    
    
    
    func addActivityView(Finish finish:@escaping ()->Void){
        
        if(self.myActivityView == nil){
            myActivityView = ActivityLoadingView(frame: CGRect(x: 0, y: 47, width: screenSize.width, height: screenSize.height - 47))
            myActivityView.alpha = 0
            self.view.addSubview(myActivityView)
            self.view.bringSubview(toFront: self.viTopBar)
            
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
    
    
    
    // MARK: - Action
    
    
    
    func loadChatRoom(finish:@escaping ()->Void){
        
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
                            arRoomM.append(newRoom)
                            
                            
                        }
                    }
                    
                }
                
                
                self.arRoom = arRoomM.sorted(by: { (obj1, obj2) -> Bool in
                    
                    return obj1.updatedAt_Date < obj2.updatedAt_Date
                })
                
                
                
                //--------------
                
                
                
                
                self.myTable.reloadData()
           
                self.working = false
                
               
                
                finish()
                
                
                //--------------
            })
            
            
            
            
            
            
        }else{
        
            self.working = false
            
            finish()
        }
    }
    
    
    
    
    func gotoChatWithRoom(Room room:RoomMessagesDataModel){
        let postRef = FIRDatabase.database().reference().child("room-messages").child(room.room_id).child("isDeleteUser").child(self.myData.userInfo.uid)
        
        postRef.setValue(nil)
        
        
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:ChatRoomVC = storyboard.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
        
        
        vc.myRoom = room
        
        if(self.myProductData.uid == self.myData.userInfo.uid){
            vc.mode = .selling
        }else{
            vc.mode = .buying
        }
        
        
        if(self.myData.masterView != nil){
            self.myData.masterView.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.removeActivityView {
            
        }
    }
    
    
    func gotoChatRoom(){
        
        self.haveGotoChat = true
        
        
        self.addActivityView {
            self.loadChatRoom {
                
        
               
                var arAllChatRoom:[RoomMessagesDataModel] = [RoomMessagesDataModel]()
                
                for room in self.arRoom{
                    if(room.product_id == self.myProductData.product_id){
                        
                        arAllChatRoom.append(room)
                        
                    }
                }
                
                
                
                var countOffer:NSInteger = 0
                var atIndex:NSInteger = 0
                for i in 0..<arAllChatRoom.count{
                    let room = arAllChatRoom[i]
                    if(room.isDeleteUser.count <= 0){
                        if(room.status == .offer ){
                            countOffer += 1
                            atIndex = i
                        }
                    }
                    
                }
                
                if(countOffer == 1){
                    self.gotoChatWithRoom(Room: arAllChatRoom[atIndex])
                
                }else if(arAllChatRoom.count == 1){
                    self.gotoChatWithRoom(Room: arAllChatRoom[0])
                    
                }else{
                    //goto message VC
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
                    let vc:MessageVC = storyboard.instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
                    
                    
                    vc.displayMode = .selling
                    vc.showBackBT = true
                    vc.showOnlyProductID = self.myProductData.product_id
                    vc.comeFromProductDetail = true
                    vc.showProduct = self.myProductData
                    vc.needUpdate = true
                    vc.showOnlyOffer = false
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    self.removeActivityView {
                        
                    }
                    
                    
                }
                
            }
        }
        
        
        
        
        
        
        
        
        
    }
    @IBAction func tapOnViewChat(_ sender: UIButton) {
        
        self.haveGotoChat = true
        
        if(self.comeFromChat == true){
            if let navigation = self.navigationController{
                navigation.popViewController(animated: true)
            }
            return
        }
        
        
        
        
        
        
        
        
        if(self.myData.userInfo != nil){
            if(self.myData.userInfo.uid == self.myProductData.uid){
                //self.displayMode = .selling
                
                print("Sell mode")
                
                self.gotoChatRoom()
                
            }else{
                
                
                self.addActivityView {
                    self.loadChatRoom {
                        
                        
                        var chatRoom:RoomMessagesDataModel! = nil
                        
                        for room in self.arRoom{
                            if(room.product_id == self.myProductData.product_id){
                                chatRoom = room
                            }
                        }
                        
                        
                        
                        
                        if(chatRoom != nil){
                            
                            
                            let postRef = FIRDatabase.database().reference().child("room-messages").child(chatRoom.room_id).child("isDeleteUser").child(self.myData.userInfo.uid)
                            
                            postRef.setValue(nil)
                            
                            
                            
                            
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
                            let vc:ChatRoomVC = storyboard.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
                            
                            
                            vc.myRoom = chatRoom
                            if(self.myProductData.uid == self.myData.userInfo.uid){
                                vc.mode = .selling
                            }else{
                                vc.mode = .buying
                            }
                            
                            if(self.myData.masterView != nil){
                                self.myData.masterView.navigationController?.pushViewController(vc, animated: true)
                            }else{
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                            self.removeActivityView {
                                
                            }
                            
                        }else{
                            //Create new room
                            print("Create new room")
                            self.createChatRoom(finish: { (room) in
                                if(room.room_id.count > 0){
                                    
                                    
                                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
                                    let vc:ChatRoomVC = storyboard.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
                                    
                                    
                                    vc.myRoom = room
                                    if(self.myProductData.uid == self.myData.userInfo.uid){
                                        vc.mode = .selling
                                    }else{
                                        vc.mode = .buying
                                    }
                                    
                                    if(self.myData.masterView != nil){
                                        self.myData.masterView.navigationController?.pushViewController(vc, animated: true)
                                    }else{
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    
                                    self.removeActivityView {
                                        
                                    }
                                    
                                    
                                }else{
                                    self.removeActivityView {
                                        self.canNotConnectToServer()
                                    }
                                }
   
                            })
                            
                            
                        }
                        
                    }
                }
                
                
                
            }
        }
        
        
        
        /*
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:ChatRoomVC = storyboard.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
        
        
        vc.myRoom = self.arRoom[indexPath.row]
        vc.mode = self.displayMode
        
        if(self.myData.masterView != nil){
            self.myData.masterView.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.navigationController?.pushViewController(vc, animated: true)
        }
        */
        
        
    }
    
    
    
    
    
    func createChatRoom(finish:@escaping (_ room:RoomMessagesDataModel)->Void) {
        let dateFormatFull:DateFormatter = DateFormatter()
        dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        var newRoom:[String:Any] = [String:Any]()
        newRoom["createdAt"] = FIRServerValue.timestamp()//dateFormatFull.string(from: Date())
        newRoom["createdByUserId"] = self.myData.userInfo.uid
        
        
        /*
        var accepted:[String:Any] = [String:Any]()
        accepted[self.myData.userInfo.uid] = false
        accepted[self.myProductData.uid] = false
        
        
        newRoom["isAccepted"] = accepted
        */
        
        
        newRoom["last_message"] = ""
        newRoom["offer_price"] = ""
        newRoom["product_id"] = self.myProductData.product_id
        newRoom["receivedByUserId"] = self.myProductData.uid
        newRoom["updatedAt"] = FIRServerValue.timestamp()//dateFormatFull.string(from: Date())
        
        
        
        var unread:[String:NSInteger] = [String:NSInteger]()
        unread[self.myData.userInfo.uid] = 0
        unread[self.myProductData.uid] = 0
        newRoom["unread_count"] = unread
        
        
        let postRef = FIRDatabase.database().reference().child("room-messages").childByAutoId()
        
        let pId:String = postRef.key
        
        
        newRoom["room_id"] = pId
        
    
        
        
        postRef.updateChildValues(newRoom) { (error, ref) in
            
            if let _ = error {
                
                
                let room:RoomMessagesDataModel! = nil
            
                finish(room)
            }else{
                let room:RoomMessagesDataModel = RoomMessagesDataModel()
                room.readJsonObject(dictionary: newRoom)
               finish(room)
                
            }
        }
        
        
  
        
    }
    
    
    
    
    @IBAction func tapOnBack(_ sender: UIButton) {
        
        self.myData.bufferDetailMainVC = nil
        self.exitScene()
        
    }
    
    @IBAction func tapOnMore(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        
        //-------
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            // ...
        }
        alertController.addAction(cancelAction)
        
        
        
        //-------
        let reportAction = UIAlertAction(title: "Report listing", style: .default) { action in
            // ...
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
            let vc:ReportUserVC = storyboard.instantiateViewController(withIdentifier: "ReportUserVC") as! ReportUserVC
            vc.mode = .reportsProduct
            vc.reportToProduct = self.myProductData.product_id
            vc.reportToUserID = self.myProductData.uid
            
            self.present(vc, animated: true) {
                
            }
            
            
            
        }
        
        if(self.myData.userInfo != nil){
            if(self.myData.userInfo.uid == self.myProductData.uid){
                
                
            }else{
                alertController.addAction(reportAction)
            }
        }else{
            alertController.addAction(reportAction)
        }
       
        
        
        
        
        
        /*
        //-------
        let shareAction = UIAlertAction(title: "Share", style: .default) { action in
            // ...
        }
        alertController.addAction(shareAction)
        
        //-------
  */
        
        
        //-------
        
        if(self.myData.userInfo != nil){
            if(self.myData.userInfo.uid == self.myProductData.uid){
                
                
                let editAction = UIAlertAction(title: "Edit", style: .default) { action in
                    // ...
                    self.editProduct()
                }
                alertController.addAction(editAction)
                
                //--------------
                let deleteAction = UIAlertAction(title: "Delete Listing", style: .destructive) { action in
                    // ...
                    
                    
                    let alertControllerDelete = UIAlertController(title: "Delete Listing", message: "Are you sure to delete this listing?", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                        //self.navigationController?.popViewController(animated: true)
                        
                    
                        
                    }
                    alertControllerDelete.addAction(cancelAction)
                    
                    
                    let deleteAction = UIAlertAction(title: "Delete", style: .default) { action in
                        // ...
                        self.myData.needUpdateAfterEdit = true
                        self.deleteThisListing()
                    }
                    alertControllerDelete.addAction(deleteAction)
                    
                    
                    self.present(alertControllerDelete, animated: true, completion: nil)
                    
                    
                    
                    
                    
                }
                alertController.addAction(deleteAction)
                
                
            }else{
               
            }
        }
        
        
        
        
        
        self.present(alertController, animated: true) {
            // ...
        }
       
        
        
    }
    
    func editProduct(){
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:PostSellVC = storyboard.instantiateViewController(withIdentifier: "PostSellVC") as! PostSellVC
        //vc.arImage = self.arImageBuffer
        vc.editMode = true
        vc.userProduct = self.myProductData
        vc.useNavigater = false
        vc.callBackEditData = {(product, isRemove) in
        
        
            self.myProductData = product
            if(isRemove == true){
                self.addActivityView {
                    
                    let seconds = 0.450
                    let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        // Your code with delay
                        
                        self.exitScene()
                        
                    }
                    
                }
            }else{
                self.reloadDisplay()
            }
        
        }
        
        let nav1 = UINavigationController()
        
        nav1.viewControllers = [vc]
        vc.navigationController?.isNavigationBarHidden = true
        
        self.present(nav1, animated: true) {
            
        }
        
        
    }
    
    func deleteThisListing() {
        
        
        
        self.addActivityView {
            
            
            self.myData.startDeleteListing(product: self.myProductData, Finish: { (productDelete) in
                
                
                let postRef = FIRDatabase.database().reference().child("users").child(self.myData.userInfo.uid)
                
                postRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let value = snapshot.value as? NSDictionary{
                        
                        
                        self.myData.userInfo = UserDataModel(dictionary: value)
                        
                        
                        
                        self.finishRemove()
                        
                        
                        
                        //print(self.myData.userInfo.first_name)
                        
                    }
                    
                    
                })
                
                
            })
        }
        
    }
    
    func finishRemove(){
        
        
        self.removeActivityView {
            
            
            let alertController = UIAlertController(title: "SUCCESS!!", message: nil, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                //self.navigationController?.popViewController(animated: true)
                
                self.exitScene()
                
            }
            alertController.addAction(cancelAction)
            
            
            self.present(alertController, animated: true, completion: nil)
            
            
            
        }
        
        
        
        
    }
    
    func exitScene() {
        if let navigation = self.navigationController{
            navigation.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: {
                
            })
        }
        
        showTapBar(show: true)
    }

    
    
    
    
    
    func getCellDetailHeight(Title strTitle:String, Detail strDetail:String) -> CGFloat {
        
        var cellHeight:CGFloat = 0
        
        let ht:CGFloat = heightForView(text: strTitle, Font: self.fontSubTitle, Width: 127 ) + 16
        
        let hd:CGFloat = heightForView(text: strDetail, Font: self.fontDetail, Width: (self.screenSize.width - 190) ) + 16
        
        
        
        
        cellHeight = hd
        
        if(ht > hd){
            cellHeight = ht
        }
        
        if(strDetail.count <= 0){
            cellHeight = 0
        }
        
        
        return cellHeight
    }
    
    
    
    
    func getSellerData(){
        if(self.myProductData.uid.count > 1){
            
            getUserDataWith(UID: self.myProductData.uid, Finish: { (uData) in
                self.sellerData = uData
                
               
                if((self.numberSectionOfMeetTheSeller >= 0) && (self.numberSectionOfMeetTheSeller < self.arSection.count)){
                    
                }
                
                
                
                
                 /*
                let ind:IndexPath = IndexPath(row: 0, section: self.numberSectionOfMeetTheSeller)
                self.myTable.reloadRows(at: [ind], with: UITableViewRowAnimation.fade)
                
                */
                self.myTable.reloadData()
                
                
            })
        }
    }
    
    
    
    func canNotConnectToServer() {
        let alertController = UIAlertController(title: "Can't connect to server", message: "Please try again", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            
            
        }
        alertController.addAction(cancelAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
}




// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProductDetailVC:UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return self.arSection.count
    }
    
    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //var numberOfCell:NSInteger = 0
        
        
        if(section < self.arSection.count){
            
            
         
      
            return self.arSection[section].arCellName.count
        }
        
        return 0
    }
    
    // MARK: - Cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
   
        var cellHeight:CGFloat = 101
        
        
        var cellType:NSInteger = -1
        if(indexPath.section < self.arSection.count){
            if(indexPath.row < self.arSection[indexPath.section].arCellName.count ){
                
                cellType = self.arSection[indexPath.section].arCellName[indexPath.row]
                
                
            }
            
        }
        
        
        
        
        
        if(cellType == CellName.image.rawValue){
            cellHeight = 200
            
            
            if(self.arImageName.count <= 0){
                cellHeight = 0
            }
        }else if(cellType == CellName.title.rawValue){
            
           
            cellHeight = heightForView(text: self.myProductData.title, Font: self.fontTitle, Width: (self.screenSize.width - 50)) + 30
            
            
            
        }else if(cellType == CellName.manufacturer.rawValue){
            
           
            cellHeight = self.getCellDetailHeight(Title: "Manufacturer", Detail: self.myProductData.manufacturer)
        }else if(cellType == CellName.model.rawValue){
            
            
            cellHeight = self.getCellDetailHeight(Title: "Model", Detail: self.myProductData.model)
        }else if(cellType == CellName.price.rawValue){
            
            
            cellHeight = self.getCellDetailHeight(Title: "Price", Detail: self.mySetting.priceWithString(strPricein: self.myProductData.price))
            
        }else if(cellType == CellName.year.rawValue){
            
            
            cellHeight = self.getCellDetailHeight(Title: "Year", Detail: self.myProductData.year)
        }else if(cellType == CellName.country.rawValue){
            
            
            cellHeight = self.getCellDetailHeight(Title: "Country of Origin", Detail: self.myProductData.country)
        }else if(cellType == CellName.category.rawValue){
            

            cellHeight = self.getCellDetailHeight(Title: "Category", Detail: self.strCategory)
            
        }else if(cellType == CellName.productId.rawValue){
            
            cellHeight = self.getCellDetailHeight(Title: "Product id", Detail: self.myProductData.product_id_number)
            
        }else if(cellType == CellName.condition.rawValue){
            
            
            cellHeight = self.getCellDetailHeight(Title: "Condition", Detail: self.strIsNew)
            
        }
        else if(cellType == CellName.points.rawValue){
            
            
            cellHeight = self.getCellDetailHeight(Title: "Points", Detail: "\(self.myProductData.points)")
            
        }
        else if(cellType == CellName.description.rawValue){
            
            
            cellHeight = self.getCellDetailHeight(Title: "Description", Detail: self.myProductData.product_description)
            
        }else if(cellType == CellName.meetTheSeller.rawValue){
            
            
            cellHeight = 160
            
            if((self.sellerData.first_name.count == 0) && (self.sellerData.last_name.count == 0)){
                
                cellHeight = 0
            }
            
        }else if(cellType == CellName.map.rawValue){
            
            
            cellHeight = 220
            
            if((self.myProductData.product_latitude == 0) && (self.myProductData.product_longitude == 0)){
                
                cellHeight = 0
            }
            
        }else if(cellType == CellName.serial.rawValue){

            cellHeight = 65
            
            
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
        
        

        
        
        
        var cellType:NSInteger = -1
        if(indexPath.section < self.arSection.count){
            if(indexPath.row < self.arSection[indexPath.section].arCellName.count ){
                
                cellType = self.arSection[indexPath.section].arCellName[indexPath.row]
                
                
            }
            
        }
        
        
        
        
        
        
        if(cellType == CellName.image.rawValue){
            let cell:ImageSliderCell? = tableView.dequeueReusableCell(withIdentifier: "ImageSliderCell", for: indexPath) as? ImageSliderCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            cell?.contentView.backgroundColor = UIColor(red: (241.0/255.0), green: (241.0/255.0), blue: (241.0/255.0), alpha: 1.0)
            
            
            cell?.myTag = cellType
            
            cell?.arImageName = self.arImageName
            
            cell?.updateFrameSize(size: CGSize(width: self.screenSize.width, height: 200))
            
            
            cell?.callBackTapOnCell = {(tag, imageIndex) in
            
            
            
                if(tag == CellName.image.rawValue){
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
                    let vc:ImagePreviewVC = storyboard.instantiateViewController(withIdentifier: "ImagePreviewVC") as! ImagePreviewVC
                    vc.strTitle = self.myProductData.title
                    
                    vc.arImageName = self.arImageName
                    vc.currentPage = imageIndex
                    vc.isEditMode = false
                 
                    
                    
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            
            }
            
            
            return cell!
            
        }else if(cellType == CellName.title.rawValue){
            //PDTitleCell
            let cell:PDTitleCell? = tableView.dequeueReusableCell(withIdentifier: "PDTitleCell", for: indexPath) as? PDTitleCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            
            cell?.lbTitle.text = self.myProductData.title
            
            return cell!
        }else if(cellType == CellName.manufacturer.rawValue){
            //PDTitleCell
            let cell:PDDetailCell? = tableView.dequeueReusableCell(withIdentifier: "PDDetailCell", for: indexPath) as? PDDetailCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            
            cell?.lbTitle.text = "Manufacturer"
            cell?.lbDetail.text = self.myProductData.manufacturer
            
            return cell!
        }else if(cellType == CellName.model.rawValue){
            //PDTitleCell
            let cell:PDDetailCell? = tableView.dequeueReusableCell(withIdentifier: "PDDetailCell", for: indexPath) as? PDDetailCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            
            cell?.lbTitle.text = "Model"
            cell?.lbDetail.text = self.myProductData.model
            
            
            return cell!
            
            
        }else if(cellType == CellName.price.rawValue){
            //PDTitleCell
            let cell:PDDetailCell? = tableView.dequeueReusableCell(withIdentifier: "PDDetailCell", for: indexPath) as? PDDetailCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            
            cell?.lbTitle.text = "Price"
            cell?.lbDetail.text = self.mySetting.priceWithString(strPricein: self.myProductData.price)
            
            
            return cell!
            
            
        }else if(cellType == CellName.year.rawValue){
            //PDTitleCell
            let cell:PDDetailCell? = tableView.dequeueReusableCell(withIdentifier: "PDDetailCell", for: indexPath) as? PDDetailCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            
            cell?.lbTitle.text = "Year"
            cell?.lbDetail.text = self.myProductData.year
            
            return cell!
            
            
        }else if(cellType == CellName.country.rawValue){
            //PDTitleCell
            let cell:PDDetailCell? = tableView.dequeueReusableCell(withIdentifier: "PDDetailCell", for: indexPath) as? PDDetailCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            
            cell?.lbTitle.text = "Country of Origin"
            cell?.lbDetail.text = self.myProductData.country
            
            return cell!
            
            
        }else if(cellType == CellName.category.rawValue){
            //PDTitleCell
           
            let cell:PDDetailCell? = tableView.dequeueReusableCell(withIdentifier: "PDDetailCell", for: indexPath) as? PDDetailCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            
            cell?.lbTitle.text = "Category"
            cell?.lbDetail.text = self.strCategory
            
            return cell!
          
            
        }else if(cellType == CellName.productId.rawValue){
            //PDTitleCell
            let cell:PDDetailCell? = tableView.dequeueReusableCell(withIdentifier: "PDDetailCell", for: indexPath) as? PDDetailCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            
            cell?.lbTitle.text = "Product id"
            cell?.lbDetail.text = self.myProductData.product_id_number
            
            return cell!
            
            
        }else if(cellType == CellName.condition.rawValue){
            //PDTitleCell
            let cell:PDDetailCell? = tableView.dequeueReusableCell(withIdentifier: "PDDetailCell", for: indexPath) as? PDDetailCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            
            cell?.lbTitle.text = "Condition"
            cell?.lbDetail.text = strIsNew
            
            return cell!
            
        }
        else if(cellType == CellName.points.rawValue){
            //PDTitleCell
            let cell:PDDetailCell? = tableView.dequeueReusableCell(withIdentifier: "PDDetailCell", for: indexPath) as? PDDetailCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            
            cell?.lbTitle.text = "Points"
            cell?.lbDetail.text = "\(self.myProductData.points)"
            
            return cell!
            
        }
        else if(cellType == CellName.description.rawValue){
            //PDTitleCell
            let cell:PDDetailCell? = tableView.dequeueReusableCell(withIdentifier: "PDDetailCell", for: indexPath) as? PDDetailCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            
            cell?.lbTitle.text = "Description"
            cell?.lbDetail.text = self.myProductData.product_description
            
            return cell!
            
        }else if(cellType == CellName.meetTheSeller.rawValue){
            //PDTitleCell
            let cell:MeetTheSellerCell? = tableView.dequeueReusableCell(withIdentifier: "MeetTheSellerCell", for: indexPath) as? MeetTheSellerCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            
            
            cell?.layzyImage.loadImage(imageURL: sellerData.profileImage_src, Thumbnail: true)
            
            cell?.lbName.text = String(format: "%@ %@", sellerData.first_name, sellerData.last_name)
            
            cell?.lbDetail.text = String(format: "Joined %@", dateFormatFull.string(from: sellerData.created_at_Date))
            
            
            var positive:NSInteger = 0
            for pos in self.sellerData.positive_list{
                positive += pos.arUser_Uid.count
            }
            cell?.lbSmile.text = String(format: "%d", positive)
            
            
            var neutral:NSInteger = 0
            for neu in self.sellerData.neutral_list{
                neutral += neu.arUser_Uid.count
            }
            cell?.lbNormal.text = String(format: "%d", neutral)
            
            
            
            var negative:NSInteger = 0
            for nega in self.sellerData.negative_list{
                negative += nega.arUser_Uid.count
            }
            cell?.lbSad.text = String(format: "%d", negative)
            
        
            return cell!
            
        }else if(cellType == CellName.map.rawValue){
          
            let cell:MapCell? = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as? MapCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            
            
            if((self.myProductData.product_latitude == 0) && (self.myProductData.product_longitude == 0)){
                
                cell?.removePin()
            }else{
                cell?.latitude = CGFloat(self.myProductData.product_latitude)
                cell?.longitude = CGFloat(self.myProductData.product_longitude)
                
                cell?.title = self.myProductData.product_location
                
                cell?.addPin()
                
            }
            
            cell?.myMap.isUserInteractionEnabled = false
            
            return cell!
        }else if(cellType == CellName.serial.rawValue){
            //PDTitleCell
            let cell:SerialNoCell? = tableView.dequeueReusableCell(withIdentifier: "SerialNoCell", for: indexPath) as? SerialNoCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            let serialIndex:NSInteger = indexPath.row - self.serialStartAtRow
            if((serialIndex >= 0) && (serialIndex < self.myProductData.product_serials.count) ){
                
                let item = self.myProductData.product_serials[serialIndex]
                cell?.lbSerialNo.text = item.serial_Title
                cell?.lbAmount.text = "\(item.amount)"
                
            }
            
            
            
            cell?.lbTitle.text = "Serial No."
           
            
            return cell!
            
        }
        
        
        
        
        
        
        
        let cell:EmptyCell? = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as? EmptyCell
        cell?.selectionStyle = .none
        cell?.clipsToBounds = true
        cell?.tag = indexPath.row
        
        
        
        
        return cell!
        
    }
    
    // MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var cellType:NSInteger = -1
        if(indexPath.section < self.arSection.count){
            if(indexPath.row < self.arSection[indexPath.section].arCellName.count ){
                
                cellType = self.arSection[indexPath.section].arCellName[indexPath.row]
                
                
            }
            
        }
        
        
        if(cellType == CellName.meetTheSeller.rawValue){

            let name = String(format: "%@ %@", sellerData.first_name, sellerData.last_name)
            
            
            if(sellerData.uid == ""){
                self.myTable.deselectRow(at: indexPath, animated: true)
                return
            }
            
            
            
            
            print(name)
            
            
            if((self.myData.masterView.thisUserForCheckInProductDetail == .toProfile) && (self.thisFirstDetail == false)){
                self.exitScene()
                
            }else{
                self.myData.bufferDetailMainVC = self
                self.myData.masterView.thisUserForCheckInProductDetail = .toProfile
                
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
                let vc:UserMainSceneVC = storyboard.instantiateViewController(withIdentifier: "UserMainSceneVC") as! UserMainSceneVC
                
                vc.sellerMode = sellerData.uid
                vc.seller = sellerData
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
           
        }else if(cellType == CellName.map.rawValue){
            
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
            let vc:FullMapVC = storyboard.instantiateViewController(withIdentifier: "FullMapVC") as! FullMapVC
            
         
            vc.latitude = CGFloat(self.myProductData.product_latitude)
            vc.longitude = CGFloat(self.myProductData.product_longitude)
            vc.myTitle = self.myProductData.product_location
            
            
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            
          
        }
        
        
        
        
        self.myTable.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    
}






