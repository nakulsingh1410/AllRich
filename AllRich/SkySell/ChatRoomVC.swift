//
//  ChatRoomVC.swift
//  SkySell
//
//  Created by DW02 on 6/7/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift


class DateChatSection{
    var title:String = ""
    var date:Date = Date()
    var messages:[RealmMessageDataObject] = [RealmMessageDataObject]()
}
class ChatRoomVC: UIViewController {

    enum RoomStatus{
        case buy_Feed0_Make1
        case buy_Feed0_Cancel1
        case buy_Feed1_Cancel0
        case sell_Accept0_Feed0
        case sell_Accept1_decline1
        case sell_Accept0_Feed1
    }
    
    var myRoomStatus:RoomStatus = .buy_Feed0_Make1
    
    
    
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    
    
    @IBOutlet weak var viTopbarBG: UIView!
    @IBOutlet weak var btBack: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    
    
    @IBOutlet weak var myTable: UITableView!
    
    @IBOutlet weak var layer_TableBottom: NSLayoutConstraint!
    
    @IBOutlet weak var lbProductName: UILabel!
    
    @IBOutlet weak var lbProductPrice: UILabel!
    
    
    @IBOutlet weak var layout_HeightProductCell: NSLayoutConstraint!
    
    @IBOutlet weak var layOut_TopProductCell: NSLayoutConstraint!
    
    
    @IBOutlet weak var viProductBG: UIView!
    @IBOutlet weak var viProductImageBG: UIView!
    var lazyImageProduct:PKImV3View! = nil
    
    
    
    @IBOutlet weak var viFeedbackBG: UIView!
    
    @IBOutlet weak var btLeaveFeedback: UIButton!
    @IBOutlet weak var btMakeOffer: UIButton!
    
    
    @IBOutlet weak var btProductDetail: UIButton!
    
    
    @IBOutlet weak var btMore: UIButton!
    
    
    
    
    
    var myData:ShareData = ShareData.sharedInstance
    var mySetting:SettingData = SettingData.sharedInstance
    
    
    
    var myRoom:RoomMessagesDataModel! = nil
    var mode:MessageVC.ChatMode = .selling
    
    
    let fontProductName:UIFont = UIFont(name: "Avenir-Medium", size: 16)!
    let fontPriceName:UIFont = UIFont(name: "Avenir-Medium", size: 20)!
    
    
    
    
    var myActivityView:ActivityLoadingView! = nil
    var working:Bool = false
    var haveNoti:Bool = false
    
    
    var myMessage:[DateChatSection] = [DateChatSection]()
    
    var haveConnection:Bool = false
    
    
    var lastIndexShow:IndexPath = IndexPath(row: 0, section: 0)
    
    
    var viKeyBoardAccessoryText:UIView! = nil
    var btSendMessage:UIButton! = nil
    var btSendImage:UIButton! = nil
    var viInputBG:UIView! = nil
    var tfInput:UITextView! = nil
    var strMessage:String = ""
    
    
    
    
    
    
    
    var keuboardHeight:CGFloat = 0
    
    var inPutViewHeight:CGFloat = 44
    
    
    let textFont:UIFont = UIFont(name: "Avenir-Roman", size: 14)!
    let timeFont:UIFont = UIFont(name: "Avenir-Roman", size: 9)!
    
    
    let dateFormatTimeStamp:DateFormatter = DateFormatter()
    let dateFormatDateHeader:DateFormatter = DateFormatter()
    
    
    var bufferUserData:[UserDataModel] = [UserDataModel]()
    
    var arImageBuffer:[PostImageObject] = [PostImageObject]()
    
    
    
    var storageRef: FIRStorageReference!
    
    var imageUploadWorking:PostImageObject! = nil
    
    var uploading:Bool = false
    
    var openNumPad:Bool = false
    
    
    var haveConnect:Bool = false
    
    
    
    
    let pinkColor:UIColor = UIColor(red: (3/255), green: (210/255), blue: (99/255), alpha: 1.0)
    
    let grayColor:UIColor = UIColor(red: (155/255), green: (155/255), blue: (155/255), alpha: 1.0)
    let darkGrayColor:UIColor = UIColor(red: (54/255), green: (54/255), blue: (54/255), alpha: 1.0)
    
    
    let likeQueue = OperationQueue()
    
    
    
    
    var viewIsShowing:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [START configurestorage]
        storageRef = FIRStorage.storage().reference()
        
        
        
        
        dateFormatTimeStamp.dateFormat = "HH:mm"
        dateFormatTimeStamp.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        dateFormatDateHeader.dateFormat = "EEEE MMMM dd, yyyy"
        dateFormatDateHeader.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        

        self.viTopbarBG.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viTopbarBG.layer.shadowRadius = 1
        self.viTopbarBG.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viTopbarBG.layer.shadowOpacity = 0.5
        self.viTopbarBG.clipsToBounds = false
        
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        
        
        
        
