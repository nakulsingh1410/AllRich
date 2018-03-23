//
//  CreateUserImageCell.swift
//  SkySell
//
//  Created by DW02 on 5/4/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class CreateUserImageCell: UITableViewCell {

    
    @IBOutlet weak var viImageBG: UIView!
    
    @IBOutlet weak var imageUser: UIImageView!
    
    
    
    
    
    
    
    
    @IBOutlet weak var lbTitle: UILabel!
    
    var lazyImage:PKImV3View! = nil
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lazyImage = PKImV3View(frame: CGRect(x: 0, y: 0, width: 110, height: 110))
        self.viImageBG.addSubview(lazyImage)
        lazyImage.backgroundColor = UIColor.clear
        lazyImage.imageView.backgroundColor = UIColor.clear
        
        lazyImage.imageView.image = nil
        
        self.viImageBG.clipsToBounds = true
        self.viImageBG.layer.cornerRadius = 55
        
        self.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
