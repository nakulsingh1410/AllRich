//
//  PaymentViewController.swift
//  SkySell
//
//  Created by Nakul Singh on 3/20/18.
//  Copyright © 2018 DW02. All rights reserved.
//

import UIKit
import Stripe
import Firebase


class PaymentViewController: UIViewController {
    @IBOutlet weak var btnBack: UIButton!

    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var txtFCardHolderName: UITextField!
    @IBOutlet weak var txtFCardNumber: UITextField!
    @IBOutlet weak var txtFCalender: UITextField!
    @IBOutlet weak var txtFCVC: UITextField!
    @IBOutlet weak var txtFAmoutPaid: UITextField!
    @IBOutlet weak var btnPayAmount: UIButton!
    
    var myActivityView:ActivityLoadingView! = nil

    var cardToken = ""
    var userId = ""
    var email = ""
    var isTopup = false
    override func viewDidLoad() {
        super.viewDidLoad()

        btnSkip.layer.cornerRadius = 3.0
        btnSkip.clipsToBounds = true
        
        btnPayAmount.layer.cornerRadius = 3.0
        btnPayAmount.clipsToBounds = true
        
        txtFCardNumber.delegate = self
        txtFCVC.delegate = self
        
        
        if isTopup {
            btnBack.isHidden = false
            btnSkip.isHidden = true
        }else{
            btnBack.isHidden = true
            btnSkip.isHidden = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func openDatePicker(){
        if let picker = CardExpiryPickerView.loadPickerView(){
            picker.frame = view.frame
            picker.monthYearPickerView.onDateSelected = { (month: Int, year: Int) in
                let string = String(format: "%02d/%d", month, year)
                self.txtFCalender.text = string
            }
            view.addSubview(picker)
        }
    }
    
    
    func checkComplete(Complete complete:(Bool, String)->Void) {
        var isError:Bool = false
        var title:String = ""
        
        if let string = txtFCardHolderName.text ,string.count <= 0{
            isError = true
            title = "Please enter Card Holder Name."
        }else if let string = txtFCardNumber.text ,string.count <= 0{
            isError = true
            title = "Please enter Card Number."
        }
        else if let string = txtFCardNumber.text?.trimmingCharacters(in: .whitespaces) ,string.count < 16{
            isError = true
            title = "Please enter valid Card Number."
        }
        else if let string = txtFCalender.text ,string.count <= 0{
            isError = true
            title = "Please Select Month/Year"
        }else if let string = txtFCVC.text ,string.count <= 0{
            isError = true
            title = "Please enter CVC."
        }else if let string = txtFCVC.text,string.count < 3{
            isError = true
            title = "Please enter valid CVC."
        }else if let string = txtFAmoutPaid.text ,string.count <= 0{
            isError = true
            title = "Please enter amount Paid."
        }else if let string = txtFAmoutPaid.text , let amt = Int(string),amt < 1 {
            isError = true
            title = "Please enter amount more than 1."
        }
        
        complete(isError, title)
    }
    
    // MARK: - IBAction

    @IBAction func btnCardExpiryTapped(_ sender: Any) {
        view.endEditing(true)
        openDatePicker()
    }
    @IBAction func btnSkipTapped(_ sender: Any) {
        view.endEditing(true)

        skipPayment()
    }
    @IBAction func btnPayAmountTapped(_ sender: Any) {
        view.endEditing(true)

        self.checkComplete { (haveErroe, message) in
            if(haveErroe){
                let alertController = UIAlertController(title: "AllRich", message: message, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            }else{
                getCardToken()
            }
        }
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
}

/*********************************************************************************/
// MARK: UITextFieldDelegate
/*********************************************************************************/
extension PaymentViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtFCardNumber {
            guard let text = textField.text else { return true }
            let length = text.count + string.count - range.length
            if string.count > 0 ,isSpaceForCard(charecterCount: length){
                textField.text = text +  " "
            }
            return length <= 19
        }
        if textField == txtFCVC {
            guard let text = textField.text else { return true }
            let length = text.count + string.count - range.length
            
            return length <= 3
        }
        
        return true
    }
  
    func isSpaceForCard(charecterCount:Int) -> Bool {
        
        if charecterCount % 5 == 0 {
            return true
        }
        return false
        
    }
    
}


/*********************************************************************************/
// MARK: Stripe
/*********************************************************************************/
extension PaymentViewController{
    
    func getCardToken()  {
        Global.showHud()
        let card  = STPCardParams()
        card.number = txtFCardNumber.text
        card.cvc = txtFCVC.text
        card.name = txtFCardHolderName.text
        if let month = txtFCalender.text?.components(separatedBy: "/").first, let intMonth = Int(month){
            card.expMonth = UInt(intMonth)
        }
        if let year = txtFCalender.text?.components(separatedBy: "/").last, let intYear = Int(year){
            card.expYear = UInt(intYear)
        }
        STPAPIClient.shared().createToken(withCard: card, completion: { (catdToken, error) in
            if let token = catdToken{
                self.cardToken = token.tokenId
                self.processStripePayment()
            }else{
                Global.hideHud()
            }
        })
        
    }
}
/*********************************************************************************/
// MARK: API
/*********************************************************************************/
extension PaymentViewController{
    //processStripePayment API
    func processStripePayment()  {
        Global.showHud()
        
        let paymenttype =  (isTopup == true) ? "Top-Up" : "Inital"
        
        let parameters = ["email":email,
                          "amount":txtFAmoutPaid.text!,
                          "cardToken":cardToken,
                          "cardnumber":txtFCardNumber.text!.trimmingCharacters(in: .whitespaces),
                          "paymentType":paymenttype,
                          "cardHolderName":txtFCardHolderName.text!,
                          "userId":userId]

        guard let url = URL(string: "https://us-central1-newmybanknotes.cloudfunctions.net/processStripePayment") else { return }
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
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]{
                        print(json)
                        if  let status = json["status"] as? String, status  == "success" {
                            if self.isTopup {
                                NavigationManager.popWithAlert(navigationController:self.navigationController)
                            }else{
                                NavigationManager.moveToRoot(navigationController:self.navigationController)
                            }
                        }
                    }
                } catch {
                     Global.hideHud()
                    print(error)
                    Global.showAlert(navigationController: self.navigationController, message:"Payment is not successfully done!")
                }
            }
            
            }.resume()
        
    }

        //skipPayment
    func skipPayment()  {
        Global.showHud()
        let parameters = ["userId":userId]

        
        guard let url = URL(string: "https://us-central1-newmybanknotes.cloudfunctions.net/skipPayment") else { return }
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
                            NavigationManager.moveToRoot(navigationController:self.navigationController)
                        }else{
                            Global.showAlert(navigationController: self.navigationController, message:"Some error occured")
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
            
            }.resume()
        
    }
}



/*********************************************************************************/
// MARK: Loader Hide and Show
/*********************************************************************************/
extension PaymentViewController {
    
    func addActivityView(Finish finish:@escaping ()->Void){
        
        if(self.myActivityView == nil){
            myActivityView = ActivityLoadingView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
            myActivityView.alpha = 0
            self.view.addSubview(myActivityView)
            
            
            UIView.animate(withDuration: 0.25, animations: {
                self.myActivityView.alpha = 1
            }, completion: { (_) in
                
                finish()
            })
        }else{
            finish()
        }
    }
    
    func removeActivityView(Finish finish:@escaping ()->Void) {
        if(self.myActivityView != nil){
            UIView.animate(withDuration: 0.45, animations: {
                self.myActivityView.alpha = 0
            }, completion: { (_) in
                
                if(self.myActivityView != nil){
                    self.myActivityView.removeFromSuperview()
                    self.myActivityView = nil
                }
                finish()
            })
        }else{
            finish()
        }
    }
    
}
