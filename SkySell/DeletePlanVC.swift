//
//  DeletePlanVC.swift
//  SkySell
//
//  Created by DW02 on 6/30/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

class DeletePlanVC: UIViewController {

    
    var screenSize:CGRect = UIScreen.main.bounds
    
    
    
    @IBOutlet weak var btClose: UIButton!
    @IBOutlet weak var viButtonClose: UIView!
    @IBOutlet weak var layout_Bottom_Close: NSLayoutConstraint!
    
    
    
    
    
    @IBOutlet weak var viTopSectionBG: UIView!
    
    @IBOutlet weak var layout_Hright_TopSection: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var lbYouHaveRecently: UILabel!
    
    @IBOutlet weak var lbPlan: UILabel!
    
    
    @IBOutlet weak var viImageBG: UIView!
    
    @IBOutlet weak var lbDetail: UILabel!
    
    
    var viImage:PKImV3View! = nil
    
    
    let myData:ShareData = ShareData.sharedInstance
    
    var userProgram:PlansDataModel! = nil
    
    
    
    
    var arUserProduct:[ProductDataModel] = [ProductDataModel]()
    
    
    
    var myActivityView:ActivityLoadingView! = nil
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    
    
    
    let fontTitle:UIFont = UIFont(name: "Avenir-Medium", size: 14)!
    let fontDetail:UIFont = UIFont(name: "Avenir-Book", size: 12)!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.clipsToBounds = true
        self.viButtonClose.clipsToBounds = true
        
        self.viImage = PKImV3View(frame: CGRect(x: 0, y: 0, width: self.screenSize.width - 16, height: 128))
        
        self.viImageBG.addSubview(self.viImage)
        
        self.viImage.imageView.contentMode = .scaleAspectFit
        
        
        
        let plan = self.myData.getUserPlan()
        if let plan = plan{
            self.userProgram = plan
        }
       
        
        
        
        self.lbPlan.text = String(format: "%@", self.userProgram.plan_name.capitalized)
        
        
        
        self.lbDetail.text = ""
        self.viImage.loadImage(imageURL: self.userProgram.image_src, Thumbnail: false)

        
        self.setDisPlayTopBar(Animation: false)
        
        
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        let sIndex = self.myTableView.indexPathForSelectedRow
        if let sIndex = sIndex{
            self.myTableView.deselectRow(at: sIndex, animated: true)
        }
        
        
        
        
        
        
        
        self.addActivityView {
            self.getProductByUserId(UserId: self.myData.userInfo.uid) { (products) in
                
                self.arUserProduct.removeAll()
                
                
                var buffer:[ProductDataModel] = [ProductDataModel]()
                for (key, value) in self.myData.userInfo.products{
                    
                    for p in products{
                        
                        if((p.product_id == key) && (value == true)){
                            buffer.append(p)
                        }
                    }
                }
                
                
                
                self.arUserProduct = buffer.sorted(by: { (pro1, pro2) -> Bool in
                    return pro1.updated_at < pro2.updated_at
                })
                
                
                
                self.setDisPlayTopBar(Animation: true)
                
                
                self.myTableView.reloadData()
                self.removeActivityView {
                    
                }
            }
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
    
    
    // MARK: - Action
    
    func setDisPlayTopBar(Animation animation:Bool) {
        
        let userProductCount:NSInteger = self.myData.userInfo.products.count
        let userProductCanPost:NSInteger = self.myData.getListtingsUserCanPost()
        
        
        var strTitle:String = ""
        
        
        if(userProductCount > userProductCanPost){
            let diff:NSInteger = userProductCount - userProductCanPost
            
            
            strTitle = String(format: "Please delete %d listings before proceeding to use the application.", diff)
            
            self.layout_Bottom_Close.constant = 0
            
            self.btClose.setTitle("Upgrade", for: UIControlState.normal)
            
            
        }else if(userProductCount == userProductCanPost){
            strTitle = "You have exceed the no. of listing for this plan. Please delete some of them before creating a new listing."
            self.layout_Bottom_Close.constant = 0
            self.btClose.setTitle("Close", for: UIControlState.normal)
        }else{
       
            
            strTitle = String(format: "You can have %d items in your listing.", userProductCanPost)
            self.layout_Bottom_Close.constant = 0
            self.btClose.setTitle("Close", for: UIControlState.normal)
        }
        
        
        self.lbDetail.text = strTitle
        
        
        let hDetail:CGFloat = heightForView(text: strTitle, Font: fontDetail, Width: self.screenSize.width - 20)
        
        
        self.layout_Hright_TopSection.constant = 207 + hDetail + 8 + 50
        
        
        
        
        if(animation == true){
            UIView.animate(withDuration: 0.45, animations: { 
                self.view.updateConstraints()
                self.view.layoutIfNeeded()
            })
        }else{
            self.view.updateConstraints()
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    
    @IBAction func tapOnClose(_ sender: UIButton) {
        
        
        
        
        
        let userProductCount:NSInteger = self.myData.userInfo.products.count
        let userProductCanPost:NSInteger = self.myData.getListtingsUserCanPost()
        
        

        
        
        if(userProductCount > userProductCanPost){
            //Upgrade
            
            
       
            
            //self.btClose.setTitle("Upgrade", for: UIControlState.normal)
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
            let vc:PlanVC = storyboard.instantiateViewController(withIdentifier: "PlanVC") as! PlanVC
            
            self.present(vc, animated: true, completion: { 
                
            })
            
        }else{
            self.dismiss(animated: true) {
                
                ShareData.sharedInstance.showingDeletePlan = false
            }
        }
        
    }
    
    
    
    
    
    
    
    func getProductByUserId(UserId uid:String, Finish finish:@escaping (_ products:[ProductDataModel])->Void){
        
        print(uid)
        
        
        
        let postRef = FIRDatabase.database().reference().child("products")
        let query = postRef.queryOrdered(byChild: "uid").queryEqual(toValue: uid)
        
        query.observeSingleEvent(of: FIRDataEventType.value, with:{ (snapshot) in
            
            var arProduct:[ProductDataModel] = [ProductDataModel]()
            
            
            
            
            
            
            if let value = snapshot.value as? NSDictionary{
                
                
                
                
                for object in value.allValues{
                    
                    if let object = object as? NSDictionary{
                        
                        let newProduct:ProductDataModel = ProductDataModel(dictionary: object)
                        arProduct.append(newProduct)
                        
                        
                    }
                }
                
            }
            
            
            finish(arProduct)
            
        })
        
        
    }
    
    
    
    
    
    func removeProductAtIndex(row:NSInteger) {
        
        
        if((row >= 0) && (row < self.arUserProduct.count)){
            let product = self.arUserProduct[row]
            
            let alertController = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this listing?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Don't Delete", style: .cancel) { (action) in
                
            }
            alertController.addAction(cancelAction)
            
            
            let okAction = UIAlertAction(title: "Delete", style: .default) { (action) in
                
                
                //delete
                self.addActivityView {
                    
                    
                    self.myData.startDeleteListing(product: product, Finish: { (productDelete) in
                        
                        
                        self.getProductByUserId(UserId: self.myData.userInfo.uid) { (products) in
                            
                            self.arUserProduct.removeAll()
                            
                            self.arUserProduct = products
                            
                            self.setDisPlayTopBar(Animation: true)
                            
                            
                            self.myTableView.reloadData()
                            
                            
                            let postRef = FIRDatabase.database().reference().child("users").child(self.myData.userInfo.uid)
                            
                            postRef.observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                if let value = snapshot.value as? NSDictionary{
                                    
                                    
                                    self.myData.userInfo = UserDataModel(dictionary: value)
                                    
                                
                                    
                                    self.finishRemove()
                                    
                                    
                                    
                                    //print(self.myData.userInfo.first_name)
                                    
                                }
                                
                                
                            })
                            
                            
                            
                        }
                        
                        
                    })
                }
                
                
                
            }
            alertController.addAction(okAction)
            
            
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    func finishRemove(){
        
        
        self.removeActivityView {
            
            
            let alertController = UIAlertController(title: "SUCCESS!!", message: nil, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                //self.navigationController?.popViewController(animated: true)
                
                
                
            }
            alertController.addAction(cancelAction)
            
            
            self.present(alertController, animated: true, completion: nil)
            
            
            
        }
        
        
        
        
    }
    
    
    
    // MARK: - Activity
    
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
                }
                
                self.myActivityView = nil
                finish()
            })
        }else{
            finish()
        }
        
    }
    
    
    
    
    
    

}





