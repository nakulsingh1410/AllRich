//
//  ProductContainerVC.swift
//  SkySell
//
//  Created by supapon pucknavin on 4/17/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

protocol ProductContainerDelegate{
    func beginTransition(FromView from:ProductContainerVC.SegName, ToView to:ProductContainerVC.SegName)
    func finishTransition(FromView from:ProductContainerVC.SegName, ToView to:ProductContainerVC.SegName)
}


class ProductContainerVC: UIViewController {

    enum SegName:String {
        case toProductList = "segToProductListVC"
        case toProductMap = "segToProductMapVC"
    }
    
    
    var myProductList:ProductListVC? = nil
    var myProductMap:ProductMapVC? = nil
   
    
    var transitionInProgress:Bool! = false
    
    
    var currentSegueIdentifier:SegName = .toProductList
    var laseSegueIdentifier:SegName = .toProductList
    
  
    
    
    var delegete:ProductContainerDelegate! = nil
    
    
    var category:CategoriesDataModel! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.performSegue(withIdentifier: currentSegueIdentifier.rawValue, sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegName.toProductList.rawValue {
            self.myProductList = segue.destination as? ProductListVC
            if let myProductList = self.myProductList{
                myProductList.category = self.category
            }
        }
        
        if segue.identifier == SegName.toProductMap.rawValue {
            self.myProductMap = segue.destination as? ProductMapVC
            if let myProductMap = self.myProductMap{
                myProductMap.category = self.category
            }
        }
        
  
        
        
        
        
        if segue.identifier == SegName.toProductList.rawValue {
            
            if (self.childViewControllers.count > 0) {
                self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myProductList!)
            }else{
                self.addChildViewController(segue.destination)
                let destView = (segue.destination as! ProductListVC).view
                if let destView = destView{
                    destView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    self.view.addSubview(destView)
                    segue.destination.didMove(toParentViewController: self)
                }
                
            }
        } else if segue.identifier == SegName.toProductMap.rawValue {
            
            self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myProductMap!)
            
        }
    }
    
    
    
    func swapFromViewController(fromViewController:UIViewController,ToViewController toViewController:UIViewController){
        
        toViewController.view.frame =  CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        
        fromViewController.willMove(toParentViewController: nil)
        self.addChildViewController(toViewController)
        
        
        self.transition(from: fromViewController, to: toViewController, duration: 0.45, options: UIViewAnimationOptions.transitionCrossDissolve, animations: nil, completion: { (finished) -> Void in
            fromViewController.removeFromParentViewController()
            toViewController.didMove(toParentViewController: self)
            self.transitionInProgress = false
            
            if(self.delegete != nil){
                self.delegete.finishTransition(FromView: self.laseSegueIdentifier, ToView: self.currentSegueIdentifier)
            }
            
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotiFinishTransition"), object: nil)
            
        })
        
    }
    
    
    
    func swapToview(identifier:SegName){
        
        
        
        if((self.transitionInProgress == true)||(self.currentSegueIdentifier == identifier)){
            return
        }
        
        
        switch(identifier){
        case SegName.toProductList:
            self.showTapBar(show: true)
            break
        case SegName.toProductMap:
            self.showTapBar(show: false)
            break
        }
        
        
        
        self.laseSegueIdentifier = currentSegueIdentifier
        
        self.currentSegueIdentifier = identifier
        
        
        self.transitionInProgress = true
        
        if(self.delegete != nil){
            self.delegete.beginTransition(FromView: currentSegueIdentifier, ToView: identifier)
        }
        
        switch(identifier){
        case SegName.toProductList:
            
            if let _ = self.myProductList{
                
                
                
       
                
                self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myProductList!)
                return;
            }
            
            break
        case SegName.toProductMap:
            if let _ = self.myProductMap{
                
                
        
                
                self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myProductMap!)
                return;
            }
            
            break
      
        }
        
        self.performSegue(withIdentifier: self.currentSegueIdentifier.rawValue, sender: nil)
        
        
    }
    
    
    
    func showTapBar(show:Bool) {
        var object:[String:Bool] = [String:Bool]()
        object["show"] = show
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HidenMainTapBar.rawValue), object: nil, userInfo: object)
        
        
    }

}


