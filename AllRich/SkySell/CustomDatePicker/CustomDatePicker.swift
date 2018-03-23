//
//  CustomDatePicker.swift
//  Hooga
//
//  Created by Nakul Singh on 1/28/18.
//  Copyright © 2018 Nakul Singh. All rights reserved.
//

import UIKit


protocol CustomDatePickerDelegate {
    
    func didSelectDate(dob:String)

}

class CustomDatePicker: UIView {

    /*********************************************************************************/
    // MARK: IB_Outlets
    /*********************************************************************************/
    
    @IBOutlet weak var datePickerView: UIDatePicker!

    var customDatePickerDelegate:CustomDatePickerDelegate?
    
    override func awakeFromNib() {
        datePickerView.datePickerMode = .date
        //datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())

    }
    
    class func loadDatePickerView() -> CustomDatePicker? {
        //        let bundle = Bundle(for: CustomPickerView)
        let arrNib = Bundle.main.loadNibNamed("CustomDatePicker", owner: self, options: nil)
        if let pickerView = arrNib?.first as? CustomDatePicker {
            return pickerView
        }
        
        return nil
    }
    
    func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: datePickerView.date)
         customDatePickerDelegate?.didSelectDate(dob: dateString)
    }

    
    /*********************************************************************************/
    // MARK: IB_Action
    /*********************************************************************************/
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.removeFromSuperview()
    }
    @IBAction func btnDoneTapped(_ sender: Any) {
        doneDatePicker()
        self.removeFromSuperview()
    }
    
}
