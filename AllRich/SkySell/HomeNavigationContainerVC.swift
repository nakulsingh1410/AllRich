//
//  HomeNavigationContainerVC.swift
//  SkySell
//
//  Created by supapon pucknavin on 4/16/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

protocol HomeNavigationContainerDelegate{
    func beginTransition(FromView from:HomeNavigationContainerVC.SegName, ToView to:HomeNavigationContainerVC.SegName)
    func finishTransition(FromView from:HomeNavigationContainerVC.SegName, ToView to:HomeNavigationContainerVC.SegName)
}

class HomeNavigationContainerVC: UIViewController {

    enum SegName:String {
        case toHomeCollection = "segToHomeNavigation"

    }
    
    
    var myHomeNavigation:UINavigationController? = nil
    
    
    
    var transitionInProgress:Bool! = false
    
    
    var currentSegueIdentifier:SegName = .toHomeCollection
    var laseSegueIdentifier:SegName = .toHomeCollection
    
    var delegete:HomeNavigationContainerDelegate! = nil
    
    
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
        if segue.identifier == SegName.toHomeCollection.rawValue {
            self.myHomeNavigation = segue.destination as? UINavigationController
            self.myHomeNavigation?.setNavigationBarHidden(true, animated: false)
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
        
        
        
        
        if segue.identifier == SegName.toHomeCollection.rawValue {
            
            if (self.childViewControllers.count > 0) {
                self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myHomeNavigation!)
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
        case SegName.toHomeCollection:
            
            if let _ = self.myHomeNavigation{
                
                
       
                self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myHomeNavigation!)
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
