//
//  GroupNavigationContainerVC.swift
//  SkySell
//
//  Created by DW02 on 6/5/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit


protocol GroupNavigationContainerDelegate{
    func beginTransition(FromView from:GroupNavigationContainerVC.SegName, ToView to:GroupNavigationContainerVC.SegName)
    func finishTransition(FromView from:GroupNavigationContainerVC.SegName, ToView to:GroupNavigationContainerVC.SegName)
}


class GroupNavigationContainerVC: UIViewController {

    enum SegName:String {
        case toGroupCollection = "segToGroupNavigation"
        
    }
    
    
    var myGroupNavigation:UINavigationController? = nil
    
    
    
    var transitionInProgress:Bool! = false
    
    
    var currentSegueIdentifier:SegName = .toGroupCollection
    var laseSegueIdentifier:SegName = .toGroupCollection
    
    var delegete:GroupNavigationContainerDelegate! = nil
    
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
        if segue.identifier == SegName.toGroupCollection.rawValue {
            self.myGroupNavigation = segue.destination as? UINavigationController
            self.myGroupNavigation?.setNavigationBarHidden(true, animated: false)
        }
        
        /*
         if segue.identifier == SegName.toGroup.rawValue {
         self.myGroup = segue.destination as? GroupVC
         
         }
         
         if segue.identifier == SegName.toMessage.rawValue {
         self.myMessage = segue.destination as? MessageVC
         
         }
         
         if segue.identifier == SegName.toProfile.rawValue {
         self.myProfile = segue.destination as? ProfileVC
         
         }*/
        
        
        
        
        if segue.identifier == SegName.toGroupCollection.rawValue {
            
            if (self.childViewControllers.count > 0) {
                self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myGroupNavigation!)
            }else{
                self.addChildViewController(segue.destination)
                let destView = (segue.destination as! UINavigationController).view
                if let destView = destView{
                    destView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    self.view.addSubview(destView)
                    segue.destination.didMove(toParentViewController: self)
                }
                
            }
        }
        
        
        /*else if segue.identifier == SegName.toGroup.rawValue {
         
         self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myGroup!)
         
         } else if segue.identifier == SegName.toMessage.rawValue {
         
         self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myMessage!)
         
         } else if segue.identifier == SegName.toProfile.rawValue {
         
         self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myProfile!)
         
         }*/
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
        
        self.laseSegueIdentifier = currentSegueIdentifier
        
        self.currentSegueIdentifier = identifier
        
        
        self.transitionInProgress = true
        
        if(self.delegete != nil){
            self.delegete.beginTransition(FromView: currentSegueIdentifier, ToView: identifier)
        }
        
        switch(identifier){
        case SegName.toGroupCollection:
            
            if let _ = self.myGroupNavigation{
                
                
                
                self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myGroupNavigation!)
                return;
            }
            
            break
            /*
             case SegName.toGroup:
             if let _ = self.myGroup{
             
             
             /*
             if(self.myMaster != nil){
             
             self.myMaster.btHome.setImage(UIImage(named: "iconHomeNonactive.png"), for: UIControlState.normal)
             self.myMaster.btGroup.setImage(UIImage(named: "iconGroupActive.png"), for: UIControlState.normal)
             self.myMaster.btMessage.setImage(UIImage(named: "iconInboxNonactive.png"), for: UIControlState.normal)
             self.myMaster.btProfile.setImage(UIImage(named: "iconProfileNonactive.png"), for: UIControlState.normal)
             
             }
             */
             
             self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myGroup!)
             return;
             }
             
             break
             case SegName.toMessage:
             if let _ = self.myMessage{
             /*
             if(self.myMaster != nil){
             
             self.myMaster.btHome.setImage(UIImage(named: "iconHomeNonactive.png"), for: UIControlState.normal)
             self.myMaster.btGroup.setImage(UIImage(named: "iconGroupNonactive.png"), for: UIControlState.normal)
             self.myMaster.btMessage.setImage(UIImage(named: "iconInboxActive.png"), for: UIControlState.normal)
             self.myMaster.btProfile.setImage(UIImage(named: "iconProfileNonactive.png"), for: UIControlState.normal)
             
             }
             */
             
             self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myMessage!)
             return;
             }
             
             break
             case SegName.toProfile:
             if let _ = self.myProfile{
             /*
             if(self.myMaster != nil){
             
             self.myMaster.btHome.setImage(UIImage(named: "iconHomeNonactive.png"), for: UIControlState.normal)
             self.myMaster.btGroup.setImage(UIImage(named: "iconGroupNonactive.png"), for: UIControlState.normal)
             self.myMaster.btMessage.setImage(UIImage(named: "iconInboxNonactive.png"), for: UIControlState.normal)
             self.myMaster.btProfile.setImage(UIImage(named: "iconProfileActive.png"), for: UIControlState.normal)
             
             }
             */
             
             self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myProfile!)
             return;
             }
             
             break
             */
            
        }
        
        self.performSegue(withIdentifier: self.currentSegueIdentifier.rawValue, sender: nil)
        
        
    }

}
