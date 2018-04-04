//
//  PlanVC.swift
//  SkySell
//
//  Created by DW02 on 6/29/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import StoreKit


class PlanVC: UIViewController {

    
    class SkySellInApp{
        var itune:SKProduct! = nil
        var firebase:PlansDataModel! = nil
    }
    
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    var myData:ShareData = ShareData.sharedInstance
    var mySetting:SettingData = SettingData.sharedInstance
    
    
    var myActivityView:ActivityLoadingView! = nil
    
    
    @IBOutlet weak var btClose: UIButton!
    
    @IBOutlet weak var myCollection: UICollectionView!
    
    
    var arProduct:[SkySellInApp] = [SkySellInApp]()
    
    
    
    var haveNoti:Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.clipsToBounds = true
        
        let nib2:UINib = UINib(nibName: "PlanCell", bundle: nil)
        self.myCollection.register(nib2, forCellWithReuseIdentifier: "PlanCell")
        
        
    
        //self.myCollection.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        self.myCollection.delegate = self
        self.myCollection.dataSource = self
        self.myCollection.clipsToBounds = true
        
        self.myCollection.isPagingEnabled = true
        
        
        
        myActivityView = ActivityLoadingView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        self.view.addSubview(myActivityView)
        
        
        
        if(self.haveNoti == false){
            self.haveNoti = true
            NotificationCenter.default.addObserver(self, selector: #selector(PlanVC.reloadProductInApp(notification:)), name:NSNotification.Name(rawValue: "SKProductsHaveLoaded"), object: nil)
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(PlanVC.reloadProductInApp(notification:)), name:NSNotification.Name(rawValue: "purchaseFailed"), object: nil)
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(PlanVC.reloadProductInApp(notification:)), name:NSNotification.Name(rawValue: "ReceiptDidUpdated"), object: nil)
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        
        self.loadPlanData()
        
        
        
        
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if(self.haveNoti == true){
            self.haveNoti = false
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "SKProductsHaveLoaded"), object: nil)
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "purchaseFailed"), object: nil)
            
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReceiptDidUpdated"), object: nil)
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - notitfication
    func reloadProductInApp(notification:NSNotification){
  
        self.addActivityView {
            self.loadPlanData()
        }
    }
    
    
    // MARK: - Activity
    
    
    
    func loadPlanData(){
        getAllPlans { (plans, secret) in
            self.myData.bufferAllPlans = plans
            self.myData.buuferItuneSecret = secret
            
            //StoreManager.shared.setup()
            
            self.arProduct.removeAll()
            
            var arProductBuffer:[SkySellInApp] = [SkySellInApp]()
            
            var arPlanID:[String] = [String]()
            
            for p in StoreManager.shared.productsFromStore{
                
                for m in self.myData.bufferAllPlans{
                    
                    var have:Bool = false
                    
                    for pid in arPlanID{
                        if(p.productIdentifier == pid){
                            have = true
                        }
                    }
                    
                    
                    if((p.productIdentifier == m.itunes_id) && (have == false)){
                        
                        arPlanID.append(m.itunes_id)
                        
                        let newItem:SkySellInApp = SkySellInApp()
                        newItem.itune = p
                        newItem.firebase = m
                        arProductBuffer.append(newItem)
                    }
                }
            }
            
            
            
            
            
            //Find free plan
            
            
            if appDelegate.isPremiumMember {
                let model = self.myData.bufferAllPlans.filter({ (planModel) -> Bool in
                    if planModel.plan_name == "Premium Plan" {
                        return true
                    }
                    return false
                })
                if let modelObj = model.last{
                    let newItem:SkySellInApp = SkySellInApp()
                    newItem.firebase = modelObj
                    newItem.firebase.amount = appDelegate.point
                    arProductBuffer.append(newItem)
                    
                }
            }else{
                let model = self.myData.bufferAllPlans.filter({ (planModel) -> Bool in
                    if planModel.plan_name == "Free Plan" {
                        return true
                    }
                    return false
                })
                if let modelObj = model.last{
                    let newItem:SkySellInApp = SkySellInApp()
                    newItem.firebase = modelObj
                    arProductBuffer.append(newItem)
                }
                
            }
            
            
            self.arProduct = arProductBuffer.sorted(by: { (obj1, obj2) -> Bool in
                
                return (obj1.firebase.order < obj2.firebase.order)
            })
            
   /**         for m in self.myData.bufferAllPlans{
                if((m.amount <= 0) && (m.isActive == true)){

                    var have:Bool = false
                    for c in self.arProduct{
                        if(c.firebase.plan_id == m.plan_id){
                            have = true
                            break
                        }
                    }

                    if(have == false){
                        let newItem:SkySellInApp = SkySellInApp()
                        newItem.firebase = m
                        arProductBuffer.append(newItem)
                    }

                }
            }

             self.arProduct = arProductBuffer.sorted(by: { (obj1, obj2) -> Bool in
             
             return (obj1.firebase.order < obj2.firebase.order)
             })

            let canpost:NSInteger = self.myData.getListtingsUserCanPost()
            print("Can post : \(canpost)")

            print("user plan : \(self.myData.getUserPlan()?.plan_name)")
            */
            
            self.myCollection.reloadData()
            
            self.removeActivityView {
                
            }
        }
    }
    
    func addActivityView(Finish finish:@escaping ()->Void){
        
        if(self.myActivityView == nil){
            myActivityView = ActivityLoadingView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
            myActivityView.alpha = 0
            self.view.addSubview(myActivityView)
            
            
            UIView.animate(withDuration: 0.25, animations: {
                self.myActivityView.alpha = 1
            }, completion: { (_) in
                
                finish()
            })
        }else{
            finish()
        }
    }
    
    
    
    func removeActivityView(Finish finish:@escaping ()->Void) {
        if(self.myActivityView != nil){
            
            UIView.animate(withDuration: 0.45, animations: {
                self.myActivityView.alpha = 0
            }, completion: { (_) in
                
                if(self.myActivityView != nil){
                    self.myActivityView.removeFromSuperview()
                    self.myActivityView = nil
                }
                finish()
            })
        }else{
            finish()
        }
        
    }
    
    
    
    // MARK: - Action
    
    @IBAction func tapOnClose(_ sender: UIButton) {
        self.exitScene()
    }
    
    
    func exitScene() {
        if let navigation = self.navigationController{
            navigation.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: {
                
            })
        }
    }
    

}






