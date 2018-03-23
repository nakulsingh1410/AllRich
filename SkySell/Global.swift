//
//  Global.swift
//  SkySell
//
//  Created by Nakul Singh on 3/20/18.
//  Copyright © 2018 DW02. All rights reserved.
//

import UIKit

class Global: NSObject {

    
    class func navigateToPayment(navigationController:UINavigationController?,email:String,userId:String){
        let storyboard = UIStoryboard(name: "Payment", bundle:  Bundle(for: PaymentViewController.self) )
        if let vcObj = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController{
            vcObj.email = email
            vcObj.userId = userId
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
    
    func showTapBar(show:Bool) {
        var object:[String:Bool] = [String:Bool]()
        object["show"] = show
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HidenMainTapBar.rawValue), object: nil, userInfo: object)
        
        
    }
    
    
   class func moveToRoot(navigationController :UINavigationController?)  {
    
    DispatchQueue.main.async {
        let alertController = UIAlertController(title:"AllRich", message: "Registeed Successfully!!", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(cancelAction)
        navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    
    }
    
    
    class func showAlert(navigationController :UINavigationController?,message:String)  {
        DispatchQueue.main.async {

        let alertController = UIAlertController(title: "AllRich", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        navigationController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK:- Show HUD
    //    MARK:- HUD
    static func showHud(_ title: String = "Loading...") {
        
        DispatchQueue.main.async {
            let hud = HudView.sharedInstance
            hud.title = title
            
            if let topController = UIApplication.topViewController() {
                hud.translatesAutoresizingMaskIntoConstraints = false
                topController.view.addSubview(hud)
                
                Constarints.setConstraint(hud, attribute: .top, relatedBy: .equal, toItem: topController.view, attributeSecond: .top, multiplier: 1.0, constant: 0, vcMain: topController.view);
                
                Constarints.setConstraint(hud, attribute: .leading, relatedBy: .equal, toItem: topController.view, attributeSecond: .leading, multiplier: 1.0, constant: 0, vcMain: topController.view);
                
                Constarints.setConstraint(hud, attribute: .trailing, relatedBy: .equal, toItem: topController.view, attributeSecond: .trailing, multiplier: 1.0, constant: 0, vcMain: topController.view);
                
                Constarints.setConstraint(hud, attribute: .bottom, relatedBy: .equal, toItem: topController.view, attributeSecond: .bottom, multiplier: 1.0, constant:0, vcMain: topController.view);
                
                topController.view.layoutIfNeeded()
                topController.view.bringSubview(toFront: hud)
            }
            
        }
    }
    
    static func hideHud() {
          DispatchQueue.main.async {
            HudView.sharedInstance.removeFromSuperview()
        }
    }
    
    
}

extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
//        if let slide = viewController as? SlideMenuController {
//            return topViewController(slide.mainViewController)
//        }
        return viewController
    }
}

