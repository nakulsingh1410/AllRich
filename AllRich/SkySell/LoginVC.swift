//
//  LoginVC.swift
//  SkySell
//
//  Created by DW02 on 5/2/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn


class LoginVC: UIViewController {

    
    
    enum CellName:NSInteger{
        case facebookGoogle = 0
        case line
        case email
        case space
        case password
        case space2
        case loginBotton
        case space3
        case forgot
        
        static let count = 9
    }
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    
    @IBOutlet weak var viTopBar: UIView!
    
    @IBOutlet weak var layout_TopbarHeight: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var viSignUpBG: UIView!
    
    @IBOutlet weak var layout_BottomSignUpBG: NSLayoutConstraint!
    
    
    
    
    
    @IBOutlet weak var myTable: UITableView!
    
    @IBOutlet weak var btSignup: UIButton!
    
    
    @IBOutlet weak var lbTitle: UILabel!
    
    
    @IBOutlet weak var btClose: UIButton!
    
    var strEmail:String = ""
    var strPassword:String = ""
    
    
    
    var haveNoti:Bool = false
    
    
    var myActivityView:ActivityLoadingView! = nil
    
    var working:Bool = false
    
    
    
    var user_uid:String = ""
    
    var user_FirstName:String = ""
    var user_LastName:String = ""
    var user_Email:String = ""
    var user_ImageProfile:String = ""
    
    
    var loginSuccess:Bool = false
    var updateUserDataSuccess:Bool = false
    
    
    let myData:ShareData = ShareData.sharedInstance
    
    
    var forceLogin:Bool = true
    
    var bufferLastTextField:UITextField? = nil
    
    @IBOutlet weak var imageLogo: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        self.imageLogo.clipsToBounds = true
        self.imageLogo.layer.cornerRadius = 11
        
        
        self.myTable.contentInset = UIEdgeInsets(top: 122, left: 0, bottom: 80, right: 0)
        
        self.myTable.delegate = self
        self.myTable.dataSource = self
        
        self.viTopBar.backgroundColor = UIColor.white
        self.viTopBar.isUserInteractionEnabled = false
        
        
        self.viTopBar.layer.shadowColor = UIColor.white.cgColor//UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viTopBar.layer.shadowRadius = 1
        self.viTopBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viTopBar.layer.shadowOpacity = 0.0
        self.viTopBar.backgroundColor = UIColor.clear
        
        
        
       
        
        
        self.viSignUpBG.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viSignUpBG.layer.shadowRadius = 1
        self.viSignUpBG.layer.shadowOffset = CGSize(width: 0, height: -1)
        self.viSignUpBG.layer.shadowOpacity = 0.5
        //self.viSignUpBG.backgroundColor = UIColor.clear
        
        
        
        self.strEmail = self.myData.loadsaveUserEmail()
        self.strPassword = self.myData.loadsaveUserPassword()
        
        
        
        
        self.view.bringSubview(toFront: viTopBar)
        
        
   
        self.view.bringSubview(toFront: btClose)
        
        
        
        
        if(self.myData.userInfo != nil){
            if(self.myData.userInfo.uid.count > 5){
                self.showTapBar(show: true)
                
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
                let vc:UserMainSceneVC = storyboard.instantiateViewController(withIdentifier: "UserMainSceneVC") as! UserMainSceneVC
                
                self.navigationController?.pushViewController(vc, animated: false)
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(self.myData.userInfo == nil){
            forceLogin = true
        }
        
        if(self.haveNoti == false){
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
            
            self.haveNoti = true
        }
        
        
        
        if(forceLogin == false){
            if(FIRAuth.auth()?.currentUser != nil){
                
                self.btClose.isEnabled = true
                self.btClose.alpha = 1
                
            }else{
                self.btClose.isEnabled = false
                self.btClose.alpha = 0
            }
        }else{
            self.btClose.isEnabled = false
            self.btClose.alpha = 0
        }
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.showTapBar(show: false)
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
    
    
    
    // MARK: - Healper
    func showTapBar(show:Bool) {
        var object:[String:Bool] = [String:Bool]()
        object["show"] = show
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HidenMainTapBar.rawValue), object: nil, userInfo: object)
        
        
    }
    
    
    // MARK: - Action
    
