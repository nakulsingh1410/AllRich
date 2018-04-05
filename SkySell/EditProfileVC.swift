//
//  EditProfileVC.swift
//  SkySell
//
//  Created by DW02 on 5/15/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit
import Firebase



class EditProfileVC: UIViewController {

    
    enum CellName:NSInteger {
        case userImage = 0
        case space1
        case company
        case space2
        case name
        case space3
        case companyWeb
        case space4
        case email
        case space5
        case contact
        case space8
        case premium
        case space9
        case bio
        case space10
        
        static let count = 18
        
    }
    
    enum paymentTitle:String {
        case premimumMember = "Premium - Payment History"
        case freeMember =  "Free - Upgrade Plan"

    }
    
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    
    
    @IBOutlet weak var viTopbarBG: UIView!
    @IBOutlet weak var btBack: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    
    
    @IBOutlet weak var viSubmitBG: UIView!
    @IBOutlet weak var layout_ViSubmit_Bottom: NSLayoutConstraint!
    
    
    @IBOutlet weak var btSubmit: UIButton!
    
    @IBOutlet weak var myTable: UITableView!
    
    
    
    let imagePicker = UIImagePickerController()
    
    
    var bufferUserImage:UIImage! = nil
    var cropImageUser:UIImage! = nil
    
    var myActivityView:ActivityLoadingView! = nil
    
    var working:Bool = false
    
    
    
    var userImage:UIImage! = nil
    
    
    var strCompanyName:String = ""
    var strFirstName:String = ""
    var strLastName:String = ""
    var strWeb:String = ""
    var strEmail:String = ""
    var strContact:String = ""
    var strBIO:String = ""
    
    var strPremium:String = "Premium"

    
    
    var strCurrency:String = "SGD"
    
    
    
    let bioFont:UIFont = UIFont(name: "Avenir-Book", size: 14)!
    
    var storageRef: FIRStorageReference!
    
    
    var myData:ShareData = ShareData.sharedInstance
    
    var indexPathForMembershipCell : IndexPath?

    
    var haveChangeImage:Bool = false
    var haveChangeData:Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viTopbarBG.backgroundColor = UIColor.white
        self.viTopbarBG.layer.shadowColor = UIColor.white.cgColor//UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viTopbarBG.layer.shadowRadius = 1
        self.viTopbarBG.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.viTopbarBG.layer.shadowOpacity = 0.5
        
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        
        // [START configurestorage]
        storageRef = FIRStorage.storage().reference()
        
        
        
        
        self.imagePicker.delegate = self
        
        self.viSubmitBG.layer.shadowColor = UIColor(red: (8.0/255.0), green: (14.0/255.0), blue: (45.0/255.0), alpha: 1.0).cgColor
        self.viSubmitBG.layer.shadowRadius = 1
        self.viSubmitBG.layer.shadowOffset = CGSize(width: 0, height: -1)
        self.viSubmitBG.layer.shadowOpacity = 0.5
        
        
        
        
        
        
        strCompanyName = self.myData.userInfo.company_name
        strFirstName = self.myData.userInfo.first_name
        strLastName = self.myData.userInfo.last_name
        strWeb = self.myData.userInfo.company_website
        strEmail = self.myData.userInfo.email
        strContact = self.myData.userInfo.phone
        strBIO = self.myData.userInfo.bio
 
        strCurrency = self.myData.userInfo.currency
        
        
        
        
        
        
        
