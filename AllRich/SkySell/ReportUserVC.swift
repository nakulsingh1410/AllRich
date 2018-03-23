//
//  ReportUserVC.swift
//  SkySell
//
//  Created by DW02 on 6/27/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift


class ReportUserVC: UIViewController {

    
    enum ReportMode{
        case reportsProduct
        case reportsUser
    }
    
    
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var viTopBarBG: UIView!
    
    @IBOutlet weak var btBack: UIButton!
    
    var strTitle:String = "Report User"
    
    
    
    @IBOutlet weak var myTable: UITableView!
    
    
    var strHeader:String = ""
    
    var mode:ReportMode = .reportsUser
    
    
    var myActivityView:ActivityLoadingView! = nil
    
    var working:Bool = false
    let myData:ShareData = ShareData.sharedInstance
    let mySetting:SettingData = SettingData.sharedInstance
    
    
    var fontHeader:UIFont = UIFont(name: "Avenir-Roman", size: 14)!
    var fontCell:UIFont = UIFont(name: "Avenir-Roman", size: 14)!
    
    
    
    var arChoice:[ReportChoiceDataModel] = [ReportChoiceDataModel]()
    
    
    
    var reportToUserID:String = ""
    var reportToProduct:String = ""
    
    
    var dateFormatFull:DateFormatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        
        self.view.clipsToBounds = true
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        
        self.viTopBarBG.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viTopBarBG.layer.shadowRadius = 1
        self.viTopBarBG.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viTopBarBG.layer.shadowOpacity = 0.5
        
        
        
        
        
        
        
        
    
        if(mode == .reportsUser){
            self.strTitle = "Report User"
            self.strHeader = "WHY ARE YOU REPORTING THIS USER?"
            
        }else{
            self.strTitle = "Report Listing"
            self.strHeader = "WHY ARE YOU REPORTING THIS LISTING?"
        }
        
        
        
        self.lbTitle.text = strTitle
        
        
        
        do{
            let nib:UINib = UINib(nibName: "ReportHeaderCell", bundle: nil)
            self.myTable.register(nib, forHeaderFooterViewReuseIdentifier: "ReportHeaderCell")
        }
        
        
        
        do{
            let nib:UINib = UINib(nibName: "ReportCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "ReportCell")
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
        
        
        if(self.arChoice.count <= 0){
            self.addActivityView {
                self.getChoiceData()
                
            }
        }
        
        
        let indexSelect = self.myTable.indexPathForSelectedRow
        if let indexSelect = indexSelect{
            self.myTable.deselectRow(at: indexSelect, animated: true)
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
        self.dismiss(animated: true) { 
            
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
    
    
    
    
    
    // MARK: - Connect
    func getChoiceData(){
        
        
        var reportType:String = "report_user"
        if(self.mode == .reportsProduct){
            reportType = "report_listing"
        }
        let postRef = FIRDatabase.database().reference().child("setting").child(reportType)
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            DispatchQueue.main.async {
                
                
                self.arChoice.removeAll()
                if let value = snapshot.value as? [String:Any]{
                    
                    
                    var arC:[ReportChoiceDataModel] = [ReportChoiceDataModel]()
                    
                    for obj in value.values{
                        if let obj = obj as? [String:Any]{
                            
                            
                            let choice:ReportChoiceDataModel = ReportChoiceDataModel(dictionary: obj)
                            
                            if(choice.isActive == true){
                                arC.append(choice)
                            }
                            
                        }
                    }
                    
                    
                    self.arChoice = arC.sorted(by: { (obj1, obj2) -> Bool in
                        
                        return obj1.position < obj2.position
                    })
                    
                    
                    
                    
                }
                
                self.myTable.reloadData()
                
                self.removeActivityView {
                    
                }
                
                
            }

        })
        
        
    }
    
    
    
    ///------------------
    
    func createReportsUserWith(Report reportChoice:ReportChoiceDataModel, Finish finish:@escaping (String)->Void){
        
        
        let postRef = FIRDatabase.database().reference().child("reports-user").childByAutoId()
        let pId:String = postRef.key
        
        var reportObj:[String:Any] = [String:Any]()
        
        reportObj["report_id"] = pId
        reportObj["user_id"] = self.reportToUserID
        reportObj["reporter_id"] = self.myData.userInfo.uid
        reportObj["status"] = "Report"
        reportObj["created_at"] = FIRServerValue.timestamp()//self.dateFormatFull.string(from: Date())
        reportObj["updated_at"] = FIRServerValue.timestamp()//self.dateFormatFull.string(from: Date())
        
        reportObj["reason_id"] = reportChoice.reason_id
        reportObj["reason_title"] = reportChoice.reason_title
        
        
        postRef.setValue(reportObj) { (error, referent) in
            
            if(error == nil){
                finish(pId)
            }else{
                finish("")
            }
            
        }
        
        
    }
    
    func updateReportIDToUser(ReportID reportID:String,  Finish finish:@escaping (String)->Void){
        
        
        let postRef1 = FIRDatabase.database().reference().child("users").child(self.reportToUserID).child("report_id").child(reportID)
        postRef1.setValue(true) { (error, referent) in
            
            if(error == nil){
                finish(reportID)
            }else{
                finish("")
            }
            
        }
        

        
    }
    
    func updateReportStatusToUser(ReportID reportID:String, Finish finish:@escaping (String)->Void){
        
        
        let postRef1 = FIRDatabase.database().reference().child("users").child(self.reportToUserID).child("status")
        postRef1.setValue("Report") { (error, referent) in
            
            if(error == nil){
                finish(reportID)
            }else{
                finish("")
            }
            
        }
        
        
     
        
    }
    
    ///------------------
    

    func createReportsProductWith(Report reportChoice:ReportChoiceDataModel, Finish finish:@escaping (String)->Void){
        
        
        let postRef = FIRDatabase.database().reference().child("reports-product").childByAutoId()
        let pId:String = postRef.key
        
        var reportObj:[String:Any] = [String:Any]()
        
        reportObj["report_id"] = pId
        reportObj["owner_product_id"] = self.reportToUserID
        reportObj["reporter_id"] = self.myData.userInfo.uid
        reportObj["product_id"] = self.reportToProduct
        reportObj["status"] = "Report"
        reportObj["created_at"] = FIRServerValue.timestamp()//self.dateFormatFull.string(from: Date())
        reportObj["updated_at"] = FIRServerValue.timestamp()//self.dateFormatFull.string(from: Date())
        
        reportObj["reason_id"] = reportChoice.reason_id
        reportObj["reason_title"] = reportChoice.reason_title
        
        
        postRef.setValue(reportObj) { (error, referent) in
            
            if(error == nil){
                finish(pId)
            }else{
                finish("")
            }
            
        }
        
        
    }
    
    func updateReportIDToProduct(ReportID reportID:String,  Finish finish:@escaping (String)->Void){
        
        
        let postRef1 = FIRDatabase.database().reference().child("products").child(self.reportToProduct).child("report_id").child(reportID)
        postRef1.setValue(true) { (error, referent) in
            
            if(error == nil){
                finish(reportID)
            }else{
                finish("")
            }
            
        }
        
        
        
    }
    
    func updateReportStatusToProduct(ReportID reportID:String, Finish finish:@escaping (String)->Void){
        
        
        let postRef1 = FIRDatabase.database().reference().child("products").child(self.reportToProduct).child("status")
        postRef1.setValue("Report") { (error, referent) in
            
            if(error == nil){
                finish(reportID)
            }else{
                finish("")
            }
            
        }
        
        
        
        
    }
    
    ///------------------
    
    
    
}







// MARK: - UITableViewDelegate, UITableViewDataSource
extension ReportUserVC:UITableViewDelegate, UITableViewDataSource{
    
    
    
    
    // MARK: - numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
    }
    
    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfCell:NSInteger = self.arChoice.count
        
        
       
        
        
        return numberOfCell
    }
    
