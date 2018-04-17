//
//  CustomPickerView.swift
//  Hooga
//
//  Created by Nakul Singh on 1/28/18.
//  Copyright © 2018 Nakul Singh. All rights reserved.
//

import UIKit


enum PickerType:String {
    case membershipTypePicker = "membershipType"
    case accountTypePicker = "accountType"


    
}

protocol CustomPickerViewDelegate {
    
    func didSelectPickerValueAt(title:String,index:Int,pickerType:PickerType?)
    func dismissPickerView()
}

class CustomPickerView:UIView,UIPickerViewDelegate,UIPickerViewDataSource {
    
    /*********************************************************************************/
    // MARK: IB_Outlets
    /*********************************************************************************/
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var pickerDataSource = ["India", "Australia", "United   Kingdom", "South Africa"];
    var customPickerViewDelegate:CustomPickerViewDelegate?
    var pickerType :PickerType?
    override func awakeFromNib() {
        endEditing(true)

    }
    
    
    class func loadPickerView() -> CustomPickerView? {
        //        let bundle = Bundle(for: CustomPickerView)
        let arrNib = Bundle.main.loadNibNamed("CustomPickerView", owner: self, options: nil)
        if let pickerView = arrNib?.first as? CustomPickerView {
            return pickerView
        }
        return nil
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        endEditing(true)
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row < pickerDataSource.count{
            customPickerViewDelegate?.didSelectPickerValueAt(title: pickerDataSource[row], index: row,pickerType:pickerType)
        }
    }
    
    
    
    /*********************************************************************************/
    // MARK: IB_Action
    /*********************************************************************************/
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.removeFromSuperview()
    }
    @IBAction func btnDoneTapped(_ sender: Any) {
        if pickerDataSource.count > 0{
            let index = pickerView.selectedRow(inComponent: 0)
            let value = pickerDataSource[pickerView.selectedRow(inComponent: 0)]
            customPickerViewDelegate?.didSelectPickerValueAt(title: value, index: index,pickerType:pickerType)
        }
        self.removeFromSuperview()
    }
    
}