        do{
            let nib:UINib = UINib(nibName: "CreateUserImageCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "CreateUserImageCell")
        }
        
        do{
            let nib:UINib = UINib(nibName: "TextFieldWithIconCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "TextFieldWithIconCell")
        }
        
        
        do{
            let nib:UINib = UINib(nibName: "EmptyCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "EmptyCell")
        }
        
        do{
            let nib:UINib = UINib(nibName: "DoubleTextFieldCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "DoubleTextFieldCell")
        }
        
        do{
            let nib:UINib = UINib(nibName: "TextBoxCell", bundle: nil)
            self.myTable.register(nib, forCellReuseIdentifier: "TextBoxCell")
        }
        
        
        self.myTable.delegate = self
        self.myTable.dataSource = self
        
        if appDelegate.isPremiumMember {
            strPremium = paymentTitle.premimumMember.rawValue
        }else{
             strPremium = paymentTitle.freeMember.rawValue
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    
    func openImagePicker()  {
        self.imagePicker.allowsEditing = false
        
        
        
        let album:MultiSelectImageVC = MultiSelectImageVC(nibName: "MultiSelectImageVC", bundle: nil)
        album.singleImage = true
        album.callBack = {(images) in
            
            /*
            for pickedImage in images{
 
                
            }
            */
            
            if(images.count > 0){
                self.bufferUserImage = images[0]
         
              
            }else{
                self.bufferUserImage = nil
            }
            
            
          
        }
        
        
        
        album.callBackExit = { _ in
            
            if(self.bufferUserImage != nil){
                
                
                let seconds = 0.450
                
                
                let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    // Your code with delay
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
                    let vc:CropImageVC = storyboard.instantiateViewController(withIdentifier: "CropImageVC") as! CropImageVC
                    
                    vc.image = self.bufferUserImage
                    vc.callBack = {(image) in
                        self.cropImageUser = image
                        self.haveChangeImage = true
                        self.haveChangeData = true
                        
                        let indexp = IndexPath(row: CellName.userImage.rawValue, section: 0)
                        self.myTable.reloadRows(at: [indexp], with: UITableViewRowAnimation.fade)
                    }
                    
                    
                    self.present(vc, animated: true, completion: {
                        
                    })
                }
                
                
                
            }
        }
        let navigation:UINavigationController = UINavigationController(rootViewController: album)
        
        self.present(navigation, animated: true) {
            
        }
        
        
        
        
        
        /*
        let alertController = UIAlertController(title:"Add photos", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        
        let choosephotosAction = UIAlertAction(title: "Choose photos", style: .default) { (action) in
            
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true) {
                
            }
            
        }
        alertController.addAction(choosephotosAction)
        
        let useCameraAction = UIAlertAction(title: "Use Camera", style: .default) { (action) in
            
            self.imagePicker.sourceType = .camera
            
            self.present(self.imagePicker, animated: true) {
                
            }
            
        }
        alertController.addAction(useCameraAction)
        
        
        
        self.present(alertController, animated: true, completion: nil)
 */
    }

    
    
    
    // MARK: - Action
    @IBAction func tapOnBack(_ sender: UIButton) {
        
        if(haveChangeData || haveChangeImage){
            
            let alertController = UIAlertController(title:"Data has changed.", message: "Do you want to save changes", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Exit", style: .cancel) { (action) in
                
                self.exitScene()
            }
            alertController.addAction(cancelAction)
            
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
                
               
                self.updateData()
                
                
            }
            alertController.addAction(saveAction)
            
            
            
            
            
            self.present(alertController, animated: true, completion: nil)
            
            
        }else{
            
            self.exitScene()
            
        }
        
        
    }
    
    
    
    
    
    func exitScene() {
        self.showTapBar(show: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapOnSubmit(_ sender: UIButton) {
        
        let alertController = UIAlertController(title:"Do you want to save changes?", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            
        }
        alertController.addAction(cancelAction)
        
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            
            if(self.checkHaveChange() == true){
                self.updateData()
            }
            
            
            
        }
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func checkComplete(Complete complete:(Bool, String)->Void) {
        var isError:Bool = false
        var title:String = ""
        
        
        
        if(self.strCompanyName.count <= 0){
            isError = true
            title = "Please enter Company Name."
        }else if(self.strFirstName.count <= 0){
            isError = true
            title = "Please enter First name."
        }else if(self.strEmail.count <= 0){
            isError = true
            title = "Please enter your email."
        }
        
        
        complete(isError, title)
    }
    
    
    
    func checkHaveChange()->Bool {
        
        
        
        
    
        
        
        if((strCompanyName != self.myData.userInfo.company_name)){
            self.haveChangeData = true
        }else if((strFirstName != self.myData.userInfo.first_name)){
            self.haveChangeData = true
        }else if((strLastName != self.myData.userInfo.last_name)){
            self.haveChangeData = true
        }else if((strWeb != self.myData.userInfo.company_website)){
            self.haveChangeData = true
        }else if((strContact != self.myData.userInfo.phone)){
            self.haveChangeData = true
        }else if((strBIO != self.myData.userInfo.bio)){
            self.haveChangeData = true
        }else if((strCurrency != self.myData.userInfo.currency)){
            self.haveChangeData = true
        }
        
        
        return self.haveChangeData
        
    }
    
    
    
    //--------------------------
    
    func updateData(){
        self.addActivityView {
            self.updateUserInfoAndImage()
        }
    }
    
    
    func updateUserInfoAndImage() {
        
        
        self.myData.needUpdateAfterEdit = true
        
        if(self.haveChangeImage == true){
            
            self.haveChangeData = true
            
            self.updateUserImage()
        }else{
            
            self.updateUserDataInfo()
        }
        
        
    }
    
    
    func updateUserDataInfo() {
        
        if(self.haveChangeData == true){
            self.updateUserData()
            
        }else{
            self.finishUpdate()
        }
        
    }
    
    
    func finishUpdate() {
        
        self.removeActivityView {
            
            let alertController = UIAlertController(title: "SUCCESS!!", message: nil, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                //self.navigationController?.popViewController(animated: true)
                
                
           
                self.haveChangeData = false
                self.haveChangeImage = false
                
                self.exitScene()
                
            }
            alertController.addAction(cancelAction)
            
            
            self.present(alertController, animated: true, completion: nil)
            
            
            
        }
    }
    
    
    
    
    func updateUserImage() {
        if(self.myData.userInfo.profileImage_path.count > 10){
            self.deleteLastUserImage {
                self.uploadImage {
                    self.updateUserDataInfo()
                }
            }
        }else{
            self.uploadImage {
                self.updateUserDataInfo()
            }
        }
    }
    
    func uploadImage(finish:@escaping ()->Void) {
        
        
        if(self.cropImageUser != nil){
            
            self.uploadImage(complete: { (success, name, path, src) in
                self.myData.userInfo.profileImage_name = name
                self.myData.userInfo.profileImage_path = path
                self.myData.userInfo.profileImage_src = src
                
                
                finish()
            })
        }else{
            finish()
        }
    }
    
    
    
    func deleteLastUserImage(finish:@escaping ()->Void) {

        
        let deleteImage = self.storageRef.child(self.myData.userInfo.profileImage_path)
        deleteImage.delete { (error) in
            if let _ = error {
                // Uh-oh, an error occurred!
            } else {
                // File deleted successfully
            }
            
            self.myData.userInfo.profileImage_path = ""
            self.myData.userInfo.profileImage_src = ""
            self.myData.userInfo.profileImage_name = ""
            
            finish()
        }
        
    }
    
    
    func uploadImage(complete:@escaping (_ success:Bool, _ name:String, _ path:String,  _ src:String)->Void){
        
        
        guard let imageData = UIImageJPEGRepresentation(self.cropImageUser, 0.8) else {
            
            complete(false, "", "", "")
            
            return
        }
        
        let fileName:String = FIRAuth.auth()!.currentUser!.uid + "\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        let imagePath = "profiles" + "/" + fileName
        
        
        //.currentUser!.uid + "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        
        
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        self.storageRef.child(imagePath)
            .put(imageData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    complete(false, "", "", "")
                    return
                }
                
                let strURL:String = (metadata?.downloadURL()?.absoluteString)!
                print(strURL)
                
                complete(true, fileName, imagePath, strURL)
                
                //self.uploadSuccess(metadata!, storagePath: imagePath)
        }
    }
    
    
    
    
    
    
    
    func updateUserData() {
        let dateFormatFull:DateFormatter = DateFormatter()
        dateFormatFull.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatFull.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let strDate:String = dateFormatFull.string(from: Date())
        
        //let locale = Locale.current
        //let currencyCode = locale.currencyCode?.uppercased()
        let profileImage:[String:String] = ["name":self.myData.userInfo.profileImage_name,
                                            "path":self.myData.userInfo.profileImage_path,
                                            "src":self.myData.userInfo.profileImage_src]
        
        let postUserData:[String:Any] = ["bio":self.strBIO,
                                         "company_name":self.strCompanyName,
                                         "company_website":self.strWeb,
                                         "created_at":self.myData.userInfo.created_at,
                                         "created_at_server_timestamp":self.myData.userInfo.created_at_server_timestamp,
                                         "currency":self.strCurrency,
                                         "email": self.strEmail,
                                         "first_name": self.strFirstName,
                                         "isActive": self.myData.userInfo.isActive,
                                         "isSignUp": self.myData.userInfo.isSignUp,
                                         "last_name": self.strLastName,
                                         "password": self.myData.userInfo.password,
                                         "phone": self.strContact,
                                         "profile_img_data":profileImage,
                                         "profile_img":self.myData.userInfo.profileImage_src,
                                         "status":self.myData.userInfo.status,
                                         "uid":self.myData.userInfo.uid,
                                         "updated_at":strDate,
                                         "updated_at_server_timestamp": FIRServerValue.timestamp(),
                                         "user_type":self.myData.userInfo.user_type
        ]
        
        
        
        
        let postRef = FIRDatabase.database().reference().child("users").child(self.myData.userInfo.uid)
        
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
                
                
                loadProductLikeByUser(uid: self.myData.userInfo.uid, Finish: { (arLike) in
                    
                    self.myData.userLike = arLike
                    self.getUserDatainfo()
                    
                })
                
                
               
                
            }
        }
        
        
        
        
        
    }
    
    
    
    
    func getUserDatainfo() {
        
        let postRef = FIRDatabase.database().reference().child("users").child(self.myData.userInfo.uid)
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary{
                
                
                self.myData.userInfo = UserDataModel(dictionary: value)
                
                
               
                
            }
            
            self.finishUpdate()
        })
        
        
        
    }
   
    
    
}



