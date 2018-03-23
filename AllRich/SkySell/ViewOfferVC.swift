//
//  ViewOfferVC.swift
//  SkySell
//
//  Created by DW02 on 8/11/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift



class ViewOfferVC: UIViewController {

    
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    
    @IBOutlet weak var btBuying: UIButton!
    @IBOutlet weak var viTopBarBG: UIView!
    
    
    let blueColor:UIColor = UIColor(red: (39.0/255.0), green: (47.0/255.0), blue: (85.0/255.0), alpha: 1.0)
    let pinkColor:UIColor = UIColor(red: (3.0/255.0), green: (210.0/255.0), blue: (99.0/255.0), alpha: 1.0)
    
    
    
    var arRoom:[RoomMessagesDataModel] = [RoomMessagesDataModel]()
    
    
    let myData:ShareData = ShareData.sharedInstance
    let mySetting:SettingData = SettingData.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    
    // MARK: - Action

    @IBAction func tapOnBack(_ sender: UIButton) {
        
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    
}
