//
//  ProductMapVC.swift
//  SkySell
//
//  Created by supapon pucknavin on 4/17/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift
import GooglePlaces
import GooglePlacePicker



class ProductPin: MKPointAnnotation {
    var product:RealmProductDataModel! = nil
    var myTag:NSInteger = 0
}

class ProductMapVC: UIViewController {
    enum MyLocationKey:String{
        case Name = "Name"
        case Street = "Street"
        case City = "City"
        case Zip = "Zip"
        case Country = "Country"
    }
    
    
    
    @IBOutlet weak var viFilterBG: UIView!
    @IBOutlet weak var viFilterBG_Layout_Height: NSLayoutConstraint!
    
    @IBOutlet weak var layout_Between_Filter_Map: NSLayoutConstraint!
    
    
    @IBOutlet weak var lbLocationTitle: UILabel!
    
    @IBOutlet weak var imPinTitle: UIImageView!
    
    @IBOutlet weak var viMapBG: UIView!
    
    @IBOutlet weak var btLocation: UIButton!
    
    @IBOutlet weak var viRangeBG: UIView!
    
    
    
    @IBOutlet weak var myMap: MKMapView!
    
    
    
    
    
    
    
    
    
    
    var myActivityView:ActivityLoadingView! = nil
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    var category:CategoriesDataModel! = nil
    
    
    var viLineFrame:UIView! = nil
    var viLineBlue:UIView! = nil
    
    
    var arRangePinLine:[UIView] = [UIView]()
    
    var viButtonRange:UIView! = nil
    
    
    var color_WhireBG:UIColor = UIColor(red: (223.0/255.0), green: (223.0/255.0), blue: (223.0/255.0), alpha: 1.0)
    var color_BlueBG:UIColor = UIColor(red: (3.0/255.0), green: (210.0/255.0), blue: (99.0/255.0), alpha: 1.0)
    
    
    var tapOnButtonRange:Bool = false
    
    
    let limite_Low_x:CGFloat = 23
    var limite_Max_x:CGFloat = 23
    
    
    var locationManager:CLLocationManager! = CLLocationManager()
    var readyGetLocation:Bool = false
    var userLatitude:Double = 1.355343
    var userLongitude:Double = 103.867826
    
    
    var locationData:[String:String] = [String:String]()
    
    var countryName:String = ""
    var strLocationName:String = ""
    
    
    var nowInRange:NSInteger = 0
    
    var isTouchInSliderBarBG:Bool = false
    
    let myData:ShareData = ShareData.sharedInstance
    let mySetting:SettingData = SettingData.sharedInstance
    
    
    var arProduct:[RealmProductDataModel] = [RealmProductDataModel]()
    var arPin:[ProductPin] = [ProductPin]()
    
    
    
    var viewCell1:MapPopUpView! = nil
    var viewCell2:MapPopUpView! = nil
    var viewCell3:MapPopUpView! = nil
    
    var arPopup:[MapPopUpView] = [MapPopUpView]()
    var disPlayCellNum:NSInteger = -1
    
    
    var selectAtPin:NSInteger = -1
    var deselectAtPin:NSInteger = -1
    
    
    var circle:MKCircle! = nil
    
    
    
    
    var haveNoti:Bool = false
    
    var strKeyword:String = ""
    
    
    
    var workOnProduct_UserId:String = ""
    
    var useGoogleLocation:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viFilterBG.clipsToBounds = true
        self.viMapBG.clipsToBounds = true
        self.viRangeBG.clipsToBounds = true
        
    
            
        
        
