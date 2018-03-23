//
//  CountryPickerVC.swift
//  SkySell
//
//  Created by DW02 on 5/23/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit


class CountryObject{
    var code:String = ""
    var countryName:String = ""
    var image:UIImage! = nil
    
    
    var currencyCode:String = ""
    var currencySymbol:String = ""
    
    var keyword:String = ""
    
    var isShow:Bool = true
}



class CountryPickerVC: UIViewController {

    
    @IBOutlet weak var btBack: UIButton!
    @IBOutlet weak var btDone: UIButton!
    
    @IBOutlet weak var viTopBar: UIView!
    
    
    @IBOutlet weak var viSearchBG: UIView!
    
    @IBOutlet weak var viSearchFrame: UIView!
    
    @IBOutlet weak var tfSearch: UITextField!
    
    @IBOutlet weak var myTable: UITableView!
    
    
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    var working:Bool = false
    
    
    var myData:ShareData = ShareData.sharedInstance
    
    var lastSelectAtRow:NSInteger = -1
    
    
    var arCountryCode:[CountryObject] = [CountryObject]()
    let locale = Locale(identifier: "en_US")
    
    
    var selectedCountry:String = ""
    
    
    
    var callBack:(_ country:CountryObject)->Void = {(countryObject) in
        
    }
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
        
        
        
 
        
        var buffCountry:[CountryObject] = [CountryObject]()
        for str in Locale.isoRegionCodes{
            let newCountry:CountryObject = CountryObject()
            newCountry.code = str
            let countryName = locale.localizedString(forRegionCode: str)
            
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
            
            newCountry.keyword = String(format: "%@ %@", str, newCountry.countryName)
            
            
            buffCountry.append(newCountry)
            
            
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
        
        //CountryLabelCell
        
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
    

    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
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
        
 
        if((self.lastSelectAtRow >= 0) && (self.lastSelectAtRow < self.arCountryCode.count)){
            self.callBack(self.arCountryCode[self.lastSelectAtRow])
        }
     
        
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
        
        self.myTable.reloadSections([0], with: UITableViewRowAnimation.fade)
    }

}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension CountryPickerVC:UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
    }
    
    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //var numberOfCell:NSInteger = 0
        
        
        return self.arCountryCode.count
    }
    
    // MARK: - Cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        var cellHeight:CGFloat = 50
        
        
        
        let country = self.arCountryCode[indexPath.row]
        
        
        if(country.isShow == false){
            cellHeight = 0
        }
        
        
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
        
        
        
        
        //print("Cell =====   \(indexPath)")
        
        
        let cell:CountryLabelCell? = tableView.dequeueReusableCell(withIdentifier: "CountryLabelCell", for: indexPath) as? CountryLabelCell
        cell?.selectionStyle = .none
        cell?.clipsToBounds = true
        //cell?.tag = indexPath.row
        
    
        let country = self.arCountryCode[indexPath.row]
     
        
        if(country.image != nil){
            cell?.imageFlag.image = country.image
            cell?.imageFlag.alpha = 1
        }else{
            cell?.imageFlag.alpha = 0
        }
        
        cell?.lbTitle.text = country.countryName
        
        
        
        
        
        if(indexPath.row == self.lastSelectAtRow){
            cell?.contentView.backgroundColor = UIColor(red: (237.0/255.0), green: (237.0/255.0), blue: (237.0/255.0), alpha: 1.0)
        }else{
            
            
            cell?.contentView.backgroundColor = UIColor.white
        }
        
        return cell!
        
    }
    
    // MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if(indexPath.row != self.lastSelectAtRow){
            
            if(self.lastSelectAtRow >= 0){
                
                let lasetIndex:IndexPath = IndexPath(row: self.lastSelectAtRow, section: 0)
                
                
                self.lastSelectAtRow = indexPath.row
                self.myTable.reloadRows(at: [indexPath, lasetIndex], with: UITableViewRowAnimation.fade)
            }else{
                
                self.lastSelectAtRow = indexPath.row
                self.myTable.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
            
            
            
            
            
          
            
            
        }
        
        
        
        
        
        
        
        
        
        self.myTable.deselectRow(at: indexPath, animated: true)
        
        
        if((self.lastSelectAtRow >= 0) && (self.lastSelectAtRow < self.arCountryCode.count)){
            self.callBack(self.arCountryCode[self.lastSelectAtRow])
            
            self.exitScene()
        }
        
        
        
        
        
    }
    
    
    
    
}





// MARK: - UITextFieldDelegate
extension CountryPickerVC:UITextFieldDelegate{
    
    
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



