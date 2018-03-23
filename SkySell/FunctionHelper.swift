//
//  FunctionHelper.swift
//  SkySell
//
//  Created by DW02 on 5/4/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

func heightForView(text:String,Font font:UIFont,Width width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame:CGRect(x:0, y:0, width:width, height:CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    
    label.sizeToFit()
    return label.frame.height
}

func widthForView(text:String,Font font:UIFont,Height height:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame:CGRect(x:0, y:0, width:CGFloat.greatestFiniteMagnitude, height:height))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    
    label.sizeToFit()
    return label.frame.width
}


func heightForView(attribute:NSAttributedString, Width width:CGFloat) -> CGFloat{
    
    let label:UILabel = UILabel(frame:CGRect(x:0, y:0, width:width, height:CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    
    label.attributedText = attribute
    label.sizeToFit()
    
    return label.frame.height
}



class FunctionHelper: NSObject {

}
