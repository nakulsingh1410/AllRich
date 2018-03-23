//
//  Constarints.swift
//  MedStaff
//
//  Created by ds on 06/10/17.
//  Copyright © 2017 Dotsquares. All rights reserved.
//

import UIKit

class Constarints: NSObject {
    class func setConstraint(_ item:AnyObject?,attribute:NSLayoutAttribute,relatedBy:NSLayoutRelation,toItem:AnyObject?,attributeSecond:NSLayoutAttribute,multiplier:CGFloat,constant:CGFloat,vcMain:AnyObject?)
    {
        
                     let any:NSLayoutConstraint = NSLayoutConstraint(item: item!, attribute: attribute, relatedBy: relatedBy, toItem: toItem, attribute:attributeSecond, multiplier: multiplier, constant:constant);
                     vcMain?.addConstraint(any);
    }
    
    
    class func returnConstraint(_ item:AnyObject?,attribute:NSLayoutAttribute,relatedBy:NSLayoutRelation,toItem:AnyObject?,attributeSecond:NSLayoutAttribute,multiplier:CGFloat,constant:CGFloat,vcMain:AnyObject?)->NSLayoutConstraint
    {
        
        let any:NSLayoutConstraint = NSLayoutConstraint(item: item!, attribute: attribute, relatedBy: relatedBy, toItem: toItem, attribute:attributeSecond, multiplier: multiplier, constant:constant);
        vcMain?.addConstraint(any);
        return any;
    }
    
    
    
}
