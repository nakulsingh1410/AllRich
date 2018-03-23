//
//  HomeContainerVC.swift
//  SkySell
//
//  Created by supapon pucknavin on 4/16/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit


protocol HomeContainerDelegate{
    func beginTransition(FromView from:HomeContainerVC.SegName, ToView to:HomeContainerVC.SegName)
    func finishTransition(FromView from:HomeContainerVC.SegName, ToView to:HomeContainerVC.SegName)
}

class HomeContainerVC: UIViewController {

    enum SegName:String {
        case toHome = "segToHomeVC"
        case toGroup = "segToGroupVC"
        case toMessage = "segToMessageVC"
        case toProfile = "segToProfileVC"
        case segToNavigationProfileVC = "segToNavigationProfileVC"
    }
    
    
    
    var myHome:HomeVC? = nil
    var myGroup:GroupVC? = nil
    var myMessage:MessageVC? = nil
    var myProfile:ProfileVC? = nil
    
    var myProfileNavigation:UINavigationController? = nil
    
    
    var transitionInProgress:Bool! = false
    
    
    var currentSegueIdentifier:SegName = .toHome
    var laseSegueIdentifier:SegName = .toHome
    
    var myMaster:ViewController! = nil
    
    
    var delegete:HomeContainerDelegate! = nil
    
    
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
        if segue.identifier == SegName.toHome.rawValue {
            self.myHome = segue.destination as? HomeVC
            
        }
        
        if segue.identifier == SegName.toGroup.rawValue {
            self.myGroup = segue.destination as? GroupVC
            
        }
        
        if segue.identifier == SegName.toMessage.rawValue {
            self.myMessage = segue.destination as? MessageVC
            
        }
        
        if segue.identifier == SegName.toProfile.rawValue {
            self.myProfile = segue.destination as? ProfileVC
            
        }
        
        if segue.identifier == SegName.segToNavigationProfileVC.rawValue {
            self.myProfileNavigation = segue.destination as? UINavigationController
            self.myProfileNavigation?.setNavigationBarHidden(true, animated: false)
        }
        
        
        
        if segue.identifier == SegName.toHome.rawValue {
            
            if (self.childViewControllers.count > 0) {
                self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myHome!)
            }else{
                self.addChildViewController(segue.destination)
                let destView = (segue.destination as! HomeVC).view
                if let destView = destView{
                    destView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    self.view.addSubview(destView)
                    segue.destination.didMove(toParentViewController: self)
                }
                
            }
        } else if segue.identifier == SegName.toGroup.rawValue {
            
            self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myGroup!)
            
        } else if segue.identifier == SegName.toMessage.rawValue {
            
            self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myMessage!)
            
        } else if segue.identifier == SegName.toProfile.rawValue {
            
            self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myProfile!)
            
        } else if segue.identifier == SegName.segToNavigationProfileVC.rawValue {
            
            self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myProfileNavigation!)
            
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
        
        if(ShareData.sharedInstance.masterView != nil){
            ShareData.sharedInstance.masterView.connectChatRoomNoti()
        }
        
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
        case SegName.toHome:
            
            if let _ = self.myHome{
                
               
                /*
                if(self.myMaster != nil){
                    
                    self.myMaster.btHome.setImage(UIImage(named: "iconHomeActive.png"), for: UIControlState.normal)
                    self.myMaster.btGroup.setImage(UIImage(named: "iconGroupNonactive.png"), for: UIControlState.normal)
                    self.myMaster.btMessage.setImage(UIImage(named: "iconInboxNonactive.png"), for: UIControlState.normal)
                    self.myMaster.btProfile.setImage(UIImage(named: "iconProfileNonactive.png"), for: UIControlState.normal)
                    
                }*/
                self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myHome!)
                return;
            }
            
            break
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
            
        case SegName.segToNavigationProfileVC:
            
            if let _ = self.myProfileNavigation{
                
                
                
                self.swapFromViewController(fromViewController: self.childViewControllers[0], ToViewController: self.myProfileNavigation!)
                return;
            }
            
            break
            
        }
        
        self.performSegue(withIdentifier: self.currentSegueIdentifier.rawValue, sender: nil)
        
        
    }
    
    
}