// MARK: - UITableViewDelegate, UITableViewDataSource
extension EditProfileVC:UITableViewDelegate, UITableViewDataSource{
    
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
        
        
        
        if(indexPath.row == CellName.userImage.rawValue){
            cellHeight = 160
        }else if(indexPath.row == CellName.company.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.space1.rawValue){
            cellHeight = 8
        }else if(indexPath.row == CellName.name.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.companyWeb.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.email.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.contact.rawValue){
            cellHeight = 45
        }else if(indexPath.row == CellName.premium.rawValue){
            cellHeight = 45
        }
        else if(indexPath.row == CellName.bio.rawValue){
            
            
            cellHeight = heightForView(text: self.strBIO, Font: bioFont, Width: self.screenSize.width - 105) + 52
            
            
            
            
            
            if(cellHeight < 145){
                cellHeight = 145
            }
            
            
            
            
            
            
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
        
        
        
        
        if(indexPath.row == CellName.userImage.rawValue){
            let cell:CreateUserImageCell? = tableView.dequeueReusableCell(withIdentifier: "CreateUserImageCell", for: indexPath) as? CreateUserImageCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            
            if(self.cropImageUser != nil){
                cell?.imageUser.image = self.cropImageUser
                cell?.imageUser.contentMode = .scaleAspectFill
                cell?.lazyImage.imageView.image = nil
                
            }else{
                
                cell?.lazyImage.imageView.contentMode = .scaleAspectFill
                cell?.lazyImage.alpha = 1
                cell?.lazyImage.loadImage(imageURL: self.myData.userInfo.profileImage_src, Thumbnail: false)
            }
            
            
            
            return cell!
        }else if(indexPath.row == CellName.company.rawValue){
            let cell:TextFieldWithIconCell? = tableView.dequeueReusableCell(withIdentifier: "TextFieldWithIconCell", for: indexPath) as? TextFieldWithIconCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            cell?.tfInput.tag = indexPath.row
            cell?.tfInput.placeholder = "Company Name"
            cell?.tfInput.delegate = self
            cell?.tfInput.text = self.strCompanyName
            cell?.tfInput.isSecureTextEntry = false
            
            
            cell?.imageIcon.image = UIImage(named: "iconProfileNonactive.png")
            
            return cell!
        }else if(indexPath.row == CellName.name.rawValue){
            let cell:DoubleTextFieldCell? = tableView.dequeueReusableCell(withIdentifier: "DoubleTextFieldCell", for: indexPath) as? DoubleTextFieldCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            cell?.tfFirstName.tag = 100 + indexPath.row
            cell?.tfLastName.tag = 200 + indexPath.row
            cell?.tfFirstName.placeholder = "First name"
            cell?.tfLastName.placeholder = "Last name"
            //cell?.tfInput.placeholder = "Company Name"
            cell?.tfFirstName.delegate = self
            cell?.tfLastName.delegate = self
            
            cell?.tfFirstName.text = self.strFirstName
            cell?.tfLastName.text = self.strLastName
            
            cell?.tfFirstName.isSecureTextEntry = false
            cell?.tfLastName.isSecureTextEntry = false
            
            
            
            
            cell?.imageIcon.image = UIImage(named: "iconProfileNonactive.png")
            
            
            
            
            return cell!
            
        }else if(indexPath.row == CellName.companyWeb.rawValue){
            let cell:TextFieldWithIconCell? = tableView.dequeueReusableCell(withIdentifier: "TextFieldWithIconCell", for: indexPath) as? TextFieldWithIconCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            cell?.tfInput.tag = indexPath.row
            cell?.tfInput.placeholder = "Company Website"
            cell?.tfInput.delegate = self
            cell?.imageIcon.image = UIImage(named: "computerInternet.png")
            
            cell?.tfInput.text = strWeb
            cell?.tfInput.isSecureTextEntry = false
            cell?.tfInput.isUserInteractionEnabled = true
            
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
            
            
            cell?.imageIcon.image = UIImage(named: "mail.png")
            if(strEmail == ""){
                cell?.tfInput.isUserInteractionEnabled = true
            }else{
                cell?.tfInput.isUserInteractionEnabled = false
            }
            
            
            return cell!
        }else if(indexPath.row == CellName.contact.rawValue){
            let cell:TextFieldWithIconCell? = tableView.dequeueReusableCell(withIdentifier: "TextFieldWithIconCell", for: indexPath) as? TextFieldWithIconCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            cell?.tfInput.tag = indexPath.row
            cell?.tfInput.placeholder = "Contact number"
            cell?.tfInput.delegate = self
            cell?.tfInput.text = strContact
            cell?.tfInput.isSecureTextEntry = false
            cell?.tfInput.isUserInteractionEnabled = true
            
            
            cell?.imageIcon.image = UIImage(named: "call.png")
            
            
            return cell!
        }else if(indexPath.row == CellName.premium.rawValue){
            let cell:TextFieldWithIconCell? = tableView.dequeueReusableCell(withIdentifier: "TextFieldWithIconCell", for: indexPath) as? TextFieldWithIconCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            cell?.tfInput.tag = indexPath.row
            cell?.tfInput.placeholder = strPremium
            cell?.tfInput.delegate = self
            cell?.tfInput.text = strPremium
            cell?.tfInput.isSecureTextEntry = false
            cell?.tfInput.isUserInteractionEnabled = true
            let image  = #imageLiteral(resourceName: "icon_member").withRenderingMode(.alwaysTemplate)
            cell?.imageIcon.tintColor = UIColor.init(red: 88/255, green: 116/255, blue: 243/255, alpha: 1)
            cell?.imageIcon.image = image
            cell?.button.isHidden = false
            indexPathForMembershipCell = indexPath
            cell?.button.addTarget(self, action: #selector(EditProfileVC.openPaymentHistory), for: .touchUpInside)
            
          
            
            return cell!
        }
        else if(indexPath.row == CellName.bio.rawValue){
            let cell:TextBoxCell? = tableView.dequeueReusableCell(withIdentifier: "TextBoxCell", for: indexPath) as? TextBoxCell
            cell?.selectionStyle = .none
            cell?.clipsToBounds = true
            cell?.tag = indexPath.row
            cell?.myTextview.tag = indexPath.row
            cell?.myTextview.isUserInteractionEnabled = false
            cell?.myTextview.text = self.strBIO
            cell?.lbTextCount.text = String(format: "%d/200", self.strBIO.count )
            
            
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
        
        
        
        
        
        if(indexPath.row == CellName.bio.rawValue){
            
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
            let vc:TextMessageInputVC = storyboard.instantiateViewController(withIdentifier: "TextMessageInputVC") as! TextMessageInputVC
            
            vc.strTitle = "Bio"
            vc.strMessage = self.strBIO
            
            vc.callBack = {(message) in
                
                
                var m:String = message
                if(m.count > 200){
                    
                    let ns:NSString = NSString(string: m)
                    m = ns.substring(with: NSMakeRange(0, 200))
                    
                }
                
                
                self.strBIO = m
                
                let indexp = IndexPath(row: CellName.bio.rawValue, section: 0)
                self.myTable.reloadRows(at: [indexp], with: UITableViewRowAnimation.fade)
                //                self.haveSomthingChange = true
                //                self.strDeliveryLocation = message
                
                //self.myTable.reloadSections([CellName.bio.rawValue], with: UITableViewRowAnimation.fade)
                
                
            }
            
            self.present(vc, animated: true, completion: {
                
            })
            
            
            
            
            
            
        }else if(indexPath.row == CellName.userImage.rawValue){
            self.openImagePicker()
        }
        
        
        
        
        
        self.myTable.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        
        //print(scrollView.contentOffset.y)
        
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension EditProfileVC:UITextFieldDelegate{
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        var newY:CGFloat = 0
        
        switch textField.tag {
        case CellName.company.rawValue:
            
         
            newY = 0
            
            break
        case (CellName.name.rawValue + 100):
            
         
            newY = 65
            
            break
        case (CellName.name.rawValue + 200):
            
        
            newY = 65
            
            break
        case CellName.companyWeb.rawValue:
            
           
            newY = 120
            
            break
        case CellName.email.rawValue:
            
           newY = 185
            
            break
        case CellName.contact.rawValue:
            
            newY = 240
            
            break
            
        default:
            break
        }
        
        self.myTable.setContentOffset(CGPoint(x: 0, y: newY), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        switch textField.tag {
        case CellName.company.rawValue:
            
            self.strCompanyName = textField.text!
            
            break
        case (CellName.name.rawValue + 100):
            
            self.strFirstName = textField.text!
            
            break
        case (CellName.name.rawValue + 200):
            
            self.strLastName = textField.text!
            
            break
        case CellName.companyWeb.rawValue:
            
            self.strWeb = textField.text!
            
            break
        case CellName.email.rawValue:
            
            self.strEmail = textField.text!
            
            break
        case CellName.contact.rawValue:
            
            self.strContact = textField.text!
            
            break
            
        default:
            break
        }
        
        //return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        print(textField.tag)
        
        switch textField.tag {
        case CellName.company.rawValue:
            
            self.strCompanyName = textField.text!
            
            break
        case (CellName.name.rawValue + 100):
            
            self.strFirstName = textField.text!
            
            break
        case (CellName.name.rawValue + 200):
            
            self.strLastName = textField.text!
            
            break
        case CellName.companyWeb.rawValue:
            
            self.strWeb = textField.text!
            
            break
        case CellName.email.rawValue:
            
            self.strEmail = textField.text!
            
            break
        case CellName.contact.rawValue:
            
            self.strContact = textField.text!
            
            break
            
        default:
            break
        }
        
        return true
    }
    
}



// MARK: - UIImagePickerControllerDelegate
extension EditProfileVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //imageView.contentMode = .ScaleAspectFit
            //imageView.image = pickedImage
            
            /*
             let newImageOb:PostImageModel = PostImageModel()
             newImageOb.image = pickedImage
             newImageOb.postStatus = .Weaiting
             newImageOb.workStatus = .Post
             
             self.arImage.append(newImageOb)
             ShareData.sharedInstance.myPostDraft.arImageWeaitPost.append(newImageOb)
             self.myCollection.reloadData()
             */
            
            self.bufferUserImage = pickedImage
            
            
            
            self.imagePicker.dismiss(animated: true) {
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
                let vc:CropImageVC = storyboard.instantiateViewController(withIdentifier: "CropImageVC") as! CropImageVC
                
                vc.image = pickedImage
                vc.callBack = {(image) in
                    self.cropImageUser = image
                    self.haveChangeImage = true
                    self.haveChangeData = true
                    
                    let indexp = IndexPath(row: CellName.userImage.rawValue, section: 0)
                    self.myTable.reloadRows(at: [indexp], with: UITableViewRowAnimation.fade)
                }
                
                
                self.present(vc, animated: true, completion: {
                    
                })
            }
            
            
            
            
            
            
            
            
            
            
        }else{
            self.bufferUserImage = nil
            
            self.imagePicker.dismiss(animated: true) {
                
            }
        }
        
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true) {
            
        }
    }
    
}

// MARK: - Premium
extension EditProfileVC{
    func openPaymentHistory(){
        view.endEditing(true)
       
        if  strPremium == paymentTitle.premimumMember.rawValue {
            NavigationManager.navigateToPaymentHistory(navigationController: navigationController)

        } else{
            NavigationManager.navigateToPayment(navigationController: navigationController, email: myData.userInfo.email, userId: myData.userInfo.uid , iSTopup: false, isComingFromRegistration: false)
            
        }
        
//        self.myTable.setContentOffset(CGPoint(x: 0, y: 340), animated: true)
        
    }
}
