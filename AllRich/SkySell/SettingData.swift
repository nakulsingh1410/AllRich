//
//  SettingData.swift
//  SkySell
//
//  Created by DW02 on 5/29/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift


class MyStringBool{
    var name:String = ""
    var enable:Bool = false
}


class ProductCellPosition {
    
    enum CellType:String {
        case product_image = "product image"
        case profile = "profile"
        case description = "description"
        case map = "map"
    }
    
    var isActive:Bool = true
    var position:NSInteger = 0
    var title:String = ""
    var type:String = ""
}

class ReportCellPosition{
    
    var isActive:Bool = true
    var position:NSInteger = 0
    var reason_id:String = ""
    var reason_title:String = ""
}


class SettingData: NSObject {

    
    
    
    
    
    static let sharedInstance = SettingData()
    
    var arCountry:[MyStringBool] = [MyStringBool]()
    
    
    var serverCurrency:String = "SGD"
    var displayCurrency:String = "SGD"
    
    var rateServer:Double = 1.0
    var rateDisplay:Double = 1.0
    
    var currencyReadyToUse:Bool = false
    
    
    
    var arProductDetail:[ProductCellPosition] = [ProductCellPosition]()
    
    var arReportListing:[ReportCellPosition] = [ReportCellPosition]()
    
    var arReportUser:[ReportCellPosition] = [ReportCellPosition]()
    
    
    
    
    
    
    var haveConnect:Bool = false
    var loadFinish:Bool = false
    
    
    
    
    
