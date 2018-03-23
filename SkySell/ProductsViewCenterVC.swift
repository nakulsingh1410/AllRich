//
//  ProductsViewCenterVC.swift
//  SkySell
//
//  Created by supapon pucknavin on 4/17/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class ProductsViewCenterVC: UIViewController {

    
    @IBOutlet weak var segmentMode: UISegmentedControl!
    
    var myProductContainer:ProductContainerVC? = nil
    
    
    var haveNoti:Bool = false
    
    var category:CategoriesDataModel! = nil
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    override func viewDidAppear(_ animated: Bool) {
        if(self.haveNoti == false){
            self.haveNoti = true
            NotificationCenter.default.addObserver(self, selector: #selector(ProductsViewCenterVC.setTapOnBackButton(notification:)), name:NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVCTapOnBack.rawValue), object: nil)
        }
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if(self.haveNoti == true){
            self.haveNoti = false
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVCTapOnBack.rawValue), object: nil)
        }
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segToProductContainerVC" {
            
            self.myProductContainer = segue.destination as? ProductContainerVC
            
            if let con = self.myProductContainer{
               
                con.delegete = self
                con.category = self.category
            }
            
            
        }
    }
    
    
    
    // MARK: - Action

    @IBAction func segmentModeChangeValue(_ sender: UISegmentedControl) {
        if let con = self.myProductContainer{
            
            self.segmentMode.isUserInteractionEnabled = false
            
            if(sender.selectedSegmentIndex == 0){
                con.swapToview(identifier: ProductContainerVC.SegName.toProductList)
                
            }else{
                con.swapToview(identifier: ProductContainerVC.SegName.toProductMap)
            }
            
        }
        
    }
    
    
    // MARK: - notitfication
    func setTapOnBackButton(notification:NSNotification){
        self.showTapBar(show: true)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func showTapBar(show:Bool) {
        var object:[String:Bool] = [String:Bool]()
        object["show"] = show
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HidenMainTapBar.rawValue), object: nil, userInfo: object)
        
        
    }
    
}

extension ProductsViewCenterVC:ProductContainerDelegate{
    
    func beginTransition(FromView from: ProductContainerVC.SegName, ToView to: ProductContainerVC.SegName) {
        
    }
    
    func finishTransition(FromView from: ProductContainerVC.SegName, ToView to: ProductContainerVC.SegName) {
        
        self.segmentMode.isUserInteractionEnabled = true
    }
}