        self.viProductBG.clipsToBounds = false
        self.viProductBG.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viProductBG.layer.shadowRadius = 1
        self.viProductBG.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viProductBG.layer.shadowOpacity = 0.5
        
        
        self.viProductImageBG.clipsToBounds = true
        self.viProductImageBG.layer.cornerRadius = 2
        self.lazyImageProduct = PKImV3View(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
        self.viProductImageBG.addSubview(self.lazyImageProduct)
        
        
        
        self.lbTitle.text = ""
        
        
        self.btLeaveFeedback.clipsToBounds = true
        self.btLeaveFeedback.layer.cornerRadius = 18
        
        self.btMakeOffer.clipsToBounds = true
        self.btMakeOffer.layer.cornerRadius = 18
        
        
        self.viKeyBoardAccessoryText = UIView(frame: CGRect(x: 0, y: (self.screenSize.height - 44), width: self.screenSize.width, height: 44))
        self.viKeyBoardAccessoryText.backgroundColor = UIColor(red: (241/255), green: (241/255), blue: (241/255), alpha: 1.0)
        
        
        self.btSendMessage = UIButton(frame: CGRect(x: self.screenSize.width - (8 + 60), y: 4, width: 60, height: 36))
        self.btSendMessage.setTitle("Send", for: UIControlState.normal)
        self.btSendMessage.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 14)
        self.btSendMessage.clipsToBounds = true
        self.btSendMessage.layer.cornerRadius = 18
        self.btSendMessage.layer.borderColor = self.pinkColor.cgColor
        self.btSendMessage.layer.borderWidth = 1
        self.btSendMessage.setTitleColor(self.pinkColor, for: UIControlState.normal)
        self.btSendMessage.addTarget(self, action: #selector(tapOnSend(_:)), for: UIControlEvents.touchUpInside)
        
        
        
        let imageCamera:UIImage = UIImage(named: "iconCamera.png")!
        self.btSendImage = UIButton(frame: CGRect(x: 8, y: 4, width: 36, height: 36))
        self.btSendImage.setImage(imageCamera, for: UIControlState.normal)
        self.btSendImage.addTarget(self, action: #selector(tapOnSendImage(_:)), for: UIControlEvents.touchUpInside)
        
        
        
        
        
        self.viInputBG = UIView(frame: CGRect(x: 52, y: 4, width: self.screenSize.width - (60 + 68), height: 36))
        self.viInputBG.backgroundColor = UIColor.white
        self.viInputBG.layer.cornerRadius = 18
        self.viInputBG.layer.borderWidth = 1
        self.viInputBG.layer.borderColor = self.pinkColor.cgColor
        
        
        self.tfInput = UITextView(frame: CGRect(x: 8, y: 4, width: self.screenSize.width - (60 + 68 + 16), height: 28))
        self.viInputBG.addSubview(self.tfInput)
        self.tfInput.font = self.textFont
        //self.tfInput.placeholder = "Type here…"
        self.tfInput.textColor = UIColor(red: (39/255), green: (47/255), blue: (85/255), alpha: 1.0)
      
        self.tfInput.delegate = self
        
            
        
        
        self.viKeyBoardAccessoryText.addSubview(self.btSendMessage)
        self.viKeyBoardAccessoryText.addSubview(self.btSendImage)
        self.viKeyBoardAccessoryText.addSubview(self.viInputBG)

        self.view.addSubview(self.viKeyBoardAccessoryText)
       
        
        
        
                
        
        
        
        
        
        
        
        
        
        
        do{
            let nib:UINib = UINib(nibName: "ChatDateTitleCell", bundle: nil)
            self.myTable.register(nib, forHeaderFooterViewReuseIdentifier: "ChatDateTitleCell")
        }
        
        
        
        do{
            let nib:UINib = UINib(nibName: "AnotherMessageCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "AnotherMessageCell")
        }
        
        
        
        do{
            let nib:UINib = UINib(nibName: "OwnerMessageCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "OwnerMessageCell")
        }
        
        
        do{
            let nib:UINib = UINib(nibName: "AnotherImageCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "AnotherImageCell")
        }
        
        do{
            let nib:UINib = UINib(nibName: "OwnerImageCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "OwnerImageCell")
        }
        
        
        
        do{
            let nib:UINib = UINib(nibName: "AnotherOfferCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "AnotherOfferCell")
        }
        
        do{
            let nib:UINib = UINib(nibName: "OwnerOfferCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "OwnerOfferCell")
        }
        
        
        
        
        self.myTable.delegate = self
        self.myTable.dataSource = self
 
        
        if((self.screenSize.width == 375) && (self.screenSize.height == 812)){
            self.keuboardHeight = 34
            
       
            self.updateInputView()
        }
        
        if(self.myRoom != nil){
            self.updateDisPlayTopBar()
            self.disPlayUserDetail()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        //showTapBar(show: false)
        self.viewIsShowing = true
        
        
        if(self.myRoom != nil){
            let dateFormatFull:DateFormatter = DateFormatter()
            dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let timeStamp = dateFormatFull.string(from: Date())
            
            
            
            self.sendTimeStampToAnotherUser(Receiver_uid: self.myRoom.receivedByUserId, Timestamp: timeStamp)
            self.sendTimeStampToAnotherUser(Receiver_uid: self.myRoom.createdByUserId, Timestamp: timeStamp)
            
            
            
            
            
            
            if(self.myRoom.product == nil){
                self.loadProductDataWith(ProductId: self.myRoom.product_id, Finish: { (arProduct) in
                    if(arProduct.count > 0){
                        self.myRoom.product = arProduct[0]
                        self.updateDisPlayTopBar()
                    }
                })
            }
            
            
            
            
            
            
            
            if(self.myMessage.count <= 0){
                
                self.addActivityView {
                    self.loadChatRoom(Finish: { (chatData) in
                   
                        self.readChatData(chatData: chatData)
                        
                        
                        
                    })
                }
            }
            
            
            if(self.haveConnection == false){
                
                self.connectToChatRoom(Finish: { (chatData) in
               
                    self.readChatData(chatData: chatData)
                })
            }
        }
        
        
        
        
        if(self.haveNoti == false){
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
            
            self.haveNoti = true
        }
        
        
        
        self.getRoomData()
        
        
    }
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.viewIsShowing = false
        
        
        self.haveConnection = false
        
        if(self.haveNoti == true){
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
            self.haveNoti = false
        }
        
    }
    
    
    
    
    
    
    func readChatData(chatData:NSDictionary) {
        
        
        
        let allKeys = chatData.allKeys
        
        
        let realm = try! Realm()
        try! realm.write {
            
            
            for key in allKeys{
                if let key = key as? String{
                    
                    
                    if let value = chatData.object(forKey: key) as? NSDictionary{
                        let newMessage:RealmMessageDataObject = RealmMessageDataObject()
                        newMessage.readJson(dictionary: value)
                        newMessage.messageID = key
                        newMessage.room_id = self.myRoom.room_id
                        realm.add(newMessage, update: true)
                        
                        
                    }
                    
                    
                    
                }
            }
        }
        
        
        let today:Date = Date()
        var dayComponent:DateComponents = DateComponents()
        dayComponent.day = -45
        let calendar:Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let lastDate:Date = calendar.date(byAdding: dayComponent, to: today)!
        
        let nDate:NSDate = NSDate(timeIntervalSince1970: lastDate.timeIntervalSince1970)
        
        // Query using an NSPredicate
        let predicate = NSPredicate(format: "timestamp_Date >= %@ AND room_id = %@", nDate, self.myRoom.room_id)
        //let predicate = NSPredicate(format: "room_id = %@", self.myRoom.room_id)
        let arMessate = realm.objects(RealmMessageDataObject.self).filter(predicate).sorted(byKeyPath: "timestamp_Date", ascending: true)
        
        print("Data count")
        print(arMessate.count)
        print("=======")
        
        let dateFormatFull:DateFormatter = DateFormatter()
        dateFormatFull.dateFormat = "yyyy-MM-dd"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        var haveNewMessage:Bool = false
        var arIndex:[IndexPath] = [IndexPath]()
        
        var countSection:NSInteger = 0
        var laseSection:NSInteger = 0
        for m in arMessate{
            let strdate = dateFormatFull.string(from: Date(timeIntervalSince1970: m.timestamp_Date.timeIntervalSince1970))
            
            var haveSection:Bool = false
            for secion in self.myMessage{
                if(secion.title == strdate){
                    haveSection = true
                    
                    var haveMess:Bool = false
                    
                    for mess in secion.messages{
                 
                        if(mess.messageID == m.messageID){
                            haveMess = true
                        }
                    }
                    
                    if(haveMess == false){
                        
                        let atIndex:IndexPath = IndexPath(row: secion.messages.count, section: laseSection)
                        arIndex.append(atIndex)
                        
                        secion.messages.append(m)
                        haveNewMessage = true
                        
                        
                    }
                    
                    break
                }
                
                
            }
            
            
            if(haveSection == false){
                
                let newSection:DateChatSection = DateChatSection()
                newSection.date = Date(timeIntervalSince1970: m.timestamp_Date.timeIntervalSince1970)
                newSection.title = strdate
                
                let atIndex:IndexPath = IndexPath(row: newSection.messages.count, section: countSection)
                arIndex.append(atIndex)
                
                
                
                newSection.messages.append(m)
                self.myMessage.append(newSection)
                haveNewMessage = true
                countSection += 1
                laseSection = countSection - 1
            }
            
            
        }
        
        
        print("All section :\(countSection)")
        print(arIndex)
        
        
        if(haveNewMessage == true){
            //self.myTable.reloadRows(at: arIndex, with: UITableViewRowAnimation.fade)
            //self.myTable.beginUpdates()
            //self.myTable.insertRows(at: arIndex, with: .automatic)
            //self.myTable.endUpdates()
            
            self.myTable.reloadData()
            
            
            let lastSection = self.myMessage.count - 1
            if(lastSection >= 0){
                let lastRow = self.myMessage[lastSection].messages.count - 1
                
                if(lastRow >= 0){
                    let lastIndex:IndexPath = IndexPath(row: lastRow, section: lastSection)
                    self.myTable.scrollToRow(at: lastIndex, at: UITableViewScrollPosition.bottom, animated: true)
                    
                }
            }
            //self.myTable.reloadData()
            //self.myTable.scrollToRow(at: arIndex.last!, at: UITableViewScrollPosition.bottom, animated: true)
        }
       
        
        
        
        for i in 0..<self.myMessage.count{
            let day = self.myMessage[i]
            
            for j in 0..<day.messages.count{
                let message = day.messages[j]
                
                self.updateMessageToRead(messageID: message.messageID)

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
    
    @IBAction func tapOnMore(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let reportAction = UIAlertAction(title: "Report user", style: .default) { action in
            // ...
            
            self.openReportUser()
            
        }
        alertController.addAction(reportAction)
        
        
        let deleteAction = UIAlertAction(title: "Delete Chat", style: .default) { action in
            // ...
            self.openDeleteChat()
            
        }
        alertController.addAction(deleteAction)
        
        
        

        
        self.present(alertController, animated: true) {
            // ...
        }
    }
    
    
    func openReportUser() {
        //ReportUserVC
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:ReportUserVC = storyboard.instantiateViewController(withIdentifier: "ReportUserVC") as! ReportUserVC
        vc.mode = .reportsUser
        vc.reportToUserID = self.myRoom.receivedByUserId
        
        
        self.present(vc, animated: true) { 
            
        }
        
    }
    
    func openDeleteChat(){
        
        let strTitle:String = "Delete Chat"
        
        let detail:String = "This will remove that chat thread. You cannot undo this, but your chat history will reappear if the other user messages you on the same listing."
        
   
        
        
        let alertController = UIAlertController(title: strTitle, message: detail, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            
        }
        alertController.addAction(cancelAction)
        
        
        let sendAction = UIAlertAction(title: "Delete Chat", style: .default) { (action) in
            
            self.addActivityView {
                
                ///delete
                
                let postRefDelete = FIRDatabase.database().reference().child("room-messages").child(self.myRoom.room_id).child("isDeleteUser").child(self.myData.userInfo.uid)
                postRefDelete.setValue(true)
                
                let seconds = 2.450
                
                
                let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.removeActivityView {
                        
                        self.exitScene()
                    }
                }
                
            }
            
            
        }
        alertController.addAction(sendAction)
        
        
        
        self.present(alertController, animated: true, completion: nil)

        
        
    }
    
    
    @IBAction func tapOnBack(_ sender: UIButton) {
        
        self.exitScene()
    }
    
    
    
    
    func exitScene() {
        showTapBar(show: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func updateDisPlayTopBar(){
        if(self.myRoom != nil){
            
            
            if(self.myRoom.product != nil){
                self.lbProductName.text = self.myRoom.product.title
                if(self.myRoom.product.price.count > 0){
                    self.lbProductPrice.text = self.mySetting.priceWithString(strPricein: self.myRoom.product.price)
                }else{
                    self.lbProductPrice.text = ""
                }
                
                self.lazyImageProduct.loadImage(imageURL: self.myRoom.product.image_src, Thumbnail: true)
                
                let space:CGFloat = 15 + 15 + 65 + 8 + 10
                let pNameH:CGFloat = heightForView(text: self.myRoom.product.title, Font: self.fontProductName, Width: self.screenSize.width - space)
                let pPriceH:CGFloat = heightForView(text: self.mySetting.priceWithString(strPricein: self.myRoom.product.price), Font: self.fontProductName, Width: self.screenSize.width - space)
                
                
                var h:CGFloat = pNameH + pPriceH + (15 + 8 + 15)
                if(h < 96){
                    h = 96
                }
                
                
                self.layout_HeightProductCell.constant = h
                self.viProductBG.clipsToBounds = false
                UIView.animate(withDuration: 0.45, animations: {
                    self.view.updateConstraints()
                    self.view.layoutIfNeeded()
                })
                
            }else{
                self.layout_HeightProductCell.constant = 0
                self.viProductBG.clipsToBounds = true
                UIView.animate(withDuration: 0.45, animations: { 
                    self.view.updateConstraints()
                    self.view.layoutIfNeeded()
                })
                
            }
        }
    }
    
    
    
    func disPlayUserDetail() {
        
        if(self.myRoom != nil){
            if(self.mode == .buying){
                if(self.myRoom.reciveBy != nil){
                    
                    self.lbTitle.text = String(format: "%@  %@", self.myRoom.reciveBy.first_name, self.myRoom.reciveBy.last_name)
                    
                }else{
                    self.loadUserDataWith(UserID: self.myRoom.receivedByUserId, Finish: { (arUser) in
                        if(arUser.count > 0){
                            self.myRoom.reciveBy = arUser[0]
                        }
                    })
                }
            }else{
                
                if(self.myRoom.createBy != nil){
                    
                    self.lbTitle.text = String(format: "%@  %@", self.myRoom.createBy.first_name, self.myRoom.createBy.last_name)
                    
                }else{
                    self.loadUserDataWith(UserID: self.myRoom.createdByUserId, Finish: { (arUser) in
                        if(arUser.count > 0){
                            self.myRoom.createBy = arUser[0]
                        }
                    })
                }
                
                
            }
            
            
        }else{
            self.lbTitle.text = ""
        }
    }
    
    
    
    
    
    
    @IBAction func tapOnFeedback(_ sender: UIButton) {
        
        
        switch self.myRoomStatus {
        case .buy_Feed0_Make1:
            
            
            //self.btLeaveFeedback.setTitle("Leave Feedback", for: UIControlState.normal)
            //self.btLeaveFeedback.isEnabled = false
            
            
            //self.createOffer()
            
            break
        case .buy_Feed0_Cancel1:
            //self.btLeaveFeedback.setTitle("Leave Feedback", for: UIControlState.normal)
            //self.btLeaveFeedback.isEnabled = false
            
            
           
            
            break
        case .buy_Feed1_Cancel0:
            
            //self.btLeaveFeedback.setTitle("Leave Feedback", for: UIControlState.normal)
            //self.btLeaveFeedback.isEnabled = true
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
            let vc:FeedbackVC = storyboard.instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackVC
            vc.myChatRoom = self.myRoom
            self.navigationController?.pushViewController(vc, animated: true)
       
            
            break
        case .sell_Accept0_Feed0:
            
            //self.btLeaveFeedback.setTitle("Accept Offer", for: UIControlState.normal)
            //self.btLeaveFeedback.isEnabled = false
            
        
            
            
            break
        case .sell_Accept1_decline1:
            
            //Sell appe
            
            let priceUSer:Double? = Double(self.myRoom.offer_price)
            if let priceUSer = priceUSer{
                
                
                print("\(priceUSer) \(self.mySetting.displayCurrency)")
                //Create Offer
                let convertToserver = self.mySetting.exchangeToServerCurrency(amount: priceUSer)
                
                print("\(convertToserver) \(self.mySetting.serverCurrency)")
                
                let pserver:String = String(format: "%.06f", convertToserver)
                
                
                
                
                ///--------------------------
                
                let alertController = UIAlertController(title: "Confirm accept offer?", message: nil, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    
                }
                alertController.addAction(cancelAction)
                
                
                let submitAction = UIAlertAction(title: "Accept Offer", style: .default) { (action) in

                    self.sendMessageToServer(message: pserver, MessageType: "accept_offer")

                    
                    
                    
                    
                    
                    
                    
                }
                alertController.addAction(submitAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                ///--------------------------
                
                
                
                
            }
            
            
            
            
            
            
            //self.btLeaveFeedback.setTitle("Accept Offer", for: UIControlState.normal)
            //self.btLeaveFeedback.isEnabled = true
            
   
            
            break
        case .sell_Accept0_Feed1:
            
            //self.btLeaveFeedback.setTitle("Accept Offer", for: UIControlState.normal)
            //self.btLeaveFeedback.isEnabled = false
            
           
            break
        }
        
        
    }
    
    @IBAction func tapOnMakeoffer(_ sender: UIButton) {
        switch self.myRoomStatus {
        case .buy_Feed0_Make1:
            
            
  
            
            self.createOffer()
            //self.btMakeOffer.setTitle("Make Offer", for: UIControlState.normal)
            //self.btMakeOffer.isEnabled = true
            
            break
        case .buy_Feed0_Cancel1:

            //self.btMakeOffer.setTitle("Cancel Offer", for: UIControlState.normal)
            //self.btMakeOffer.isEnabled = true
            
            let priceUSer:Double? = Double(self.myRoom.offer_price)
            if let priceUSer = priceUSer{
                
                
                print("\(priceUSer) \(self.mySetting.displayCurrency)")
                //Create Offer
                let convertToserver = self.mySetting.exchangeToServerCurrency(amount: priceUSer)
                
                print("\(convertToserver) \(self.mySetting.serverCurrency)")
                
                let pserver:String = String(format: "%.06f", convertToserver)
                
                
                
                ///--------------------------
                
                let alertController = UIAlertController(title: "Confirm cancel offer?", message: nil, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    
                }
                alertController.addAction(cancelAction)
                
                
                let submitAction = UIAlertAction(title: "Cancel Offer", style: .default) { (action) in
                    
                   self.sendMessageToServer(message: pserver, MessageType: "cancel_offer")
                    
                }
                alertController.addAction(submitAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                ///--------------------------
                
                
                
                
                
                
            }
            
            
            
            
            break
        case .buy_Feed1_Cancel0:
            

            //self.btMakeOffer.setTitle("Cancel Offer", for: UIControlState.normal)
            //self.btMakeOffer.isEnabled = false
            
            break
        case .sell_Accept0_Feed0:

            //self.btMakeOffer.setTitle("Leave Feedback", for: UIControlState.normal)
            //self.btMakeOffer.isEnabled = false
            
            
            break
        case .sell_Accept1_decline1:

            //Sell tap Decli
            
            let priceUSer:Double? = Double(self.myRoom.offer_price)
            if let priceUSer = priceUSer{
                
                
                print("\(priceUSer) \(self.mySetting.displayCurrency)")
                //Create Offer
                let convertToserver = self.mySetting.exchangeToServerCurrency(amount: priceUSer)
                
                print("\(convertToserver) \(self.mySetting.serverCurrency)")
                
                let pserver:String = String(format: "%.06f", convertToserver)
                
                
                
                
                ///--------------------------
                
                let alertController = UIAlertController(title: "Confirm decline offer?", message: nil, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    
                }
                alertController.addAction(cancelAction)
                
                
                let submitAction = UIAlertAction(title: "Decline offer", style: .default) { (action) in
                    
                    self.sendMessageToServer(message: pserver, MessageType: "decline_offer")
                    
                }
                alertController.addAction(submitAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                ///--------------------------
                
                
                
                
                
                
            }
            
            
            
            
            
            
            //self.btMakeOffer.setTitle("Decline Offer", for: UIControlState.normal)
            //self.btMakeOffer.isEnabled = false
            
            break
        case .sell_Accept0_Feed1:

            
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
            let vc:FeedbackVC = storyboard.instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackVC
            vc.myChatRoom = self.myRoom
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            
            //self.btMakeOffer.setTitle("Leave Feedback", for: UIControlState.normal)
            //self.btMakeOffer.isEnabled = true
            break
        }
    }
    
    
    
    @IBAction func tapOnProductDetail(_ sender: UIButton) {
        
        
        self.addActivityView {
            
            let realmPro = self.myRoom.product!
        
            
            getProductDataWith(ProductID: realmPro.product_id, Finish: { (product) in
                
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
                let vc:ProductDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
                
                vc.thisFirstDetail = true
                vc.myProductData = product
                vc.comeFromChat = true
                
                
                if(self.myData.masterView != nil){
                    self.myData.masterView.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                self.removeActivityView {
                    
                }
                
            })
            
        }
    }
    
    
    
    
    func tapOnSend(_ sender: UIButton) {
        
        
        
        
        if(self.tfInput.text.count > 0){
            
            if(self.openNumPad == false){
                self.strMessage = self.tfInput.text
                if(self.strMessage.count > 0){
                    self.sendMessageToServer(message: self.strMessage)
                }
                
                self.openNumPad = false
                self.tfInput.keyboardType = .default
            }else{
                
                let priceUSer:Double? = Double(self.tfInput.text)
                if let priceUSer = priceUSer{
                    
                    
                    self.tfInput.resignFirstResponder()
                    self.openNumPad = false
                    self.tfInput.keyboardType = .default
                    
                    
                    
                    
                    
                    print("\(priceUSer) \(self.mySetting.displayCurrency)")
                    //Create Offer
                    let convertToserver = self.mySetting.exchangeToServerCurrency(amount: priceUSer)
                    
                    print("\(convertToserver) \(self.mySetting.serverCurrency)")
                    
                    let pserver:String = String(format: "%.06f", convertToserver)
                    
                    
                    let alertController = UIAlertController(title: "Confirm Offer", message: "Once offer has been accepted by the seller, you'll be able to leave each other feedback.", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                        
                        
                        
                        
                    }
                    alertController.addAction(cancelAction)
                    
                    
                    let submitAction = UIAlertAction(title: "Submit Offer", style: .default) { (action) in
                        
                        
                        
                  
                        
                        
                        self.myRoom.offer_price = pserver
                         
                        self.sendMessageToServer(message: pserver, MessageType: "offer")
                        
                        
                        
                        
                    }
                    alertController.addAction(submitAction)
                    
                    
                    
                    
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    
                    
                    
                }else{
                    
                    //Not number
                    
                    let alertController = UIAlertController(title: "Please enter number", message: nil, preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        
                    }
                    alertController.addAction(cancelAction)
                    
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    
                    
                }
                
                
                
            }
            
            
            
            
            
            
            
            self.strMessage = ""
            self.tfInput.text = ""
            self.updateInputView()
        }
        
        
    }
    
    

    func createOffer(){
        
        self.tfInput.resignFirstResponder()
        self.openNumPad = true
        self.tfInput.keyboardType = .decimalPad
        self.tfInput.text = ""
        self.tfInput.becomeFirstResponder()
        
        
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:MadeOfferVC = storyboard.instantiateViewController(withIdentifier: "MadeOfferVC") as! MadeOfferVC
        
        
        vc.modalPresentationStyle = .overFullScreen
        
        
        self.present(vc, animated: true) { 
            
        }*/
        
        
        
    }
    
    
    func tapOnSendImage(_ sender: UIButton) {
        
        
        if(self.uploading == false){
            
            self.openImagePicker()
            
        }
    }
    
    
    
    func openImagePicker() {
        let album:MultiSelectImageVC = MultiSelectImageVC(nibName: "MultiSelectImageVC", bundle: nil)
        album.singleImage = false
        album.limit = 1
        
        
        album.callBack = {(images) in
            
            self.arImageBuffer.removeAll()
            
            for pickedImage in images{
                
                
                let newImage:PostImageObject = PostImageObject()
                newImage.local_image = pickedImage
                self.arImageBuffer.append(newImage)
                
            }
            
            
            
            
            
        }
        
        
        album.callBackExit = { _ in
            
            
            self.startRunUploadImage()
            /*
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
                
                
            }*/
            
            
            
        }
        
        
        
        let navigation:UINavigationController = UINavigationController(rootViewController: album)
        
        self.present(navigation, animated: true) {
            
        }
    }
    
    
    
    
    
    
    
    
    func getRoomData(){
        
        if(self.haveConnect == false){
            self.haveConnect = true
            
            let postRef = FIRDatabase.database().reference().child("room-messages").child(self.myRoom.room_id)
            postRef.observe(FIRDataEventType.value, with: { (snapshot) in
                
                
                if let value = snapshot.value as? NSDictionary{
                    
                    print(value)
                    
                    self.myRoom.readJson(dictionary: value)
                    self.updateTopButtonWithRoomStatus(st: self.myRoom.status)
                }
                
                
            })
            
        }
        
        
        
    }
    
    
    
    
    
    func updateTopButtonWithRoomStatus(st:RoomMessagesDataModel.SellStatus){
        
        /*
        var myAccep:Bool = false
        var anotherAccep:Bool = false
        
        var anotherID:String = self.myRoom.createdByUserId
        if(self.myRoom.createdByUserId == self.myData.userInfo.uid){
            anotherID = self.myRoom.receivedByUserId
        }
        
        let accepted:[String:Bool]? = room.object(forKey: "isAccepted") as? [String:Bool]
        if let accepted = accepted{
            
            let my:Bool? = accepted[self.myData.userInfo.uid]
            if let my = my{
                myAccep = my
            }
            
            let ano:Bool? = accepted[anotherID]
            if let ano = ano{
                anotherAccep = ano
            }
            
        }
        */
        
        
   
        switch st {
        case .non:
            
            if(self.mode == .selling){
                self.myRoomStatus = .sell_Accept0_Feed0
            }else{
                self.myRoomStatus = .buy_Feed0_Make1
            }
            
            break
        case .accepted:
            
            if(self.mode == .selling){
                self.myRoomStatus = .sell_Accept0_Feed1
            }else{
                self.myRoomStatus = .buy_Feed1_Cancel0
            }
            
            break
        case .declined:
            
            if(self.mode == .selling){
                self.myRoomStatus = .sell_Accept0_Feed0
            }else{
                self.myRoomStatus = .buy_Feed0_Make1
            }
            
            break
        case .cancel:
            
            if(self.mode == .selling){
                self.myRoomStatus = .sell_Accept0_Feed0
            }else{
                self.myRoomStatus = .buy_Feed0_Make1
            }
            
            
            break
        case .offer:
            
            if(self.mode == .selling){
                self.myRoomStatus = .sell_Accept1_decline1
            }else{
                self.myRoomStatus = .buy_Feed0_Cancel1
            }
            
            
            
            break
            
        }
        
        
        
        
        
        /*
        if((myAccep == false) && (anotherAccep == false)){
         
            if(self.mode == .selling){
                self.myRoomStatus = .sell_Accept0_Feed0
                
                
                
                
            }else{
                self.myRoomStatus = .buy_Feed0_Make1
                
                
                
            }
        }else if((myAccep == true) && (anotherAccep == false)){
            
            if(self.mode == .selling){
                self.myRoomStatus = .sell_Accept0_Feed0
            }else{
                self.myRoomStatus = .buy_Feed0_Cancel1
            }
            
        }else if((myAccep == false) && (anotherAccep == true)){
            
            if(self.mode == .selling){
                self.myRoomStatus = .sell_Accept1_decline1
            }else{
                self.myRoomStatus = .buy_Feed0_Cancel1
            }
            
        }else if((myAccep == true) && (anotherAccep == true)){
            
            if(self.mode == .selling){
                self.myRoomStatus = .sell_Accept0_Feed1
            }else{
                self.myRoomStatus = .buy_Feed1_Cancel0
            }
            
        }
        */
        
        
        
        switch self.myRoomStatus {
        case .buy_Feed0_Make1:
            
            
            self.btLeaveFeedback.setTitle("Leave Feedback", for: UIControlState.normal)
            self.btLeaveFeedback.isEnabled = false
            self.btLeaveFeedback.backgroundColor = self.grayColor
            
            
            self.btMakeOffer.setTitle("Make Offer", for: UIControlState.normal)
            self.btMakeOffer.isEnabled = true
            self.btMakeOffer.backgroundColor = self.pinkColor
            
            
            
            break
        case .buy_Feed0_Cancel1:
            self.btLeaveFeedback.setTitle("Leave Feedback", for: UIControlState.normal)
            self.btLeaveFeedback.isEnabled = false
            self.btLeaveFeedback.backgroundColor = self.grayColor
            
            
            self.btMakeOffer.setTitle("Cancel Offer", for: UIControlState.normal)
            self.btMakeOffer.isEnabled = true
            self.btMakeOffer.backgroundColor = self.darkGrayColor
            
            break
        case .buy_Feed1_Cancel0:
            
            self.btLeaveFeedback.setTitle("Leave Feedback", for: UIControlState.normal)
            self.btLeaveFeedback.isEnabled = true
            self.btLeaveFeedback.backgroundColor = self.pinkColor
            
            
            
            self.btMakeOffer.setTitle("Cancel Offer", for: UIControlState.normal)
            self.btMakeOffer.isEnabled = false
            self.btMakeOffer.backgroundColor = self.grayColor
            break
        case .sell_Accept0_Feed0:
            
            self.btLeaveFeedback.setTitle("Accept Offer", for: UIControlState.normal)
            self.btLeaveFeedback.isEnabled = false
            self.btLeaveFeedback.backgroundColor = self.grayColor
            
            
            
            self.btMakeOffer.setTitle("Leave Feedback", for: UIControlState.normal)
            self.btMakeOffer.isEnabled = false
            self.btMakeOffer.backgroundColor = self.grayColor
            
            break
        case .sell_Accept1_decline1:
            
            self.btLeaveFeedback.setTitle("Accept Offer", for: UIControlState.normal)
            self.btLeaveFeedback.isEnabled = true
            self.btLeaveFeedback.backgroundColor = self.pinkColor
            
            
            
            
            self.btMakeOffer.setTitle("Decline Offer", for: UIControlState.normal)
            self.btMakeOffer.isEnabled = true
            self.btMakeOffer.backgroundColor = self.darkGrayColor
            
            
            break
        case .sell_Accept0_Feed1:
            
            self.btLeaveFeedback.setTitle("Accept Offer", for: UIControlState.normal)
            self.btLeaveFeedback.isEnabled = false
            self.btLeaveFeedback.backgroundColor = self.grayColor
            
            
            
            self.btMakeOffer.setTitle("Leave Feedback", for: UIControlState.normal)
            self.btMakeOffer.isEnabled = true
            self.btMakeOffer.backgroundColor = self.pinkColor
            break
        }
        
        
        
       
        
        
        
    }
    
    
    
    // MARK: - Upload
    
    func startRunUploadImage() {
        self.uploading = true
        
        
        self.imageUploadWorking = nil
        for image in self.arImageBuffer{
            if((image.image_src == "") && (image.local_image != nil) && (image.uploadError == false)){
                self.imageUploadWorking = image
                break
            }
            
        }
        
        
        if(self.imageUploadWorking == nil){
            
            
            //Create Message
            
            for imObj in self.arImageBuffer{
                if(imObj.messID == ""){
                    
                    self.imageUploadWorking = imObj
                }
            }
            
            if(self.imageUploadWorking != nil){
                self.sendImageToServer(image: self.imageUploadWorking, Callback: { (messageID) in
                    self.imageUploadWorking.messID = messageID
                    
                    self.startRunUploadImage()
                })
            }else{
                self.uploading = false
            }
            
        }else{
            self.runUploadImage {
                self.startRunUploadImage()
            }
        }
        
    }
    
    
    
    
    func runUploadImage(finish:@escaping ()->Void) {
        
        self.imageUploadWorking = nil
        for image in self.arImageBuffer{
            if((image.image_src == "") && (image.local_image != nil) && (image.uploadError == false)){
                self.imageUploadWorking = image
                break
            }
            
        }
        
        
        if(self.imageUploadWorking != nil){
            
            
            
            self.uploadImage(image: self.imageUploadWorking.local_image, Complete: { (success, name, path, src) in
                
                
                for im in self.arImageBuffer{
                    
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
        let imagePath = "chat" + "/" + fileName
        
        
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
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Load data
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
    
    
    func loadUserDataWith(UserID uID:String, Finish finish:@escaping([RealmUserDataObject])->Void){
        
        
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
    
    
    
    
    func loadChatRoom(Finish finish:@escaping (_ chatData:NSDictionary)->Void) {
        if(self.myRoom != nil){
            
            let postRef = FIRDatabase.database().reference().child("messages").child(self.myRoom.room_id)
            
            
            
            
            postRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.removeActivityView {
                    
                }
                
                if let value = snapshot.value as? NSDictionary{
                    
                   
                    finish(value)
                    
                    
                }
                
            })
            
        }
        
    }
    
    
    
    
    func connectToChatRoom(Finish finish:@escaping (_ chatData:NSDictionary)->Void) {
        if(self.myRoom != nil){
            
            let postRef = FIRDatabase.database().reference().child("messages").child(self.myRoom.room_id)
            
            
            
            postRef.observe(FIRDataEventType.value, with: { (snapshot) in
                
                if let value = snapshot.value as? NSDictionary{
                    
                    self.haveConnection = true
                    finish(value)
                    
                   
                    
                }
                
            }, withCancel: { (error) in
                self.haveConnection = false
                
            })
            
            
           
            
        }
        
    }
    
    
    
    
    
    
    
    func sendMessageToServer(message:String) {
        
        let dateFormatFull:DateFormatter = DateFormatter()
        dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let timeStamp = dateFormatFull.string(from: Date())
        
        let postRefDelete = FIRDatabase.database().reference().child("room-messages").child(self.myRoom.room_id).child("isDeleteUser")
        postRefDelete.setValue(nil)
        
        
       
        
        
        
        
        let postRef = FIRDatabase.database().reference().child("messages").child(self.myRoom.room_id).childByAutoId()
        
        
        var postMessage:[String:Any] = [String:Any]()
        
        postMessage["body"] = message
        postMessage["isDeleteUser"] = false
        postMessage["isOffer"] = false
        postMessage["isRead"] = false
        postMessage["owner_uid"] = self.myData.userInfo.uid
        
        var recUID:String = self.myRoom.receivedByUserId
        
        if(self.mode == .buying){
            postMessage["receiver_uid"] = self.myRoom.receivedByUserId
         
        }else if(self.mode == .selling){
            postMessage["receiver_uid"] = self.myRoom.createdByUserId
            recUID = self.myRoom.createdByUserId
            
            
        }
        //postMessage["receiver_uid"] = self.myRoom.receivedByUserId
        
        
        
        postMessage["timestamp"] = FIRServerValue.timestamp()
        postMessage["type"] = "text"
        
        postRef.setValue(postMessage)
        
        
        
        let whoSend:String = String(format: "%@ %@", self.myData.userInfo.first_name, self.myData.userInfo.last_name)
        let title:String = whoSend
        sendNotificationToUser(UserID: recUID, Title: title, Message: message)
        
        
        
        
        self.sendTimeStampToAnotherUser(Receiver_uid: recUID, Timestamp: timeStamp)
        self.sendTimeStampToAnotherUser(Receiver_uid: self.myRoom.createdByUserId, Timestamp: timeStamp)
        
        
        self.updateUnreadToAnother()
        self.updateLastMessageToRoomData(message: message)
        self.updateTimeToRoomData()
    }
    
 
    
    
    
    
    func sendTimeStampToAnotherUser(Receiver_uid receiver_uid:String, Timestamp timestamp:String){
        let postRefDelete = FIRDatabase.database().reference().child("users").child(receiver_uid).child("message_timeStamp")
        postRefDelete.setValue(FIRServerValue.timestamp())
    }
    
    
    
    func sendMessageToServer(message:String, MessageType type:String) {
        let postRefDelete = FIRDatabase.database().reference().child("room-messages").child(self.myRoom.room_id).child("isDeleteUser")
        postRefDelete.setValue(nil)
        
        
        
        
        
        let dateFormatFull:DateFormatter = DateFormatter()
        dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        let postRef = FIRDatabase.database().reference().child("messages").child(self.myRoom.room_id).childByAutoId()
        
        
        var postMessage:[String:Any] = [String:Any]()
        
        postMessage["body"] = message
        
        var notiMessage:String = ""
        if(type == "offer"){
           postMessage["body"] = message
            
            
            notiMessage = "Send offer"
        }else if(type == "cancel_offer"){
           
            postMessage["body"] = self.myRoom.offer_price
            
            notiMessage = "Cancel offer"
        }else if(type == "accept_offer"){
          
            postMessage["body"] = self.myRoom.offer_price
            
            notiMessage = "Accept offer"
            
            
        }else if(type == "decline_offer"){
            postMessage["body"] = self.myRoom.offer_price
            
            notiMessage = "Decline offer"
        }
        
        
        postMessage["isDeleteUser"] = false
        
        if(type == "offer"){
            postMessage["isOffer"] = true
            
        }else{
            postMessage["isOffer"] = false
        }
        
        
        
        postMessage["isRead"] = false
        postMessage["owner_uid"] = self.myData.userInfo.uid
        
        
        var recUID:String = self.myRoom.receivedByUserId
        if(self.mode == .buying){
            postMessage["receiver_uid"] = self.myRoom.receivedByUserId
        }else if(self.mode == .selling){
            postMessage["receiver_uid"] = self.myRoom.createdByUserId
            recUID = self.myRoom.createdByUserId
        }
        //postMessage["receiver_uid"] = self.myRoom.receivedByUserId
        
        
        let timeStamp = dateFormatFull.string(from: Date())
        postMessage["timestamp"] = FIRServerValue.timestamp()
        postMessage["type"] = type
        
        postRef.setValue(postMessage)
        
        
        
        if(type == "image"){
            notiMessage = "Send image"
        }
        ///------------------
        
        let whoSend:String = String(format: "%@ %@", self.myData.userInfo.first_name, self.myData.userInfo.last_name)
        let title:String = whoSend
        sendNotificationToUser(UserID: recUID, Title: title, Message: notiMessage)
 
        
 
        ///-------
        
        
        
        self.sendTimeStampToAnotherUser(Receiver_uid: recUID, Timestamp: timeStamp)
        
        self.sendTimeStampToAnotherUser(Receiver_uid: self.myRoom.createdByUserId, Timestamp: timeStamp)
        
        
        self.updateUnreadToAnother()
        
        var lastMessage:String = message
        if(type == "text"){
            lastMessage = message
            
        }else if(type == "image"){
            lastMessage = "image"
        }else if(type == "decline_offer"){
            lastMessage = "decline"
            self.updateAcceptedToRoomData(UserID: self.myRoom.createdByUserId, IsAccepted: false)
            self.updateAcceptedToRoomData(UserID: self.myRoom.receivedByUserId, IsAccepted: true)
            
            self.updateLastStatusToRoomData(Status: "decline_offer")
            
            //self.updateOfferPriceToRoomData(message: "")
            
            
            
        }else if(type == "offer"){
            lastMessage = "offer"
            self.updateOfferPriceToRoomData(message: message)
            self.updateAcceptedToRoomData(UserID: self.myRoom.createdByUserId, IsAccepted: true)
            self.updateAcceptedToRoomData(UserID: self.myRoom.receivedByUserId, IsAccepted: false)
            
            self.updateLastStatusToRoomData(Status: "offer")
            self.updateProductStatus(ProductID: self.myRoom.product_id, Status: ProductDataModel.ProductStatus.offering)
            
            
            let offerOperation:DashboardMadeOfferOperation = DashboardMadeOfferOperation()
            self.likeQueue.addOperation(offerOperation)
            
            
        }else if(type == "cancel_offer"){
            lastMessage = "cancel_offer"
            self.updateAcceptedToRoomData(UserID: self.myRoom.createdByUserId, IsAccepted: false)
            self.updateAcceptedToRoomData(UserID: self.myRoom.receivedByUserId, IsAccepted: false)
            
            self.updateLastStatusToRoomData(Status: "cancel_offer")
            //self.updateOfferPriceToRoomData(message: "")
            
            
        }else if(type == "accept_offer"){
            lastMessage = "accept_offer"
            self.updateAcceptedToRoomData(UserID: self.myRoom.createdByUserId, IsAccepted: true)
            self.updateAcceptedToRoomData(UserID: self.myRoom.receivedByUserId, IsAccepted: true)
            
            self.updateLastStatusToRoomData(Status: "accept_offer")
            
            
            var aPrice:Double = 0
            if let price = Double(message){
                aPrice = price
            }
            let offerOperation:DashboardAcceptedOfferOperation = DashboardAcceptedOfferOperation(price: aPrice)
            self.likeQueue.addOperation(offerOperation)
            
            
            
        }else if(type == "decline_offer"){
            lastMessage = "decline_offer"
            self.updateAcceptedToRoomData(UserID: self.myRoom.createdByUserId, IsAccepted: false)
            self.updateAcceptedToRoomData(UserID: self.myRoom.receivedByUserId, IsAccepted: true)
            
            self.updateLastStatusToRoomData(Status: "decline_offer")
            //self.updateOfferPriceToRoomData(message: "")
            
            
        }
        
        self.updateLastMessageToRoomData(message: lastMessage)
        self.updateTimeToRoomData()
    }
    
    
    
    
    
    
    func sendImageToServer(image:PostImageObject, Callback callback:(_ chatID:String)->Void) {
        
        let dateFormatFull:DateFormatter = DateFormatter()
        dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        let postRef = FIRDatabase.database().reference().child("messages").child(self.myRoom.room_id).childByAutoId()
        
        
        
        var postMessage:[String:Any] = [String:Any]()
        
        postMessage["body"] = ""
        postMessage["isDeleteUser"] = false
        postMessage["isOffer"] = false
        postMessage["isRead"] = false
        postMessage["owner_uid"] = self.myData.userInfo.uid
        
        var recUID:String = self.myRoom.receivedByUserId
        if(self.mode == .buying){
            postMessage["receiver_uid"] = self.myRoom.receivedByUserId
            recUID = self.myRoom.receivedByUserId
        }else if(self.mode == .selling){
            postMessage["receiver_uid"] = self.myRoom.createdByUserId
            recUID = self.myRoom.createdByUserId
        }
        //postMessage["receiver_uid"] = self.myRoom.receivedByUserId
        
        var imData:[String:Any] = [String:Any]()
        imData["name"] = image.image_name
        imData["path"] = image.image_path
        imData["src"] = image.image_src
        
        postMessage["image"] = imData
        
        postMessage["timestamp"] = FIRServerValue.timestamp()//dateFormatFull.string(from: Date())
        postMessage["type"] = "image"
        
        postRef.setValue(postMessage)
        
        callback(postRef.key)
        
        
        
        
        let notiMessage = "Send image"
        
        let whoSend:String = String(format: "%@ %@", self.myData.userInfo.first_name, self.myData.userInfo.last_name)
        let title:String = whoSend
        sendNotificationToUser(UserID: recUID, Title: title, Message: notiMessage)
        
        
        
        
        self.updateUnreadToAnother()
        self.updateLastMessageToRoomData(message: "")
        self.updateTimeToRoomData()
    }
    
    
    
    
    
    
    
    func updateTimeToRoomData() {
        let dateFormatFull:DateFormatter = DateFormatter()
        dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        let postRef = FIRDatabase.database().reference().child("room-messages").child(self.myRoom.room_id).child("updatedAt")
        
        let time:String = dateFormatFull.string(from: Date())
        
        postRef.setValue(FIRServerValue.timestamp())
        
      
    }

    func updateLastMessageToRoomData(message:String) {

        
        
        let postRef = FIRDatabase.database().reference().child("room-messages").child(self.myRoom.room_id).child("last_message")
       
        
        postRef.setValue(message)
        
        
    }
    
    func updateOfferPriceToRoomData(message:String) {
        
        
        let postRef = FIRDatabase.database().reference().child("room-messages").child(self.myRoom.room_id).child("offer_price")
        postRef.setValue(message)
        
        
    }
    
    
    func updateAcceptedToRoomData(UserID userId:String, IsAccepted accept:Bool) {
        
        
        let postRef = FIRDatabase.database().reference().child("room-messages").child(self.myRoom.room_id).child("isAccepted").child(userId)
        
        if(accept == true){
            postRef.setValue(accept)
        }else{
            postRef.setValue(nil)
        }
        
        
        
    }
    
    
    
    
    func updateProductStatus(ProductID product:String, Status status: ProductDataModel.ProductStatus){
        
        getProductDataWith(ProductID: product) { (sproduct) in
            
          
            if((sproduct.product_status.lowercased() != "sold out") && (sproduct.product_status.lowercased() != "offering")){
                
                let postRef = FIRDatabase.database().reference().child("products").child(self.myRoom.product_id).child("product_status")
                
                postRef.setValue(status.rawValue)
                
            }
            
        }
    }
    
    func updateLastStatusToRoomData(Status status:String) {
        
        
        let postRef = FIRDatabase.database().reference().child("room-messages").child(self.myRoom.room_id).child("last_status")
        postRef.setValue(status)
        
        
    }
    
    
    
    
    
    
    
    func updateSelfUnreadToRoomData() {
        
        let postRef = FIRDatabase.database().reference().child("room-messages").child(self.myRoom.room_id).child("unread_count").child(self.myData.userInfo.uid)
        
        postRef.setValue(0)

        
        
        let dateFormatFull:DateFormatter = DateFormatter()
        dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let timeStamp = dateFormatFull.string(from: Date())
        
        
        
        self.sendTimeStampToAnotherUser(Receiver_uid: self.myRoom.receivedByUserId, Timestamp: timeStamp)
        self.sendTimeStampToAnotherUser(Receiver_uid: self.myRoom.createdByUserId, Timestamp: timeStamp)
        
       
        
        
    }
    
    
    
    func updateUnreadToAnother() {
        
        if(self.myRoom != nil){
            
            var anotherID:String = self.myRoom.createdByUserId
            if(self.mode == .buying){
                anotherID = self.myRoom.receivedByUserId
            }
            
            
            let postRef = FIRDatabase.database().reference().child("room-messages").child(self.myRoom.room_id).child("unread_count").child(anotherID)
            
            
            
            
            postRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
             
                
                if let value = snapshot.value as? NSInteger{
                    
                    
                   
                    let newvalue = value + 1
                    
                    var anotherID2:String = self.myRoom.createdByUserId
                    if(self.mode == .buying){
                        anotherID2 = self.myRoom.receivedByUserId
                    }
                    
                    let postRef2 = FIRDatabase.database().reference().child("room-messages").child(self.myRoom.room_id).child("unread_count").child(anotherID2)
                    
               
                    postRef2.setValue(newvalue)
                    
                    
                }
                
            })
            
        }
        
    }
    
    
    
    
    
    
    func updateMessageToRead(messageID:String) {
        
        if(self.viewIsShowing == true){
            let postRef = FIRDatabase.database().reference().child("messages").child(self.myRoom.room_id).child(messageID).child("isRead")
            
            postRef.setValue(true)
            
            
            self.updateSelfUnreadToRoomData()
        }
        
    }
    
    
    
    
    
    
    
    func openImagePreview(images:[PostImageObject]) {
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:ImagePreviewVC = storyboard.instantiateViewController(withIdentifier: "ImagePreviewVC") as! ImagePreviewVC
      
        
        vc.arImageName = images
        vc.currentPage = 0
        vc.isEditMode = false
        vc.strTitle = ""
        
        
        vc.callBackDelete = { (imageIndex) in
            

        }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    
    func getAutoMessage(message:String)->String{
        var str:String = message
        if(message == "decline_offer"){
            str = "Declined offer"
        }else if(message == "offer"){
            str = "Offer"
        }else if(message == "cancel_offer"){
            str = "Cancelled offer"
        }else if(message == "accept_offer"){
            str = "Accepted offer"
        }
        
        
        
        return str
    }
    
}





// MARK: - UITableViewDelegate, UITableViewDataSource
extension ChatRoomVC:UITableViewDelegate, UITableViewDataSource{
    
    
    
    
    // MARK: - numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return self.myMessage.count
    }
    
    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfCell:NSInteger = 0
        
      
        if(section < self.myMessage.count){
            numberOfCell = self.myMessage[section].messages.count
        }
        
        
        return numberOfCell
    }
    
    // MARK: - Cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        var cellHeight:CGFloat = 60
        
        
        if(indexPath.section < self.myMessage.count){
            let day = self.myMessage[indexPath.section]
            if(indexPath.row < day.messages.count){
                let message = day.messages[indexPath.row]
            /////---------------------
                if(message.owner_uid == self.myData.userInfo.uid){
                    
                    if(message.type == "text"){
                        
                        
                        
                        let messageH:CGFloat = heightForView(text: message.body, Font: self.textFont, Width: screenSize.width - (80 + 16 + 16 + 12)) + 2 + 8 + 8 + 16 + 2
                        
                        
                        cellHeight = messageH
                        if(cellHeight < 45){
                            cellHeight = 45
                        }
                        
                    }else if(message.type == "image"){
                        
                        let messageH:CGFloat = heightForView(text: message.body, Font: self.textFont, Width: screenSize.width - (80 + 16 + 16 + 12))
  
                        cellHeight = messageH + 184
                        if(cellHeight < 184){
                            cellHeight = 184
                        }
                        
                        
                        
                    }else if(message.type == "offer"){
                        
                        let messageH:CGFloat = heightForView(text: self.mySetting.priceWithString(strPricein: message.body) , Font: self.fontPriceName, Width: screenSize.width - (80 + 16 + 16 + 12)) + 2 + 8 + 8 + 16 + 2 + 30
                        
                        
                        cellHeight = messageH
                        if(cellHeight < 80){
                            cellHeight = 80
                        }
                        
                        
                        
                    }else if((message.type == "decline_offer") || (message.type == "cancel_offer") || (message.type == "accept_offer")){
                        
                        
                        
                        
                        let messageH:CGFloat = heightForView(text: self.mySetting.priceWithString(strPricein: message.body) , Font: self.fontPriceName, Width: screenSize.width - (80 + 16 + 16 + 12)) + 2 + 8 + 8 + 16 + 2 + 30
                        
                        
                        cellHeight = messageH
                        if(cellHeight < 80){
                            cellHeight = 80
                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                }else{
                    /////---------------------
                    
                    if(message.type == "text"){
                        
                        
                        
                        let messageH:CGFloat = heightForView(text: message.body, Font: self.textFont, Width: screenSize.width - (60 + 16 + 16 + 8 + 28 + 8 + 12)) + 2 + 8 + 8 + 16 + 2 + 12
                        
                        
                        cellHeight = messageH
                        if(cellHeight < 45){
                            cellHeight = 45
                        }
                        
                    }else if(message.type == "image"){
                        
                        let messageH:CGFloat = heightForView(text: message.body, Font: self.textFont, Width: screenSize.width - (60 + 16 + 16 + 8 + 28 + 8 + 12))
                        
                        cellHeight = messageH + 184
                        if(cellHeight < 184){
                            cellHeight = 184
                        }
                        
                        
                        
                    }else if(message.type == "offer"){
                        
                        let messageH:CGFloat = heightForView(text: self.mySetting.priceWithString(strPricein: message.body), Font: self.fontPriceName, Width: screenSize.width - (60 + 16 + 16 + 8 + 28 + 8 + 12)) + 2 + 8 + 8 + 16 + 2 + 12 + 30
                        
                        
                        cellHeight = messageH
                        if(cellHeight < 80){
                            cellHeight = 80
                        }
                        
                        
                        
                    }else if((message.type == "decline_offer") || (message.type == "cancel_offer") || (message.type == "accept_offer")){
                        
                        let messageH:CGFloat = heightForView(text: self.mySetting.priceWithString(strPricein: message.body), Font: self.fontPriceName, Width: screenSize.width - (60 + 16 + 16 + 8 + 28 + 8 + 12)) + 2 + 8 + 8 + 16 + 2 + 12 + 30
                        
                        
                        cellHeight = messageH
                        if(cellHeight < 80){
                            cellHeight = 80
                        }
                        
                        
                        
                    }
                    
                    
                    
                }
                
                
                
                
            }
        }
        
        
        return cellHeight
    }
    

    // MARK: - Header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let cellHeight:CGFloat = 35
        
        
        
        return cellHeight
        
    }
    
    // MARK: - Header cell
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell:ChatDateTitleCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ChatDateTitleCell") as? ChatDateTitleCell
        
        
        if(section < self.myMessage.count){
            let day = self.myMessage[section]
            cell?.lbTitle.text = self.dateFormatDateHeader.string(from: day.date)
            
        }
        
      
        
        return cell
    }
  
    
    
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if(indexPath.section < self.myMessage.count){
            let day = self.myMessage[indexPath.section]
            if(indexPath.row < day.messages.count){
                let message = day.messages[indexPath.row]
                
                if(message.owner_uid == self.myData.userInfo.uid){
                    
                    if(message.type == "text"){
                        
                        var cellState:OwnerMessageCell.State = .single
                        
                        let cell:OwnerMessageCell? = tableView.dequeueReusableCell(withIdentifier: "OwnerMessageCell", for: indexPath) as? OwnerMessageCell
                        
                        cell?.selectionStyle = .none
                        
                        cell?.lbMessage.text = message.body
                        let sDate:Date = Date(timeIntervalSince1970: message.timestamp_Date.timeIntervalSince1970)
                        
                        cell?.lbTime.text = dateFormatTimeStamp.string(from: sDate)
                        
                        
                        
                        //---------
                       
                        var boxw:CGFloat = self.screenSize.width - 92
                        let messageW:CGFloat = widthForView(text: message.body, Font: self.textFont, Height: 19.5) + 46
                        if(messageW < self.screenSize.width - 100){
                            boxw = messageW
                        }
                        
                        if(boxw < 80){
                            boxw = 80
                        }
                        
                        cell?.layout_Leading.constant = screenSize.width - (boxw + 12)
                       
                        //--------
                        let before:NSInteger = indexPath.row - 1
    
                        let next:NSInteger = indexPath.row + 1
                        
                        
                        var haveTop:Bool = false
                        var haveBottom:Bool = false
                        
                        if(before >= 0){
                            let bMessage = day.messages[before]
                            if(bMessage.owner_uid == self.myData.userInfo.uid){
                                haveTop = true
                            }
                        }
                        
                        
                        if(next < day.messages.count){
                            let nMessage = day.messages[next]
                            if(nMessage.owner_uid == self.myData.userInfo.uid){
                                haveBottom = true
                            }
                        }
                        
                        
                        if((haveTop == false) && (haveBottom == false) ){
                            cellState = .single
                        }else if((haveTop == false) && (haveBottom == true) ){
                            cellState = .top
                        }else if((haveTop == true) && (haveBottom == true) ){
                            cellState = .middle
                        }else if((haveTop == true) && (haveBottom == false) ){
                            cellState = .bottom
                        }
                        
                        
                        
                        cell?.setTextBoxState(state: cellState)
                        //-------------
                 
                        return cell!
                        
                        
                        
                    }else if(message.type == "image"){
                        
                        var cellState:OwnerImageCell.State = .single
                        
                        let cell:OwnerImageCell? = tableView.dequeueReusableCell(withIdentifier: "OwnerImageCell", for: indexPath) as? OwnerImageCell
                        
                        cell?.selectionStyle = .none
                        
                        cell?.lbMessage.text = ""//message.body
                        let sDate:Date = Date(timeIntervalSince1970: message.timestamp_Date.timeIntervalSince1970)
                        
                        cell?.lbTime.text = dateFormatTimeStamp.string(from: sDate)
                        
                        
                        cell?.imageSend.loadImage(imageURL: message.imageSrc, Thumbnail: true)
                        //---------
                        
                        var boxw:CGFloat = self.screenSize.width - 92
                        let messageW:CGFloat = widthForView(text: message.body, Font: self.textFont, Height: 19.5) + 36
                        if(messageW < self.screenSize.width - 100){
                            boxw = messageW
                        }
                        
                        if(boxw < 160){
                            boxw = 160
                        }
                        
                        cell?.layout_Leading.constant = boxw
                        
                        //--------
                        let before:NSInteger = indexPath.row - 1
                        
                        let next:NSInteger = indexPath.row + 1
                        
                        
                        var haveTop:Bool = false
                        var haveBottom:Bool = false
                        
                        if(before >= 0){
                            let bMessage = day.messages[before]
                            if(bMessage.owner_uid == self.myData.userInfo.uid){
                                haveTop = true
                            }
                        }
                        
                        
                        if(next < day.messages.count){
                            let nMessage = day.messages[next]
                            if(nMessage.owner_uid == self.myData.userInfo.uid){
                                haveBottom = true
                            }
                        }
                        
                        
                        if((haveTop == false) && (haveBottom == false) ){
                            cellState = .single
                        }else if((haveTop == false) && (haveBottom == true) ){
                            cellState = .top
                        }else if((haveTop == true) && (haveBottom == true) ){
                            cellState = .middle
                        }else if((haveTop == true) && (haveBottom == false) ){
                            cellState = .bottom
                        }
                        
                        
                        
                        cell?.setTextBoxState(state: cellState)
                        //-------------
                        
                        return cell!
                        
                        
                        
                    }else if(message.type == "offer"){
                        
                        var cellState:OwnerOfferCell.State = .single
                        
                        let cell:OwnerOfferCell? = tableView.dequeueReusableCell(withIdentifier: "OwnerOfferCell", for: indexPath) as? OwnerOfferCell
                        
                        cell?.selectionStyle = .none
                        
                        
                        let price:String = self.mySetting.priceWithString(strPricein: message.body)
                        cell?.lbPrice.text = price
                        
                        
                        
                        
                        
                        let sDate:Date = Date(timeIntervalSince1970: message.timestamp_Date.timeIntervalSince1970)
                        
                        cell?.lbTime.text = dateFormatTimeStamp.string(from: sDate)
                        cell?.lbMessage.text = "Made an Offer"
                        
                        
                        //---------
                        //---------
                        
                        var boxw:CGFloat = self.screenSize.width - 92
                        var messageW:CGFloat = widthForView(text: price, Font: self.fontPriceName, Height: 19.5) + 40
                        if(messageW < 150){
                            messageW = 150
                        }
                        if(messageW < self.screenSize.width - 100){
                            boxw = messageW
                        }
                        
                        if(boxw < 60){
                            boxw = 60
                        }
                        
                        cell?.layout_Leading.constant = screenSize.width - (boxw + 12)
                        
                        //--------
                        let before:NSInteger = indexPath.row - 1
                        
                        let next:NSInteger = indexPath.row + 1
                        
                        
                        var haveTop:Bool = false
                        var haveBottom:Bool = false
                        
                        if(before >= 0){
                            let bMessage = day.messages[before]
                            if(bMessage.owner_uid == self.myData.userInfo.uid){
                                haveTop = true
                            }
                        }
                        
                        
                        if(next < day.messages.count){
                            let nMessage = day.messages[next]
                            if(nMessage.owner_uid == self.myData.userInfo.uid){
                                haveBottom = true
                            }
                        }
                        
                        
                        if((haveTop == false) && (haveBottom == false) ){
                            cellState = .single
                        }else if((haveTop == false) && (haveBottom == true) ){
                            cellState = .top
                        }else if((haveTop == true) && (haveBottom == true) ){
                            cellState = .middle
                        }else if((haveTop == true) && (haveBottom == false) ){
                            cellState = .bottom
                        }
                        
                        
                        
                        cell?.setTextBoxState(state: cellState)
                        //-------------
                        
                        return cell!
                        
                        
                        
                    }else if((message.type == "decline_offer") || (message.type == "cancel_offer") || (message.type == "accept_offer")){
                        
                        var cellState:OwnerOfferCell.State = .single
                        
                        let cell:OwnerOfferCell? = tableView.dequeueReusableCell(withIdentifier: "OwnerOfferCell", for: indexPath) as? OwnerOfferCell
                        
                        cell?.selectionStyle = .none
                        
                        
                        let price:String = self.mySetting.priceWithString(strPricein: message.body)
                        cell?.lbPrice.text = price
                        
                        
                        if((message.type == "accept_offer") || (message.type == "decline_offer")){
                            
                        }else{
                            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: price)
                            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                            cell?.lbPrice.attributedText = attributeString
                        }
                        
                        
                        
                        
                        
                        let sDate:Date = Date(timeIntervalSince1970: message.timestamp_Date.timeIntervalSince1970)
                        
                        cell?.lbTime.text = dateFormatTimeStamp.string(from: sDate)
                        
                        
                        cell?.strTitle = self.getAutoMessage(message: message.type).capitalized
                        
                        
                        
                        //---------
                        //---------
                        
                        var boxw:CGFloat = self.screenSize.width - 92
                        let messageW:CGFloat = widthForView(text: price, Font: self.fontPriceName, Height: 19.5) + 40
                        if(messageW < self.screenSize.width - 100){
                            boxw = messageW
                        }
                        
                        if(boxw < 60){
                            boxw = 60
                        }
                        
                        cell?.layout_Leading.constant = screenSize.width - (boxw + 12)
                        
                        //--------
                        let before:NSInteger = indexPath.row - 1
                        
                        let next:NSInteger = indexPath.row + 1
                        
                        
                        var haveTop:Bool = false
                        var haveBottom:Bool = false
                        
                        if(before >= 0){
                            let bMessage = day.messages[before]
                            if(bMessage.owner_uid == self.myData.userInfo.uid){
                                haveTop = true
                            }
                        }
                        
                        
                        if(next < day.messages.count){
                            let nMessage = day.messages[next]
                            if(nMessage.owner_uid == self.myData.userInfo.uid){
                                haveBottom = true
                            }
                        }
                        
                        
                        if((haveTop == false) && (haveBottom == false) ){
                            cellState = .single
                        }else if((haveTop == false) && (haveBottom == true) ){
                            cellState = .top
                        }else if((haveTop == true) && (haveBottom == true) ){
                            cellState = .middle
                        }else if((haveTop == true) && (haveBottom == false) ){
                            cellState = .bottom
                        }
                        
                        
                        
                        cell?.setTextBoxState(state: cellState)
                        //-------------
                        
                        return cell!
                        
                        
                        
                    }
                    
                    
                    
                    
                }else{
                    
                    
                    if(message.type == "text"){
                        
                        var cellState:AnotherMessageCell.State = .single
                        
                        let cell:AnotherMessageCell? = tableView.dequeueReusableCell(withIdentifier: "AnotherMessageCell", for: indexPath) as? AnotherMessageCell
                        
                        cell?.selectionStyle = .none
                        
                        cell?.lbMessage.text = message.body
                        let sDate:Date = Date(timeIntervalSince1970: message.timestamp_Date.timeIntervalSince1970)
                        
                        cell?.lbTime.text = dateFormatTimeStamp.string(from: sDate)
                        
                        
                        
                        var userData:UserDataModel! = nil
                        for u in self.bufferUserData{
                            if(u.uid == message.owner_uid){
                                userData = u
                            }
                        }
                        
                        if(userData != nil){
                            cell?.lazyImage.loadImage(imageURL: userData.profileImage_src, Thumbnail: true)
                        }else{
                            getUserDataWith(UID: message.owner_uid, Finish: { (uData) in
                                userData = uData
                                self.bufferUserData.append(userData)
                                cell?.lazyImage.loadImage(imageURL: userData.profileImage_src, Thumbnail: true)
                                
                            })
                        }
                        
                        //---------
                       
                         var boxw:CGFloat = self.screenSize.width - 92
                     
                         let messageW:CGFloat = widthForView(text: message.body, Font: self.textFont, Height: 19.5) + 66
                         if(messageW < self.screenSize.width - 120){
                            boxw = messageW
                         }
                         
                         if(boxw < 80){
                            boxw = 80
                         }
                         
                         cell?.layout_Leading.constant = screenSize.width - (boxw + 12)
                        
                        //--------
                        let before:NSInteger = indexPath.row - 1
                        
                        let next:NSInteger = indexPath.row + 1
                        
                        
                        let worlOnUserId:String =  message.owner_uid
                        
                        var haveTop:Bool = false
                        var haveBottom:Bool = false
                        
                        if(before >= 0){
                            let bMessage = day.messages[before]
                            if(bMessage.owner_uid == worlOnUserId){
                                haveTop = true
                            }
                        }
                        
                        
                        if(next < day.messages.count){
                            let nMessage = day.messages[next]
                            if(nMessage.owner_uid == worlOnUserId){
                                haveBottom = true
                            }
                        }
                        
                        
                        if((haveTop == false) && (haveBottom == false) ){
                            cellState = .single
                        }else if((haveTop == false) && (haveBottom == true) ){
                            cellState = .top
                        }else if((haveTop == true) && (haveBottom == true) ){
                            cellState = .middle
                        }else if((haveTop == true) && (haveBottom == false) ){
                            cellState = .bottom
                        }
                        
                        
                        
                        cell?.setTextBoxState(state: cellState)
                        //-------------
                        
                       
                        return cell!
                        
                        
                        
                    }else if(message.type == "image"){
                        
                        var cellState:AnotherImageCell.State = .single
                        
                        let cell:AnotherImageCell? = tableView.dequeueReusableCell(withIdentifier: "AnotherImageCell", for: indexPath) as? AnotherImageCell
                        
                        cell?.selectionStyle = .none
                        
                        cell?.lbMessage.text = ""//message.body
                        let sDate:Date = Date(timeIntervalSince1970: message.timestamp_Date.timeIntervalSince1970)
                        
                        cell?.lbTime.text = dateFormatTimeStamp.string(from: sDate)
                        cell?.imageSend.loadImage(imageURL: message.imageSrc, Thumbnail: true)
                        
                        
                        var userData:UserDataModel! = nil
                        for u in self.bufferUserData{
                            if(u.uid == message.owner_uid){
                                userData = u
                            }
                        }
                        
                        if(userData != nil){
                            cell?.lazyImage.loadImage(imageURL: userData.profileImage_src, Thumbnail: true)
                        }else{
                            getUserDataWith(UID: message.owner_uid, Finish: { (uData) in
                                userData = uData
                                self.bufferUserData.append(userData)
                                cell?.lazyImage.loadImage(imageURL: userData.profileImage_src, Thumbnail: true)
                                
                            })
                        }
                        
                        //---------
                        
                        var boxw:CGFloat = self.screenSize.width - 92
                        let messageW:CGFloat = widthForView(text: message.body, Font: self.textFont, Height: 19.5) + 36
                        if(messageW < self.screenSize.width - 120){
                            boxw = messageW
                        }
                        
                        if(boxw < 160){
                            boxw = 160
                        }
                        
                        cell?.layout_MessageBox_Width.constant = boxw
                        
                        //--------
                        let before:NSInteger = indexPath.row - 1
                        
                        let next:NSInteger = indexPath.row + 1
                        
                        
                        let worlOnUserId:String =  message.owner_uid
                        
                        var haveTop:Bool = false
                        var haveBottom:Bool = false
                        
                        if(before >= 0){
                            let bMessage = day.messages[before]
                            if(bMessage.owner_uid == worlOnUserId){
                                haveTop = true
                            }
                        }
                        
                        
                        if(next < day.messages.count){
                            let nMessage = day.messages[next]
                            if(nMessage.owner_uid == worlOnUserId){
                                haveBottom = true
                            }
                        }
                        
                        
                        if((haveTop == false) && (haveBottom == false) ){
                            cellState = .single
                        }else if((haveTop == false) && (haveBottom == true) ){
                            cellState = .top
                        }else if((haveTop == true) && (haveBottom == true) ){
                            cellState = .middle
                        }else if((haveTop == true) && (haveBottom == false) ){
                            cellState = .bottom
                        }
                        
                        
                        
                        cell?.setTextBoxState(state: cellState)
                        //-------------
                        
                        
                        return cell!
                        
                        
                        
                    }else if(message.type == "offer"){
                        
                        var cellState:AnotherOfferCell.State = .single
                        
                        let cell:AnotherOfferCell? = tableView.dequeueReusableCell(withIdentifier: "AnotherOfferCell", for: indexPath) as? AnotherOfferCell
                        
                        cell?.selectionStyle = .none
                        
                        let price:String = self.mySetting.priceWithString(strPricein: message.body)
                        
                        
                        cell?.lbPrice.text = price
                        let sDate:Date = Date(timeIntervalSince1970: message.timestamp_Date.timeIntervalSince1970)
                        
                        cell?.lbTime.text = dateFormatTimeStamp.string(from: sDate)
                       
                        cell?.lbMessage.text = "Made an Offer"
                        
                        
                        var userData:UserDataModel! = nil
                        for u in self.bufferUserData{
                            if(u.uid == message.owner_uid){
                                userData = u
                            }
                        }
                        
                        if(userData != nil){
                            cell?.lazyImage.loadImage(imageURL: userData.profileImage_src, Thumbnail: true)
                        }else{
                            getUserDataWith(UID: message.owner_uid, Finish: { (uData) in
                                userData = uData
                                self.bufferUserData.append(userData)
                                cell?.lazyImage.loadImage(imageURL: userData.profileImage_src, Thumbnail: true)
                                
                            })
                        }
                        
                        //---------
                        
                        var boxw:CGFloat = self.screenSize.width - 92
                        var messageW:CGFloat = widthForView(text: price, Font: self.fontPriceName, Height: 19.5) + 70
                        if(messageW < 150){
                            messageW = 150
                        }
                        
                        if(messageW < self.screenSize.width - 120){
                            boxw = messageW
                        }
                        
                        if(boxw < 70){
                            boxw = 70
                        }
                        
                        cell?.layout_Leading.constant = screenSize.width - (boxw + 12)
                        
                        //--------
                        let before:NSInteger = indexPath.row - 1
                        
                        let next:NSInteger = indexPath.row + 1
                        
                        
                        let worlOnUserId:String =  message.owner_uid
                        
                        var haveTop:Bool = false
                        var haveBottom:Bool = false
                        
                        if(before >= 0){
                            let bMessage = day.messages[before]
                            if(bMessage.owner_uid == worlOnUserId){
                                haveTop = true
                            }
                        }
                        
                        
                        if(next < day.messages.count){
                            let nMessage = day.messages[next]
                            if(nMessage.owner_uid == worlOnUserId){
                                haveBottom = true
                            }
                        }
                        
                        
                        if((haveTop == false) && (haveBottom == false) ){
                            cellState = .single
                        }else if((haveTop == false) && (haveBottom == true) ){
                            cellState = .top
                        }else if((haveTop == true) && (haveBottom == true) ){
                            cellState = .middle
                        }else if((haveTop == true) && (haveBottom == false) ){
                            cellState = .bottom
                        }
                        
                        
                        
                        cell?.setTextBoxState(state: cellState)
                        //-------------
                        
                        
                        return cell!
                        
                        
                        
                    }else if((message.type == "decline_offer") || (message.type == "cancel_offer") || (message.type == "accept_offer")){
                        
                        var cellState:AnotherOfferCell.State = .single
                        
                        let cell:AnotherOfferCell? = tableView.dequeueReusableCell(withIdentifier: "AnotherOfferCell", for: indexPath) as? AnotherOfferCell
                        
                        cell?.selectionStyle = .none
                        
                      
                        let price:String = self.mySetting.priceWithString(strPricein: message.body)
                        
                        cell?.lbPrice.text = price
                        
                        if((message.type == "accept_offer") || (message.type == "decline_offer")){
                            
                        }else{
                            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: price)
                            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                            cell?.lbPrice.attributedText = attributeString
                        }
                        
                        
                        
                        
                        
                        
                        
                        let sDate:Date = Date(timeIntervalSince1970: message.timestamp_Date.timeIntervalSince1970)
                        
                        cell?.lbTime.text = dateFormatTimeStamp.string(from: sDate)
                        
                        cell?.strTitle = self.getAutoMessage(message: message.type).capitalized
                        
                        
                        var userData:UserDataModel! = nil
                        for u in self.bufferUserData{
                            if(u.uid == message.owner_uid){
                                userData = u
                            }
                        }
                        
                        if(userData != nil){
                            cell?.lazyImage.loadImage(imageURL: userData.profileImage_src, Thumbnail: true)
                        }else{
                            getUserDataWith(UID: message.owner_uid, Finish: { (uData) in
                                userData = uData
                                self.bufferUserData.append(userData)
                                cell?.lazyImage.loadImage(imageURL: userData.profileImage_src, Thumbnail: true)
                                
                            })
                        }
                        
                        //---------
                        
                        var boxw:CGFloat = self.screenSize.width - 92
                        let messageW:CGFloat = widthForView(text: price, Font: self.fontPriceName, Height: 19.5) + 70
                        if(messageW < self.screenSize.width - 120){
                            boxw = messageW
                        }
                        
                        if(boxw < 70){
                            boxw = 70
                        }
                        
                        cell?.layout_Leading.constant = screenSize.width - (boxw + 12)
                        
                        //--------
                        let before:NSInteger = indexPath.row - 1
                        
                        let next:NSInteger = indexPath.row + 1
                        
                        
                        let worlOnUserId:String =  message.owner_uid
                        
                        var haveTop:Bool = false
                        var haveBottom:Bool = false
                        
                        if(before >= 0){
                            let bMessage = day.messages[before]
                            if(bMessage.owner_uid == worlOnUserId){
                                haveTop = true
                            }
                        }
                        
                        
                        if(next < day.messages.count){
                            let nMessage = day.messages[next]
                            if(nMessage.owner_uid == worlOnUserId){
                                haveBottom = true
                            }
                        }
                        
                        
                        if((haveTop == false) && (haveBottom == false) ){
                            cellState = .single
                        }else if((haveTop == false) && (haveBottom == true) ){
                            cellState = .top
                        }else if((haveTop == true) && (haveBottom == true) ){
                            cellState = .middle
                        }else if((haveTop == true) && (haveBottom == false) ){
                            cellState = .bottom
                        }
                        
                        
                        
                        cell?.setTextBoxState(state: cellState)
                        //-------------
                        
                        
                        return cell!
                        
                        
                        
                    }

                    
                    
                    
                    
                    
                    
                    
                    if((message.isRead == false) && (message.owner_uid != self.myData.userInfo.uid)){
                        self.updateMessageToRead(messageID: message.messageID)
                    }
                    
                    
                    
                }
                
                
                
                
            }
        }
        
        
        
        
        let cell:AnotherMessageCell? = tableView.dequeueReusableCell(withIdentifier: "AnotherMessageCell", for: indexPath) as? AnotherMessageCell
        
        cell?.selectionStyle = .none
        
        
        
        return cell!
        
        
        
        
    }
    
    // MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        
        
        
        
        if(indexPath.section < self.myMessage.count){
            let day = self.myMessage[indexPath.section]
            if(indexPath.row < day.messages.count){
                let message = day.messages[indexPath.row]
                
                if(message.owner_uid == self.myData.userInfo.uid){
                    
                    if(message.type == "text"){
                        
                        
                        
                    }else if(message.type == "image"){
                        
                        
                    
                        let newImage:PostImageObject = PostImageObject()
                        newImage.image_name = message.imageName
                        newImage.image_path = message.imagePath
                        newImage.image_src = message.imageSrc
                        newImage.messID = message.messageID
                        
                        let arIm:[PostImageObject] = [newImage]
                        self.openImagePreview(images: arIm)
                        
                    }
                    
                }else{
                    
                    
                    if(message.type == "text"){
                        
                        
                        
                        
                    }else if(message.type == "image"){
                        
                        
                        let newImage:PostImageObject = PostImageObject()
                        newImage.image_name = message.imageName
                        newImage.image_path = message.imagePath
                        newImage.image_src = message.imageSrc
                        newImage.messID = message.messageID
                        
                        let arIm:[PostImageObject] = [newImage]
                        self.openImagePreview(images: arIm)
                        
                        
                    }
         
                    
                    
                }
                
                
                
                
            }
        }
        
        
        
        
        
        
   

 
 
 
        self.myTable.deselectRow(at: indexPath, animated: true)
 
    }
 
 
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.tfInput.resignFirstResponder()
 
    }
 
}



// MARK: -
extension ChatRoomVC:UITextViewDelegate{
 
 
    func updateInputView() {
 
 
        let tw:CGFloat = self.screenSize.width - (60 + 68 + 16 + 10)
        var tfHeight:CGFloat = heightForView(text: self.strMessage, Font: self.textFont, Width: tw) + 10
 
        if(tfHeight < 28){
            tfHeight = 28
        }else if(tfHeight > 100){
            tfHeight = 100
        }
        
        
        
        self.inPutViewHeight = tfHeight + 16
        if(self.inPutViewHeight < 44){
            self.inPutViewHeight = 44
        }
        
        
        
        //self.tfInput = UITextView(frame: CGRect(x: 8, y: 4, width: self.screenSize.width - (60 + 68 + 16), height: 28))
        
        //self.viInputBG = UIView(frame: CGRect(x: 52, y: 4, width: self.screenSize.width - (60 + 68), height: 36))
        
        //self.btSendMessage = UIButton(frame: CGRect(x: self.screenSize.width - (8 + 60), y: 4, width: 60, height: 36))
        
        
        
        
        
        let totalH:CGFloat = self.inPutViewHeight + self.keuboardHeight
        
        
        if((self.screenSize.width == 375) && (self.screenSize.height == 812)){
          
            
            if(self.keuboardHeight > 34){
                self.layOut_TopProductCell.constant = (self.layout_HeightProductCell.constant * -1)
            }else{
                self.layOut_TopProductCell.constant = 0//self.inPutViewHeight
            }
            
            
        }else{
            if(self.keuboardHeight > 0){
                self.layOut_TopProductCell.constant = (self.layout_HeightProductCell.constant * -1)
            }else{
                self.layOut_TopProductCell.constant = 0//self.inPutViewHeight
            }
        }
        
        
        
      
      
        
        let newFrame:CGRect = CGRect(x: 0, y: self.screenSize.height - totalH, width: self.screenSize.width, height: self.inPutViewHeight)
        
        
        
        if((self.screenSize.width == 375) && (self.screenSize.height == 812)){
            self.layer_TableBottom.constant = (self.screenSize.height - 34) - newFrame.origin.y
        }else{
            self.layer_TableBottom.constant = self.screenSize.height - newFrame.origin.y
        }
            
        UIView.animate(withDuration: 0.25) { 
            self.viKeyBoardAccessoryText.frame = newFrame
            self.tfInput.frame = CGRect(x: 8, y: 4, width: self.screenSize.width - (60 + 68 + 16), height: tfHeight)
            
            
            self.viInputBG.frame = CGRect(x: 52, y: 4, width: self.screenSize.width - (60 + 68), height: tfHeight + 8)
            
            
            self.btSendMessage.center.y = self.inPutViewHeight - 22
            self.btSendImage.center.y = self.inPutViewHeight - 22
            
            self.view.updateConstraints()
            self.view.layoutIfNeeded()
        }
        
    }
    // MARK: - keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        
        
         if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
         
            self.keuboardHeight = keyboardSize.height
            
            self.updateInputView()
            
            
            
            let lastSection = self.myMessage.count - 1
            if(lastSection >= 0){
                let lastRow = self.myMessage[lastSection].messages.count - 1
                
                if(lastRow >= 0){
                    let lastIndex:IndexPath = IndexPath(row: lastRow, section: lastSection)
                    self.myTable.scrollToRow(at: lastIndex, at: UITableViewScrollPosition.bottom, animated: false)
                    
                }
            }
            
            
            
         //let keyboardHeight = (screenSize.height - 67) - keyboardSize.height
         
         //print("kH: \(keyboardHeight)")
         //self.myTable.setContentOffset(CGPoint(x: 0, y: keyboardHeight), animated: true)
         
         
         }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        self.keuboardHeight = 0
        
        if((self.screenSize.width == 375) && (self.screenSize.height == 812)){
            self.keuboardHeight = 34
        }
        self.updateInputView()
        
        self.openNumPad = false
        self.tfInput.keyboardType = .default
    }
    
    
    
    // MARK: - UITextViewDelegate
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if(openNumPad == true){
            self.tfInput.keyboardType = .decimalPad
        }else{
            self.tfInput.keyboardType = .default
        }
        
        
        
        self.strMessage = textView.text!
        self.updateInputView()
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        let seconds = 0.150
        let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            
            self.strMessage = self.tfInput.text!
            self.updateInputView()
        }
        
        
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        self.strMessage = textView.text!
        self.updateInputView()
    }
    
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.strMessage = textView.text!
        self.updateInputView()
    }

    
    
   
    
}



