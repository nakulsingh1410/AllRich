//
//  ReferAndEarnViewController.swift
//  SkySell
//
//  Created by Nakul Singh on 3/23/18.
//  Copyright © 2018 DW02. All rights reserved.
//

import UIKit

class ReferAndEarnViewController: UIViewController {
    
    @IBOutlet weak var inviteImage: UIImageView!
    @IBOutlet weak var lblInviteCode: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inviteImage.layer.cornerRadius = 10.0
        inviteImage.clipsToBounds = true

        btnShare.layer.cornerRadius = 3.0
        btnShare.clipsToBounds = true
        loadinviteCode()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private  func loadinviteCode()  {
        lblInviteCode.text =  ShareData.sharedInstance.userInfo.userReferKey
        
    }
    
    
    private func shareInviteCode() {
        // text to share
        if let inviteCode = lblInviteCode.text {
            let strInviteCode = inviteCode
            // set up activity view controller
            
            let appShareUrl =  "https://itunes.apple.com/in/app/allrich/id1362807498?mt=8"
            let shareContent =  "Hi, Use my referral code \(strInviteCode) to signup, click \(appShareUrl) to download the AllRich app."
            
            let textToShare:[Any] = [ shareContent]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    // MARK: - IBAction
    @IBAction func btnShareTapped(_ sender: Any) {
        shareInviteCode()
    }
    @IBAction func btnShareOnContactTapped(_ sender: Any) {
//        let objController = self.storyboard?.instantiateViewControllerWithIdentifier("ContactListVCID") as! ContactListVC
//        objController.contactType = .PhoneNumber
//        self.navigationController?.pushViewController(objController, animated: true)
    
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
}
