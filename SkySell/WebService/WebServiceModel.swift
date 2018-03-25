//
//  WebServiceModel.swift
//  SkySell
//
//  Created by Nakul Singh on 3/23/18.
//  Copyright © 2018 DW02. All rights reserved.
//

import UIKit

class WebServiceModel: NSObject {

    /*************************************************************/
    class func isPremiunMember(callback:@escaping (Bool)-> Void) {
            //Global.showHud()
            let uid = ShareData.sharedInstance.loadsaveUserInfo_UID()
            let parameters = ["userId":uid]
            
            guard let url = URL(string: "https://us-central1-newmybanknotes.cloudfunctions.net/isPremiunMember") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
            request.httpBody = httpBody
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                Global.hideHud()
                if let response = response {
                    print(response)
                }
                if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                            print(json)
                            if  let status = json["status"] as? String, status  == "success" {
                                if  let data = json["data"] as? [String:Any] ,let isPaid = data["isPremiunMemberPaid"] as? Int ,isPaid  == 1 {
                                    callback(true)
                                }else {
                                    callback(false)
                                }
                            }else{
                                callback(false)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
                }.resume()
        
    }
    /*************************************************************/
    
    /*************************************************************/
    class func getUserPoints(callback:@escaping (Int?)-> Void) {
        //Global.showHud()
        let uid = ShareData.sharedInstance.loadsaveUserInfo_UID()
        let parameters = ["userId":uid]
        
        guard let url = URL(string: "https://us-central1-newmybanknotes.cloudfunctions.net/getUserPoints") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            Global.hideHud()
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                        print(json)
                        if  let points = json["points"] as? Int {
                            callback(points)
                        }else{
                            callback(nil)
                        }
                    }
                } catch {
                    print(error)
                }
            }
            }.resume()
        
    }
    /*************************************************************/
    /*************************************************************/
    class func getPaymentHistory(callback:@escaping ( [[String:Any]]?)-> Void) {
        Global.showHud()
        let uid = ShareData.sharedInstance.loadsaveUserInfo_UID()
        let parameters = ["userId":uid]
        
        guard let url = URL(string: "https://us-central1-newmybanknotes.cloudfunctions.net/getPaymentHistory") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            Global.hideHud()
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                        print(json)
                        if  let dataDict = json["data"] as? [String:Any] {
                            callback(WebServiceModel.getArrayFromDictionary(dictionary: dataDict))
                        }else{
                            callback(nil)
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
            
            }.resume()
    }
    
   class func getArrayFromDictionary(dictionary:[String:Any]) -> [[String:Any]]{
        var arrayDictionay = [[String:Any]]()
        for (key,_) in dictionary {
            if let newDictionary = dictionary[key] as? [String:Any]{
                arrayDictionay.append(newDictionary)
            }
        }
        return arrayDictionay
    }
    
    /*************************************************************/
    
    
}
