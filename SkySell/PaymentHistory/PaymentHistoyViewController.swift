//
//  PaymentHistoyViewController.swift
//  SkySell
//
//  Created by Nakul Singh on 3/25/18.
//  Copyright © 2018 DW02. All rights reserved.
//

import UIKit

class PaymentHistoyViewController: UIViewController {

    @IBOutlet weak var tableViewPaymentHistory: UITableView!
    var arrPayemnt = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       let nib = UINib(nibName: "PaymentHistorycell", bundle: nil)
        tableViewPaymentHistory.register(nib, forCellReuseIdentifier: "PaymentHistorycell")
        
        tableViewPaymentHistory.rowHeight = UITableViewAutomaticDimension
        tableViewPaymentHistory.estimatedRowHeight = 44.0
        tableViewPaymentHistory.tableFooterView = UIView()
        tableViewPaymentHistory.separatorColor = .clear
        paymentHistory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - IBAction

    @IBAction func btnBackTapped(_ sender: Any) {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - UITableViewDataSource
extension PaymentHistoyViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPayemnt.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentHistorycell") as? PaymentHistorycell {
            cell.loadCellData(dict: arrPayemnt[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
}
// MARK: - API
extension PaymentHistoyViewController{

    func paymentHistory(){
        
        WebServiceModel.getPaymentHistory { (arrPaymentData) in
            if let array = arrPaymentData {
                self.arrPayemnt = array
            }
            DispatchQueue.main.async {
                self.tableViewPaymentHistory.reloadData()
            }
        }
    }

}
