//
//  PointView.swift
//  SkySell
//
//  Created by Nakul Singh on 3/24/18.
//  Copyright © 2018 DW02. All rights reserved.
//

import UIKit

let setPointNotificatio = "PointNotification"

class PointView: UIView {

    @IBOutlet weak var lblPoints: UILabel!
     var points = 0 {
        didSet{
           setPoints()
        }
    }
    
    private var nibView:UIView!
    /******************************************************/
    //MARK: Function
    /******************************************************/
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNib()
        self.nibView.frame = self.bounds
        self.addSubview(nibView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setPoints), name: Notification.Name(setPointNotificatio), object: nil)

    }
    
    func setPoints()  {
        DispatchQueue.main.async {
            self.lblPoints.text = "\(appDelegate.point)"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.nibView.frame = self.bounds
        lblPoints.text = "\(appDelegate.point)"
    }
    
    private func loadNib() {
        let bundle = Bundle(for: PointView.self)
        if let nib = bundle.loadNibNamed("PointView", owner: self, options: nil)?.first as? UIView {
            nibView = nib
            lblPoints.text = ""
            nibView.backgroundColor = .clear
        }
    }

}
