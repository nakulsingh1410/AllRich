//
//  CardExpiryPickerView.swift
//  SkySell
//
//  Created by Nakul Singh on 3/21/18.
//  Copyright © 2018 DW02. All rights reserved.
//

import UIKit

class CardExpiryPickerView: UIView {

    @IBOutlet weak var monthYearPickerView: MonthYearPickerView!
   
    class func loadPickerView() -> CardExpiryPickerView? {
        //        let bundle = Bundle(for: CustomPickerView)
        let arrNib = Bundle.main.loadNibNamed("CardExpiryPickerView", owner: self, options: nil)
        if let pickerView = arrNib?.first as? CardExpiryPickerView {
            return pickerView
        }
        return nil
    }

    
    /*********************************************************************************/
    // MARK: IB_Action
    /*********************************************************************************/
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.removeFromSuperview()
    }
    @IBAction func btnDoneTapped(_ sender: Any) {
        
        self.removeFromSuperview()
    }
}