    @IBAction func tapOnClose(_ sender: UIButton) {
        
        self.showTapBar(show: true)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SkySell_Notification_Name.HomeVCGotoLastMode.rawValue), object: nil, userInfo: nil)
        
    }
    
    
    
    @IBAction func tapOnSignup(_ sender: UIButton) {
        
        
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:CreateAccount = storyboard.instantiateViewController(withIdentifier: "CreateAccount") as! CreateAccount
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        
        
        
    }
    
    
    
    
    func loginWithFacebook() {
        
        self.addActivityView {
            self.facebookLogin()
        }
    }
    
    
    func loginWithGoogle() {
        
        
        self.addActivityView {
            
            //print("\(FIRApp.defaultApp()?.options.clientID)")
            GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
            
        }
        
    }
    
    
    func loginWithEmail() {
        
        var canLogin:Bool = true
        var errorTitle:String = ""
        
        
        let nssEmail:NSString = NSString(format: "%@", self.strEmail)
        let atRange:NSRange = nssEmail.range(of: "@")
        
        
        
        
        if((self.strEmail.count < 3) || (atRange.length <= 0)){
            errorTitle = "Your email address is invalid, please try again"
            canLogin = false
        }else if(self.strPassword.count < 3){
            errorTitle = "Please enter your password"
            canLogin = false
        }
        
        
        if(canLogin == false){

            
            let alertController = UIAlertController(title: errorTitle, message: nil, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
              
            }
            alertController.addAction(cancelAction)
            
            
            self.present(alertController, animated: true, completion: nil)
        }else{
            
            
            
            
            
            
            
            self.addActivityView {
                
                
                // [START headless_email_auth]
                FIRAuth.auth()?.signIn(withEmail: self.strEmail, password: self.strPassword) { (user, error) in
                    // [START_EXCLUDE]
                    self.removeActivityView {
                        
                        
                        if let error = error {
                            
                            
                            let alertController = UIAlertController(title: "Can't Login", message: error.localizedDescription, preferredStyle: .alert)
                            
                            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                                
                            }
                            alertController.addAction(cancelAction)
                            
                            
                            self.present(alertController, animated: true, completion: nil)
                            
                            return
                        }else{
                            
                            
                            
                            if let user = user{
                                if (user.isEmailVerified == false){
                                    let alertVC = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \(self.strEmail).", preferredStyle: .alert)
                                    let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                                        (_) in
                                        
                                        print(FIRAuth.auth()?.currentUser?.email)
                                        FIRAuth.auth()?.currentUser?.sendEmailVerification { (error) in
                                            // ...
                                            
                                            print(error)
                                        }
                                    }
                                    let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                                    
                                    alertVC.addAction(alertActionOkay)
                                    alertVC.addAction(alertActionCancel)
                                    self.present(alertVC, animated: true, completion: nil)
                                } else {
                                    print ("Email verified. Signing in...")
                                    
                                    self.user_uid = user.uid
                                    
                                    self.loginSuccess = true
                                    
                                    
                                    self.myData.saveUserEmail(UID: self.strEmail)
                                    self.myData.saveUserPassword(UID: self.strPassword)
                                    
                                    loadProductLikeByUser(uid: self.user_uid, Finish: { (arLike) in
                                        
                                        self.myData.userLike = arLike
                                        self.getUserDatainfo()
                                        
                                    })
                                    
                                }
                            }
                            
                            
                            
                            
                           
                            
                            
                            
                        }
                    }
                    // [END_EXCLUDE]
                }
                // [END headless_email_auth]
                
                
                
                
            }
            
        }
        
        
        
        
        
    }
    
    func forgotPassword() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:ForgotPasswordVC = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        
        
        
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
    
    
    
    
    func facebookLogin() {
        let fbLoginManager = FBSDKLoginManager()
        
        if let currentAccessToken = FBSDKAccessToken.current(), currentAccessToken.appID != FBSDKSettings.appID()
        {
            fbLoginManager.logOut()
        }
        
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                
                
                self.removeActivityView {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: "Failed to login: \(error.localizedDescription)", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                }
                
                
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                
                self.removeActivityView {
                    
                    let alertController = UIAlertController(title: "Login Error", message: "Failed to get access token", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                }
                
                return
            }
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            
            
           
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    
                    self.removeActivityView {
                        print("Login error: \(error.localizedDescription)")
                        let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(okayAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                    }
                    
                    
                }else{
                    
                    
                    self.loginSuccess = true
                    //self.updateFacebookUserData()
                    if let user = user{
                        self.user_uid = user.uid
                        
                        
                        self.checkReadyUser(readyHave: { (have) in
                            if(have == true){
                                loadProductLikeByUser(uid: self.user_uid, Finish: { (arLike) in
                                    
                                    self.myData.userLike = arLike
                                    self.getUserDatainfo()
                                    
                                })
                            }else{
                                ShareData.sharedInstance.startUpdateDashboardRegisterData()
                                self.updateFacebookUserData()
                            }
                        })
                        
                        
                    }else{
                        loadProductLikeByUser(uid: self.user_uid, Finish: { (arLike) in
                            
                            self.myData.userLike = arLike
                            self.getUserDatainfo()
                            
                        })
                    }
                    
                    
                   
                    
                }
                
                

                
                
                
            })
            
            
        }   
    }
    
    
    
    func checkReadyUser(readyHave:@escaping (Bool)->Void) {
        
        let postRef = FIRDatabase.database().reference().child("users")
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary{
                
                let arAllKey:[String] = value.allKeys as! [String]
                var have:Bool = false
                
                for k in arAllKey{
                    if(self.user_uid == k){
                        have = true
                        break
                    }
                }
                
                
                readyHave(have)
                
            }
            
            
        })
        
        
    }
    
    
    
    
    func updateFacebookUserData() {
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //self.dict = result as! [String : AnyObject]
                    print(result!)
                    //print(self.dict)
                    
                    
                    if let result = result as? [String:Any]{
                        
                        if let email = result["email"] as? String{
                            self.user_Email = email
                        }
                        
                        if let first_name = result["first_name"] as? String{
                            self.user_FirstName = first_name
                        }
                        
                        if let last_name = result["last_name"] as? String{
                            self.user_LastName = last_name
                        }
                        
                        if let picture = result["picture"] as? [String:Any]{
                            if let data = picture["data"] as? [String:Any]{
                                if let url = data["url"] as? String{
                                    self.user_ImageProfile = url
                                }
                            }
                        }
                        
                        
                        self.postUserInfoToServer()
                    }else{
                        self.removeActivityView {
                            
                            
                            let alertController = UIAlertController(title: "Login Error", message: "Can't get personal user data", preferredStyle: .alert)
                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(okayAction)
                            self.present(alertController, animated: true, completion: nil)
                            
                        }
                    }
                }else{
                    
                    self.removeActivityView {
                        
                        print("Login error: \(String(describing: error?.localizedDescription))")
                        let alertController = UIAlertController(title: "Login Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(okayAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                    
                    
                   
                }
                
               
                
                
            })
        }
    }
    
    
    
    func getserverCurrency(complete:@escaping (String)->Void) {
        
        let fRef = FIRDatabase.database().reference().child("setting").child("server_currency_Notchange")
        
        fRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            
            
            if let value = snapshot.value as? String{
                
                
                
                complete(value)
                
                
                
            }else{
                complete("")
            }
            
            
            
            
        }) { (error) in
            complete("")
        }
        
    }
    
    
    
    
    func postUserInfoToServer() {
        
        self.getserverCurrency { (currency) in
            
            var strCurrency:String = "SGD"
            if(currency.count > 0){
                strCurrency = currency
            }
            
            
            
            
            let dateFormatFull:DateFormatter = DateFormatter()
            dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            
            let strDate:String = dateFormatFull.string(from: Date())
            
            //let locale = Locale.current
            //let currencyCode = locale.currencyCode?.uppercased()
            let profileImage:[String:String] = ["name":"",
                                                "path":"",
                                                "src":self.user_ImageProfile]
            
            let postUserData:[String:Any] = ["bio":"",
                                             "company_name":"",
                                             "company_website":"",
                                             "created_at":strDate,
                                             "created_at_server_timestamp":FIRServerValue.timestamp(),
                                             "currency":strCurrency,
                                             "email": self.user_Email,
                                             "first_name": self.user_FirstName,
                                             "isActive": true,
                                             "isSignUp": true,
                                             "last_name": self.user_LastName,
                                             "password": "",
                                             "phone": "",
                                             "profile_img_data":profileImage,
                                             "profile_img":self.user_ImageProfile,
                                             "status":"Active",
                                             "uid":self.user_uid,
                                             "updated_at":strDate,
                                             "updated_at_server_timestamp":FIRServerValue.timestamp(),
                                             "user_type":"Regular"
            ]
            
            
            
            
            let postRef = FIRDatabase.database().reference().child("users").child(self.user_uid)
            
            postRef.updateChildValues(postUserData) { (error, ref) in
                
                if let error = error {
                    self.removeActivityView {
                        
                        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                            
                        }
                        alertController.addAction(cancelAction)
                        
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                        
                    }
                }else{
                    
                    
                    loadProductLikeByUser(uid: self.user_uid, Finish: { (arLike) in
                        
                        self.myData.userLike = arLike
                        self.getUserDatainfo()
                        
                    })
                    
                }
            }
            
            
            
            
            
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    func getUserDatainfo() {
        self.myData.haveLogout = false
        
        
        let postRef = FIRDatabase.database().reference().child("users").child(self.user_uid)
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary{
                
                
                self.myData.userInfo = UserDataModel(dictionary: value)
                
                self.myData.saveUserInfo(UID: self.myData.userInfo.uid)
                
                //print(self.myData.userInfo.first_name)
                
                
              
            }
            
            
            
            
            
            if(SettingData.sharedInstance.haveConnect == false){
                SettingData.sharedInstance.startConnect()
            }
            
            if(self.myData.productDownloading == .noData){
                self.myData.productDownloading = .loading
                self.myData.loadAllProduct({
                    self.myData.productDownloading = .finish
                    
                    
                })
            }
            
            getAllPlans(Finish: { (plans, secret) in
                self.myData.bufferAllPlans = plans
                self.myData.buuferItuneSecret = secret
                StoreManager.shared.setup()
                
                
                self.finishLogin()
            })
            
            
        })
        
        
        
    }
    
    
    func finishLogin(){
        
        
        
        if(self.myData.userInfo.status.lowercased() == "ban"){
            self.myData.userInfo = nil
            
            self.myData.saveUserInfo(UID: "")
            
            self.removeActivityView {
                
                let alertController = UIAlertController(title: "Account Banned", message: "Your user account has been banned from MyBankNotes.\nPlease contact administrator for infomation.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    //self.navigationController?.popViewController(animated: true)
                    
                 
                    
                    
                    //
                }
                alertController.addAction(cancelAction)
                
                
                self.present(alertController, animated: true, completion: nil)
                
                
                
            }
            
        }else{
            let setting:SettingData = SettingData()
            setting.startConnect()
            
            if(self.myData.userInfo != nil){
                FIRMessaging.messaging().subscribe(toTopic: self.myData.userInfo.uid)
            }
            
            self.removeActivityView {
                
                let alertController = UIAlertController(title: "SUCCESS!!", message: nil, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    //self.navigationController?.popViewController(animated: true)
                    
                    self.gotoUserMainScene()
                    
                    
                    //
                }
                alertController.addAction(cancelAction)
                
                
                self.present(alertController, animated: true, completion: nil)
                
                
                
            }
        }
        
        
        
        
        
    }
    
    
    
    func gotoUserMainScene(){
        self.showTapBar(show: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let vc:UserMainSceneVC = storyboard.instantiateViewController(withIdentifier: "UserMainSceneVC") as! UserMainSceneVC
        
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension LoginVC:UITableViewDelegate, UITableViewDataSource{
    
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
        
        
        var cellHeight:CGFloat = 60
        
        
        
        if(indexPath.row == CellName.facebookGoogle.rawValue){
            cellHeight = 61
        }else if(indexPath.row == CellName.line.rawValue){
            cellHeight = 60
        }else if(indexPath.row == CellName.email.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.space.rawValue){
            cellHeight = 8
        }else if(indexPath.row == CellName.password.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.space2.rawValue){
            cellHeight = 25
        }else if(indexPath.row == CellName.loginBotton.rawValue){
            cellHeight = 40
        }else if(indexPath.row == CellName.space3.rawValue){
            cellHeight = 8
        }else if(indexPath.row == CellName.forgot.rawValue){
            cellHeight = 50
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
        

        if(indexPath.row == CellName.facebookGoogle.rawValue){
            
            
            let cell:FacebookGoogleCell? = tableView.dequeueReusableCell(withIdentifier: "FacebookGoogleCell", for: indexPath) as? FacebookGoogleCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            
            cell?.handleCallBack = {(tag) in
            
                if(tag == 0){
                    //facebook
                    self.loginWithFacebook()
                    
                }else if(tag == 1){
                    //Google
                    self.loginWithGoogle()
                }
            }
            return cell!
        }else if(indexPath.row == CellName.line.rawValue){
            
            
            let cell:LineOrCell? = tableView.dequeueReusableCell(withIdentifier: "LineOrCell", for: indexPath) as? LineOrCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            return cell!
            
        }else if(indexPath.row == CellName.email.rawValue){
            
            
            let cell:LoginEmailCell? = tableView.dequeueReusableCell(withIdentifier: "LoginEmailCell", for: indexPath) as? LoginEmailCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.tfEmail.tag = CellName.email.rawValue
            cell?.tfEmail.delegate = self
            
            cell?.tfEmail.text = self.strEmail
            
            return cell!
        }else if(indexPath.row == CellName.space.rawValue){
            
            
            let cell:LoginEmptyCell? = tableView.dequeueReusableCell(withIdentifier: "LoginEmptyCell", for: indexPath) as? LoginEmptyCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            return cell!
        }else if(indexPath.row == CellName.password.rawValue){
            
            
            let cell:LoginPasswordCell? = tableView.dequeueReusableCell(withIdentifier: "LoginPasswordCell", for: indexPath) as? LoginPasswordCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            
            cell?.tfPassword.tag = CellName.password.rawValue
            cell?.tfPassword.delegate = self
            
            cell?.tfPassword.text = self.strPassword
            
            return cell!
        }else if(indexPath.row == CellName.space2.rawValue){
            
            
            let cell:LoginEmptyCell? = tableView.dequeueReusableCell(withIdentifier: "LoginEmptyCell", for: indexPath) as? LoginEmptyCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            return cell!
        }else if(indexPath.row == CellName.loginBotton.rawValue){
            
            
            let cell:LoginButtonCell? = tableView.dequeueReusableCell(withIdentifier: "LoginButtonCell", for: indexPath) as? LoginButtonCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            cell?.handleCallBack = {(tag) in
                
                if let tf = self.bufferLastTextField{
                    tf.resignFirstResponder()
                }
                self.loginWithEmail()
                
            }
            
            
            
            
            return cell!
        }else if(indexPath.row == CellName.space3.rawValue){
            
            
            let cell:LoginEmptyCell? = tableView.dequeueReusableCell(withIdentifier: "LoginEmptyCell", for: indexPath) as? LoginEmptyCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            return cell!
        }else if(indexPath.row == CellName.forgot.rawValue){
            
            
            let cell:LoginForgotPasswordCell? = tableView.dequeueReusableCell(withIdentifier: "LoginForgotPasswordCell", for: indexPath) as? LoginForgotPasswordCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            return cell!
        }
        
        
        
        
        
        let cell:LoginEmptyCell? = tableView.dequeueReusableCell(withIdentifier: "LoginEmptyCell", for: indexPath) as? LoginEmptyCell
        cell?.selectionStyle = .none
        cell?.clipsToBounds = true
        cell?.tag = indexPath.row

        
        return cell!
        
    }
    
    // MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
   
        if(indexPath.row == CellName.forgot.rawValue){
            self.forgotPassword()
        }
        
        
        self.myTable.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
     
        if(scrollView.contentOffset.y <= 0){
            self.layout_TopbarHeight.constant = 169 - (122 + scrollView.contentOffset.y)
            self.viTopBar.layer.shadowOpacity = 0.0
        }else{
            self.layout_TopbarHeight.constant = 47
            self.viTopBar.layer.shadowOpacity = 0.5
        }
        
        //print(scrollView.contentOffset.y)
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LoginVC:UITextFieldDelegate{


    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.bufferLastTextField = textField
        if(self.screenSize.height <= 568){
            
            if(textField.tag == CellName.email.rawValue){
                
                
                self.myTable.setContentOffset(CGPoint(x: 0, y: 5), animated: true)
                
            }else if(textField.tag == CellName.password.rawValue){
                self.myTable.setContentOffset(CGPoint(x: 0, y: 58), animated: true)
            }
            
        }
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(textField.tag == CellName.email.rawValue){
            
            
            self.strEmail = textField.text!
            
        }else if(textField.tag == CellName.password.rawValue){
            self.strPassword = textField.text!
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if(textField.tag == CellName.email.rawValue){
            
            
            self.strEmail = textField.text!
            
        }else if(textField.tag == CellName.password.rawValue){
            self.strPassword = textField.text!
        }
        
        
        self.bufferLastTextField = nil
        
        self.myTable.setContentOffset(CGPoint(x: 0, y: -122), animated: true)
        
        return true
    }
    
    
    
    
    

}

extension LoginVC:GIDSignInDelegate, GIDSignInUIDelegate{
    
 
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
        if let error = error {
            self.removeActivityView {
                
                self.loginSuccess = false
                
                
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    
                }
                alertController.addAction(cancelAction)
                
                
                self.present(alertController, animated: true, completion: nil)
                
                
                
            }
            return
        }else{
            
            print(user.userID)
            
            print(user.profile.givenName)
            print(user.profile.familyName)
            print(user.profile.email)
            let userImageURL = user.profile.imageURL(withDimension: 200).absoluteString
             print(userImageURL)
            
            
            
            self.loginSuccess = true
            
            self.user_FirstName = user.profile.givenName
            self.user_LastName = user.profile.familyName
            self.user_Email = user.profile.email
            self.user_ImageProfile = userImageURL
            
          
            guard let authentication = user.authentication else {
                
                
                self.removeActivityView {
                    
                    self.loginSuccess = false
                    
                    
                    let alertController = UIAlertController(title: "Error", message: "This email address already used by another account", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                        
                    }
                    alertController.addAction(cancelAction)
                    
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                    
                }
                
                return
            }
            let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                              accessToken: authentication.accessToken)
            
            
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                // ...
                
                if let error = error {
                    self.removeActivityView {
                        
                        self.loginSuccess = false
                        
                        
                        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                            
                        }
                        alertController.addAction(cancelAction)
                        
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        
                        
                    }
                    return
                }else{

                    
                    if let user = user{
                        self.user_uid = user.uid
                        self.loginSuccess = true
                        self.checkReadyUser(readyHave: { (have) in
                            if(have == true){
                                loadProductLikeByUser(uid: self.user_uid, Finish: { (arLike) in
                                    
                                    self.myData.userLike = arLike
                                    self.getUserDatainfo()
                                    
                                })
                            }else{
                                ShareData.sharedInstance.startUpdateDashboardRegisterData()
                                self.postUserInfoToServer()
                            }
                        })
                        
                        
                    }else{
                        
                        self.removeActivityView {
                            
                            self.loginSuccess = false
                            
                            
                            let alertController = UIAlertController(title: "Error", message: "Can't get user uid", preferredStyle: .alert)
                            
                            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                                
                            }
                            alertController.addAction(cancelAction)
                            
                            
                            self.present(alertController, animated: true, completion: nil)
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                }
                
            }
            
            
        }
        
        
        
        
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true) { 
            
        }
    }
    
    
 
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
        
    }
}
