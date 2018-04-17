//
//  SerialProductDataModel.swift
//  SkySell
//
//  Created by DW02 on 20/11/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class SerialProductDataModel: NSObject {

    
    var serial_Id:String = ""
    var serial_Title:String = ""
    var amount:NSInteger = 0
    
    var isSelect:Bool = false
    
    override init() {
        super.init()
    }
    
    convenience init(dictionary:NSDictionary){
        
        self.init()
        self.readJson(obj: dictionary)
    }
    
    
    
    
    
    func readJson(obj:NSDictionary) {
        
        if let serial_Id = obj.object(forKey: "serial_Id") as? String{
            self.serial_Id = serial_Id
        }
        
        if let serial_Title = obj.object(forKey: "serial_Title") as? String{
            self.serial_Title = serial_Title
        }
        
        
        if let amount = obj.object(forKey: "amount") as? NSInteger{
            self.amount = amount
        }
        
    }
    
}
