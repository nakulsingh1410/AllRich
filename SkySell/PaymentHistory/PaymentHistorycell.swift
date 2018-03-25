//
//  PaymentHistorycell.swift
//  SkySell
//
//  Created by Nakul Singh on 3/25/18.
//  Copyright © 2018 DW02. All rights reserved.
//

import UIKit

class PaymentHistorycell: UITableViewCell {

    @IBOutlet weak var lbltransactionNo: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblPaymentDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func loadCellData(dict:[String:Any])  {
        lbltransactionNo.text = ""
        lblPaymentType.text = ""
        lblPayment.text = ""
        lblPaymentDate.text = ""
        
        if let string = dict["charge.balance_transaction"] as? String{
            lbltransactionNo.text = string
        }
        if let string = dict["paymentType"] as? String{
            lblPaymentType.text = string
        }
        if let string = dict["amount"] as? Int{
            lblPayment.text = "SGD \(string)"
        }
        if let string = dict["charge.balance_transaction"] as? String{
            lblPaymentDate.text = string
        }
    }
}
