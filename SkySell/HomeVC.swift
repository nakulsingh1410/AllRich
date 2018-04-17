//
//  HomeVC.swift
//  SkySell
//
//  Created by supapon pucknavin on 4/16/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    
    @IBOutlet weak var viTopBarBG: UIView!
    
    @IBOutlet weak var btBack: UIButton!
    
    @IBOutlet weak var btBack_layout_Width: NSLayoutConstraint!
    
    @IBOutlet weak var btLike: UIButton!
    
    @IBOutlet weak var viSearchBG: UIView!
    
    @IBOutlet weak var viSearchBG_layout_Leading: NSLayoutConstraint!
    
    
    @IBOutlet weak var tfSearch: UITextField!
    
    
    var myHomeNavigationVC:HomeNavigationContainerVC? = nil
    
    
    
    var haveNoti:Bool = false
    
    

    var inModeSearch:Bool = false
    var searchInCategory:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.btBack.clipsToBounds = true
        self.btLike.clipsToBounds = true
        self.viSearchBG.clipsToBounds = true
        self.viSearchBG.layer.cornerRadius = 4
        
        
        
        self.btBack_layout_Width.constant = 0
        self.viSearchBG_layout_Leading.constant = 0
        
        
        
        if(self.haveNoti == false){
            self.haveNoti = true
            NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.setShowBackButton(notification:)), name:NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVCSetShowBackButton.rawValue), object: nil)
            
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.setShowSearchBar(notification:)), name:NSNotification.Name(rawValue: SkySell_Notification_Name.SearchMapShow.rawValue), object: nil)
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.changeToLikeButton(notification:)), name:NSNotification.Name(rawValue: SkySell_Notification_Name.ChangeToLikeButton.rawValue), object: nil)
            
            
            
        }
        
        
        self.tfSearch.isEnabled = true
        self.tfSearch.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit {
        if(self.haveNoti == true){
            self.haveNoti = false
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVCSetShowBackButton.rawValue), object: nil)
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SkySell_Notification_Name.SearchMapShow.rawValue), object: nil)
            
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SkySell_Notification_Name.ChangeToLikeButton.rawValue), object: nil)
        }
    }

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segHomeNavigationContainerVC" {
            
            self.myHomeNavigationVC = segue.destination as? HomeNavigationContainerVC
  
        }
        
        
    }
  

    // MARK: - Action
    
    @IBAction func tapOnBack(_ sender: UIButton) {
        if(self.inModeSearch == true){
            
            self.inModeSearch = false
            self.tfSearch.text = ""
            self.tfSearch.resignFirstResponder()
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVCTapOnBack.rawValue), object: nil, userInfo: nil)
    }
    
    @IBAction func tapOnLike(_ sender: UIButton) {
        
        if(self.inModeSearch == false){
            
            //MyLikesVC
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.GotoLikesScene.rawValue), object: nil, userInfo: nil)
            
            
            
            
            
        }else{
            self.inModeSearch = false
            
            let im:UIImage = UIImage(named: "like.png")!
            self.btLike.setImage(im, for: UIControlState.normal)
            self.btLike.setTitle("", for: UIControlState.normal)
            
            self.tfSearch.text = ""
            self.tfSearch.resignFirstResponder()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVC_CancelSearch.rawValue), object: nil, userInfo: nil)
            
        }
    }
    
    
    
    
    
    
    
    
    // MARK: - notitfication
    func changeToLikeButton(notification:NSNotification){
        self.inModeSearch = false
        
        let im:UIImage = UIImage(named: "like.png")!
        self.btLike.setImage(im, for: UIControlState.normal)
        self.btLike.setTitle("", for: UIControlState.normal)
        
        self.tfSearch.text = ""
        self.tfSearch.resignFirstResponder()
    }
    
    
    func setShowBackButton(notification:NSNotification){
        
        
        if let show = notification.userInfo?["show"] as? Bool {
            
        
            
            if(show == true){
                self.btBack_layout_Width.constant = 47
                self.viSearchBG_layout_Leading.constant = 8
                self.searchInCategory = true
            }else{
                self.btBack_layout_Width.constant = 0
                self.viSearchBG_layout_Leading.constant = 0
                self.searchInCategory = false
                self.tfSearch.text = ""
            }
            
            UIView.animate(withDuration: 0.2, animations: { 
                self.view.layoutIfNeeded()
                self.view.updateConstraints()
            })
            
        }
        
    }
    
    
    
    func setShowSearchBar(notification:NSNotification){
        
        
        if let show = notification.userInfo?["show"] as? Bool {
            
            
            
            print(show)
            
            UIView.animate(withDuration: 0.2, animations: {
                if(show == true){
                    self.viSearchBG.alpha = 1
                    self.viSearchBG.isUserInteractionEnabled = true
                    
                    
                    /*
                    if(self.inModeSearch == false){
                        
                        self.inModeSearch = false
                        
                        let im:UIImage = UIImage(named: "like.png")!
                        self.btLike.setImage(im, for: UIControlState.normal)
                        self.btLike.setTitle("", for: UIControlState.normal)
                        self.tfSearch.text = ""
                        self.tfSearch.resignFirstResponder()
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVC_CancelSearch.rawValue), object: nil, userInfo: nil)
                        
                        self.posrSearchWithKey(key: self.tfSearch.text!)
                        
                    }
                    */
                }else{
                    self.viSearchBG.alpha = 0
                    self.viSearchBG.isUserInteractionEnabled = false
                    
                    
                    /*
                    if(self.inModeSearch == false){
  
                        
                        
                    }else{
                        self.inModeSearch = false
                        
                        let im:UIImage = UIImage(named: "like.png")!
                        self.btLike.setImage(im, for: UIControlState.normal)
                        self.btLike.setTitle("", for: UIControlState.normal)
                        self.tfSearch.text = ""
                        self.tfSearch.resignFirstResponder()
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVC_CancelSearch.rawValue), object: nil, userInfo: nil)
                        
                        self.posrSearchWithKey(key: self.tfSearch.text!)
                        
                    }
                    */
                    
                    
                    
                    
                }
            })
            
        }
        
    }
    
}



// MARK: - UITextFieldDelegate
extension HomeVC:UITextFieldDelegate{
    
    
    func posrSearchWithKey(key:String) {
        
        var object:[String:String] = [String:String]()
        object["key"] = key
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVC_SearchWithKey.rawValue), object: nil, userInfo: object)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if(self.inModeSearch == false){
            self.inModeSearch = true
            
            if(self.searchInCategory == false){
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVCGotoSearchModeAll.rawValue), object: nil, userInfo: nil)
            }
            
            
            self.btLike.setImage(nil, for: UIControlState.normal)
            self.btLike.setTitle("Cancel", for: UIControlState.normal)
        }
        
        
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let seconds = 0.150
        let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            
            self.posrSearchWithKey(key: self.tfSearch.text!)
            
        }
        
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        let seconds = 0.150
        let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            
            self.posrSearchWithKey(key: self.tfSearch.text!)
            
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        
        self.posrSearchWithKey(key: self.tfSearch.text!)
        
        
        return true
        
    }
    
}

