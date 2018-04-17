//
//  ReferAndEarnViewController.swift
//  SkySell
//
//  Created by Nakul Singh on 3/23/18.
//  Copyright © 2018 DW02. All rights reserved.
//

import UIKit
import MessageUI

class ReferAndEarnViewController: UIViewController {
    
    @IBOutlet weak var inviteImage: UIImageView!
    @IBOutlet weak var lblInviteCode: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    
    let appShareUrl =  "https://itunes.apple.com/in/app/allrich/id1362807498?mt=8"

    
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

        if (MFMessageComposeViewController.canSendText()) {
            if let inviteCode = lblInviteCode.text {
                let strInviteCode = inviteCode
                // set up activity view controller
                let shareContent =  "Hi, Use my referral code \(strInviteCode) to signup, click \(appShareUrl) to download the AllRich app."
                let controller = MFMessageComposeViewController()
                controller.body = shareContent
                //            controller.recipients = [phoneNumber.text]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
                
            }

        }
    
    }
    @IBAction func btnShareOnEmailTapped(_ sender: Any) {
    
        if MFMailComposeViewController.canSendMail() {
            if let inviteCode = lblInviteCode.text {
                let strInviteCode = inviteCode
                // set up activity view controller
                let shareContent =  "Hi, Use my referral code \(strInviteCode) to signup, click \(appShareUrl) to download the AllRich app."
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
//                mail.setToRecipients(["paul@hackingwithswift.com"])
                mail.setMessageBody(shareContent, isHTML: false)
                
                present(mail, animated: true)
            }
           
        } else {
            // show failure alert
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
}

extension ReferAndEarnViewController: MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)

    }
}

extension ReferAndEarnViewController:MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
    }
    
}
