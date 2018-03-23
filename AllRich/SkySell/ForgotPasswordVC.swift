//
//  ForgotPasswordVC.swift
//  SkySell
//
//  Created by DW02 on 5/11/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth



class ForgotPasswordVC: UIViewController {

    
    enum CellName:NSInteger {
        case space1 = 0
        case title
        case space2
        case email
        case space3
        case button
        
        static let count = 6
        
    }
    
    
    
    
    @IBOutlet weak var btBack: UIButton!
    
    
    @IBOutlet weak var myTable: UITableView!
    
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    
    var strEmail:String = ""
    
    
    var haveNoti:Bool = false
    
    
    var myActivityView:ActivityLoadingView! = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.clipsToBounds = true
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        
        
        
        
        do{
            let nib:UINib = UINib(nibName: "TextFieldWithIconCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "TextFieldWithIconCell")
        }
        
        
        do{
            let nib:UINib = UINib(nibName: "EmptyCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "EmptyCell")
        }
     
    
        
        do{
            let nib:UINib = UINib(nibName: "ButtonCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "ButtonCell")
        }
        
        do{
            let nib:UINib = UINib(nibName: "DoubleRowTitleCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "DoubleRowTitleCell")
        }
        
        
        
        self.myTable.delegate = self
        self.myTable.dataSource = self
        
        
        
        self.view.bringSubview(toFront: self.btBack)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        if(self.haveNoti == false){
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
            
            self.haveNoti = true
        }
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if(self.haveNoti == true){
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
            self.haveNoti = false
        }
        
    }
    
        
        
      
        
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - Activity
    
    func addActivityView(Finish finish:@escaping ()->Void){
        
        if(self.myActivityView == nil){
            myActivityView = ActivityLoadingView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
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
    
    
    
    
    
    // MARK: - Action
    
    @IBAction func tapOnBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
        
        
    }
    
    
    
    func tapOnsubmit() {
        
        
        let index:IndexPath = IndexPath(row: CellName.email.rawValue, section: 0)
        if let cell = self.myTable.cellForRow(at: index) as? TextFieldWithIconCell{
            cell.tfInput.resignFirstResponder()
            self.strEmail = cell.tfInput.text!
        }
        
        
        
        
        
        
        
        if(self.strEmail.count <= 0){
            
            let alertController = UIAlertController(title: "email can't be empty", message: nil, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                
            }
            alertController.addAction(cancelAction)
            
            
            self.present(alertController, animated: true, completion: nil)
            
            
        }else{
            
            self.addActivityView {
                self.postResetPassword()
            }
        }
    }
    
    
    
    func postResetPassword() {
        
        
        // [START password_reset]
        FIRAuth.auth()?.sendPasswordReset(withEmail: strEmail) { (error) in
            // [START_EXCLUDE]
            
            
            self.removeActivityView {
                if let error = error {
                    self.showMessagePrompt(message: error.localizedDescription)
                    return
                }else{
                    
                    let alertController = UIAlertController(title: "Please check your email for password reset instructions.", message: nil, preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(cancelAction)
                    
                    
                    self.present(alertController, animated: true, completion: nil)
                }

                
            }
           
            // [END_EXCLUDE]
        }
        // [END password_reset]
        
        
        
    }
    
    
    func showMessagePrompt(message:String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK: - keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        
        /*
         if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
         
         let keyboardHeight = (screenSize.height - 67) - keyboardSize.height
         
         print("kH: \(keyboardHeight)")
         //self.myTable.setContentOffset(CGPoint(x: 0, y: keyboardHeight), animated: true)
         
         
         }*/
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        
    }
    
    
    
        
        
    
    
    
}



// MARK: - UITableViewDelegate, UITableViewDataSource
extension ForgotPasswordVC:UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
    }
    
    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //var numberOfCell:NSInteger = 0
        
        
        return CellName.count
    }
    
    // MARK: - Cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        var cellHeight:CGFloat = 8
        
        
        
        if(indexPath.row == CellName.space1.rawValue){
            cellHeight = 80
        }else if(indexPath.row == CellName.title.rawValue){
            cellHeight = 100
        }else if(indexPath.row == CellName.space2.rawValue){
            cellHeight = 8
        }else if(indexPath.row == CellName.email.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.space3.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.email.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.button.rawValue){
            cellHeight = 45
        }
        
        
        
        
        
        
        return cellHeight
    }
    
    /*
     // MARK: - Header height
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     
     var cellHeight:CGFloat = 30
     
     return cellHeight
     
     }
     
     // MARK: - Header cell
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
     let cell:LabelHeaderCell? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LabelHeaderCell") as? LabelHeaderCell
     
     return cell
     }*/
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        if((indexPath.row == CellName.space1.rawValue) || (indexPath.row == CellName.space2.rawValue) || (indexPath.row == CellName.space3.rawValue)){
            let cell:EmptyCell? = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as? EmptyCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true

            
            
            return cell!
        }else if(indexPath.row == CellName.title.rawValue){
            let cell:DoubleRowTitleCell? = tableView.dequeueReusableCell(withIdentifier: "DoubleRowTitleCell", for: indexPath) as? DoubleRowTitleCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            
            /*
            cell?.tfInput.tag = indexPath.row
            cell?.tfInput.placeholder = "Company Name"
            cell?.tfInput.delegate = self
            cell?.tfInput.text = self.strCompanyName
            cell?.tfInput.isSecureTextEntry = false
            
            
            cell?.imageIcon.image = UIImage(named: "iconProfileNonactive.png")*/
            
            return cell!
        }else if(indexPath.row == CellName.email.rawValue){
            
            let cell:TextFieldWithIconCell? = tableView.dequeueReusableCell(withIdentifier: "TextFieldWithIconCell", for: indexPath) as? TextFieldWithIconCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            cell?.tfInput.tag = indexPath.row
            cell?.tfInput.placeholder = "Email address"
            cell?.tfInput.delegate = self
            cell?.tfInput.text = strEmail
            cell?.tfInput.isSecureTextEntry = false
            cell?.tfInput.keyboardType = .emailAddress
            
            cell?.imageIcon.image = UIImage(named: "mail.png")
            
            
            
            return cell!
            
        }else if(indexPath.row == CellName.button.rawValue){
            let cell:ButtonCell? = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as? ButtonCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
    
            cell?.myButton.setTitle("Reset Password", for: UIControlState.normal)
            
            cell?.callBack = { () in
                self.tapOnsubmit()
            }
            
            return cell!
        }
        
        
        
        let cell:EmptyCell? = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as? EmptyCell
        cell?.selectionStyle = .none
        cell?.clipsToBounds = true
        cell?.tag = indexPath.row
        
        
        
        
        return cell!
        
    }
    
    // MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
        
        
        
        
        self.myTable.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        
        //print(scrollView.contentOffset.y)
        
    }
}



// MARK: - UITableViewDelegate, UITableViewDataSource
extension ForgotPasswordVC:UITextFieldDelegate{
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(self.screenSize.height <= 568){
            
            if(textField.tag == CellName.email.rawValue){
                
                
                self.myTable.setContentOffset(CGPoint(x: 0, y: 80), animated: true)
                
            }
            
        }
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.tag == CellName.email.rawValue){
            
            
            self.strEmail = textField.text!
            
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if(textField.tag == CellName.email.rawValue){
            
            
            self.strEmail = textField.text!
            
        }
        
        
        
        self.myTable.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        return true
    }
    
    
    
    
    
    
}




