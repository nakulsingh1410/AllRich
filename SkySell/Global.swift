//
//  Global.swift
//  SkySell
//
//  Created by Nakul Singh on 3/20/18.
//  Copyright © 2018 DW02. All rights reserved.
//

import UIKit

let appDelegate =  UIApplication.shared.delegate as! AppDelegate
class Global: NSObject {

    
   
    
    class func showAlert(navigationController :UINavigationController?,message:String)  {
        DispatchQueue.main.async {

        let alertController = UIAlertController(title: "AllRich", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        navigationController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func showAlertOnController(viewController :UIViewController,message:String)  {
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: "AllRich", message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            }
            alertController.addAction(cancelAction)
            viewController.present(alertController, animated: true, completion: nil)
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
    
    class func EmptyMessage(message:String, viewController:UIViewController,tableView:UITableView) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: viewController.view.bounds.size.width, height: viewController.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
//        messageLabel.font = Font.gillSansRegular(size: 17)
        messageLabel.sizeToFit()
        tableView.backgroundView = messageLabel;
        tableView.separatorStyle = .none;
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

