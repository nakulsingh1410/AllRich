//
//  FriendRequestViewController.swift
//  SkySell
//
//  Created by Nakul Singh on 3/30/18.
//  Copyright © 2018 DW02. All rights reserved.
//

import UIKit

class FriendRequestViewController: UIViewController {
    
    @IBOutlet weak var tableViewFriendList: UITableView!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var txtFSeach: UITextField!
    @IBOutlet weak var btnLike: UIButton!
    
    var arrAppUserFriendList = [FriendListModel]()
    var arrFriendList = [FriendListModel]()
    var arrPendingFriendRequestList = [FriendListModel]()
    var arrTableData = [FriendListModel]()
    var friendListType:FriendListType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.layer.cornerRadius = 3.0
        searchView.layer.masksToBounds = true
        initialiseTableView()
        getAppUserAPi()
        friendListType = .appUser
        txtFSeach.placeholder = "Search Friends"
        txtFSeach.delegate = self
    }
    
    func initialiseTableView()  {
        
        tableViewFriendList.register(UINib(nibName: "FriendListCell", bundle: nil), forCellReuseIdentifier: "FriendListCell")
        tableViewFriendList.dataSource = self
        tableViewFriendList.delegate = self
        tableViewFriendList.rowHeight = UITableViewAutomaticDimension
        tableViewFriendList.estimatedRowHeight = 44.0
        tableViewFriendList.tableFooterView = UIView()
        tableViewFriendList.separatorColor = .clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        txtFSeach.resignFirstResponder()
    }
    
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        txtFSeach.resignFirstResponder()
        if sender.selectedSegmentIndex == 0 {
            getAppUserAPi()
            friendListType = .appUser
        }else if sender.selectedSegmentIndex == 1 {
            friendListAPi()
            friendListType = .friendList
        }else if sender.selectedSegmentIndex == 2 {
            pendingFriendListAPi()
            friendListType = .friendRequest
        }
    }
    
    @IBAction func btnLikeTapped(_ sender: Any) {
    }
}


//MARK: UITableViewDataSource
extension FriendRequestViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell") as? FriendListCell{
            cell.loadData(model: arrTableData[indexPath.row], requestType: friendListType)
            cell.friendListCellDelegate = self
            return cell
        }
        return UITableViewCell()
    }
}
//MARK :UITableViewDelegate
extension FriendRequestViewController:UITableViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        txtFSeach.resignFirstResponder()
    }
}
//MARK: FriendListCellDelegate
extension FriendRequestViewController:FriendListCellDelegate{
    
    func cellButtonTapped(sender: UIButton, friendListModel: FriendListModel) {
        guard let bttonTitle = sender.titleLabel?.text else{return}
        guard let userId = friendListModel.user_id  else {return}
        
        if bttonTitle == FriendRequestButtonTitle.accept.rawValue {
            responseOfFriendRequestApi(selecteduserId: userId, requestStatus: "accepted", model: friendListModel)
        }
        if bttonTitle == FriendRequestButtonTitle.declined.rawValue {
            responseOfFriendRequestApi(selecteduserId: userId, requestStatus: "declined", model: friendListModel)
        }
        if bttonTitle == FriendRequestButtonTitle.unfriend.rawValue {
            responseOfFriendRequestApi(selecteduserId: userId, requestStatus: "unfriend", model: friendListModel)
        }
        if bttonTitle == FriendRequestButtonTitle.block.rawValue {
            responseOfFriendRequestApi(selecteduserId: userId, requestStatus: "blocked", model: friendListModel)
        }
        if bttonTitle == FriendRequestButtonTitle.request.rawValue{
            createFriendRequestApi(selecteduserId: userId, model: friendListModel)
        }
    }
}

//MARK: UITextFieldDelegate
extension FriendRequestViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
}

//MARK :API
extension FriendRequestViewController{
    
    func getAppUserAPi()  {
        self.arrTableData.removeAll()
        tableViewFriendList.reloadData()
        tableViewFriendList.backgroundView = nil
        
        WebServiceModel.getUsersList { (friendList) in
            self.arrAppUserFriendList.removeAll()
            if let friendListObj = friendList{
                if let premium = friendListObj.premiumUsers{
                    self.arrAppUserFriendList.append(contentsOf: premium)
                }
                if let free = friendListObj.freeUsers{
                    self.arrAppUserFriendList.append(contentsOf: free)
                }
                self.arrTableData = self.arrAppUserFriendList
            }
            DispatchQueue.main.async {
                if self.arrTableData.count == 0 {
                    Global.EmptyMessage(message: "No app user list", viewController: self, tableView: self.tableViewFriendList)
                }
                self.tableViewFriendList.reloadData()
            }
        }
    }
    
    func friendListAPi()  {
        self.arrTableData.removeAll()
        tableViewFriendList.reloadData()
        tableViewFriendList.backgroundView = nil
        WebServiceModel.acceptedFriendList { (responseData) in
            self.arrFriendList.removeAll()
            if let friendListObj = responseData{
                self.arrFriendList = friendListObj
                self.arrTableData = self.arrFriendList
            }
            DispatchQueue.main.async {
                if self.arrTableData.count == 0 {
                    Global.EmptyMessage(message: "No friend list", viewController: self, tableView: self.tableViewFriendList)
                }
                self.tableViewFriendList.reloadData()
            }
            
        }
    }
    
    func pendingFriendListAPi()  {
        self.arrTableData.removeAll()
        tableViewFriendList.reloadData()
        tableViewFriendList.backgroundView = nil
        WebServiceModel.pendingFriendList { (responseData) in
            self.arrPendingFriendRequestList.removeAll()
            if let friendListObj = responseData{
                self.arrPendingFriendRequestList = friendListObj
            }
            self.arrTableData = self.arrPendingFriendRequestList
            
            DispatchQueue.main.async {
                if self.arrTableData.count == 0 {
                    Global.EmptyMessage(message: "No pending friends requests", viewController: self, tableView: self.tableViewFriendList)
                }
                self.tableViewFriendList.reloadData()
            }
            
        }
    }
    
    func createFriendRequestApi(selecteduserId:String,model:FriendListModel)  {
        tableViewFriendList.backgroundView = nil
        WebServiceModel.createFriendRequest(selectedUser: selecteduserId) { (messgae) in
            if let _ = messgae{
                model.requestStatus = "pending"
//                Global.showAlertOnController(viewController: self, message: msg)
                DispatchQueue.main.async {
                    self.tableViewFriendList.reloadData()
                }
            }else{
                Global.showAlertOnController(viewController: self, message: "Error!!")
            }
        }
    }
    func responseOfFriendRequestApi(selecteduserId:String,requestStatus:String,model:FriendListModel)  {
        tableViewFriendList.backgroundView = nil
        WebServiceModel.responseOfFriendRequest(selectedUser: selecteduserId, requestStatus: requestStatus) { (flag) in
            if let _ = flag{
                if let index = self.arrTableData.index(where: {$0.user_id == model.user_id}) {
                    self.arrTableData.remove(at: index)
                }
                DispatchQueue.main.async {
                    if self.arrTableData.count == 0 {
                        Global.EmptyMessage(message: "No friends", viewController: self, tableView: self.tableViewFriendList)
                    }
                    self.tableViewFriendList.reloadData()
                }
            }else{
                Global.showAlertOnController(viewController: self, message: "Error!!")
            }
        }
    }
}