        self.viLineFrame = UIView(frame: CGRect(x: 23, y: 38, width: screenSize.width - 46, height: 4))
        self.viLineFrame.clipsToBounds = true
        self.viLineFrame.layer.cornerRadius = 2
        self.viLineFrame.backgroundColor = color_WhireBG
        
        
        self.viLineBlue = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 4))
        self.viLineBlue.clipsToBounds = true
        self.viLineBlue.layer.cornerRadius = 2
        self.viLineBlue.backgroundColor = color_BlueBG
        self.viLineFrame.addSubview(self.viLineBlue)
        
        
        
        self.viRangeBG.addSubview(self.viLineFrame)
        
        let countRange:NSInteger = 5
        let startXAt:CGFloat = 16
        let space:CGFloat = (screenSize.width - 46) / (CGFloat)(countRange)
        for i in 0...countRange{
            let btView:UIView = UIView(frame: CGRect(x: startXAt + (space * CGFloat(i)), y: 33, width: 14, height: 14))
            btView.backgroundColor = color_WhireBG
            
            btView.clipsToBounds = true
            btView.layer.cornerRadius = 7
            
            self.viRangeBG.addSubview(btView)
            self.arRangePinLine.append(btView)
        }
        
        self.viButtonRange = UIView(frame: CGRect(x: 8, y: 25, width: 30, height: 30))
        self.viButtonRange.backgroundColor = UIColor.white
        self.viRangeBG.addSubview(self.viButtonRange)
        self.viButtonRange.clipsToBounds = true
        self.viButtonRange.layer.cornerRadius = 15
        self.viButtonRange.layer.borderWidth = 4
        self.viButtonRange.layer.borderColor = color_BlueBG.cgColor
        
        
        self.limite_Max_x = screenSize.width - limite_Low_x
        
        
        self.lbLocationTitle.text = "Singapore"
        
        
        self.myMap.delegate = self
        
        
        //---------------
        self.viewCell1 = MapPopUpView(frame: CGRect(x: 0, y: -50, width: self.screenSize.width, height: 90))
        self.viewCell1.backgroundColor = UIColor.white
        self.viewCell1.clipsToBounds = false
        
        self.viewCell1.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viewCell1.layer.shadowRadius = 6
        self.viewCell1.layer.shadowOffset = CGSize(width: 0, height: 6)
        self.viewCell1.layer.shadowOpacity = 0.5
        
        self.view.addSubview(self.viewCell1)
        //-------------------
        self.viewCell2 = MapPopUpView(frame: CGRect(x: 0, y: -50, width: self.screenSize.width, height: 90))
        self.viewCell2.backgroundColor = UIColor.white
        self.viewCell2.clipsToBounds = false
        
        self.viewCell2.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viewCell2.layer.shadowRadius = 6
        self.viewCell2.layer.shadowOffset = CGSize(width: 0, height: 6)
        self.viewCell2.layer.shadowOpacity = 0.5
        
        self.view.addSubview(self.viewCell2)
        //-------------------
  
        self.viewCell3 = MapPopUpView(frame: CGRect(x: 0, y: -50, width: self.screenSize.width, height: 90))
        self.viewCell3.backgroundColor = UIColor.white
        self.viewCell3.clipsToBounds = false
        
        self.viewCell3.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viewCell3.layer.shadowRadius = 6
        self.viewCell3.layer.shadowOffset = CGSize(width: 0, height: 6)
        self.viewCell3.layer.shadowOpacity = 0.5
        
        self.view.addSubview(self.viewCell3)
        //-------------------
        
        arPopup.append(self.viewCell1)
        arPopup.append(self.viewCell2)
        arPopup.append(self.viewCell3)
        
   
        
        
        for v in arPopup{
            
            let tapGesture = UITapGestureRecognizer(target:self,  action:#selector(ProductMapVC.tapOnCallout(sender:)))
            v.addGestureRecognizer(tapGesture)
            v.alpha = 0
            
        }
        
        
        self.view.bringSubview(toFront: viFilterBG)
        
    
        
        
        self.view.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    override func viewDidAppear(_ animated: Bool) {
        print(self.category.category_name)
        
        
        if(self.useGoogleLocation == false){
            self.startGetLocation()
            
            self.getLocation()
        }
        
        
        
        
        
        
        
        if(self.haveNoti == false){
            self.haveNoti = true
            NotificationCenter.default.addObserver(self, selector: #selector(ProductMapVC.tapOnCancel(notification:)), name:NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVC_CancelSearch.rawValue), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(ProductMapVC.searchWithKey(notification:)), name:NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVC_SearchWithKey.rawValue), object: nil)
        }
        
        
        
        var object:[String:Bool] = [String:Bool]()
        object["show"] = false

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.SearchMapShow.rawValue), object: nil, userInfo: object)
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if(self.haveNoti == true){
            self.haveNoti = false
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVC_CancelSearch.rawValue), object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVC_SearchWithKey.rawValue), object: nil)
        }
        
        
        var object:[String:Bool] = [String:Bool]()
        object["show"] = true
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.SearchMapShow.rawValue), object: nil, userInfo: object)
        
        
        
        
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
    func tapOnCancel(notification:NSNotification){
        
        //self.exitScene()
        self.strKeyword = ""
        
        self.startSearchWithStep(countRange: self.nowInRange, ForceUpdate: true)
    }
    
    func searchWithKey(notification:NSNotification){
        if let key = notification.userInfo?["key"] as? String {
            print(key)
            self.strKeyword = key
            
            
            self.strKeyword = ""
            self.startSearchWithStep(countRange: self.nowInRange, ForceUpdate: true)
        }
        
    }
    
    
    
    // MARK: - Activity
    
    func addActivityView(Finish finish:@escaping ()->Void){
        
        if(self.myActivityView == nil){
            myActivityView = ActivityLoadingView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - 156))
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
    
    
    
    
    
    
    func setUpPupupWith(product:RealmProductDataModel) {
        
        if((self.disPlayCellNum >= 0) && (self.disPlayCellNum < self.arPopup.count)){
            
            let popup = self.arPopup[self.disPlayCellNum]
            
            popup.userImage.loadImage(imageURL: product.owner_Image_src, Thumbnail: true)
            popup.productImage.loadImage(imageURL: product.image_src, Thumbnail: true)
            
            let fullName:String = String(format: "%@  %@", product.owner_FirstName, product.owner_LastName)
            
            popup.lbName.text = fullName
            popup.lbProductName.text = product.title
            
            let strPrice = self.mySetting.priceWithString(strPricein: product.price)
            let strP:String = String(format: "Price: %@", strPrice )
            popup.lbPrice.text = strP
            
        }
    }
    
    
    func showCellPopupWith(product:RealmProductDataModel) {
        
        
        var nextP:NSInteger = -1
        var laseP:NSInteger = -1
        
        
        if(self.disPlayCellNum < 0){
            nextP = 0
            self.disPlayCellNum = 0
        }else{
            laseP = self.disPlayCellNum
            
            self.disPlayCellNum += 1
            if(self.disPlayCellNum >= self.arPopup.count){
                self.disPlayCellNum = 0
            }
            
            nextP = self.disPlayCellNum
        }
        
        
        self.setUpPupupWith(product: product)
       
        
        
        self.view.bringSubview(toFront: self.arPopup[nextP])
        self.view.bringSubview(toFront: viFilterBG)
      
        
        
        UIView.animate(withDuration: 0.45, animations: { 
           
            let cenX:CGFloat = self.screenSize.width / 2
            self.arPopup[nextP].center = CGPoint(x: cenX, y: 95.0)
            self.arPopup[nextP].alpha = 1
            if(laseP >= 0){
                self.arPopup[laseP].center = CGPoint(x: cenX, y: -95.0)
                //self.arPopup[nextP].alpha = 0
            }
            
        }) { (finish) in
            
        }
        
        
        
    }
    
    func hidenCellPopup()  {
      
        
        self.view.bringSubview(toFront: viFilterBG)
     
        
        if((self.disPlayCellNum >= 0) && (self.disPlayCellNum < self.arPopup.count)){
            
            UIView.animate(withDuration: 0.45, animations: {
                let cenX:CGFloat = self.screenSize.width / 2
                self.arPopup[self.disPlayCellNum].center = CGPoint(x: cenX, y: -95.0)
                //self.arPopup[self.disPlayCellNum].alpha = 0
                
            }) { (finish) in
                //self.disPlayCellNum = -1
            }
            
        }else{
            //self.disPlayCellNum = -1
        }
        
        
        
        
        
    }
    
    
    private func myHitTest(Point point:CGPoint, onView view:UIView) -> Bool {
        
        
        if((point.x > view.frame.origin.x) && (point.x < view.frame.origin.x + view.frame.width) && (point.y > view.frame.origin.y) && (point.y < view.frame.origin.y + view.frame.height)){
            return true
        }else{
            return false
        }
    }
    
    func checkInRangeOnPinWith(Position position:CGPoint) -> NSInteger {
        
        var pin:NSInteger = 0
        var minDistance:Int32 = Int32(self.screenSize.width)
        
        for i in 0..<self.arRangePinLine.count{
            let p = self.arRangePinLine[i]
            let sp:CGFloat = position.x - p.center.x
            let value = abs(Int32(sp))
            
            if(value <= minDistance){
                minDistance = value
                pin = i
            }
        }
        
        return pin
    }
    
    
    func setPinHighlight(x:CGFloat) {
        var countRange:NSInteger = 0
        for pin in self.arRangePinLine{
            if(pin.center.x <= x){
                pin.backgroundColor = color_BlueBG
                countRange += 1
            }else{
                pin.backgroundColor = color_WhireBG
            }
            
        }
        
       
        if(countRange < 1){
            countRange = 1
        }
        
        //-------------
        
        self.startSearchWithStep(countRange: countRange, ForceUpdate: false)
        
        
        
    }
    
    
    func startSearchWithStep(countRange:NSInteger, ForceUpdate force:Bool ) {
        
   
        
        
        if((countRange != self.nowInRange) || (force == true)){
            self.nowInRange = countRange
            
            switch self.nowInRange {
            case 1:
                // 5 km
                self.searchProductInRange(Km: 5.0)
                break
            case 2:
                // 10 km
                self.searchProductInRange(Km: 10.0)
                
                break
            case 3:
                // 20 km
                self.searchProductInRange(Km: 20.0)
                break
            case 4:
                // 30 km
                self.searchProductInRange(Km: 30.0)
                break
            case 5:
                // 40 km
                self.searchProductInRange(Km: 40.0)
                break
            case 6:
                // 50 km
                self.searchProductInRange(Km: 50.0)
                
                break
            default:
                self.searchProductInRange(Km: 5.0)
                self.nowInRange = 1
                break
            }
            
        }
    }
  
    
    
    
    
    
    func loadOwnerData() {
        
        var allHaveData:Bool = true
        
        var setToPro:RealmProductDataModel! = nil
        
        for pro in self.arProduct{
            if((pro.owner_FirstName == "") && (pro.owner_LastName == "") && (pro.loadFinish == false)){
                allHaveData = false
                
                self.workOnProduct_UserId = pro.uid
                
                setToPro = pro
                
                
                break
            }
        }
        
        
        if((allHaveData == false) && (setToPro != nil)){
            
            getUserDataWith(UID: self.workOnProduct_UserId, Finish: { (userData) in
                
                for pro in self.arProduct{
                    if(pro.uid == self.workOnProduct_UserId){
                        pro.owner_FirstName = userData.first_name
                        pro.owner_LastName = userData.last_name
                        pro.owner_Image_src = userData.profileImage_src
                        pro.loadFinish = true
                        
                    }
                    
                }
                
                //self.myCollection.reloadData()
                self.loadOwnerData()
                
            })
        }
        
        
    }
    
    
    func searchProductInRange(Km km:CGFloat) {
      
        

        
        
        self.zoomToLocation(Latitude: self.userLatitude, Longitude: self.userLongitude, DistanceMeters: Double(km * 1000))
        
        
        DispatchQueue.main.async {
            self.arProduct.removeAll()
            let otherRealm = try! Realm()
            
            
            
            
            var predicate:String = String(format: "category1 = '%@'", self.category.category_id)
            
            
            var arKey:[String] = self.strKeyword.components(separatedBy: " ")
            if((arKey.count > 0) && (self.strKeyword.count > 0)){
                
                var strPredicate:String = String(format: "title CONTAINS[c] '%@'", arKey[0])
                
                for i in 1..<arKey.count{
                    strPredicate = String(format: "%@ AND title CONTAINS[c] '%@'", strPredicate, arKey[i])
                }
                
                
                strPredicate = String(format: "%@ AND category1 = '%@'", strPredicate, self.category.category_id)
                
                predicate = strPredicate
                
            }else{
                
            }
            
            
            
            
            
            
            
            
            let otherResults = otherRealm.objects(RealmProductDataModel.self).filter(predicate)
            
            print("Number of product \(otherResults.count)")
            
            
            var r:Double = 5000
            switch self.nowInRange {
            case 1:
                // 5 km
                r = 5.0 * 1000.0
                break
            case 2:
                // 10 km
                
                r = 10.0 * 1000.0
                break
            case 3:
                // 20 km
                r = 20.0 * 1000.0
                break
            case 4:
                // 30 km
                r = 30.0 * 1000.0
                break
            case 5:
                // 40 km
                r = 40.0 * 1000.0
                break
            case 6:
                // 50 km
                r = 50.0 * 1000.0
                
                break
            default:
                break
            }
            
            self.addRadiusCircle(location: CLLocation(latitude: self.userLatitude, longitude: self.userLongitude), Radius: (r/2.0))
            
            
            
            
            let userLocation = CLLocation(latitude: self.userLatitude, longitude: self.userLongitude)
            
            
            var arBuffer:[RealmProductDataModel] = [RealmProductDataModel]()
            
            for pro in otherResults{
                
                
                
                
                let proLocation = CLLocation(latitude: pro.product_latitude, longitude: pro.product_longitude)
                
                let distanceInMeters = userLocation.distance(from: proLocation) // result is in meters
                
                if(distanceInMeters <= r){
                    
                    //print(distanceInMeters)
                  
                    let newP:RealmProductDataModel = RealmProductDataModel()
                    
                    newP.category1 = pro.category1
                    newP.category2 = pro.category2
                    
                    newP.created_at_Date = pro.created_at_Date
                    
                    newP.image_name = pro.image_name
                    newP.image_path = pro.image_path
                    newP.image_src = pro.image_src
                    
                    
                    
                    
                    newP.isDeleted = pro.isDeleted
                    newP.isNew = pro.isNew
                    //newP.likeCount = pro.likeCount
                    newP.manufacturer = pro.manufacturer
                    newP.model = pro.model
                    newP.price = pro.price
                    newP.price_server_Number = pro.price_server_Number
                    newP.product_description = pro.product_description
                    newP.product_id = pro.product_id
                    newP.product_id_number = pro.product_id_number
                    newP.product_latitude = pro.product_latitude
                    newP.product_location = pro.product_location
                    newP.product_longitude = pro.product_longitude
                    
                    for item in pro.product_serials{
                        let newItem:RealmSerial = RealmSerial()
                        newItem.amount = item.amount
                        newItem.serialID = item.serialID
                        newItem.serialNumber = item.serialNumber
                        newP.product_serials.append(newItem)
                    }
                    
                    
                    
                    newP.product_status = pro.product_status
                    newP.status = pro.status
                    newP.title = pro.title
                    newP.uid = pro.uid
                    
                    newP.updated_at_Date = pro.updated_at_Date
                    newP.year = pro.year
                    newP.country = pro.country
                    
                    
                    
                    
                    
                    newP.viewCount = pro.viewCount
                    
                    
                    
                    newP.owner_FirstName = pro.owner_FirstName
                    newP.owner_LastName = pro.owner_LastName
                    newP.owner_Image_src = pro.owner_Image_src
                    
                    
                    
                    newP.distance = distanceInMeters
 
                    newP.isUserLike = false
                    let myData:ShareData = ShareData.sharedInstance
                    if(myData.userInfo != nil){
                        
                        for like in myData.userLike{
                            
                            if(newP.product_id == like.product_id){
                                newP.isUserLike = true
                            }
                        }
                        
                    }
                    
                    if((newP.product_status == "Sold Out") || (newP.isDeleted == true)){
                        
                        
                    }else{
                        arBuffer.append(newP)
                    }
                   
                    
                }
                
                
                
                
            }
            
            
            let sort = arBuffer.sorted(by: { (obj1, obj2) -> Bool in
                return (obj1.distance < obj2.distance)
            })
            
            self.arProduct = sort
            
            self.addPin()
       
            self.loadOwnerData()
            
            self.useGoogleLocation = false
            
        }
        
        
    }
    
    @IBAction func tapOnLocation(_ sender: UIButton) {
        
        self.showGoogleAutocomplete()
        
        
    }
    
    
    // MARK: - touch event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //tapOnButtonRange
        
        
        
        
        if let touch = touches.first {
            
            let touchPoint = touch.location(in: self.viRangeBG)
            if(touchPoint.y > 0){
                self.isTouchInSliderBarBG = true
                let touchIn1:Bool = self.myHitTest(Point: touchPoint, onView: self.viButtonRange)
                
                if(touchIn1){
                    
                    self.tapOnButtonRange = true
                }
            }
            
            

            
        }
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            if(self.isTouchInSliderBarBG == true){
                let touchPoint = touch.location(in: self.viRangeBG)
                
                
                if(touchPoint.x <= limite_Low_x){
                    self.viButtonRange.center.x = limite_Low_x
                }else if(touchPoint.x >= limite_Max_x){
                    self.viButtonRange.center.x = limite_Max_x
                }else{
                    self.viButtonRange.center.x = touchPoint.x
                }
                
                let w:CGFloat = self.viButtonRange.center.x - limite_Low_x
                self.viLineBlue.frame = CGRect(x: 0, y: 0, width: w, height: 4)
                self.setPinHighlight(x: touchPoint.x)
            }
            
        
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if(self.isTouchInSliderBarBG == true){
            
            let selectOn = self.checkInRangeOnPinWith(Position: self.viButtonRange.center)
            self.viButtonRange.center.x = self.arRangePinLine[selectOn].center.x
            let w:CGFloat = self.viButtonRange.center.x - limite_Low_x
            self.viLineBlue.frame = CGRect(x: 0, y: 0, width: w, height: 4)
            self.setPinHighlight(x: self.viButtonRange.center.x)
        }
        self.tapOnButtonRange = false
        self.isTouchInSliderBarBG = false
        
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tapOnButtonRange = false
        self.isTouchInSliderBarBG = false
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - Location
    
    func getLocation() {
        
        let location = CLLocationCoordinate2D(latitude: self.userLatitude, longitude: userLongitude)
        
   
    
        if(self.nowInRange < 1){
            self.searchProductInRange(Km: 5.0)
        }else{
            self.startSearchWithStep(countRange: self.nowInRange, ForceUpdate: false)
        }
    
        
        
        
        self.getLocationNameWith(location: location)
    }
    
    
    func getLocationNameWith(location:CLLocationCoordinate2D) {
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            // print(placeMark.addressDictionary)
            
            self.locationData = [String:String]()
            
            self.strLocationName = ""
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? String {
                //print(locationName)
                self.strLocationName = locationName
                
                self.locationData[MyLocationKey.Name.rawValue] = locationName
            }
            
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? String {
                print(street)
                
                if(self.strLocationName.count == 0){
                    self.strLocationName = street
                }else{
                    self.strLocationName = String(format: "%@ %@", self.strLocationName, street)
                }
                
                self.locationData[MyLocationKey.Street.rawValue] = street
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? String {
                //print(city)
                if(self.strLocationName.count == 0){
                    self.strLocationName = city
                }else{
                    self.strLocationName = String(format: "%@ %@", self.strLocationName, city)
                }
                
                self.locationData[MyLocationKey.City.rawValue] = city
                
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? String {
                print(zip)
                if(self.strLocationName.count == 0){
                    self.strLocationName = zip
                }else{
                    self.strLocationName = String(format: "%@ %@", self.strLocationName, zip)
                }
                
                self.locationData[MyLocationKey.Zip.rawValue] = zip
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? String {
                //print(country)
                
                if(self.strLocationName.count == 0){
                    self.strLocationName = country
                }else{
                    self.strLocationName = String(format: "%@ %@", self.strLocationName, country)
                }
                
                self.locationData[MyLocationKey.Country.rawValue] = country
                
                self.lbLocationTitle.text = country
            }
            
            print(self.strLocationName)

            //self.addPin()
        })
    }
    
    
    func addPin() {
        self.myMap.removeAnnotations(self.arPin)
        
        self.arPin.removeAll()
        
        var count:NSInteger = 0
        for pro in self.arProduct{
            
            let myPin = ProductPin()
            myPin.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(pro.product_latitude), longitude: CLLocationDegrees(pro.product_longitude))
            
            //-----------
            let strPrice:String = self.mySetting.priceWithString(strPricein: pro.price)
            
            /*
            let p = Double(pro.price)
            
            if let p = p{
                if(self.mySetting.currencyReadyToUse == true){
                    
                  
                    let priceCon = self.mySetting.exchangeFrom(form: self.mySetting.serverCurrency, To: self.myData.userInfo.currency, Amount: CGFloat(p))
                    
                    if(priceCon >= 0){
                        strPrice = String(format: "%.02f %@", priceCon, self.myData.userInfo.currency)
                    }else{
                        strPrice = String(format: "%.02f %@", p, self.mySetting.serverCurrency)
                    }
                    
                }else{
                    strPrice = String(format: "%.02f %@", p, self.mySetting.serverCurrency)
                }
            }else{
                
                strPrice = String(format: "%@ %@", pro.price, self.mySetting.serverCurrency)
            }
            */
            //-----------
            
            myPin.title = strPrice
            myPin.product = pro
            myPin.myTag = count
            self.arPin.append(myPin)
            count += 1
        }
        
        self.myMap.addAnnotations(self.arPin)
        
        /*
        if(self.arPin.count > 0){
            let p = self.arPin[0]
            self.myMap.showAnnotations([p], animated: true)
        }*/
        //self.myMap.showAnnotations(self.arPin, animated: true)
    }
}


