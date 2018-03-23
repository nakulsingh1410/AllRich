//
//  TextMessageInputVC.swift
//  DemoHome
//
//  Created by supapon pucknavin on 1/15/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class TextMessageInputVC: UIViewController {

    @IBOutlet weak var viTopBar: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var btSave: UIButton!
    @IBOutlet weak var btCancel: UIButton!
    
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    var strTitle:String = "Description"
    
    @IBOutlet weak var tvInput: UITextView!
    
    @IBOutlet weak var layout_TvInput_Bottom: NSLayoutConstraint!
    
    var strMessage:String = ""
    

    var callBack:(String)->Void = {(message) in }
    
    
    var haveNoti:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
        self.viTopBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viTopBar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.viTopBar.layer.shadowOpacity = 0.05
        self.viTopBar.layer.shadowRadius = 1
        
        self.viTopBar.clipsToBounds = false
        
        self.view.bringSubview(toFront: self.viTopBar)
        
        self.lbTitle.text = strTitle
        
        self.tvInput.text = strMessage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if(self.haveNoti == false){
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillHide, object: nil)
            
            self.haveNoti = true
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        if(self.tvInput.text.count == 0){
            self.tvInput.becomeFirstResponder()
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

    
    // MARK: - Action
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height + 80
            
            
            self.layout_TvInput_Bottom.constant = keyboardHeight
            
            UIView.animate(withDuration: 0.25, animations: { 
                self.view.layoutIfNeeded()
                self.view.updateConstraints()
            })
            print(keyboardHeight)
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        
        self.layout_TvInput_Bottom.constant = 0.0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
            self.view.updateConstraints()
        })
    }
    
    
    
    
    @IBAction func tapOnCancel(_ sender: UIButton) {
        self.tvInput.resignFirstResponder()
        
        let alertController = UIAlertController(title: "Are you sure you want to leave this page?", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Stay on Page", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        
        let okAction = UIAlertAction(title: "Leave Page", style: .default) { (action) in
            
            //var save:Bool = true
            
            if let navigation = self.navigationController{
                navigation.popToRootViewController(animated: true)
            }else{
                self.dismiss(animated: true, completion: {
                    
                })
            }
            
        }
        alertController.addAction(okAction)
        
        
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func tapOnSave(_ sender: UIButton) {
        
        self.tvInput.resignFirstResponder()
        
        
        
        self.callBack(self.tvInput.text)
        
        if let navigation = self.navigationController{
            navigation.popToRootViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: {
                
            })
        }
        
    }
    
}



extension TextMessageInputVC:UITextViewDelegate{
    
    
    
}
