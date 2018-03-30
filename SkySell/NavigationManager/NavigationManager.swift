//
//  NavigationManager.swift
//  SkySell
//
//  Created by Nakul Singh on 3/23/18.
//  Copyright © 2018 DW02. All rights reserved.
//

import UIKit

class NavigationManager: NSObject {

    class func navigateToPayment(navigationController:UINavigationController?,email:String,userId:String,iSTopup:Bool){
        let storyboard = UIStoryboard(name: "Payment", bundle:  Bundle(for: PaymentViewController.self) )
        if let vcObj = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController{
            vcObj.email = email
            vcObj.userId = userId
            vcObj.isTopup = iSTopup
            navigationController?.pushViewController(vcObj, animated: true)
        }
    }
    
    class func navigateToHome(navigationController:UINavigationController?){
        let storyboard = UIStoryboard(name: "Main", bundle:  nil )
        if let vc:UserMainSceneVC = storyboard.instantiateViewController(withIdentifier: "UserMainSceneVC") as? UserMainSceneVC {
            SkySell.showTapBar(show: true)
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    class func navigateToReferAndEarn(navigationController:UINavigationController?){
        let storyboard = UIStoryboard(name: "ReferAndEarn", bundle:  nil )
        if let vcObj = storyboard.instantiateViewController(withIdentifier: "ReferAndEarnViewController") as? ReferAndEarnViewController {
            navigationController?.pushViewController(vcObj, animated: true)
        }
        
    }
    
    class func navigateToPaymentHistory(navigationController:UINavigationController?){
        let storyboard = UIStoryboard(name: "PaymentHistory", bundle:  nil )
        if let vcObj = storyboard.instantiateViewController(withIdentifier: "PaymentHistoyViewController") as? PaymentHistoyViewController {
            navigationController?.pushViewController(vcObj, animated: true)
        }
        
    }
    
    
    func showTapBar(show:Bool) {
        var object:[String:Bool] = [String:Bool]()
        object["show"] = show
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HidenMainTapBar.rawValue), object: nil, userInfo: object)
        
        
    }
    
    class func navigateToFriendequest(navigationController:UINavigationController?){
        let storyboard = UIStoryboard(name: "FriendRequest", bundle:  nil )
        if let vcObj = storyboard.instantiateViewController(withIdentifier: "FriendRequestViewController") as? FriendRequestViewController {
            navigationController?.pushViewController(vcObj, animated: true)
        }
        
    }
    
    
    class func moveToRoot(navigationController :UINavigationController?)  {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title:"AllRich", message: "Success!!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                navigationController?.popToRootViewController(animated: true)
            }
            alertController.addAction(cancelAction)
            navigationController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func popWithAlert(navigationController :UINavigationController?)  {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title:"AllRich", message: "Successfully Added!!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                navigationController?.popViewController(animated: true)
            }
            alertController.addAction(cancelAction)
            navigationController?.present(alertController, animated: true, completion: nil)
        }
    }
    
}