// MARK: - CLLocationManagerDelegate
extension ProductMapVC:CLLocationManagerDelegate{
    
    func zoomToLocation(Latitude lat:Double, Longitude log:Double, DistanceMeters disM:Double) {
        
        let dis:Double = disM * 1.75
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: log)
        //let span = MKCoordinateSpan(latitudeDelta: sp, longitudeDelta: sp)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(location, dis, dis)
        
        self.myMap.setRegion(region, animated: true)
    }
    
    
    
    
    func startGetLocation() {
        
//        if(self.locationManager == nil){
//            self.locationManager = CLLocationManager()
//        }
        
        
        
        
        
        //self.locationManager.delegate = self
        //self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        
        
//        if(NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0){
//            
//            self.locationManager.requestWhenInUseAuthorization()
//        }
        
        
        self.locationManager.requestWhenInUseAuthorization()
        
        
    
        
        /*
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }*/
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
            
            
            /*
            let seconds = 0.450
            let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                
                self.locationManager.startUpdatingLocation()
                
            }
            
            self.locationManager.startUpdatingLocation()
            */
        }
        else{
            print("Location service disabled");
        }
        
        
        //self.locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("get User location didFail")
        
        
        self.readyGetLocation = true
        self.getLocation()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        
        // let currentLocation:CLLocation = newLocation
        
        guard let location = locations.last, location.horizontalAccuracy >= 0 else { return }
        
        
        
        
        self.userLatitude = location.coordinate.latitude
        self.userLongitude = location.coordinate.longitude
        //self.myData.myPostDraft.latitude = currentLocation.coordinate.latitude
        //self.myData.myPostDraft.longitude = currentLocation.coordinate.longitude
        
        
        
        
        
        
        self.locationManager.stopUpdatingLocation()
        
        
        self.readyGetLocation = true
        self.getLocation()
        
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        
        print("get User location")
        
        // let currentLocation:CLLocation = newLocation
        
        self.userLatitude = newLocation.coordinate.latitude
        self.userLongitude = newLocation.coordinate.longitude
        //self.myData.myPostDraft.latitude = currentLocation.coordinate.latitude
        //self.myData.myPostDraft.longitude = currentLocation.coordinate.longitude
        
        
        
        
        
        
        self.locationManager.stopUpdatingLocation()
        
        
        self.readyGetLocation = true
        self.getLocation()
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        
    }
}



