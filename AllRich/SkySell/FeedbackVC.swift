//
//  FeedbackVC.swift
//  SkySell
//
//  Created by DW02 on 6/23/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase


class FeedbackVC: UIViewController {

    
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    
    
    @IBOutlet weak var viTopBarBG: UIView!
    
    @IBOutlet weak var btBack: UIButton!
    
    @IBOutlet weak var btSubmit: UIButton!
    
    
    
    
    
    @IBOutlet weak var myTable: UITableView!
    
    
    var selectOn:FeedbackChoiceCell.SelectOn = .non
    
    
    var myActivityView:ActivityLoadingView! = nil
    var working:Bool = false
    
    
    let myData:ShareData = ShareData.sharedInstance
    
    var myChatRoom:RoomMessagesDataModel! = nil
    
    var editMode:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.clipsToBounds = true
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
 
        self.viTopBarBG.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viTopBarBG.layer.shadowRadius = 1
        self.viTopBarBG.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viTopBarBG.layer.shadowOpacity = 0.5
        
        
        
        do{
            let nib:UINib = UINib(nibName: "FeedbackTitleCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "FeedbackTitleCell")
        }
        
        
        
        do{
            let nib:UINib = UINib(nibName: "FeedbackChoiceCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "FeedbackChoiceCell")
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
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.addActivityView {
            
            self.getFeedBackData(Finish: { (select) in
                self.selectOn = select
                
                
                if(select == .non){
                    self.editMode = false
                }else{
                    self.editMode = true
                }
                DispatchQueue.main.async {
                    
                    self.myTable.reloadData()
 
                    self.removeActivityView {
                        
                        
                    }
                }
                
            })
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
    
    
    @IBAction func tapOnBack(_ sender: UIButton) {
        
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    @IBAction func tapOnSubmit(_ sender: UIButton) {
        
        
        
        var strTitle:String = "Submit Feedback"
        
        var detail:String = "Are you sure you want to submit feedback?"
        
        if(self.editMode == true){
            strTitle = "Edit Feedback"
            detail = "Are you sure you want to edit feedback?"
        }
        
        
        let alertController = UIAlertController(title: strTitle, message: detail, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            
       
        }
        alertController.addAction(cancelAction)
        
        
        let sendAction = UIAlertAction(title: "Yes, I'm sure", style: .default) { (action) in
            
           self.submitSelect()
        }
        alertController.addAction(sendAction)
        
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
        
        
        
        
    }
    
   
    // MARK: - Connect to server
    func getFeedBackData(Finish finish:@escaping(_ status:FeedbackChoiceCell.SelectOn)->Void) {
        
        
        var uID:String = self.myChatRoom.receivedByUserId
        
        if(self.myData.userInfo.uid == self.myChatRoom.receivedByUserId){
            uID = self.myChatRoom.createdByUserId
        }
        
        getUserDataWith(UID: uID) { (uData) in
          
            
            var pStatus:FeedbackChoiceCell.SelectOn = .non
            
            for pEmo in uData.positive_list{
                if(pEmo.product_id == self.myChatRoom.product_id){
                    
                    for u in pEmo.arUser_Uid{
                        if(u == self.myData.userInfo.uid){
                            pStatus = .positive
                            break
                        }
                    }
                }
            }
            
            for pEmo in uData.negative_list{
                if(pEmo.product_id == self.myChatRoom.product_id){
                    
                    for u in pEmo.arUser_Uid{
                        if(u == self.myData.userInfo.uid){
                            pStatus = .negative
                            break
                        }
                    }
                }
            }
            
            
            for pEmo in uData.neutral_list{
                if(pEmo.product_id == self.myChatRoom.product_id){
                    
                    for u in pEmo.arUser_Uid{
                        if(u == self.myData.userInfo.uid){
                            pStatus = .neutral
                            break
                        }
                    }
                }
            }
            
            
            finish(pStatus)
            
        }
        
        
        
        
    }
    
    
    
    func submitSelect() {
        
        self.addActivityView {
            
            
            self.postToNeutral(status: self.selectOn)
            self.postToNegative(status: self.selectOn)
            self.postToPositive(status: self.selectOn)
            
            let seconds = 2.450
            
            
            let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                
                self.removeActivityView {
                    
                    let alertController = UIAlertController(title: "Thank you for your feedback.", message: nil, preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Close", style: .cancel) { (action) in
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(cancelAction)
                    
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
            
            
        }
        
    }
    
    // MARK: -
    
    func postToPositive(status:FeedbackChoiceCell.SelectOn){
    
        var uID:String = self.myChatRoom.receivedByUserId
        
        if(self.myData.userInfo.uid == self.myChatRoom.receivedByUserId){
            uID = self.myChatRoom.createdByUserId
        }
        
        let postRef = FIRDatabase.database().reference().child("users").child(uID).child("positive_list").child(self.myChatRoom.product_id).child(self.myData.userInfo.uid)
        
        
        if(status == .positive){
            postRef.setValue(true)
        }else{
            postRef.setValue(nil)
        }
        
    }
    
    
    func postToNegative(status:FeedbackChoiceCell.SelectOn){
        
        var uID:String = self.myChatRoom.receivedByUserId
        
        if(self.myData.userInfo.uid == self.myChatRoom.receivedByUserId){
            uID = self.myChatRoom.createdByUserId
        }
        
        let postRef = FIRDatabase.database().reference().child("users").child(uID).child("negative_list").child(self.myChatRoom.product_id).child(self.myData.userInfo.uid)
        
        
        if(status == .negative){
            postRef.setValue(true)
        }else{
            postRef.setValue(nil)
        }
        
    }
    
    func postToNeutral(status:FeedbackChoiceCell.SelectOn){
        
        var uID:String = self.myChatRoom.receivedByUserId
        
        if(self.myData.userInfo.uid == self.myChatRoom.receivedByUserId){
            uID = self.myChatRoom.createdByUserId
        }
        
        let postRef = FIRDatabase.database().reference().child("users").child(uID).child("neutral_list").child(self.myChatRoom.product_id).child(self.myData.userInfo.uid)
        
        
        if(status == .neutral){
            postRef.setValue(true)
        }else{
            postRef.setValue(nil)
        }
        
    }
    
    // MARK: - Activity
    
    func addActivityView(Finish finish:@escaping ()->Void){
        
        if(self.myActivityView == nil){
            
            
            
            
            
            myActivityView = ActivityLoadingView(frame: CGRect(x: 0, y: 67, width: screenSize.width, height: screenSize.height - 67))
            
            
            
            
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
                }
                
                self.myActivityView = nil
                finish()
            })
        }else{
            finish()
        }
        
    }

    
    
    
    
    
    
    
}



// MARK: - UITableViewDelegate, UITableViewDataSource
extension FeedbackVC:UITableViewDelegate, UITableViewDataSource{
    
    
    
    
    // MARK: - numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
    }
    
    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        
        
        return 2
    }
    
    // MARK: - Cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        var cellHeight:CGFloat = 60
        
        if(indexPath.row == 0){
            cellHeight = 60
        }else{
            cellHeight = 96
        }
        
        return cellHeight
    }
    
    /*
    // MARK: - Header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let cellHeight:CGFloat = 0
        
        
        
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
    
    */
    
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if(indexPath.row == 0){
            let cell:FeedbackTitleCell? = tableView.dequeueReusableCell(withIdentifier: "FeedbackTitleCell", for: indexPath) as? FeedbackTitleCell
            
            cell?.selectionStyle = .none
            
            
            
            return cell!
            
            
        }else{
            let cell:FeedbackChoiceCell? = tableView.dequeueReusableCell(withIdentifier: "FeedbackChoiceCell", for: indexPath) as? FeedbackChoiceCell
            
            cell?.selectionStyle = .none
            
            cell?.selectOn = self.selectOn
            cell?.callBackSelect = { (select) in
                self.selectOn = select
                
            }
            
            return cell!
        }
        
        
        
        
        
        
        
        
        
    }
    
    // MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
     
        
        
        
        
        
        
        
        
        self.myTable.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //self.tfInput.resignFirstResponder()
        
    }
    
}




