

//
//  FriendListCell.swift
//  SkySell
//
//  Created by Nakul Singh on 3/30/18.
//  Copyright © 2018 DW02. All rights reserved.
//

import UIKit
import Kingfisher

protocol FriendListCellDelegate {
    func cellButtonTapped(sender:UIButton,friendListModel:FriendListModel)
}

enum FriendRequestButtonTitle:String {
    case accept = " Accept "
    case declined = " Declined "
    case block = " Block "
    case unfriend = " Unfriend "
    case request = " Request "
    case pendingResponse = " Pending Response "

}

enum FriendListType:String {
    case appUser = "AppUser"
    case friendList = "FriendList"
    case friendRequest = "FriendRequest"
}

class FriendListCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUserType: UILabel!
    @IBOutlet weak var lblNumberOfPoints: UILabel!
    @IBOutlet weak var lblJoinDate: UILabel!
    @IBOutlet weak var imgViewProfilePic: UIImageView!
    
    
    @IBOutlet weak var btnFirst: UIButton!
    @IBOutlet weak var btnSecond: UIButton!
    @IBOutlet weak var btnThird: UIButton!
    @IBOutlet weak var btnWidthConstraint: NSLayoutConstraint!
    var friendListCellDelegate:FriendListCellDelegate?
    
    var blueColor = UIColor(red: 88/255, green: 116/255, blue: 243/255, alpha: 1)
    var grayColor = UIColor.lightGray

    var cornerRadius:CGFloat = 3.0
    var modelObj : FriendListModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        imgViewProfilePic.layer.cornerRadius = imgViewProfilePic.frame.size.height/2
        imgViewProfilePic.layer.masksToBounds = true
        
        btnFirst.isHidden = true
        btnSecond.isHidden = true
        btnThird.isHidden = true
        
        btnFirst.layer.cornerRadius = cornerRadius
        btnFirst.layer.masksToBounds = true
        
        btnSecond.layer.cornerRadius = cornerRadius
        btnSecond.layer.masksToBounds = true
        
        btnThird.layer.cornerRadius = cornerRadius
        btnThird.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(model:FriendListModel,requestType:FriendListType?)  {
        modelObj = model
         lblName.text = ""
         lblUserType.text = ""
         lblNumberOfPoints.text = ""
         lblJoinDate.text = ""
        imgViewProfilePic.image = nil
        
        btnFirst.isHidden = true
        btnSecond.isHidden = true
        btnThird.isHidden = true
        
        if let string = model.first_name {
            lblName.text = string
        }
        if let string = model.user_type {
            lblUserType.text = string
        }
        if let point = model.numberOfPosts {
            let strPoints = point <= 1 ? "Point" : "Points"
            lblNumberOfPoints.text = "\(point) \(strPoints)"
        }

        if let timeStamp = model.user_joinDate{
            lblJoinDate.text = getDateString(unixtimeInterval:timeStamp )
        }
        
        
        if let image = model.profile_img,image.count > 0,let url = URL(string:image){
            imgViewProfilePic.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "userPlaceholder"), options: nil, progressBlock: nil, completionHandler: { (image, error, typr, url) in
                if image == nil{
                    self.imgViewProfilePic.image = #imageLiteral(resourceName: "userPlaceholder")
                }
            })

        }
        
        if let requestStatus  = model.requestStatus ,requestStatus.count > 0 {
            setButtonsTitles(requestStatus: requestStatus, requestType: requestType)
        }

    }
    
    func setButtonsTitles(requestStatus:String,requestType:FriendListType?)  {
        guard let requestTypeObj = requestType else{return}
        btnSecond.backgroundColor = blueColor

        if requestTypeObj == .appUser{
            if requestStatus == "new" {
                btnSecond.backgroundColor = blueColor
                btnSecond.setTitle(FriendRequestButtonTitle.request.rawValue, for: .normal)
            }
            if requestStatus == "pending" {
                btnSecond.backgroundColor = grayColor
                btnSecond.setTitle(FriendRequestButtonTitle.pendingResponse.rawValue, for: .normal)
            }
            btnSecond.isHidden = false
        }
        if requestTypeObj == .friendList{
            if requestStatus == "accepted" {
                btnFirst.setTitle(FriendRequestButtonTitle.unfriend.rawValue, for: .normal)
                btnSecond.setTitle(FriendRequestButtonTitle.block.rawValue, for: .normal)
                btnFirst.isHidden = false
                btnSecond.isHidden = false
            }
        }
        if requestTypeObj == .friendRequest{
            btnFirst.setTitle(FriendRequestButtonTitle.accept.rawValue, for: .normal)
            btnSecond.setTitle(FriendRequestButtonTitle.declined.rawValue, for: .normal)
            btnThird.setTitle(FriendRequestButtonTitle.block.rawValue, for: .normal)
            btnFirst.isHidden = false
            btnSecond.isHidden = false
            btnThird.isHidden = false
        }
        
    }

    func getDateString(unixtimeInterval:Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixtimeInterval/1000))
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
//        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    @IBAction func btnFirstTapped(_ sender: UIButton) {
        if let model = modelObj{
            friendListCellDelegate?.cellButtonTapped(sender: sender, friendListModel: model)
        }
    }
    @IBAction func btnSecondTapped(_ sender: UIButton) {
        if let model = modelObj{
            friendListCellDelegate?.cellButtonTapped(sender: sender, friendListModel: model)
        }
    }
    
    @IBAction func btnThirdTapped(_ sender: UIButton) {
        if let model = modelObj{
            friendListCellDelegate?.cellButtonTapped(sender: sender, friendListModel: model)
        }
    }
}