extension PlanVC:UICollectionViewDelegateFlowLayout{
    
    
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = screenSize.width
        let h = screenSize.height
        
        return CGSize(width: w, height: h)
        
    }
    
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate


extension PlanVC:UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        

        
        
        
        return self.arProduct.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        
        let cell:PlanCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanCell", for: indexPath) as! PlanCell
        

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let itune = self.arProduct[indexPath.item].itune{
            
            cell.lbTitle.text = itune.localizedTitle.uppercased()
            
            
            
            formatter.locale = itune.priceLocale

            cell.lbPrice.text = formatter.string(from: itune.price)

            
            
            if let plan = self.arProduct[indexPath.item].firebase{
                cell.lbPlanName.text = ""//String(format: "%@ Plans", plan.plan_name.capitalized)
                cell.lbDetail.text = plan.description
                
                
                
                cell.lazyImage.loadImage(imageURL: plan.image_src, Thumbnail: false)
                
                
                if(myData.userInfo.plan_id == plan.plan_id){
                    cell.btUpgrade.isEnabled = false
                    cell.btUpgrade.setTitle("Subscribed", for: .normal)
                    cell.btUpgrade.alpha = 1
                }else{
                    
                    
                    if(myData.userInfo.plan_id == ""){
                        cell.btUpgrade.isEnabled = true
                        cell.btUpgrade.setTitle("Upgrade / Restore", for: .normal)
                        cell.btUpgrade.alpha = 1
                    }else{
                        cell.btUpgrade.isEnabled = false
                        cell.btUpgrade.setTitle("Upgrade / Restore", for: .normal)
                        cell.btUpgrade.alpha = 0
                    }
                    
                }
            }
            

            
            
        }else if let plan = self.arProduct[indexPath.item].firebase{
            cell.lbTitle.text = plan.plan_name.uppercased()
            
            if(plan.amount == 0){
                
                formatter.locale = Locale.current
                
                cell.lbPrice.text = formatter.string(from: NSNumber(value: plan.amount))
                
            }else{
                
                
                
                formatter.locale = Locale.current
                
                cell.lbPrice.text = formatter.string(from: NSNumber(value: plan.amount))
                
                
            }
            
            cell.lbPlanName.text = ""//String(format: "%@ Plans", plan.plan_name.capitalized)
            cell.lbDetail.text = plan.description
            
            cell.lazyImage.loadImage(imageURL: plan.image_src, Thumbnail: false)
            
            
            
            
            if(myData.userInfo.plan_id == plan.plan_id){
                cell.btUpgrade.isEnabled = false
                cell.btUpgrade.setTitle("Subscribed", for: .normal)
                cell.btUpgrade.alpha = 1
            }else{
                cell.btUpgrade.isEnabled = false
                cell.btUpgrade.setTitle("Subscribed", for: .normal)
                cell.btUpgrade.alpha = 0
            }
        }
        
        
        let w = screenSize.width
        let h = screenSize.height
        cell.updateCellSize(size: CGSize(width: w, height: h))
        
        cell.myTag = indexPath.item
        
        cell.callBackUpgrade = {(tag) in
        
        
            if(tag < self.arProduct.count){
                if let itune = self.arProduct[tag].itune{
                    
                    self.addActivityView {
                        StoreManager.shared.buy(product: itune)
                    }
                    
                    
                }
            }
            
        
        
        }
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
  
        
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    
    
}








