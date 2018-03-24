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
        
        btnShare.layer.cornerRadius = 3.0
        btnShare.clipsToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   private  func loadinviteCode()  {
    lblInviteCode.text =  ShareData.sharedInstance.loadSaveUserReferKey()
    
    }
    
    
    private func shareInviteCode() {
        // text to share
        if let inviteCode = lblInviteCode.text {
            let text = inviteCode
            // set up activity view controller
            let textToShare = [ text ]
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
    
    @IBAction func btnBackTapped(_ sender: Any) {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
}