// MARK: - UITableViewDelegate, UITableViewDataSource
extension DeletePlanVC:UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
    }
    
    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //var numberOfCell:NSInteger = 0
        
        
        return self.arUserProduct.count
    }
    
    // MARK: - Cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        let cellHeight:CGFloat = 80
        
        /*
        
        let product = self.arUserProduct[indexPath.row]
        
        let tH:CGFloat = heightForView(text: product.title, Font: self.fontTitle, Width: self.screenSize.width - 150)
        
        let dH:CGFloat = heightForView(text: product.product_description, Font: self.fontTitle, Width: self.screenSize.width - 150)
        
        
        cellHeight = tH + dH + 24
        
        if(cellHeight < 80){
            cellHeight = 80
        }
        */
        
        return cellHeight
    }
    
    /*
     // MARK: - Header height
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     
     var cellHeight:CGFloat = 30
     
     return cellHeight
     
     }
     
     // MARK: - Header cell
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
     let cell:LabelHeaderCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LabelHeaderCell") as? LabelHeaderCell
     
     return cell
     }*/
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        let product = self.arUserProduct[indexPath.row]
        
        
        
        let cell:DeletePlanCell? = tableView.dequeueReusableCell(withIdentifier: "DeletePlanCell", for: indexPath) as? DeletePlanCell
        cell?.selectionStyle = .default
        cell?.clipsToBounds = true
        cell?.myTag = indexPath.row
        
        cell?.lazyImage.loadImage(imageURL: product.image_src, Thumbnail: true)
        
        cell?.lbTitle.text = product.title
        cell?.lbDetail.text = product.product_description
        
        cell?.callBackDelete = {(tag) in
            
            self.removeProductAtIndex(row: tag)
            
            
        }
        
        
        return cell!
        
    }
    
    // MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let product = self.arUserProduct[indexPath.row]
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:PostSellVC = storyboard.instantiateViewController(withIdentifier: "PostSellVC") as! PostSellVC
        //vc.arImage = self.arImageBuffer
        vc.editMode = true
        vc.userProduct = product
        let nav1 = UINavigationController()
        
        nav1.viewControllers = [vc]
        vc.navigationController?.isNavigationBarHidden = true
        
        self.present(nav1, animated: true) {
            
        }
        
        
        
        
        /*
        self.addActivityView {
         
            let product = self.arUserProduct[indexPath.row]
            
            getProductDataWith(ProductID: product.product_id, Finish: { (product) in
                
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
                let vc:ProductDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
                
                vc.thisFirstDetail = true
                vc.myProductData = product
                
                
                
                
                self.navigationController?.pushViewController(vc, animated: true)
                
                self.removeActivityView {
                    
                }
                
            })
        }
        
        */
        
        //self.myTable.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        
        //print(scrollView.contentOffset.y)
        
    }
}



