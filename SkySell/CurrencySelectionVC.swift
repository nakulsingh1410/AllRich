//
//  CurrencySelectionVC.swift
//  SkySell
//
//  Created by DW02 on 6/2/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase



class CurrencySelectionVC: UIViewController {

    
    
    
    @IBOutlet weak var btBack: UIButton!
    @IBOutlet weak var btDone: UIButton!
    
    @IBOutlet weak var viTopBar: UIView!
    
    
    @IBOutlet weak var viSearchBG: UIView!
    
    @IBOutlet weak var viSearchFrame: UIView!
    
    @IBOutlet weak var tfSearch: UITextField!
    
    @IBOutlet weak var myTable: UITableView!
    
    
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    
    
    
    var myData:ShareData = ShareData.sharedInstance
    var mySetting:SettingData = SettingData.sharedInstance
    
    
    
    
    var lastSelectAtRow:NSInteger = -1
    
    
    var arCountryCode:[CountryObject] = [CountryObject]()
    let locale = Locale(identifier: "en_US")
    
    
    var selectedCountry:String = ""
    
    var userSecetCountry:[CountryObject] = [CountryObject]()
    
    var callBack:(_ country:CountryObject)->Void = {(countryObject) in
        
    }
    
    
    
    let textFont:UIFont = UIFont(name: "Avenir-Medium", size: 14)!
    
    
    
    
    var myActivityView:ActivityLoadingView! = nil
    var working:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        
        self.tfSearch.delegate = self
        
        
        self.viTopBar.isUserInteractionEnabled = true
        
        
        self.viTopBar.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viTopBar.layer.shadowRadius = 1
        self.viTopBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viTopBar.layer.shadowOpacity = 0.5
        
        
        self.viSearchFrame.clipsToBounds = true
        self.viSearchFrame.layer.cornerRadius = 2
        
        
        
        
        
        
        
        //CountryLabelCell
        
        do{
            let nib:UINib = UINib(nibName: "CurrencyHeaderCell", bundle: nil)
            self.myTable.register(nib, forHeaderFooterViewReuseIdentifier: "CurrencyHeaderCell")
        }
        
        
        do{
            let nib:UINib = UINib(nibName: "CountryLabelCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "CountryLabelCell")
        }
        
        
        
        
        
        self.myTable.delegate = self
        self.myTable.dataSource = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        self.addActivityView {
            var buffCountry:[CountryObject] = [CountryObject]()
            
            
            
            
            for str in Locale.isoRegionCodes{
                let newCountry:CountryObject = CountryObject()
                newCountry.code = str
                let countryName = self.locale.localizedString(forRegionCode: str)
                
                
                
                let countryCodeCA = str
                let localeIdCA = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue:countryCodeCA])
                let localeCA = NSLocale(localeIdentifier: localeIdCA)
                let currencySymbolCA = localeCA.object(forKey: NSLocale.Key.currencySymbol)
                let currencyCodeCA = localeCA.object(forKey: NSLocale.Key.currencyCode)
                
                
                if let currencySymbolCA = currencySymbolCA as? String{
                    newCountry.currencyCode = currencySymbolCA
                }
                
                if let currencyCodeCA = currencyCodeCA as? String{
                    newCountry.currencyCode = currencyCodeCA
                }
                
                
                
                
                if let countryName = countryName{
                    newCountry.countryName = countryName
                }else{
                    newCountry.countryName = ""
                }
                
                let imageName:String = String(format: "%@.png", str)
                let image:UIImage? = UIImage(named: imageName)
                if let image = image{
                    newCountry.image = image
                    
                }else{
                    newCountry.image = nil
                }
                
                newCountry.keyword = String(format: "%@ %@ %@", str, newCountry.countryName, newCountry.currencyCode)
                
                
                buffCountry.append(newCountry)
                
                
                if((self.myData.userInfo.currency.lowercased() == newCountry.currencyCode.lowercased()) && (self.userSecetCountry.count == 0)){
                    
                    
                    
                    
                    ///-------------
                    let newc:CountryObject = CountryObject()
                    newc.code = newCountry.code
                    newc.countryName = newCountry.countryName
                    newc.image = newCountry.image
                    self.selectedCountry = newCountry.countryName
                    
                    newc.currencyCode = newCountry.currencyCode
                    newc.currencySymbol = newCountry.currencySymbol
                    
                    newc.keyword = newCountry.keyword
                    
                    newc.isShow = true
                    
                    self.userSecetCountry.append(newc)
                    ///-------------
                    
                }
                
                
            }
            
            
            