    override init() {
        
        
        //-------------
        do{
            let pp1:ProductCellPosition = ProductCellPosition()
            pp1.isActive = true
            pp1.position = 1
            pp1.title = "Photo"
            pp1.type = "product image"
            
            arProductDetail.append(pp1)
        }
        
        do{
            let pp1:ProductCellPosition = ProductCellPosition()
            pp1.isActive = true
            pp1.position = 2
            pp1.title = "Profile"
            pp1.type = "profile"
            
            arProductDetail.append(pp1)
        }
        
        
        do{
            let pp1:ProductCellPosition = ProductCellPosition()
            pp1.isActive = true
            pp1.position = 3
            pp1.title = "Information"
            pp1.type = "description"
            
            arProductDetail.append(pp1)
        }
        
        do{
            let pp1:ProductCellPosition = ProductCellPosition()
            pp1.isActive = true
            pp1.position = 4
            pp1.title = "Map Location"
            pp1.type = "map"
            
            arProductDetail.append(pp1)
        }
        //-------------

        do{
            let rp:ReportCellPosition = ReportCellPosition()
            rp.isActive = true
            rp.position = 1
            rp.reason_id = "R0001"
            rp.reason_title = "Prohibited item"
            
            self.arReportListing.append(rp)
        }
        
        
        do{
            let rp:ReportCellPosition = ReportCellPosition()
            rp.isActive = true
            rp.position = 2
            rp.reason_id = "R0002"
            rp.reason_title = "Counterfeit"
            
            self.arReportListing.append(rp)
        }
        
        do{
            let rp:ReportCellPosition = ReportCellPosition()
            rp.isActive = true
            rp.position = 3
            rp.reason_id = "R0003"
            rp.reason_title = "Wrong Category"
            
            self.arReportListing.append(rp)
        }
        
        do{
            let rp:ReportCellPosition = ReportCellPosition()
            rp.isActive = true
            rp.position = 4
            rp.reason_id = "R0004"
            rp.reason_title = "Keyword Spam"
            
            self.arReportListing.append(rp)
        }
        
        do{
            let rp:ReportCellPosition = ReportCellPosition()
            rp.isActive = true
            rp.position = 5
            rp.reason_id = "R0005"
            rp.reason_title = "Repeated posts"
            
            self.arReportListing.append(rp)
        }
        
        do{
            let rp:ReportCellPosition = ReportCellPosition()
            rp.isActive = true
            rp.position = 6
            rp.reason_id = "R0006"
            rp.reason_title = "Nudity/pornography/mature content"
            
            self.arReportListing.append(rp)
        }
        
        do{
            let rp:ReportCellPosition = ReportCellPosition()
            rp.isActive = true
            rp.position = 7
            rp.reason_id = "R0007"
            rp.reason_title = "Hateful speech/blackmail"
            
            self.arReportListing.append(rp)
        }
        
        //-------------
        
        
        
        
        
        
        
        
    }
    
    
    func startConnect(){
        
        self.haveConnect = true
        let postRef = FIRDatabase.database().reference().child("setting")
     
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary{
                
                
                self.readData(dictionary: value)
                
                
                let myData:ShareData = ShareData.sharedInstance
                
                if(myData.userInfo != nil){
                    print(myData.userInfo.currency)
                    
                    
                    self.exchangeFrom(form: self.serverCurrency, To: myData.userInfo.currency, Amount: 1, Answer: { (ans) in
                        print("currency \(ans)")
                    })
                }
            
                
                
            }
            
            self.loadFinish = true
        }) { (error) in
            self.haveConnect = false
            
        }
        
        
        
    }
    
    
    
    func readData(dictionary:NSDictionary) {
        
        //print("Read ===")
       // print(dictionary)
        
        //---------- country ----------
        let country = dictionary.object(forKey: "country") as? NSDictionary
        if let country = country{
            
            self.arCountry.removeAll()
            let allKey:[String]? = country.allKeys as? [String]
            if let allKey = allKey{
                for key in allKey{
                    let enable:Bool? = country.object(forKey: key) as? Bool
                    if let enable = enable{
                        
                        let newCountry:MyStringBool = MyStringBool()
                        newCountry.name = key
                        newCountry.enable = enable
                        
                        self.arCountry.append(newCountry)
                        
                    }
                }
            }
            
            
            
        }
        
        
        //---------- currency ----------
        
        
        self.serverCurrency = "SGD"
        let dcurrency = dictionary.object(forKey: "server_currency_Notchange") as? String
        if let dcurrency = dcurrency{
            self.serverCurrency = dcurrency
        }
        
        
        //---------- product_detail ----------
        
        
        
        
        var arBuuferProductPosition:[ProductCellPosition] = [ProductCellPosition]()
        
        let arProd = dictionary.object(forKey: "product_detail") as? NSArray
        if let arProd = arProd{
            
            arBuuferProductPosition.removeAll()
            for obj in arProd{
                if let obj = obj as? NSDictionary{
                    
                    let newPo:ProductCellPosition = ProductCellPosition()
                    //------
                    let active = obj.object(forKey: "isActive") as? Bool
                    if let active = active{
                        newPo.isActive = active
                    }
                    //------
                    let position = obj.object(forKey: "position") as? NSInteger
                    if let position = position{
                        newPo.position = position
                    }
                    //------
                    let title = obj.object(forKey: "title") as? String
                    if let title = title{
                        newPo.title = title
                    }
                    //------
                    let type = obj.object(forKey: "type") as? String
                    if let type = type{
                        newPo.type = type
                    }
                    //------
                    
                    arBuuferProductPosition.append(newPo)
                    
                    
                }
            }
        }
        
        //----------
        
        let dicProd = dictionary.object(forKey: "product_detail") as? NSDictionary
        if let dicProd = dicProd{
            arBuuferProductPosition.removeAll()
            
            let allValue = dicProd.allValues
            for obj in allValue{
                if let obj = obj as? NSDictionary{
                    
                    let newPo:ProductCellPosition = ProductCellPosition()
                    //------
                    let active = obj.object(forKey: "isActive") as? Bool
                    if let active = active{
                        newPo.isActive = active
                    }
                    //------
                    let position = obj.object(forKey: "position") as? NSInteger
                    if let position = position{
                        newPo.position = position
                    }
                    //------
                    let title = obj.object(forKey: "title") as? String
                    if let title = title{
                        newPo.title = title
                    }
                    //------
                    let type = obj.object(forKey: "type") as? String
                    if let type = type{
                        newPo.type = type
                    }
                    //------
                    
                    arBuuferProductPosition.append(newPo)
                    
                    
                }
            }
        }
        
        
        self.arProductDetail.removeAll()
        
        
        self.arProductDetail = arBuuferProductPosition.sorted(by: { (value1, value2) -> Bool in
            
            return value1.position <= value2.position
        })
        
        
        //---------- report_listing ----------
        
        var arReportBuffer:[ReportCellPosition] = [ReportCellPosition]()
        let dicReport = dictionary.object(forKey: "report_listing") as? NSDictionary
        if let dicReport = dicReport{
            
            let allValue = dicReport.allValues
            for value in allValue{
                if let value = value as? NSDictionary{
                    
                    let newreport:ReportCellPosition = ReportCellPosition()
                    //------
                    let active = value.object(forKey: "isActive") as? Bool
                    if let active = active{
                        newreport.isActive = active
                    }
                    //------
                    let position = value.object(forKey: "position") as? NSInteger
                    if let position = position{
                        newreport.position = position
                    }
                    //------
                    let reason_id = value.object(forKey: "reason_id") as? String
                    if let reason_id = reason_id{
                        newreport.reason_id = reason_id
                    }
                    //------
                    let reason_title = value.object(forKey: "reason_title") as? String
                    if let reason_title = reason_title{
                        newreport.reason_title = reason_title
                    }
                    //------
                    arReportBuffer.append(newreport)
                    
                    
                }
            }
            
        }
        
        
        self.arReportListing.removeAll()
        
        self.arReportListing = arReportBuffer.sorted(by: { (obj1, obj2) -> Bool in
            
            
            return obj1.position <= obj2.position
        })
        
        //---------- report_user ----------
        
        var arReportUserBuffer:[ReportCellPosition] = [ReportCellPosition]()
        let dicReportUser = dictionary.object(forKey: "report_user") as? NSDictionary
        if let dicReport = dicReportUser{
            
            let allValue = dicReport.allValues
            for value in allValue{
                if let value = value as? NSDictionary{
                    
                    let newreport:ReportCellPosition = ReportCellPosition()
                    //------
                    let active = value.object(forKey: "isActive") as? Bool
                    if let active = active{
                        newreport.isActive = active
                    }
                    //------
                    let position = value.object(forKey: "position") as? NSInteger
                    if let position = position{
                        newreport.position = position
                    }
                    //------
                    let reason_id = value.object(forKey: "reason_id") as? String
                    if let reason_id = reason_id{
                        newreport.reason_id = reason_id
                    }
                    //------
                    let reason_title = value.object(forKey: "reason_title") as? String
                    if let reason_title = reason_title{
                        newreport.reason_title = reason_title
                    }
                    //------
                    arReportUserBuffer.append(newreport)
                    
                    
                }
            }
            
        }
        
        
        self.arReportUser.removeAll()
        
        self.arReportUser = arReportUserBuffer.sorted(by: { (obj1, obj2) -> Bool in
            
            
            return obj1.position <= obj2.position
        })
        
        //----------
        
    }
    
    // MARK: - Currency
    
    func exchangeFrom(form:String, To to:String, Amount amount:Double, Answer answer:@escaping (Double)->Void) {
        
        
        
        if((self.serverCurrency != form.uppercased()) || (self.displayCurrency != to.uppercased())){
            self.currencyReadyToUse = false
        }
        
        
        if(self.currencyReadyToUse == false){
            
            self.serverCurrency = form.uppercased()
            self.displayCurrency = to.uppercased()
            self.getRateExchange(ServerCurrency: form, DisplayCurrency: to, callBack: { (dic) in
                self.readRateCurrencyDictionary(dic: dic)
                
                if((self.rateServer == 0) || (self.rateDisplay == 0)){
                    self.currencyReadyToUse = false
                    
                    print("Amount \(amount) , form \(form), To \(to), = error")
                    answer(-1)
                }else{
                    self.currencyReadyToUse = true
                    
                    let rate:Double = self.rateDisplay / self.rateServer
                    
                    let ans:Double = amount * rate
                    
                    print("Amount \(amount) , form \(form), To \(to), = \(ans)")
                    answer(ans)
                    
                }
                
                
                
            })
            
        }else{
            let rate:Double = self.rateDisplay / self.rateServer
            
            let ans:Double = amount * rate
            
            print("Amount \(amount) , form \(form), To \(to), = \(ans)")
            answer(ans)
        }
        
        
    }
    
    func exchangeFrom(form:String, To to:String, Amount amount:Double)->Double {
        
        
        
        if((self.serverCurrency != form.uppercased()) || (self.displayCurrency != to.uppercased())){
            self.currencyReadyToUse = false
        }
        
        
        if(self.currencyReadyToUse == false){
            
            self.serverCurrency = form.uppercased()
            self.displayCurrency = to.uppercased()
            self.getRateExchange(ServerCurrency: form, DisplayCurrency: to, callBack: { (dic) in
                self.readRateCurrencyDictionary(dic: dic)
                
                if((self.rateServer == 0) || (self.rateDisplay == 0)){
                    self.currencyReadyToUse = false
                }else{
                    self.currencyReadyToUse = true
                }
                
                
                
            })
            
            return -1
        }else{
            
            /*
            let rate:Double = Double(self.rateDisplay / self.rateServer)
            
            let ans:Double = amount * rate
 */
            let ans:Double = (amount * self.rateDisplay) / self.rateServer
            
            return ans
        }
        
        
    }
    
    
    func exchangeToServerCurrency(amount:Double) -> Double {
        if(self.serverCurrency.uppercased() == self.displayCurrency.uppercased()){
            return amount
        }else{
            let rate:Double =  self.rateServer / self.rateDisplay
            let ans:Double = amount * rate
            return ans
        }
    }
    
    func priceWithString(strPricein:String)->String {
        var strPrice:String = strPricein
        
        /*
        if let testP0:Double = Double(strPrice){
            //let testP1:Double = testP0 / 10000.0
            let strTest04:String = String(format: "%.07f", testP0)
            
            if let testP2:Double = Double(strTest04){
                
                let test3:Double = testP2
                
                strPrice = String(format: "%.07f", test3)
            }
            
        }
        */
        
        
        
        
        
        var p = Double(strPrice)
        
        
        
        
        if let pp = p{
            
            
            let chackis999Int:NSInteger = NSInteger(pp)
            let chackis999Dou:Double = pp - Double(chackis999Int)
            let dot:NSInteger = NSInteger(chackis999Dou * 1000)
            
            if(dot == 999){
                let check1000:NSInteger = NSInteger(pp * 1000)
                let check10000:NSInteger = NSInteger(pp * 10000)
                
                let check9000:NSInteger = check10000 - check1000
                
                p = Double(check9000) / 9000.0
                
            }
            
            
        }
        
        
        
        
        
        let myData:ShareData = ShareData.sharedInstance
        
        
        let numberF = NumberFormatter()
        numberF.numberStyle = .currency
        
        
        
        if(myData.userInfo != nil){
           
            if let p = p{
                if(self.currencyReadyToUse == true){
                    
                    
                    let priceCon = self.exchangeFrom(form: self.serverCurrency, To: myData.userInfo.currency, Amount: p)
                    
                    if(priceCon >= 0){
                        
                        
                        numberF.currencyCode = myData.userInfo.currency
                        
                        strPrice = numberF.string(from: NSNumber(value: Double(priceCon)))!
                        
                        strPrice = String(format: "%@", strPrice)
                    }else{
                     
                        
                        numberF.currencyCode = self.serverCurrency
                        strPrice = numberF.string(from: NSNumber(value: Double(p)))!
                        
                        
                        
                        strPrice = String(format: "%@", strPrice)
                    }
                    
                }else{
                    
                 
                    
                    numberF.currencyCode = self.serverCurrency
                    strPrice = numberF.string(from: NSNumber(value: Double(p)))!
                    
                    
                    strPrice = String(format: "%@", strPrice)
                }
            }else{
                numberF.currencyCode = self.serverCurrency
                strPrice = String(format: "%@", strPrice)
            }
            
      
        }else{
            if let p = p{
           
                
                numberF.currencyCode = self.serverCurrency
                strPrice = numberF.string(from: NSNumber(value: Double(p)))!
                
                strPrice = String(format: "%@", strPrice)
            }else{
                numberF.currencyCode = self.serverCurrency
                strPrice = String(format: "%@", strPrice)
            }
        }
        
        
        return strPrice
    }
    
    
    
    
    func readRateCurrencyDictionary(dic:[String:Any]) {
        
        self.rateDisplay = 1.0
        self.rateServer = 1.0
        
        
        
        if(self.serverCurrency == self.displayCurrency){
            return
        }
        
        
        
        
        let base:String? = dic["base"] as? String
        if let base = base{
            print(base)
        }
        
        let dateFormatFull:DateFormatter = DateFormatter()
        dateFormatFull.dateFormat = "yyyy-MM-dd"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let date:String? = dic["date"] as? String
        if let date = date{
            print(date)
        }
        
        
        
        let rates:[String:Double]? = dic["rates"] as? [String:Double]
        if let rates = rates{
            
            for r in rates{
                if(r.key.uppercased() == self.displayCurrency.uppercased()){
                    self.rateDisplay = r.value
                    
                }else if(r.key.uppercased() == self.serverCurrency.uppercased()){
                    self.rateServer = r.value
                    
                    
                }
            }
            
        }
        
        
        
        
        
        
        
    }
    
    
    
    func getRateExchange(ServerCurrency server:String, DisplayCurrency display:String, callBack:@escaping ([String:Any])->Void){
        
        
        let strURL:String = String(format: "http://api.fixer.io/latest?base=USD&symbols=%@,%@", server.uppercased(), display.uppercased())
        print(strURL)
        let urlUpdate:URL? = URL(string: strURL)
        if let urlUpdate = urlUpdate{
            var request = URLRequest(url: urlUpdate)
            
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                
                
                if let _ = response, let data = data{
                    
                    do{
                        let dicData = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                        
                        
                        if let dicData = dicData{
                            
                            print(dicData)
                            
                            callBack(dicData)
                            
                            
                        }else{
                            print("save_Unsave_AlistingWith Error")
                            callBack([String:Any]())
                        }
                        
                        
                    }catch{
                        print("save_Unsave_AlistingWith jsonObject Error")
                        callBack([String:Any]())
                    }
                    
                    
                    
                }
            })
            
            task.resume()
            
        }
        
        
        
    }
    
    
}