// MARK: - MKMapViewDelegate
extension ProductMapVC:MKMapViewDelegate{
    
    func tapOnCallout(sender:UITapGestureRecognizer)  {
        print("tapOnCallout")
        
        
        if((self.selectAtPin >= 0) && (self.selectAtPin < self.arPin.count)){
            
            
            
            
            self.addActivityView {
                
                let realmPro = self.arPin[self.selectAtPin].product!
                
                getProductDataWith(ProductID: realmPro.product_id, Finish: { (product) in
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
                    let vc:ProductDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
                    
                    vc.thisFirstDetail = true
                    vc.myProductData = product
                    
                    if(self.myData.masterView != nil){
                        self.myData.masterView.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    self.removeActivityView {
                        
                    }
                    
                })
                
            }
            
            
            
        }
        
       
        
        
        
        
     
        
    }
    
    
    func addRadiusCircle(location: CLLocation, Radius radius:Double){
        self.myMap.delegate = self
        
        if(self.circle != nil){
            self.myMap.remove(self.circle)
            self.circle = nil
        }
        self.circle = MKCircle(center: location.coordinate, radius: radius as CLLocationDistance)//MKCircle(centerCoordinate: location.coordinate, radius: 10000 as CLLocationDistance)
        self.myMap.add(self.circle)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor(red: (3/255), green: (210/255), blue: (99/255), alpha: 1.0)
            circle.fillColor = UIColor(red: (3/255), green: (210/255), blue: (99/255), alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor(red: (3/255), green: (210/255), blue: (99/255), alpha: 1.0)
            circle.fillColor = UIColor(red: (3/255), green: (210/255), blue: (99/255), alpha: 0.0)
            circle.lineWidth = 1
            return circle
        }
    }
    
    
    
    
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if(pinView == nil) {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            
            
            //            let tap = UITapGestureRecognizer(target: self, action:#selector(SearchMapViewController.tapOnCallout(sender:)) )
            //            pinView!.addGestureRecognizer(tap)
            
            
            
            
        }
        
        
        
        
        if let annota = annotation as? ProductPin{
            pinView?.tag = annota.myTag
        }
        
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("didSelect \(view.tag)")
        
      selectAtPin = view.tag
        
        
        
        
        
        let tapGesture = UITapGestureRecognizer(target:self,  action:#selector(ProductMapVC.tapOnCallout(sender:)))
        view.addGestureRecognizer(tapGesture)
        
        if(view.tag < self.arPin.count){
            let product = self.arPin[view.tag].product
            
            self.showCellPopupWith(product: product!)
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
    
        print("didDeselect \(view.tag)")
        
        deselectAtPin = view.tag
        view.removeGestureRecognizer(view.gestureRecognizers!.first!)
        
        if(selectAtPin == deselectAtPin){
            self.hidenCellPopup()
        }
    }
}




// MARK: - GMSAutocompleteViewControllerDelegate
extension ProductMapVC:GMSAutocompleteViewControllerDelegate{
    
    func showGoogleAutocomplete() {
        
        
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.tableCellSeparatorColor = UIColor(red: (99.0/255.0), green: (99.0/255.0), blue: (99.0/255.0), alpha: 1.0)
        
        present(autocompleteController, animated: true, completion: nil)
        
        
        
        
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print(place.name)
        //print(place.formattedAddress)
        
        
        self.useGoogleLocation = true
        
        
        self.strLocationName = place.name
        self.lbLocationTitle.text = self.strLocationName
        
        
        /*
        var zipCode:String = ""
        var address:String = ""
        
        let arAddress = place.formattedAddress?.components(separatedBy: ",")
        
        if let arAddress = arAddress{
            
            address = arAddress[0]
            
            
            if(arAddress.count >= 2){
                
                let lastStr:String = arAddress[arAddress.count - 1]
                
                let rangeSingapore = lastStr.range(of: "Singapore")
                if rangeSingapore != nil{
                    
                    let arSubZip = lastStr.components(separatedBy: " ")
                    
                    if(arSubZip.count > 0){
                        zipCode = arSubZip[arSubZip.count - 1]
                    }
                    
                    if(zipCode.lowercased() == "singapore"){
                        zipCode = ""
                    }
                }
            }
        }
        
        
        var strFullAddress:String = String(format: "%@ %@", place.name, address)
        
        if(place.name == address){
            strFullAddress = place.name
        }
        */
        
        /*
        ShareData.sharedInstance.myPostDraft.street = strFullAddress
        ShareData.sharedInstance.myPostDraft.latitude = place.coordinate.latitude
        ShareData.sharedInstance.myPostDraft.longitude = place.coordinate.longitude
        ShareData.sharedInstance.myPostDraft.postal_code = zipCode
        
        */

        self.userLatitude = place.coordinate.latitude
        self.userLongitude = place.coordinate.longitude
        
        
        
        self.dismiss(animated: true) {
            
            if(self.nowInRange < 1){
                self.searchProductInRange(Km: 5.0)
            }else{
                self.startSearchWithStep(countRange: self.nowInRange, ForceUpdate: true)
            }
            
        }
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
        //self.dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
      
        
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    
}