            self.arCountryCode = buffCountry.sorted(by: { (obj1, obj2) -> Bool in
                let value1 = obj1.countryName
                let value2 = obj2.countryName
                
                return value1 < value2
            })
            
            
            
            for i in 0..<self.arCountryCode.count{
                
                
                if(self.selectedCountry == self.arCountryCode[i].countryName){
                    self.lastSelectAtRow = i
                }
            }
            
            
            self.removeActivityView {
                self.myTable.reloadData()
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
    
    
    @IBAction func tapOnBack(_ sender: UIButton) {
        
        self.exitScene()
        
    }
    
    @IBAction func tapOnDone(_ sender: UIButton) {
        self.myData.needUpdateAfterEdit = true
        
        
        if(self.userSecetCountry.count > 0){
            self.addActivityView {
                
                let select = self.userSecetCountry[0]
                
                self.sendUserCurrencyToServer(strCurrency: select.currencyCode)
                
                
                
            }
        }
        
        
        /*
        if((self.lastSelectAtRow >= 0) && (self.lastSelectAtRow < self.arCountryCode.count)){
            self.callBack(self.arCountryCode[self.lastSelectAtRow])
        }
        
        
        self.exitScene()
 */
        
        
    }
    
    func exitScene() {
        if let navigation = self.navigationController{
            navigation.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: {
                
            })
        }
    }
    
    
    
    
    
    
    
    func searchCountryWith(Key strKey:String) {
        
        if(strKey.count <= 0){
            for cat in self.arCountryCode{
                cat.isShow = true
            }
        }else{
            
            for cat in self.arCountryCode{
                let nsStr:NSString = NSString(string: cat.keyword.lowercased())
                
                let range = nsStr.range(of: strKey.lowercased())
                if(range.length > 0){
                    cat.isShow = true
                }else{
                    cat.isShow = false
                }
            }
            
            
            
            
        }
        
        self.myTable.reloadSections([1], with: UITableViewRowAnimation.fade)
    }
    
    // MARK: - Activity
    
    func addActivityView(Finish finish:@escaping ()->Void){
        
        if(self.myActivityView == nil){
            myActivityView = ActivityLoadingView(frame: CGRect(x: 0, y: 47, width: screenSize.width, height: screenSize.height - 47))
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
    
    
    
    
    // MARK: - Connect
    
    
    func sendUserCurrencyToServer(strCurrency:String) {
        
        
        let postRef = FIRDatabase.database().reference().child("users").child(self.myData.userInfo.uid).child("currency")
        
        
        postRef.setValue(strCurrency) { (error, reference) in
            
            getUserDataWith(UID: self.myData.userInfo.uid, Finish: { (udata) in
                
                
                self.myData.userInfo = udata
                
                self.mySetting.startConnect()
                
                self.removeActivityView {
                    self.exitScene()
                }
                
            })
            
        }
        
        
    }
    
    
    
    
    
    
    
}



// MARK: - UITableViewDelegate, UITableViewDataSource
extension CurrencySelectionVC:UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 2
    }
    
    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //var numberOfCell:NSInteger = 0
        if(section == 0){
            return self.userSecetCountry.count
        }
        
