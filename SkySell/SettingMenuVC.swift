//
//  SettingMenuVC.swift
//  SkySell
//
//  Created by DW02 on 6/2/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase

class SettingMenuVC: UIViewController {

    enum CellName:NSInteger {
      
        case currency = 0
        case help
        case plan
        case logout
    }
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    
    
    @IBOutlet weak var viTopbarBG: UIView!
    @IBOutlet weak var btBack: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    
    
    @IBOutlet weak var myTable: UITableView!
    
    
    
    
    
    var myData:ShareData = ShareData.sharedInstance
    
    
    
    var arMenu:[String] = [String]()
    
    
    let drakColor:UIColor = UIColor(red: (39/255), green: (47/255), blue: (85/255), alpha: 1.0)
    let pinkColor:UIColor = UIColor(red: (3/255), green: (210/255), blue: (99/255), alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.viTopbarBG.backgroundColor = UIColor.white
        self.viTopbarBG.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viTopbarBG.layer.shadowRadius = 1
        self.viTopbarBG.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viTopbarBG.layer.shadowOpacity = 0.5
        self.viTopbarBG.clipsToBounds = false
        
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        
     
        arMenu.append("Currency Selection")
        arMenu.append("Help & FAQ")
        arMenu.append("Plan")
        arMenu.append("Log Out")
        
        
        

        
        do{
            let nib:UINib = UINib(nibName: "MenuLabelCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "MenuLabelCell")
        }
        
        
        
        self.myTable.delegate = self
        self.myTable.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let indexPath = self.myTable.indexPathForSelectedRow
        if let indexPath = indexPath{
            self.myTable.deselectRow(at: indexPath, animated: true)
            
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
        
        self.exitScene()
    }
    

    
    
    func exitScene() {
        showTapBar(show: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    func logOut() {
        
        
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Log Out", style: .default) { (action) in
            
            /*
            let firebaseAuth = FIRAuth.auth()
            do {
                try firebaseAuth?.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            */
            
            
            self.myData.saveUserInfo(UID: "")
            self.myData.userInfo = nil
            self.myData.userLike.removeAll()
            
            
            self.myData.saveUserEmail(UID: "")
            self.myData.saveUserPassword(UID: "")
            
            
            self.myData.showUserSceneFirstTime = true
            self.myData.haveLogout = true
            showTapBar(show: true)
            self.navigationController?.popToRootViewController(animated: true)
            
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVC_CancelSearch.rawValue), object: nil, userInfo: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.ChangeToLikeButton.rawValue), object: nil, userInfo: nil)
            
            self.myData.showUserSceneFirstTime = true
            
        }
        alertController.addAction(okAction)
        
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    
    func setCurrenct() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:CurrencySelectionVC = storyboard.instantiateViewController(withIdentifier: "CurrencySelectionVC") as! CurrencySelectionVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    
    
    
    func openPlanVC() {
        //PlanVC
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:PlanVC = storyboard.instantiateViewController(withIdentifier: "PlanVC") as! PlanVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        
    }
}





// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingMenuVC:UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
    }
    
    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
     
        
        return self.arMenu.count
    }
    
    // MARK: - Cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        
        
        return 45
    }
    
    // MARK: - Header height
    /*
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let cellHeight:CGFloat = 0
        
        
        
        return cellHeight
        
    }
    
    // MARK: - Header cell
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell:LabelHeaderCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LabelHeaderCell") as? LabelHeaderCell
        
        
        if(section < self.arOrderData.count){
            cell?.lbTitle.text = self.arOrderData[section].strDate
        }else{
            cell?.lbTitle.text = ""
        }
        cell?.lbTitle.textAlignment = .center
        
        
        
        cell?.contentView.backgroundColor = UIColor(red: (207/255), green: (241/255), blue: (255/255), alpha: 1.0)
        
        cell?.lbTitle.textColor = UIColor(red: (31/255), green: (46/255), blue: (60/255), alpha: 1.0)
        
        return cell
    }*/
    
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MenuLabelCell? = tableView.dequeueReusableCell(withIdentifier: "MenuLabelCell", for: indexPath) as? MenuLabelCell
        

        cell?.lbTitle.text = self.arMenu[indexPath.row]
    
        
        if(indexPath.row == CellName.logout.rawValue){
            cell?.lbTitle.textColor = pinkColor
        }else{
            cell?.lbTitle.textColor = drakColor
        }
        
        
        
        
        
        return cell!
        
        
        
        
    }
    
    // MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
   
        
        if(indexPath.row == CellName.logout.rawValue){
            self.logOut()
        }else if(indexPath.row == CellName.currency.rawValue){
            self.setCurrenct()
        }else if(indexPath.row == CellName.plan.rawValue){
            self.openPlanVC()
        }else if(indexPath.row == CellName.help.rawValue){
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
            let vc:WebPreviewVC = storyboard.instantiateViewController(withIdentifier: "WebPreviewVC") as! WebPreviewVC
            vc.strURL = "https://www.facebook.com/notes/mybanknotes/faq/138731376862171/"
            vc.strTitle = "Help & FAQ"
            self.present(vc, animated: true, completion: {
                
            })
            
            
        }
        
        //self.myTable.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}