    // MARK: - Cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        var cellHeight:CGFloat = 40
        
        
        let choice = self.arChoice[indexPath.row]
        
        cellHeight = heightForView(text: choice.reason_title, Font: self.fontHeader, Width: (self.screenSize.width - 60)) + 20
        
        if(cellHeight < 40){
            cellHeight = 40
        }
        
        return cellHeight
    }
    
    
    // MARK: - Header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var cellHeight:CGFloat = 53
        
        cellHeight = heightForView(text: self.strHeader, Font: self.fontHeader, Width: (self.screenSize.width - 60)) + 20
        
        if(cellHeight < 53){
            cellHeight = 53
        }
        
        
        return cellHeight
        
    }
    
    // MARK: - Header cell
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell:ReportHeaderCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ReportHeaderCell") as? ReportHeaderCell
        

        cell?.lbTitle.text = strHeader
        
        
        
        return cell
    }
    
    
    
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:ReportCell? = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as? ReportCell
        
        cell?.selectionStyle = .default
        
        
        let choice = self.arChoice[indexPath.row]
        
        cell?.lbTitle.text = choice.reason_title
        
        return cell!
        
        
        
    }
    
    // MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        //self.myTable.deselectRow(at: indexPath, animated: true)
        let choice = self.arChoice[indexPath.row]
        
        
        
        var strTitle:String = "Flag for Review?"
        
        
        var detail:String = "Are you sure you want to report this user?"
        
        
        
        
        if(self.mode == .reportsProduct){
            strTitle = "Flag for Review?"
            detail = "Are you sure you want to report this product?"
        }
        
     
        
        
        let alertController = UIAlertController(title: strTitle, message: detail, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            let indexSelect = self.myTable.indexPathForSelectedRow
            if let indexSelect = indexSelect{
                self.myTable.deselectRow(at: indexSelect, animated: true)
            }
            
        }
        alertController.addAction(cancelAction)
        
        
        let sendAction = UIAlertAction(title: "Yes, I'm sure", style: .default) { (action) in
            
            
            self.addActivityView {
                if(self.mode == .reportsProduct){
                    
                    self.createReportsProductWith(Report: choice, Finish: { (reportID) in
                        self.updateReportIDToProduct(ReportID: reportID, Finish: { (reportID) in
                            self.updateReportStatusToProduct(ReportID: reportID, Finish: { (reportID) in
                                
                                self.removeActivityView {
                                    self.dismiss(animated: true, completion: { 
                                        
                                    })
                                }
                                
                                
                            })
                        })
                    })
                    
                }else{
                    
                    
                    self.createReportsUserWith(Report: choice, Finish: { (reportID) in
                        self.updateReportIDToUser(ReportID: reportID, Finish: { (reportID) in
                            self.updateReportStatusToUser(ReportID: reportID, Finish: { (reportID) in
                                
                                
                                self.removeActivityView {
                                    self.dismiss(animated: true, completion: {
                                        
                                    })
                                }
                                
                                
                            })
                        })
                    })
                    
                    
                }
            }
            
            
            
            
            
        }
        alertController.addAction(sendAction)
        
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
        
        
        
    }
    
 
    
}