        return self.arCountryCode.count
    }
    
    // MARK: - Cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        var cellHeight:CGFloat = 50
        
        if(indexPath.section == 0){
            return cellHeight
        }
        
        let country = self.arCountryCode[indexPath.row]
        
        
        if(country.isShow == false){
            cellHeight = 0
        }
        
        if(country.currencyCode.lowercased() == "xxx"){
            cellHeight = 0
        }
        
        return cellHeight
    }
    
   
     // MARK: - Header height
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     
     var cellHeight:CGFloat = 30
     
        
        if(section == 1){
            let str:String = "Would you like to switch to a Currency of your choice?"
            
            cellHeight = heightForView(text: str, Font: textFont, Width: self.screenSize.width - 44) + 26
            
            if(cellHeight < 30){
                cellHeight = 30
            }
        }
        
        
     return cellHeight
     
     }
     
     // MARK: - Header cell
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
     let cell:CurrencyHeaderCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CurrencyHeaderCell") as? CurrencyHeaderCell
     
        if(section == 0){
            cell?.lbTitle.text = "Default Currency"
        }else{
            cell?.lbTitle.text = "Would you like to switch to a Currency of your choice?"
        }
     return cell
     }
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        //print("Cell =====   \(indexPath)")
        
        
        let cell:CountryLabelCell? = tableView.dequeueReusableCell(withIdentifier: "CountryLabelCell", for: indexPath) as? CountryLabelCell
        cell?.selectionStyle = .default
        cell?.clipsToBounds = true
        //cell?.tag = indexPath.row
        
        
        var country = self.arCountryCode[indexPath.row]
        if(indexPath.section == 0){
            country = self.userSecetCountry[indexPath.row]
        }else{
            country = self.arCountryCode[indexPath.row]
        }
        
        
        
        if(country.image != nil){
            cell?.imageFlag.image = country.image
            cell?.imageFlag.alpha = 1
        }else{
            cell?.imageFlag.alpha = 0
        }
        
        cell?.lbTitle.text = String(format: "%@ - %@", country.currencyCode, country.countryName)
        
        
        
        
        
        if(indexPath.row == self.lastSelectAtRow){
            cell?.contentView.backgroundColor = UIColor(red: (237.0/255.0), green: (237.0/255.0), blue: (237.0/255.0), alpha: 1.0)
        }else{
            
            
            cell?.contentView.backgroundColor = UIColor.white
        }
        
        return cell!
        
    }
    
    // MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.section == 1){
            
            
            self.userSecetCountry.removeAll()
            if(indexPath.row < self.arCountryCode.count){
                let country = self.arCountryCode[indexPath.row]
                
                let newc:CountryObject = CountryObject()
                newc.code = country.code
                newc.countryName = country.countryName
                newc.image = country.image
                
                
                newc.currencyCode = country.currencyCode
                newc.currencySymbol = country.currencySymbol
                
                newc.keyword = country.keyword
                
                newc.isShow = true
                
                self.userSecetCountry.append(newc)
                
                let indexSelect = IndexPath(row: 0, section: 0)
                self.myTable.reloadRows(at: [indexSelect], with: UITableViewRowAnimation.fade)
            }
            
            
            
            
            if(indexPath.row != self.lastSelectAtRow){
                
                if(self.lastSelectAtRow >= 0){
                    
                    let lasetIndex:IndexPath = IndexPath(row: self.lastSelectAtRow, section: 1)
                    
                    
                    self.lastSelectAtRow = indexPath.row
                    self.myTable.reloadRows(at: [indexPath, lasetIndex], with: UITableViewRowAnimation.fade)
                }else{
                    
                    self.lastSelectAtRow = indexPath.row
                    self.myTable.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                }

                
            }
            
            
        }
        
        
        
        
       
        
        
        
        
        
        
        self.myTable.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    
}





// MARK: - UITableViewDelegate, UITableViewDataSource
extension CurrencySelectionVC:UITextFieldDelegate{
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        
        
        
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let seconds = 0.150
        let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            
            self.searchCountryWith(Key: self.tfSearch.text!)
            
        }
        
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
        let seconds = 0.150
        let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            
            self.searchCountryWith(Key: self.tfSearch.text!)
            
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        
        self.searchCountryWith(Key: self.tfSearch.text!)
        
        
        return true
        
    }
    
}




