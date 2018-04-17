//
//  WebServiceModel.swift
//  SkySell
//
//  Created by Nakul Singh on 3/23/18.
//  Copyright © 2018 DW02. All rights reserved.
//

import UIKit
import ObjectMapper
class WebServiceModel: NSObject {

    /*************************************************************/
    class func isPremiunMember(callback:@escaping (Bool)-> Void) {
            //Global.showHud()
            let uid = ShareData.sharedInstance.loadsaveUserInfo_UID()
        
            if uid.count < 1 {return}
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
                    print("Params =\(parameters)\n \(response.url)")
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
        if uid.count < 1 {return}
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
                     Global.hideHud()
                } catch {
                    print(error)
                     Global.hideHud()
                }
            }
             Global.hideHud()
            }.resume()
    }
    
    class func getArrayFromDictionary(dictionary:[String:Any]) -> [[String:Any]]{
        var arrayDictionay = [[String:Any]]()
        for (key,_) in dictionary {
            if let newDictionary = dictionary[key] as? [String:Any]{
                arrayDictionay.append(newDictionary)
            }
        }
        
        arrayDictionay = arrayDictionay.sorted { (dict1, dict2 ) -> Bool in
            if let dictObj1 = dict1["charge"] as? [String:Any],let dictObj2 = dict2["charge"] as? [String:Any] {
                if let timeStamp1 = dictObj1["created"] as? Int,let timeStamp2 = dictObj2["created"] as? Int{
                    return timeStamp1 > timeStamp2
                }
            }
            return false
        }
        
        return arrayDictionay
    }
    
    /*************************************************************/
    //MARK: FriendRequest APIS
    /*************************************************************/
    class func getUsersList(callback:@escaping ( FrindList?)-> Void) {
        Global.showHud()
        let uid = ShareData.sharedInstance.loadsaveUserInfo_UID()
        let parameters = ["userId":uid]
        
        guard let url = URL(string: "https://us-central1-newmybanknotes.cloudfunctions.net/getUsersList") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print("Params =\(parameters)\n \(response.url)")
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                        print(json)
                        if  let dataDict = json["usersList"] as? [String:Any] {
//                            let array = Mapper<FrindList>().mapArray(JSONArray:arrObj)
                            let friendList =  Mapper<FrindList>().map(JSON: dataDict)
                            callback(friendList);
                        }else{
                            callback(nil)
                        }
                    }
                    Global.hideHud()
                } catch {
                    print(error)
                    Global.hideHud()
                }
            }
            Global.hideHud()
            }.resume()
    }
    /*************************************************************/
    class func acceptedFriendList(callback:@escaping ( [FriendListModel]?)-> Void) {
        Global.showHud()
        let uid = ShareData.sharedInstance.loadsaveUserInfo_UID()
        let parameters = ["userId":uid]
        
        guard let url = URL(string: "https://us-central1-newmybanknotes.cloudfunctions.net/acceptedFriendList") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print("Params =\(parameters)\n \(response.url)")
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                        print(json)
                        if  let obj = json["friends"] as? [[String:Any]] {
                            //                            let array = Mapper<FrindList>().mapArray(JSONArray:arrObj)
                            let friendList =  Mapper<FriendListModel>().mapArray(JSONArray: obj)
                            callback(friendList);
                        }else{
                            callback(nil)
                        }
                    }
                    Global.hideHud()
                } catch {
                    print(error)
                    Global.hideHud()
                }
            }
            Global.hideHud()
            }.resume()
    }
    
    /*************************************************************/
    class func pendingFriendList(callback:@escaping ( [FriendListModel]?)-> Void) {
        Global.showHud()
        let uid = ShareData.sharedInstance.loadsaveUserInfo_UID()
        let parameters = ["userId":uid]
        
        guard let url = URL(string: "https://us-central1-newmybanknotes.cloudfunctions.net/pendingFriendList") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print("Params =\(parameters)\n \(response.url)")
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                        print(json)
                        if  let obj = json["friends"] as? [[String:Any]] {
                            //                            let array = Mapper<FrindList>().mapArray(JSONArray:arrObj)
                            let friendList =  Mapper<FriendListModel>().mapArray(JSONArray: obj)
                            callback(friendList);
                        }else{
                            callback(nil)
                        }
                    }
                    Global.hideHud()
                } catch {
                    print(error)
                    Global.hideHud()
                }
            }
            Global.hideHud()
            }.resume()
    }
    
    /*************************************************************/
    class func createFriendRequest(selectedUser:String,callback:@escaping ( String?)-> Void) {
        Global.showHud()
        let uid = ShareData.sharedInstance.loadsaveUserInfo_UID()
        let parameters = ["userId":uid,
                          "selectedUser":selectedUser]
        
        guard let url = URL(string: "https://us-central1-newmybanknotes.cloudfunctions.net/createFriendRequest") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print("Params =\(parameters)\n \(response.url)")
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                        print(json)
                        if  let obj = json["msg"] as? String {
                            callback(obj);
                        }else{
                            callback(nil)
                        }
                    }
                    Global.hideHud()
                } catch {
                    print(error)
                    Global.hideHud()
                }
            }
            Global.hideHud()
            }.resume()
    }
    
    /*************************************************************/
    class func responseOfFriendRequest(selectedUser:String,requestStatus:String,callback:@escaping ( Bool?)-> Void) {
        Global.showHud()
        let uid = ShareData.sharedInstance.loadsaveUserInfo_UID()
        let parameters = ["requestUserId":uid,
                          "responseUserId":selectedUser,
                          "requestStatus":requestStatus]
        
        
        
        guard let url = URL(string: "https://us-central1-newmybanknotes.cloudfunctions.net/responseOfFriendRequest") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print("Params =\(parameters)\n \(response.url)")
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                        print(json)
                        if  let obj = json["status"] as? String , obj == "success" {
                            callback(true);
                        }else{
                            callback(nil)
                        }
                    }
                    Global.hideHud()
                } catch {
                    print(error)
                    Global.hideHud()
                }
            }
            Global.hideHud()
            }.resume()
    }
    //
    /*************************************************************/
    class func getPostsByCategoryId(categoryId:String,callback:@escaping ( [RealmProductDataModel]?)-> Void) {
        Global.showHud()
        let uid = ShareData.sharedInstance.loadsaveUserInfo_UID()
        let parameters = ["userId":uid,
                          "categoryId":categoryId]

        
        
        guard let url = URL(string: "https://us-central1-newmybanknotes.cloudfunctions.net/getPostsByCategoryId") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print("Params =\(parameters)\n \(response.url)")
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                        print(json)
                       let array = getRealmProductDataModelArrayFromDictionary(dictionary: json)
                        callback(array);
                    }
                    Global.hideHud()
                } catch {
                    print(error)
                    Global.hideHud()
                    callback(nil);

                }
            }
            Global.hideHud()
            }.resume()
    }
    
    class func getRealmProductDataModelArrayFromDictionary(dictionary:[String:Any]) ->[RealmProductDataModel]{
        var arrProductList = [RealmProductDataModel]()
        for (key,_) in dictionary {
            if let newDictionary = dictionary[key] as? [String:Any]{
//                arrayDictionay.append(newDictionary)
                let model = RealmProductDataModel()
                model.readJson(obj: newDictionary as NSDictionary)
                arrProductList.append(model)
            }
        }
        
      arrProductList =  arrProductList.sorted(by: {$0.points > $1.points})
    return arrProductList
    }
    
    
    /********************************************************/
    
}






